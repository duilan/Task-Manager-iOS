//
//  TMProjectsVC.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import UIKit

protocol TMProjectsProtocol: class {
    func projectDidChange(project: Project?)
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
        pageIndicator.pageIndicatorTintColor = ThemeColors.accentColor.withAlphaComponent(0.2)
        pageIndicator.isUserInteractionEnabled = false
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
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
            collectionView.bottomAnchor.constraint(equalTo: pageIndicator.topAnchor)
        ])
    }
    
    private func animateToStartItem() {
        collectionView.transform = CGAffineTransform(translationX: (self.view.bounds.width), y: 0).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        pageIndicatorIndex = 0
        currentProjectSelected = self.projectsData.first
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            self.collectionView.transform = .identity
            self.pageIndicator.numberOfPages = self.projectsData.count
        }
    }
    
    private func getProjectAtCenterPoint() {
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
        if projectsData.isEmpty {
            DispatchQueue.main.async {
                self.collectionView.backgroundView = TMEmptyView(message: "Sin Proyectos ☝️")
            }
        }
        
        var snapshot = ProjectSnapshot()
        snapshot.appendSections([.projects])
        snapshot.appendItems( projectsData, toSection: .projects)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: false)
            self.animateToStartItem()
        }
    }
    
    private func generateLayout()->UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // 1.0 = 100%
            let itemFractionalWidth: CGFloat = 1.0
            let itemFractionalHeight: CGFloat = 1.0
            let groupFractionalWidth: CGFloat = 0.65
            let groupFractionalHeight: CGFloat = 1.0
            let spacingBetweenGroups: CGFloat = 24
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: paddingToCenterItem, bottom: 0, trailing: paddingToCenterItem)
            
            section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, point, env) -> Void in
                guard let self = self else { return }
                // Obtener el item que se muestra al centro cada vez que las celdas visibles cambien
                self.getProjectAtCenterPoint()
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
}
