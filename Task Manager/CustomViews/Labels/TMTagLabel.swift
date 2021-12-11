//
//  TMTagLabel.swift
//  Task Manager
//
//  Created by Duilan on 10/12/21.
//

import UIKit

class TMTagLabel: UILabel {
    
    private let paddingInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    
    var accentColor: UIColor = .systemBlue {
        didSet {
            self.backgroundColor = accentColor.withAlphaComponent(0.2)
            self.textColor = accentColor.darker()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // default color
        accentColor = UIColor.systemBlue
        font = .systemFont(ofSize: 12, weight: .regular)
        textAlignment = .center
        numberOfLines = 1
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize:CGSize {
        var s = super.intrinsicContentSize
        s.height = s.height + paddingInsets.top + paddingInsets.bottom
        s.width = s.width + paddingInsets.left + paddingInsets.right
        return s
    }
    
    override func drawText(in rect:CGRect) {
        let r = rect.inset(by: paddingInsets)
        super.drawText(in: r)
    }
    
    override func textRect(forBounds bounds:CGRect, limitedToNumberOfLines n:Int) -> CGRect {
        let b = bounds
        let tr = b.inset(by: paddingInsets)
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: 0)
        // that line of code MUST be LAST in this function, NOT first
        return ctr
    }
}
