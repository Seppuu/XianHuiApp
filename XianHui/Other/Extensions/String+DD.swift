//
//  String+DD.swift
//  DingDong
//
//  Created by Seppuu on 16/3/16.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

extension String {
    
    
    mutating func removeCharsFromEnd(count:Int) -> String {
        
        for _ in 0..<count {
            
            self.removeAtIndex(self.endIndex.predecessor())
            
        }
        
        return self
    }
    
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        
        var textSize:CGSize!
        
        if CGSizeEqualToSize(size, CGSizeZero) {
            
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            
            textSize = self.sizeWithAttributes(attributes as! [String : AnyObject] as [String : AnyObject])
            
        } else {
            
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes as! [String : AnyObject] as [String : AnyObject], context: nil)
            
            textSize = stringRect.size
            
        }
        
        return textSize
        
    }
    
    
    /**
     Encode a String to Base64
     
     :returns:
     */
    func toBase64()->String{
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
    }
    
    func fromBase64() -> String{
        
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: NSUTF8StringEncoding)!
    }
    
    
    var md5: String! {
        
        return self.md5
    }
    
    
    
    func tokenByPassword() -> String {
        //demo直接使用username作为account，md5(password)作为token
        //接入应用开发需要根据自己的实际情况来获取 account和token
        return md5
    }
    
    //下标取子字符串
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            
            return self[Range(startIndex..<endIndex)]
        }
    }
    
    func isPhoneNumber() -> Bool {
        
        var isPhone = false
        let threeNum = self[0...2]
        PhoneNumbers.phones.forEach { (numbers) in
            
            for i in 0..<numbers.count {
                
                if threeNum == String(numbers[i]) {
                    isPhone =  true
                    
                }
                
            }
            
        }
        
    
        return isPhone
    }

    func stringByAppendingPathComponent(path: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(path)
    }
    
}
