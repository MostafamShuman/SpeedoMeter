//
//  UIBorderButton.swift
//  SpeedoMeter
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import UIKit

@IBDesignable
class UIBorderButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit(){
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = titleLabel?.textColor.cgColor
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
}
