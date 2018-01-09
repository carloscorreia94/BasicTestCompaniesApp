//
//  IconLabelView.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class IconLabelView: UIView {
    
    
    private var textLabel = UILabel()
    var iconImageView = UIImageView()
    
    //MARK:- Properties
    var textFont:UIFont = UIFont.systemFont(ofSize: 13.0) {
        didSet {
            textLabel.font = textFont
        }
    }
    
    @IBInspectable var textColor:UIColor = UIColor.darkText {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    @IBInspectable var iconImage:UIImage = UIImage() {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
    @IBInspectable var text:String = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    //MARK:- Initializations
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    //MARK:- Overrides
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewHeight = frame.height
        let viewWidth = frame.width
        
        iconImageView.frame = CGRect(x: 0, y: 0, width: viewHeight, height: viewHeight)
        textLabel.frame = CGRect(x: viewHeight, y: 0, width: viewWidth - viewHeight, height: viewHeight)
    }
    
    //MARK:- Privates
    private func setup() {
        textLabel.font = UIFont(name: "Roboto-Regular", size: frame.height * 0.8)!
        textLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        textLabel.textAlignment = NSTextAlignment.left
        self.addSubview(textLabel)
        
        iconImageView.contentMode = UIViewContentMode.center
        self.addSubview(iconImageView)
    }
    
}
