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
    
    private var currentProjectSelected: Project?
    
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
        pageIndicator.hidesForSinglePage = true
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
            
            let statusActions: [UIAction] = StatusProject.allCases.compactMap({ status in
                if status == project.statusDescription { return nil }
                return UIAction(
                    title: "Pasar a \(status.rawValue)",
                    image: UIImage(systemName: status.icon)) { (action) in
                    
                    project.statusDescription = status
                    CoreDataManager.shared.update() { [weak self] in
                        self?.removeInSnapshot(project)
                        self?.delegate?.projectUpdated()
                    }
                }
            })
            
            var actionsForContextMenu: [UIAction] = []
            actionsForContextMenu.append(deleteAction)
            actionsForContextMenu.append(contentsOf: statusActions)
            
            return UIMenu(title: "OPCIONES DEL PROYECTO",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: actionsForContextMenu)
        }
    }
    
    func animateToStartItem() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        pageIndicatorIndex = 0
    }
    
    private func removeInSnapshot(_ project: Project) {
        var currentSnapshot =  dataSource.snapshot()
        currentSnapshot.deleteItems([project])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func changeProjectSelected( index: Int) {
        guard index >= 0 && index < projectsData.count else { return }
        let indexPath = IndexPath(row: index, section: 0)
        // como el metodo es ejectado varias veces, se verifica si el item es diff al actual
        guard let item = dataSource.itemIdentifier(for: indexPath),
              currentProjectSelected != item else { return }
        
        currentProjectSelected = item
        pageIndicatorIndex = index
        updatePageIndicatorColor()
        delegate?.projectDidChange(project: item)
        impactFeedback.impactOccurred()
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
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item , count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacingBetweenGroups
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: sectionTopBottomInset, leading: paddingToCenterItem, bottom:sectionTopBottomInset, trailing: paddingToCenterItem)
            
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
                items.forEach { item in
                    // animacion flow de los items al hacer scroll
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let minScale: CGFloat = 0.85
                    let maxScale: CGFloat = 1
                    let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
                // Obtener el item que se muestra al centro cada vez que la celda visible
                let widthContainer = environment.container.contentSize.width // 375
                let scrollOffset = offset.x // anchura segun el scroll realizado
                let withItem = widthContainer * groupFractionalWidth
                let tolerance: CGFloat = 10.0 // tolerancia
                // obtiene la posicion proxima del siguiente item 2
                let indexFloat: CGFloat =  (scrollOffset-tolerance) / withItem
                // redondeamos para obtener la posicion siguiente ejem: 1.49 = 1 , 1.50 = 2
                let index = Int(indexFloat.rounded(.toNearestOrEven))
                self?.changeProjectSelected(index: index)
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
