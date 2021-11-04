//
//  TMTextView.swift
//  Task Manager
//
//  Created by Duilan on 02/11/21.
//

import UIKit

class TMTextView: UITextView {
    
    private let titleLabel = UILabel()
    private let borderView = UIView()
    private let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
    
    var title: String? {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.title?.uppercased()
            }
        }
    }
    
    var maximumNumberOfLines: Int = 0 {
        didSet {
            textContainer.maximumNumberOfLines = maximumNumberOfLines
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
        setupTitleLabel()
        setupBorderView()
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.textColor = ThemeColors.text
        self.tintColor = ThemeColors.accentColor
        self.textContainer.maximumNumberOfLines = maximumNumberOfLines
        self.textContainer.lineBreakMode = .byWordWrapping
        self.textContainerInset = UIEdgeInsets(top: 30, left: 3, bottom: 8, right: 3)
        self.isScrollEnabled = false
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        // UITextViewDelegate
        self.delegate = self
        
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)        
        titleLabel.textColor = textColor?.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func setupBorderView() {
        addSubview(borderView)
        borderView.alpha = 0
        borderView.backgroundColor = ThemeColors.accentColor        
    }
    
    private func setupToolbar() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.tintColor = ThemeColors.accentColor
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        DispatchQueue.main.async { self.endEditing(true) }
    }
    
    private func showBorder(_ enable: Bool) {
        if enable {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.textColor = ThemeColors.accentColor
                self.borderView.transform = .identity
                self.borderView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.textColor = self.textColor?.withAlphaComponent(0.6)
                self.borderView.alpha = 0
                self.borderView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView.frame = CGRect(x: 0, y: 0, width: 2, height: bounds.height)
    }
    
}

// MARK: -  UITextViewDelegate
extension TMTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        showBorder(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        showBorder(false)
    }
    
}
