//
//  GFBodyLabel.swift
//  GitHubFollowers
//
//  Created by Alex on 26.02.2022.
//

import UIKit

class GFBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAligment: NSTextAlignment){
        super.init(frame: .zero)
        self.textAlignment = textAligment
        configure()
    }
    
    private func configure(){
        textColor                                 = .secondaryLabel
        font                                      = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.75
        lineBreakMode                             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
