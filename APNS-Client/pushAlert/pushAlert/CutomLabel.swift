//
//  CutomLabel.swift
//  pushAlert
//
//  Created by Anantha Krishnan K G on 12/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit

@IBDesignable
public class CutomLabel:UILabel {
    
    
    public let layerColor:UIColor = UIColor(colorLiteralRed: 178/255, green: 37/255, blue: 81/255, alpha: 1)
    
    @IBInspectable public var borderColor: UIColor = UIColor.green {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable public var borderWidth: Double = 2.0 {
        didSet {
            self.layer.borderWidth  = CGFloat(borderWidth)
        }
    }
    @IBInspectable public var cornerRadius: Double = 2.0 {
        didSet {
            self.layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = layerColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10.0
    }
    // MARK: Initialization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
