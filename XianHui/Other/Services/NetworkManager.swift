//
//  NetworkManager.swift
//  DingDong
//
//  Created by Seppuu on 16/6/3.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift


enum  VerifyCodeType: String{
    
    case sms = "sms"
    case voice = "voice"
    
}

enum UserType:String {
    case Customer = "customer"
    case Employee = "employee"
}

///网络请求基本回调
typealias DDResultHandler = (success:Bool,json:JSON?,error:String?) -> Void

public typealias JSONDictionary = [String: AnyObject]


class NetworkManager {
    
    static var sharedManager = NetworkManager()
    
    var baseDict: JSONDictionary = [
        "token":Defaults.userToken.value!,
        "ssid" :Defaults.userSSID.value!
    ]
    
    //MARK:用户
    
    //login
    func loginWith(userName:String,passWord:String,usertype:UserType,completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "username":userName,
            "password":passWord,
            "type"    :usertype.rawValue
        ]
        
        let urlString = loginURL
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //登出
    func userLogOut(completion:DDResultHandler) {
        
        //let newDict = generatePostDictWithBaseDictOr(nil)
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = logOutURL
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    
    func updateUserAvatarWith(avatar:UIImage,completion:DDResultHandler) {
        
        let dict = [
            "token":Defaults.userToken.value!
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        let urlString = updateAvatarURL
        
        let zipData = UIImageJPEGRepresentation(avatar, 0.1)
        
        Alamofire.upload(.POST, urlString, multipartFormData: { (multipartFormData) in
            
            //json dict
            for (key, value) in newDict {
                let str = String(value)
                multipartFormData.appendBodyPart(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            //add iamge data if need
            if zipData != nil {
                multipartFormData.appendBodyPart(data: zipData!, name: "avator", fileName: "avator.jpg", mimeType: "image/jpg")
            }
            
            
        }) { (encodingResult) in
            
            switch encodingResult {
            case .Success(let upload, _, _ ):
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    let json = JSON(response.result.value!)
                    
                    if json["status"].string == "ok" {
                        let avatarUrlString = json["data"]
                        completion(success: true, json: avatarUrlString,error: nil)
                    }
                    else {
                        let msg = self.getErrorMsgFrom(json)
                        completion(success: false, json: nil,error: msg)
                    }
                    
                })
                
                
            case .Failure(let encodingError):
                print("Failure")
                print(encodingError)
                completion(success: false, json: nil,error:"请求失败")
            }
            
        }
        
    }
    
    //完善用户信息
    func updateUserInfo(with firstName:String,lastName:String,avatarData:NSData?,completion:DDResultHandler) {
        
        let dict = [
            "first_name":firstName,
            "last_name" :lastName
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        let urlString = updateUserInfoURL
        
        Alamofire.upload(.POST, urlString, multipartFormData: { (multipartFormData) in
            
            //json dict
            for (key, value) in newDict {
                let str = String(value)
                multipartFormData.appendBodyPart(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            //add iamge data if need
            if avatarData != nil {
               multipartFormData.appendBodyPart(data: avatarData!, name: "avator", fileName: "avator.jpg", mimeType: "image/jpg")
            }
            
            
        }) { (encodingResult) in
            
            switch encodingResult {
            case .Success(let upload, _, _ ):
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    let json = JSON(response.result.value!)
                    
                    if json["status"].int == 1 {
                        let dataInfo = json["dataInfo"]
                        completion(success: true, json: dataInfo,error: nil)
                    }
                    else {
                        let msg = self.getErrorMsgFrom(json)
                        completion(success: false, json: nil,error: msg)
                    }
                    
                })
                
                
            case .Failure(let encodingError):
                print("Failure")
                print(encodingError)
                completion(success: false, json: nil,error:"请求失败")
            }
            
        }
        
    }
    

}

//MARK:用户关系管理
extension NetworkManager {
    
    func getUserList(completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = userListUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
}

//MARK:日报表
extension NetworkManager {
    
    //获取日报表数据
    func getDailyReportDataWith(date:String,completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "date":date
        ]
        
        let urlString = GetDailyReportDataUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    
    func getDailyReportMaxVaule(completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = GetDailyReportMaxVauleUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    func saveDailyReportMaxVaule(completion:DDResultHandler) {
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = SaveDailyReportMaxVauleUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
}


extension NetworkManager {
    
    //计划顾客列表
    func getCustomerPlanListWith(completion:DDResultHandler) {
        
        let urlString = GetCustomerPlanListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //预约顾客列表
    func getCustomerScheduleListWith(startDate:String,days:Int,completion:DDResultHandler) {
        
        let urlString = getCustomerScheduleListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "date":startDate,
            "days":days
        ]
        
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    
    func getCustomerDetailWith(id:Int,completion:DDResultHandler) {
        
        let urlString = GetCustomerDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //详细的消费记录
    func getCustomerConsumeListWith(id:Int,pageSize:Int,pageNumber:Int,completion:DDResultHandler) {
        
        let urlString = GetCustomerConsumeUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id,
            "pageSize":pageSize,
            "pageNumber":pageNumber
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //详细的预约记录
    func getCustomerSchedulesUrlWith(id:Int,date:String,completion:DDResultHandler) {
        
        let urlString = GetCustomerSchedulesUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id,
            "date":date
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    
    //获取项目,产品计划
    func getGoodPlanListWith(id:Int,completion:DDResultHandler) {
        
        let urlString = GetGoodPlanListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //保存项目,产品计划
    func saveGoodPlanWith(id:Int,ids:String,completion:DDResultHandler) {
        
        let urlString = SaveGoodPlanUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id,
            "ids":ids
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
}

//MARK:系统管理
extension NetworkManager {
    
    //发送反馈
    func submitFeedback(with content:String, completion:DDResultHandler) {
        
        let urlString = submitFeedBackURL
        let jsonDict:JSONDictionary = [
            "content":content
        ]
        let dict = generatePostDictWithBaseDictOr(jsonDict)

        baseRequestWith(urlString, dict: dict, completion: completion)
    }
}


//MAKR:基本请求方法
extension NetworkManager {
    
    private func addSignTo( dict:JSONDictionary) -> JSONDictionary {
        
        let keys = dict.keys
        
        let sortedKeys = keys.sort { (value1, value2) -> Bool in
            return value1 < value2
        }
        
        var parameter = ""
        
        for key in sortedKeys {
            parameter += key + "\(dict[key]!)"
        }
        
        let md5 = parameter.md5
        
        var newDict = dict
        
        newDict["sign"] = md5
        
        return newDict
    }
    
    private func getErrorMsgFrom(json:JSON) -> String {
        var msg = ""
        msg = json["message"].string!
        
        return msg
    }
    
    //生成post参数.
    private func generatePostDictWithBaseDictOr(dict:JSONDictionary?) -> JSONDictionary {
        
        var d = JSONDictionary()
        
        for (key,value) in baseDict {
            
            d[key] = value
            
        }
        if dict != nil {
            
            for (key,value) in dict! {
                
                d[key] = value
                
            }
        }
        else {
            //不需要其他参数了.
        }
        
        return addSignTo(d)
        
    }
    //REQUEST
    //基本请求,返回 status dataInfo errorMsg
    private func baseRequestWith(urlString:String,dict:JSONDictionary,completion:DDResultHandler) {
        
        Alamofire.request(.POST, urlString, parameters: dict)
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    let json = JSON(response.result.value!)
                    if json["status"].string! == "ok" {
                        let dataInfo = json["data"]
                        completion(success: true,json:dataInfo,error: nil)
                        
                    }
                    else {
                        let msg = self.getErrorMsgFrom(json)
                        completion(success: false, json: nil, error: msg)
                    }
                case .Failure(let error):
                    completion(success: false, json: nil, error: error.description)
                    
                }
        }
    }
    
    
    //UPLOAD
    
}


