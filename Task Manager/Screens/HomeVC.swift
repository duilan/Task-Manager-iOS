//
//  HomeVC.swift
//  Task Manager
//
//  Created by Duilan on 08/10/21.
//

import UIKit
import BetterSegmentedControl

class HomeVC: UIViewController {
    
    private let welcomeHeader = TMWelcomeHeaderView()
    private let segmentedControl = BetterSegmentedControl()
    private let scrollView = UIScrollView()
    private let contentView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationButtonItems()
        setupScrollView()
        setupContentView()
        setupWelcomeHeader()
        setupSegmentedControl()
    }
    
    @objc private func segmentIndexChanged(_ sender: BetterSegmentedControl) {
        print(sender.index)
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
        title = "Proyectos"
    }
    
    private func setupNavigationButtonItems() {
        let userImageSymbol = UIImage(systemName: "person.circle.fill")
        let addImageSymbol = UIImage(systemName: "plus")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: userImageSymbol, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addImageSymbol, style: .plain, target: self, action: nil)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        //scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let paddingForContentView: CGFloat = 16
        // Constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -paddingForContentView * 2),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: 1)
        ])
    }
    
    private func setupWelcomeHeader() {
        contentView.addSubview(welcomeHeader)
        welcomeHeader.title = "Hola Adrián"
        // Constraints
        NSLayoutConstraint.activate([
            welcomeHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            welcomeHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            welcomeHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            welcomeHeader.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupSegmentedControl() {
        contentView.addSubview(segmentedControl)
        segmentedControl.cornerRadius = 22.5
        segmentedControl.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6156862745, blue: 0.6156862745, alpha: 0.08)
        segmentedControl.addTarget(self, action: #selector(segmentIndexChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure BettersegmentedControl segmets
        segmentedControl.segments = LabelSegment.segments(
            withTitles: ["Mis Proyectos", "En Progreso", "Completados"],
            normalFont: .systemFont(ofSize: 12.0, weight: .regular),
            normalTextColor: .lightGray,
            selectedFont: .systemFont(ofSize: 12.0, weight: .bold),
            selectedTextColor: ThemeColors.title)
        
        // Constraints
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: welcomeHeader.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
}
