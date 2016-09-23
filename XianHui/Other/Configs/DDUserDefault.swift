//
//  DDUserDefault.swift
//  DingDong
//
//  Created by Seppuu on 16/6/3.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import Palau


typealias Defaults = PalauDefaults
typealias Defaultable = PalauDefaultable
/// Your defaults are defined as extension of PalauDefaults
///
/// - The generic type of your PalauDefaultsEntry must conform
///   to the protocol PalauDefaultable.
/// - We provide support for the most common types.
/// - `value` is a helper function defined in PalauDefaults
/// - The String "backingName" is the key used in NSUserDefaults
/// - The empty `set` is used to please the compiler
extension PalauDefaults {
    
    
    public static var userToken: PalauDefaultsEntry<String> {
        get {
            return value("userToken").whenNil(use:defaultToken)
        }
        set {
            
        }
    }
    
    public static var actualApiUrl: PalauDefaultsEntry<String> {
        get {
            return value("actualApiUrl").whenNil(use:"")
        }
        set {
            
        }
    }
    
    //登录的时候返回,设置
    public static var userSSID: PalauDefaultsEntry<String> {
        get {
            return value("userSSID").whenNil(use: "")
        }
        set {
            
        }
    }
    
    

    public static var hasLessonUpload: PalauDefaultsEntry<Bool> {
        get {
            return value("hasLessonUpload").whenNil(use: false)
        }
        set {
            
        }
    }
    
    
    public static var useTouchID: PalauDefaultsEntry<Bool> {
        get {
            return value("useTouchID").whenNil(use:false )
        }
        set {
            
        }
    }
    
    public static var localPassword: PalauDefaultsEntry<String> {
        get {
            return value("localPassword").whenNil(use:"")
        }
        set {
            
        }
    }
    
    public static var cashMaxValue: PalauDefaultsEntry<Int> {
        get {
            return value("cashMaxValue").whenNil(use:15000)
        }
        set {
            
        }
    }
    
    public static var projectMaxValue: PalauDefaultsEntry<Int> {
        get {
            return value("projectMaxValue").whenNil(use:7000)
        }
        set {
            
        }
    }
    
    public static var productMaxValue: PalauDefaultsEntry<Int> {
        get {
            return value("productMaxValue").whenNil(use:5000)
        }
        set {
            
        }
    }
    
    public static var customerMaxValue: PalauDefaultsEntry<Int> {
        get {
            return value("customerMaxValue").whenNil(use:20)
        }
        set {
            
        }
    }
    
    public static var employeeMaxValue: PalauDefaultsEntry<Int> {
        get {
            return value("employeeMaxValue").whenNil(use:500)
        }
        set {
            
        }
    }
  
}
