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
typealias DDResultHandler = (_ success:Bool,_ json:JSON?,_ error:String?) -> Void

public typealias JSONDictionary = [String: Any]


class NetworkManager {
    
    static var sharedManager = NetworkManager()
    
    var baseDict: JSONDictionary = [
        "token":Defaults.userToken.value!,
        "ssid" :Defaults.userSSID.value!
    ]
    
    //MARK:用户
    
    //login
    func loginWith(_ mobile:String,passWord:String,usertype:UserLoginType,completion:@escaping DDResultHandler) {
        
        var dict:JSONDictionary!
        
        dict = [
                "mobile":mobile,
                "password":passWord,
                "type":usertype.rawValue
            ]
        
        let urlString = loginWithPhoneURL
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //登出
    func userLogOut(_ completion:@escaping DDResultHandler) {
        
        //let newDict = generatePostDictWithBaseDictOr(nil)
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = logOutURL
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    
    //获取手机验证码
    func getPhoneCodeWith(_ mobile:String,usertype:UserLoginType,codeType:PhoneCodeType,completion:@escaping DDResultHandler) {
        
        let dict:JSONDictionary = [
            "mobile":mobile,
            "type":usertype.rawValue,
            "sms_type":codeType.rawValue
        ]
        
        let urlString = getPhoneCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    
    //验证手机验证码
    func verifyPhoneCodeWith(_ mobile:String,usertype:UserLoginType,code:String,completion:@escaping DDResultHandler) {
        
        let dict:JSONDictionary = [
            "mobile":mobile,
            "type":usertype.rawValue,
            "sms_code":code
        ]
        
        let urlString = verifyPhoneCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //更新密码
    func updatePassWordWith(_ userName:String,usertype:UserLoginType,passWord:String,completion:@escaping DDResultHandler) {
        
        
        let sign = (userName + "-" + usertype.rawValue + "-" + passWord + "-" + Date.currentDateString() + "-" + XHPublicKey).md5()
        
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
    func getCompanyListWith(_ userName:String,usertype:UserLoginType,completion:@escaping DDResultHandler) {

        let sign = (userName + "-" + usertype.rawValue + "-" + Date.currentDateString() + "-" + XHPublicKey).md5()
        
        let dict:JSONDictionary = [
            "username":userName,
            "type":usertype.rawValue,
            "sign":sign
        ]
        
        let urlString = getCompanyListUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //设置当前企业
    func setCurrentCompanyWith(_ userName:String,usertype:UserLoginType,agentId:Int,completion:@escaping DDResultHandler) {
        
        let sign = (userName + "-" + usertype.rawValue + "-" + String(agentId) + "-" + Date.currentDateString() + "-" + XHPublicKey).md5()
        
        let dict:JSONDictionary = [
            "username":userName,
            "type":usertype.rawValue,
            "agent_id":agentId,
            "sign":sign
        ]
        
        let urlString = setCurrentCompanyUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
        
    }
    
    func updateUserAvatarWith(_ avatar:UIImage,completion:@escaping DDResultHandler) {
        
        let dict = [
            "token":Defaults.userToken.value!
        ]
        
        
        let urlString = updateAvatarURL
        
        let zipData = UIImageJPEGRepresentation(avatar, 0.1)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            //json dict
            for (key, value) in dict {
                let str = String(value)
                multipartFormData.append(str!.data(using: String.Encoding.utf8)!, withName: key)
              
            }
            
            //add iamge data if need
            if zipData != nil {
                multipartFormData.append(zipData!, withName: "avator", fileName: "avator.jpg", mimeType: "image/jpg")
                
                
            }
            
            }, to: urlString) { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _ ):
                    
                    upload.responseJSON(completionHandler: { (response) in
                        
                        let json = JSON(response.result.value!)
                        
                        if json["status"].string == "ok" {
                            let avatarUrlString = json["data"]
                            completion(true, avatarUrlString,nil)
                        }
                        else {
                            let msg = self.getErrorMsgFrom(json)
                            completion(false, nil,msg)
                        }
                        
                    })
                    
                    
                case .failure(let encodingError):
                    print("Failure")
                    print(encodingError)
                    completion(false, nil,"请求失败")
                }

                
        }
        
        
        
    }
    
    //完善用户信息
    func updateUserInfo(with firstName:String,lastName:String,avatarData:Data?,completion:@escaping DDResultHandler) {
        
        let dict:JSONDictionary = [
            "first_name":firstName,
            "last_name" :lastName
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        let urlString = updateUserInfoURL
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            //json dict
            for (key, value) in newDict {
                if let str = value as? String {
                    multipartFormData.append(str.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                
            }
            
            //add iamge data if need
            if avatarData != nil {
                multipartFormData.append(avatarData!, withName: "avator", fileName: "avator.jpg", mimeType: "image/jpg")
                
                
            }
            
            
        }, to: urlString) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _ ):
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    let json = JSON(response.result.value!)
                    
                    if json["status"].int == 1 {
                        let dataInfo = json["dataInfo"]
                        completion(true, dataInfo,nil)
                    }
                    else {
                        let msg = self.getErrorMsgFrom(json)
                        completion(false, nil,msg)
                    }
                    
                })
                
                
            case .failure(let encodingError):
                print("Failure")
                print(encodingError)
                completion(false, nil,"请求失败")
            }
        }


        
    }
    

}


//MARK:二维码
extension NetworkManager {

    //二维码登陆ERP
    func logInERPWith(_ qrCode:String,completion:@escaping DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "webtoken":qrCode
        ]
        
        let urlString = logInERPWithQRCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //二维码退出ERP
    func logOutERPWith(_ qrCode:String,completion:@escaping DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "webtoken":qrCode
        ]
        
        let urlString = logOutERPWithQRCodeUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取二维码登陆ERP状态.
    func getERPLogInStatus(_ completion:@escaping DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        let urlString = getERPLogInStatusUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
}


//MARK:用户关系管理
extension NetworkManager {
    
    func getUserList(_ completion:@escaping DDResultHandler) {
        
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
    func getDailyReportDataWith(_ noticeId:Int,completion:@escaping DDResultHandler) {
        
        var dict:JSONDictionary!
        
        dict = [
            "token":Defaults.userToken.value!,
            "notice_id":noticeId
        ]
        
        let urlString = GetDailyReportDataUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    //获取报表峰值
    func getDailyReportMaxVaule(_ orgId:Int,completion:@escaping DDResultHandler) {
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "org_id":orgId
        ]
        
        let urlString = GetDailyReportMaxVauleUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //保存报表峰值
    func saveDailyReportMaxVaule(_ orgId:Int,cashMax:Float,projectmax:Float,prodMax:Float,roomTurnoverMax:Float,employeeHoursmax:Float,completion:@escaping DDResultHandler) {
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "org_id":orgId,
            "cash_amount":cashMax,
            "project_amount":projectmax,
            "product_amount":prodMax,
            "room_turnover":roomTurnoverMax,
            "employee_hours":employeeHoursmax
        ]
        
        let urlString = SaveDailyReportMaxVauleUrl
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
}


extension NetworkManager {
    
    //获取助手列表
    func getHelperListWith(_ pageSize:Int,pageNumber:Int,completion:@escaping DDResultHandler) {
        
        let urlString = GetHelperListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "pageSize":pageSize,
            "pageNumber":pageNumber
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    //获取提醒,通知列表
    func getNoticeListWith(_ pageSize:Int,pageNumber:Int,completion:@escaping DDResultHandler) {
        
        let urlString = GetNoticeListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "pageSize":pageSize,
            "pageNumber":pageNumber
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    
    //获取提醒,通知明细,同时也是设置notice 已读的接口.调用成功即已读
    func getNoticeDetailWith(_ notice_id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = GetNoticeDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "notice_id":notice_id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //计划顾客列表
    func getCustomerPlanListWith(_ completion:@escaping DDResultHandler) {
        
        let urlString = GetCustomerPlanListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //预约顾客列表
    func getCustomerScheduleListWith(_ startDate:String,days:Int,completion:@escaping DDResultHandler) {
        
        let urlString = getCustomerScheduleListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "date":startDate,
            "days":days
        ]
        
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取顾客,同事,项目,产品的过滤条件以及数据
    func getMyWorkListFilterDataWith(_ params:JSONDictionary,urlString:String,completion:@escaping DDResultHandler) {
        let urlString = urlString
        
        var dict:JSONDictionary = [
            "token":Defaults.userToken.value!
            
        ]
        
        dict += params
        
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //我的工作四种列表
    func getMyWorkListWith(_ searchText:String ,params:JSONDictionary,urlString:String,pageSize:Int,pageNumber:Int,completion:@escaping DDResultHandler) {
        
        let urlString = urlString
        
        var dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "pageSize":pageSize,
            "pageNumber":pageNumber,
            "keyword":searchText
        ]
        
        dict += params
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //获取同事明细
    func getEmployeeDetailWith(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = GetEmployeeDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "user_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //我的工作四种列表点击cell.
    func getMyWorkScheduleListWith(_ urlString:String,idPramName:String,id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = urlString
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            idPramName:id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    func getProjectProfileWith(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = getMyWorkProjectProfileUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "project_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    func getProdProfileWith(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = getMyWorkProdProfileUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "item_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    func getCustomerDetailWith(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = GetCustomerDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //详细的消费记录
    func getCustomerConsumeListWith(_ id:Int,pageSize:Int,pageNumber:Int,completion:@escaping DDResultHandler) {
        
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
    func getCustomerSchedulesUrlWith(_ id:Int,date:String,completion:@escaping DDResultHandler) {
        
        let urlString = GetCustomerSchedulesUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id,
            "date":date
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    
    //获取项目,产品计划
    func getGoodPlanListWith(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = GetGoodPlanListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //保存项目,产品计划
    func saveGoodPlanWith(_ id:Int,ids:String,completion:@escaping DDResultHandler) {
        
        let urlString = SaveGoodPlanUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":id,
            "ids":ids
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
        
    }
    
    //获取顾客卡包列表
    func getCustomerCardListWith(_ customerId:Int,completion:@escaping DDResultHandler) {
        
        let urlString = GetCustomerCardListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":customerId
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取顾客卡包明细
    func getCustomerCardDetailWith(_ cardNum:String,completion:@escaping DDResultHandler) {
        
        let urlString = GetCustomerCardDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "card_num":cardNum
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取顾客顾问列表
    func getCustomerAdviserWith(_ customerId:Int,completion:@escaping DDResultHandler) {
        let urlString = GetcustomerAdviserlistUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":customerId
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //设置顾客顾问
    func setCustomerAdviserWith(_ customerId:Int,advisderId:Int,completion:@escaping DDResultHandler) {
        let urlString = SetCustomerAdviserUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "customer_id":customerId,
            "adviser":advisderId
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
}

//及时通讯
extension NetworkManager {
    
    
    func getConversationList(_ completion:@escaping DDResultHandler) {
        let urlString = GetConversationListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    
    func saveConversationListwith(convIds ids:String,completion:@escaping DDResultHandler) {
        let urlString = SaveConversationListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "conv_id":ids
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
}

//MARK:进度

extension NetworkManager {
    
    //获取任务选项
    func getTaskOptions(completion:@escaping DDResultHandler) {
        
        let urlString = getTaskOptionsUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //保存,修改任务 task_id>0时修改任务，否则为添加任务
    func saveTaskInBack(_ taskId:Int,type:String,range:String,target:Int,startDate:String,endDate:String,userList:String,note:String,completion:@escaping DDResultHandler) {
        let urlString = saveTaskUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "task_id":taskId,
            "type":type,
            "range":range,
            "target":target,
            "start_date":startDate,
            "end_date":endDate,
            "user_list":userList,
            "note":note
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取任务列表
    func getTaskList(completion:@escaping DDResultHandler) {
        let urlString = getTaskListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //任务明细
    func getTaskDetail(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = getTaskDetailUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "task_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //获取任务明细中的列表
    func getTaskDetailList(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = getTaskDetailListUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "task_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }

    
    
    
    //置顶任务
    func setTaskTopInBack(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = setTaskTopUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "task_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
    //删除任务
    func deleteTaskTopInBack(_ id:Int,completion:@escaping DDResultHandler) {
        
        let urlString = deleteTaskUrl
        
        let dict:JSONDictionary = [
            "token":Defaults.userToken.value!,
            "task_id":id
        ]
        
        baseRequestWith(urlString, dict: dict, completion: completion)
    }
    
}


//MARK:系统管理
extension NetworkManager {
    
    //发送反馈
    func submitFeedback(with content:String, completion:@escaping DDResultHandler) {
        
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
    
    fileprivate func addSignTo( _ dict:JSONDictionary) -> JSONDictionary {
        
        let keys = dict.keys
        
        let sortedKeys = keys.sorted { (value1, value2) -> Bool in
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
    
    fileprivate func getErrorMsgFrom(_ json:JSON) -> String {
        var msg = ""
        msg = json["message"].string!
        
        return msg
    }
    
    //生成post参数.
    fileprivate func generatePostDictWithBaseDictOr(_ dict:JSONDictionary?) -> JSONDictionary {
        
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
    fileprivate func baseRequestWith(_ urlString:String,dict:JSONDictionary,completion:@escaping DDResultHandler) {
        
        let parameters:Parameters = dict
        
        Alamofire.request(urlString, method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    if let status = json["status"].string {
                        if status == "ok" {
                            let dataInfo = json["data"]
                            completion(true,dataInfo,nil)
                            
                        }
                        else {
                            let msg = self.getErrorMsgFrom(json)
                            let dataInfo = json["data"]
                            completion(false, dataInfo, msg)
                        }
                    }
                    
                case .failure(let error):
                    completion(false, nil, error.localizedDescription)
                    
                }
        }

    }
    
    
    //UPLOAD
    
}


