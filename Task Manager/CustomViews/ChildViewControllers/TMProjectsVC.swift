//
//  TMProjectsVC.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import UIKit

protocol TMProjectsProtocol: AnyObject {
    func projectDidChange(project: Project?)
    func projectDeleted()
    func projectUpdated()
}

class TMProjectsVC: UIViewController {
    
    private typealias ProjectDataSource = UICollectionViewDiffableDataSource<Section,Project>
    private typealias ProjectSnapshot = NSDiffableDataSourceSnapshot<Section,Project>
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
    private var dataSource: ProjectDataSource!
    private let pageIndicator = UIPageControl(frame: .zero)
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: -  Delegate TMProjectsProtocol
    weak var delegate: TMProjectsProtocol?
    
    private enum Section: String, Hashable {
        case projects = "Proyectos"
    }
    
    private var currentProjectSelected: Project?   {
        didSet {
            delegate?.projectDidChange(project: currentProjectSelected)
            updatePageIndicatorColor()
        }
    }
    
    var projectsData: [Project] = [] {
        didSet {
            updateDataSourceSnapshot()
        }
    }
    
    private var pageIndicatorIndex = 0 {
        didSet {
            pageIndicator.currentPage = pageIndicatorIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPageIndicator()
        setupCollectionView()
        setupDataSource()
    }
    
    private func setupPageIndicator() {
        view.addSubview(pageIndicator)
        pageIndicator.currentPageIndicatorTintColor = ThemeColors.accentColor
        pageIndicator.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.2)
        pageIndicator.isUserInteractionEnabled = false
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 6 ),
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageIndicator.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        // Registro de cell reusable
        collectionView.register(ProjectViewCell.self, forCellWithReuseIdentifier: ProjectViewCell.cellID)
        // Contraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func contextMenuConfigurationActions(indexPath: IndexPath) ->UIContextMenuConfiguration? {
        
        let project = self.dataSource.itemIdentifier(for: indexPath)!
        
        return UIContextMenuConfiguration(identifier: NSIndexPath(item: indexPath.item, section: indexPath.section), previewProvider: nil) { (menuElement) -> UIMenu? in
            
            let deleteAction = UIAction(title: "Eliminar",
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { (action) in
                
                CoreDataManager.shared.delete(project) { [weak self] in
                    self?.removeInSnapshot(project)
                    self?.delegate?.projectDeleted()
                }
            }
            
            var toggleStatusAction: UIAction!
            
            if project.statusDescription == .inProgress {
                
                toggleStatusAction = UIAction(title: "Pasar a Completados", image: UIImage(systemName: "tray.and.arrow.down")) { (action) in
                    project.statusDescription = .completed
                    CoreDataManager.shared.update() { [weak self] in
                        self?.removeInSnapshot(project)
                        self?.delegate?.projectUpdated()
                    }
                }
            } else if project.statusDescription == .completed{
                
                toggleStatusAction = UIAction(title: "Pasar a En Progreso", image: UIImage(systemName: "tray.and.arrow.up")) { (action) in
                    project.statusDescription = .inProgress
                    CoreDataManager.shared.update() { [weak self] in
                        self?.removeInSnapshot(project)
                        self?.delegate?.projectUpdated()
                    }
                }
            }
            
            return UIMenu(title: "OPCIONES DEL PROYECTO",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [deleteAction, toggleStatusAction])
        }
    }
    
    func animateToStartItem() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        pageIndicatorIndex = 0
        currentProjectSelected = self.projectsData.first
    }
    
    private func removeInSnapshot(_ project: Project) {
        var currentSnapshot =  dataSource.snapshot()
        currentSnapshot.deleteItems([project])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func updateCurrentProjectSelected() {
        let centerPoint = self.view.convert(collectionView.center, to: collectionView)
        guard let indexPathSafe = collectionView.indexPathForItem(at: centerPoint) else { return }
        guard let item = dataSource.itemIdentifier(for: indexPathSafe) else { return }
        // como el metodo es ejectado varias veces,
        // esto verifica si ya tenemos un valor igual no se asigne el mismo valor varias veces
        if currentProjectSelected != item {
            currentProjectSelected = item
            pageIndicatorIndex = indexPathSafe.row
            impactFeedback.impactOccurred()
        }
    }
    
    private func updatePageIndicatorColor() {
        guard let project = currentProjectSelected,
              let color =  ProjectColors(rawValue: Int(project.color ))?.value else { return }
        pageIndicator.currentPageIndicatorTintColor = color
    }
    
    private func setupDataSource() {
        dataSource = ProjectDataSource(collectionView: collectionView) { (collectionView, indexPath, project) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectViewCell.cellID, for: indexPath) as? ProjectViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: project)
            return cell
        }
    }
    
    private func updateDataSourceSnapshot() {
        collectionView.backgroundView = nil
        
        var snapshot = ProjectSnapshot()
        snapshot.appendSections([.projects])
        snapshot.appendItems( projectsData, toSection: .projects)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: false)
            self.pageIndicator.numberOfPages = self.projectsData.count
            if self.projectsData.isEmpty {
                self.collectionView.backgroundView = TMEmptyView(message: "Sin Proyectos ☝️")
                self.currentProjectSelected = nil
            }
        }
    }
    
    private func generateLayout()->UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // 1.0 = 100%
            let itemFractionalWidth: CGFloat = 1.0
            let itemFractionalHeight: CGFloat = 1.0
            let groupFractionalWidth: CGFloat = 0.75
            let groupFractionalHeight: CGFloat = 1.0
            let spacingBetweenGroups: CGFloat = 0
            let sectionTopBottomInset: CGFloat = 20
            // calcula el espacio lateral entre el item para centrarlo !!!
            // groupPagingCenter no funciona adecuadamente!!!!
            let actuaLayoutContainerWidth = layoutEnvironment.container.effectiveContentSize.width
            let paddingToCenterItem: CGFloat = (actuaLayoutContainerWidth - (actuaLayoutContainerWidth * groupFractionalWidth)) / 2
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidth), heightDimension: .fractionalHeight(itemFractionalHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .fractionalHeight(groupFractionalHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacingBetweenGroups
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: sectionTopBottomInset, leading: paddingToCenterItem, bottom:sectionTopBottomInset, trailing: paddingToCenterItem)
            
            section.visibleItemsInvalidationHandler = { (items, offset, environment) in
                items.forEach { item in
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let minScale: CGFloat = 0.85
                    let maxScale: CGFloat = 1
                    let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                    // Obtener el item que se muestra al centro cada vez que las celdas visibles cambien
                    self.updateCurrentProjectSelected()
                }
            }
            return section
        }
        return layout
    }
    
}

extension TMProjectsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let projectSelected = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let projectDetailVC = ProjectDetailVC(project: projectSelected)
        navigationController?.pushViewController(projectDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        contextMenuConfigurationActions(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath)
        else {
            return nil
        }
        
        let targetedPreview = UITargetedPreview(view: cell)
        targetedPreview.parameters.backgroundColor = .clear
        return targetedPreview
    }
    
}
