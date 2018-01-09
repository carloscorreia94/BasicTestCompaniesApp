//
//  Colors.swift
//  UpsalesBasicClients
//
//  Created by NTW-laptop on 09/01/18.
//  Copyright © 2018 NTW - Web Technology. All rights reserved.
//

import Foundation


struct Colors {
    static let rowTitleText = "000000"
    static let rowDescriptionText = "4B5562"
    static let rowBackground = "FFFFFF"

    static let baseBackground = "002F65"
  
    static let sectionHeaderCompanyPeopleNumber = "A4B3C7"
    static let mainHeaderTitle = "FFFFFF"

}

extension UIColor {
    static func rowBackground() -> UIColor {
        return UIColor().HexToColor(hexString: Colors.rowBackground)
    }
    
    static func baseBackground() -> UIColor {
        return UIColor().HexToColor(hexString: Colors.baseBackground)
    }
    
    static func rowTitleText() -> UIColor {
        return UIColor().HexToColor(hexString: Colors.rowTitleText)
    }
    
    static func rowDescriptionText() -> UIColor {
        return UIColor().HexToColor(hexString: Colors.rowDescriptionText)
    }
    
    static func sectionHeaderCompanyPeopleNumber() -> UIColor {
        return UIColor().HexToColor(hexString: Colors.sectionHeaderCompanyPeopleNumber)
    }
    
    static func mainHeaderTitle() -> UIColor {
        return UIColor().HexToColor(hexString: Colors.mainHeaderTitle)
    }
}

//Simple util to get UIColor instances from HEX codes. Taken from StackOverFlow
//Source: https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
extension UIColor {
    
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    
    convenience init(red: UInt32, green: UInt32, blue: UInt32, alphaH: UInt32) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alphaH >= 0 && alphaH <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alphaH) / 255.0)
    }
    
    convenience init(netHex: UInt32) {
        let mask : UInt32 = 0xff
        self.init(red: (netHex >> 16) & mask, green: (netHex >> 8) & mask, blue: netHex & mask, alphaH: (netHex >> 24) & mask)
    }

}
