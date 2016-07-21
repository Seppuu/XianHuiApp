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
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

