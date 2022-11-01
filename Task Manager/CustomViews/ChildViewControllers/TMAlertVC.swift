//
//  TMAlertVC.swift
//  Task Manager
//
//  Created by Duilan on 31/10/22.
//

import UIKit

class TMAlertVC: UIViewController {
    
    // MARK: -  Properties
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    
    private var alertTitle: String
    private var alertMessage: String
    private var buttonTitle: String
    private let padding: CGFloat = 20.0
    
    // MARK: -  Init
    init(title: String, message: String, buttonTitle: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        setupContainerView()
        setupTitleLabel()
        setupActionButton()
        setupMessageLabel()
    }
    
    // MARK: -  Methods
    @objc private func actionButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.cornerCurve = .continuous
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //Constrains
        containerView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 260).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        //Constrains
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = alertMessage
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .preferredFont(forTextStyle: .body)
        //Constrains
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor).isActive = true
    }
    
    private func setupActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        //Constrains
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
