//
//  TMProjectsVC.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import UIKit

protocol TMProjectsProtocol: class {
    func ItemCenterDidChange(itemIndex: Int)
}

class TMProjectsVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section,Project>!
    private let projectsData = DummyData.shared.projects
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // Protocolo Delegado
    weak var delegate: TMProjectsProtocol?
    
    private enum Section: String, Hashable {
        case projects = "Proyectos"
        case tasks = "Tareas"
    }
    
    var projectFilter: StatusProject? {
        didSet {
            updateDataSourceSnapshot( with: projectsData , filter: projectFilter)
            self.resetScroll()
        }
    }
    
    private var currentItemIndex: Int = -1 {
        didSet { delegate?.ItemCenterDidChange(itemIndex: currentItemIndex) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
        setupDataSource()
        updateDataSourceSnapshot( with: projectsData , filter: projectFilter)
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
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
    
    private func resetScroll() {
        collectionView.transform = CGAffineTransform(translationX: (self.view.bounds.width), y: 0).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            self.collectionView.transform = .identity
        }
    }
    
    private func findCenterIndex() {
        let center = self.view.convert(collectionView.center, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: center)
        guard let indexPathSafe = indexPath else { return }
        // como el metodo es ejectado varias veces,
        // esto verifica si ya tenemos un valor igual no se asigne el mismo valor varias veces
        guard currentItemIndex != indexPathSafe.row else { return }
        currentItemIndex = indexPathSafe.row
        impactFeedback.impactOccurred()
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Project>(collectionView: collectionView) { (collectionView, indexPath, projectItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectViewCell.cellID, for: indexPath) as? ProjectViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: projectItem)
            return cell
        }
    }
    
    private func updateDataSourceSnapshot(with projects: [Project], filter: StatusProject? = nil) {
        var projectsDataSource = projects
        if filter !=  nil {
            projectsDataSource = projects.filter({ (project) -> Bool in
                return project.status == filter
            })
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,Project>()
        snapshot.appendSections([.projects])
        snapshot.appendItems( projectsDataSource, toSection: .projects)
        dataSource.apply(snapshot, animatingDifferences: false)
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
                self.findCenterIndex()
            }
            return section
        }
        return layout
    }
    
}
