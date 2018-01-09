//
//  CompanyView.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//

import Foundation

/* I'm implementing this view independently for the ease of future re-use */
class CompanyView : UITableViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.rowBackground()
        
        companyNameLabel.textColor = UIColor.rowTitleText()
        userNameLabel.textColor = UIColor.rowDescriptionText()

        let text = NSAttributedString()
        text.setTextWithIcon("", icon: UIImage(named:"ic_person")!)
        userNameLabel.attributedText = text
        
    }
    
    
   
}

extension NSAttributedString {
    func setTextWithIcon(_ text : String, icon: UIImage) {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = icon
        
        //Set bound to reposition
        let imageOffsetY:CGFloat = -5.0;
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: text)
        completeText.append(textAfterIcon)
        
    }
}
