//
//  Array+DD.swift
//  DingDong
//
//  Created by Seppuu on 16/3/3.
//  Copyright © 2016年 seppuu. All rights reserved.
//


extension Array {
    
    subscript (safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }

    
}

extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

extension Int {
   
    //转化成逢千位加逗号
    func convertToKiloPerCommaString() -> String {
        
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        let numString = fmt.string(from: NSNumber(value: self))
        
        return numString!
    }
}




