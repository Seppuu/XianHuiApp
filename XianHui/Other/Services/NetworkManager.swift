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
import SwiftDate

enum  VerifyCodeType: String{
    
    case sms = "sms"
    case voice = "voice"
    
}

enum UserLoginType:String {
    case Customer = "customer"
    case Employee = "employee"
}

enum PhoneCodeType:String {
    case sms = "sms"
    case voice = "voice"
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
    func loginWith(mobile:String,passWord:String,usertype:UserLoginType,completion:DDResultHandler) {
        
        var dict:JSONDictionary!
        
        dict = [
                "mobile":mobile,
                "password":passWord,
                "type"    :usertype.rawValue
            ]
        
        let urlString = loginWithPhoneURL
        
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
    
    
    //获取手机验证码
    func getPhoneCodeWith(mobile:String,usertype:UserLoginType,codeType:PhoneCodeType,completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "mobile":mobile,
            "type":usertype.rawValue,
            "sms_type":codeType.rawValue
        ]
        
        let urlString = getPhoneCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    
    //验证手机验证码
    func verifyPhoneCodeWith(mobile:String,usertype:UserLoginType,code:String,completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "mobile":mobile,
            "type":usertype.rawValue,
            "sms_code":code
        ]
        
        let urlString = verifyPhoneCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //更新密码
    func updatePassWordWith(userName:String,usertype:UserLoginType,passWord:String,completion:DDResultHandler) {
        
        
        let sign = (userName + "-" + usertype.rawValue + "-" + passWord + "-" + NSDate.currentDateString() + "-" + XHPublicKey).md5()
        
        let dict:JSONDictionary = [
            "username":userName,
            "type":usertype.rawValue,
            "password":passWord,
            "sign":sign
        ]
        
        let urlString = updatePassWordUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    //获取企业列表
    func getCompanyListWith(userName:String,usertype:UserLoginType,completion:DDResultHandler) {

        let sign = (userName + "-" + usertype.rawValue + "-" + NSDate.currentDateString() + "-" + XHPublicKey).md5()
        
        let dict:JSONDictionary = [
            "username":userName,
            "type":usertype.rawValue,
            "sign":sign
        ]
        
        let urlString = getCompanyListUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //设置当前企业
    func setCurrentCompanyWith(userName:String,usertype:UserLoginType,agentId:Int,completion:DDResultHandler) {
        
        let sign = (userName + "-" + usertype.rawValue + "-" + String(agentId) + "-" + NSDate.currentDateString() + "-" + XHPublicKey).md5()
        
        let dict:JSONDictionary = [
            "username":userName,
            "type":usertype.rawValue,
            "agent_id":agentId,
            "sign":sign
        ]
        
        let urlString = setCurrentCompanyUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
        
    }
    
    func updateUserAvatarWith(avatar:UIImage,completion:DDResultHandler) {
        
        let dict = [
            "token":Defaults.userToken.value!
        ]
        
        
        let urlString = updateAvatarURL
        
        let zipData = UIImageJPEGRepresentation(avatar, 0.1)
        
        Alamofire.upload(.POST, urlString, multipartFormData: { (multipartFormData) in
            
            //json dict
            for (key, value) in dict {
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


//MARK:二维码
extension NetworkManager {

    //二维码登陆ERP
    func logInERPWith(qrCode:String,completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "webtoken":qrCode
        ]
        
        let urlString = logInERPWithQRCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //二维码退出ERP
    func logOutERPWith(qrCode:String,completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "webtoken":qrCode
        ]
        
        let urlString = logOutERPWithQRCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取二维码登陆ERP状态.
    func getERPLogInStatus(completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = getERPLogInStatusUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
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
    func getDailyReportDataWith(noticeId:Int,completion:DDResultHandler) {
        
        var dict:JSONDictionary!
        
        dict = [
            "token":Defaults.userToken.value!,
            "notice_id":noticeId
        ]
        
        let urlString = GetDailyReportDataUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    //获取报表峰值
    func getDailyReportMaxVaule(completion:DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = GetDailyReportMaxVauleUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //保存报表峰值
    func saveDailyReportMaxVaule(cashMax:Int,projectmax:Int,prodMax:Int,customerMax:Int,employeemax:Int,completion:DDResultHandler) {
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "cash_amount":cashMax,
            "project_amount":projectmax,
            "product_amount":prodMax,
            "customer_total":customerMax,
            "employee_amount":employeemax
        ]
        
        let urlString = SaveDailyReportMaxVauleUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
}


extension NetworkManager {
    
    //获取助手列表
    func getHelperListWith(pageSize:Int,pageNumber:Int,completion:DDResultHandler) {
        
        let urlString = GetHelperListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "pageSize":pageSize,
            "pageNumber":pageNumber
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    //获取提醒,通知列表
    func getNoticeListWith(pageSize:Int,pageNumber:Int,completion:DDResultHandler) {
        
        let urlString = GetNoticeListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "pageSize":pageSize,
            "pageNumber":pageNumber
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    //获取提醒,通知明细,同时也是设置notice 已读的接口.调用成功即已读
    func getNoticeDetailWith(notice_id:Int,completion:DDResultHandler) {
        
        let urlString = GetNoticeDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "notice_id":notice_id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    

    
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
    
    
    //我的工作四种列表
    func getMyWorkListWith(urlString:String,completion:DDResultHandler) {
        
        let urlString = urlString
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //获取同事明细
    func getEmployeeDetailWith(id:Int,completion:DDResultHandler) {
        
        let urlString = GetEmployeeDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "user_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //我的工作四种列表点击cell.
    func getMyWorkScheduleListWith(urlString:String,idPramName:String,id:Int,completion:DDResultHandler) {
        
        let urlString = urlString
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            idPramName:id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    func getProjectProfileWith(id:Int,completion:DDResultHandler) {
        
        let urlString = getMyWorkProjectProfileUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "project_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    func getProdProfileWith(id:Int,completion:DDResultHandler) {
        
        let urlString = getMyWorkProdProfileUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "item_id":id
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
    
    //获取顾客卡包列表
    func getCustomerCardListWith(customerId:Int,completion:DDResultHandler) {
        
        let urlString = GetCustomerCardListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":customerId
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取顾客卡包明细
    func getCustomerCardDetailWith(cardNum:String,completion:DDResultHandler) {
        
        let urlString = GetCustomerCardDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "card_num":cardNum
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取顾客顾问列表
    func getCustomerAdviserWith(customerId:Int,completion:DDResultHandler) {
        let urlString = GetcustomerAdviserlistUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":customerId
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //设置顾客顾问
    func setCustomerAdviserWith(customerId:Int,advisderId:Int,completion:DDResultHandler) {
        let urlString = SetCustomerAdviserUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":customerId,
            "adviser":advisderId
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
                        let dataInfo = json["data"]
                        completion(success: false, json: dataInfo, error: msg)
                    }
                case .Failure(let error):
                    completion(success: false, json: nil, error: error.description)
                    
                }
        }
    }
    
    
    //UPLOAD
    
}


