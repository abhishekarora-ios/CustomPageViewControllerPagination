//
//  ColorExtension.swift
//  dineout
//
//  Created by Vipul Singhania on 03/02/17.
//  Copyright © 2017 TIL. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let recommendationRed = UIColor.rgb(255.0, 100.0, 90.0)
    static let borderGrey = UIColor.rgb(99.0, 99.0, 99.0)
    
    static func rgb(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func getColorForUserRating(_ rating: Float) -> UIColor {
        switch rating {
        case 4.5...5.0:
            return UIColor.rgb(0, 152, 62)
        case 4.0..<4.5:
            return UIColor.rgb(0, 177, 72)
        case 3.5..<4.0:
            return UIColor.rgb(0, 211, 86)
        case 3.0..<3.5:
            return UIColor.rgb(119, 232, 41)
        case 2.5..<3.0:
            return UIColor.rgb(179, 242, 0)
        case 2.0..<2.5:
            return UIColor.rgb(229, 242, 0)
        case 1.5..<2.0:
            return UIColor.rgb(242, 221, 0)
        case 1.0..<1.5:
            return UIColor.rgb(255, 178, 73)
        default:
            return UIColor.rgb(250, 87, 87)
        }
    }
    
    func HexToColor(_ hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static func convertHexToColor(_ hexString: String?, alpha:CGFloat? = 1.0) -> UIColor? {
        // Convert hex string to an integer
        guard let hexString = hexString else {
            return nil
        }
        if hexString.count == 0 {
            return nil
        }
        let hexint = Int(self.intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
}
