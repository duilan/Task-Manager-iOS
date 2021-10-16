//
//  HomeVC.swift
//  Task Manager
//
//  Created by Duilan on 08/10/21.
//

import UIKit

class HomeVC: UIViewController {
    
    private let welcomeHeader = WelcomeHeaderView()
    private let scrollView = UIScrollView()
    private let contentView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationButtonItems()
        setupScrollView()
        setupContentView()
        setupWelcomeHeader()
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
    
}
