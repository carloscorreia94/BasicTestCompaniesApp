//
//  UIHelpers.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//

import Foundation


class UIHelpers {
    
    class func presentDialog(title: String,message: String, vController: UIViewController, action: ((UIAlertAction) -> ())? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
        vController.present(ac, animated: true, completion: nil)
    }
    
}
