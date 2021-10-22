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
    let scrollView = UIScrollView()
    let stackContentView = UIStackView()
    
    let headerContainer = UIView()
    let segmentedControlContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationButtonItems()
        setupScrollViewWithStackContainer()
        setupWelcomeHeader()
        setupSegmentedControl()
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
    
    private func setupScrollViewWithStackContainer() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackContentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackContentView.translatesAutoresizingMaskIntoConstraints = false
        
        stackContentView.axis = .vertical
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            stackContentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
//            stackContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0),
//            stackContentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 0),
//
            stackContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
            
        ])
    }
    
    private func setupWelcomeHeader() {
        stackContentView.addArrangedSubview(headerContainer)
        stackContentView.setCustomSpacing(20, after: headerContainer)
        headerContainer.addSubview(welcomeHeader)
        welcomeHeader.title = "Hola Adrián"
        NSLayoutConstraint.activate([
            headerContainer.heightAnchor.constraint(equalToConstant: 60),
            welcomeHeader.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            welcomeHeader.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            welcomeHeader.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            welcomeHeader.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        ])
    }
    
    private func setupSegmentedControl() {
        stackContentView.addArrangedSubview(segmentedControlContainer)
        stackContentView.setCustomSpacing(20, after: segmentedControlContainer)
        segmentedControlContainer.addSubview(segmentedControl)
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
            segmentedControlContainer.heightAnchor.constraint(equalToConstant: 45),
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainer.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainer.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlContainer.trailingAnchor, constant: -16),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlContainer.bottomAnchor)
        ])
    }
    
    
    @objc private func segmentIndexChanged(_ sender: BetterSegmentedControl) {
        print(sender.index)
    }
}
