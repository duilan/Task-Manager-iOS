//
//  TMDateField.swift
//  Task Manager
//
//  Created by Duilan on 05/11/21.
//

import UIKit

class TMDateField: UITextField {
    private let datePicker = UIDatePicker()
    private let titleLabel = UILabel()
    private let borderView = UIView()
    private let paddingInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 8, bottom: 0, right: 8)
    
    private(set) var date: Date?
    
    var dateFormatter: DateFormatter = DateFormatter()
    
    var title: String? {
        didSet {
            titleLabel.text = title?.uppercased()
        }
    }
    
    var datePickerMode: UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = datePickerMode
            setupDateFormatter()
            guard date != nil else { return }
            updateDate()
        }
    }
    
    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }
    
    override var tintColor: UIColor! {
        didSet {
            borderView.backgroundColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupDateFormatter()
        setupDatePicker()
        setupTitleLabel()
        setupBorderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultDate(_ date: Date = Date() ) {
        self.date = date
        self.datePicker.date = date
        self.text = self.dateFormatter.string(from: date)
    }
    
    @objc private func updateDate() {
        DispatchQueue.main.async {
            self.date = self.datePicker.date
            self.text = self.dateFormatter.string(from: self.datePicker.date)
        }
    }
    
    @objc private func editEvent() {
        if isFirstResponder {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.textColor = self.tintColor
                self.borderView.alpha = 1
                self.borderView.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.textColor = self.textColor?.withAlphaComponent(0.6)
                self.borderView.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
        }
    }
    
    private func setup() {
        self.textColor = ThemeColors.title
        self.tintColor = ThemeColors.accentColor
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.addTarget(self, action: #selector(editEvent), for: .allEditingEvents)
        self.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    private func setupDateFormatter() {        
        dateFormatter.dateStyle = .medium
        switch datePickerMode {
        case .time:
            dateFormatter.dateFormat = "HH:mm"
        case .date:
            dateFormatter.dateFormat = "d MMMM yyyy"
        case .dateAndTime:
            dateFormatter.dateFormat = "d MMM yyyy HH:mm"
        case .countDownTimer:
            dateFormatter.dateFormat = "HH:mm"
        @unknown default:
            dateFormatter.dateFormat = "d MMM yyyy HH:mm"
        }
        
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = self.datePickerMode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.inputView = datePicker
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
    }
    
    private func setupBorderView() {
        addSubview(borderView)
        borderView.alpha = 0
        borderView.backgroundColor = self.tintColor
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 2)
        ])
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: paddingInset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: paddingInset))
    }
    
}
