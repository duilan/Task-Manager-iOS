//
//  TMWelcomeHeaderView.swift
//  Task Manager
//
//  Created by Duilan on 13/10/21.
//

import UIKit

class TMWelcomeHeaderView: UIView {
    
    private let titleLabel = TMTitleLabel(fontSize: 34)
    private let subtitleLabel = TMSubtitleLabel()
    private let subtitlesData = ["Completemos algunas tareas!","Con diciplina lo lograrás!","Imposible es lo que no intentas!","No te rindas, ¡tú puedes!","¡Aprendamos de los errores!","El camino al éxito es la actitud.","Descansa, pero no te rindas!"]
    
    public var title: String? {
        didSet {
            updateLabels()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLabels() {
        DispatchQueue.main.async {
            self.titleLabel.text = self.title
            self.subtitleLabel.text = self.subtitlesData.randomElement()
        }
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        self.translatesAutoresizingMaskIntoConstraints = false
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
