//
//  CompanyView.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Company {
    let name, user : String
}

/* I'm implementing this view independently for the ease of future re-use */
class CompanyView : UITableViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: IconLabelView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.rowBackground()
        
        companyNameLabel.textColor = UIColor.rowTitleText()
        userNameLabel.textColor = UIColor.rowDescriptionText()
        
    }
    
    static func createCompany(_ data: JSON) -> Company? {
        if let name = data["name"].string, let users = data["users"].array {
            if users.count > 0 && users[0]["name"].string != nil {
                return Company(name: name, user: users[0]["name"].stringValue)
            }
            
        }
        return nil
    }
    
   
}

