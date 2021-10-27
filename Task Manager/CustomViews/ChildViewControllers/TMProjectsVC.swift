//
//  TMProjectsVC.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import UIKit

protocol TMProjectsProtocol: class {
    func projectDidChange(project: Project)
}

class TMProjectsVC: UIViewController {
    
    private typealias ProjectDataSource = UICollectionViewDiffableDataSource<Section,Project>
    private typealias ProjectSnapshot = NSDiffableDataSourceSnapshot<Section,Project>
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
    private var dataSource: ProjectDataSource!
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: -  Delegate TMProjectsProtocol
    weak var delegate: TMProjectsProtocol?
    
    private enum Section: String, Hashable {
        case projects = "Proyectos"
    }
    
    private var currentProjectSelected: Project?   {
        didSet {
            if let projectSelected = currentProjectSelected {
                delegate?.projectDidChange(project: projectSelected)
            }
        }
    }
    
    var projectsData: [Project] = [] {
        didSet {
            updateDataSourceSnapshot()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
        setupDataSource()
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
    
    private func animateToStartItem() {
        collectionView.transform = CGAffineTransform(translationX: (self.view.bounds.width), y: 0).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            self.collectionView.transform = .identity
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
