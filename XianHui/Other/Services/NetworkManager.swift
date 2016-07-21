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
    //发送验证码
    func requestVerifyCodeWith(type:VerifyCodeType,phone:String,completion:DDResultHandler) {
        
        let dict: JSONDictionary = [
            "token":Defaults.userToken.value!,
            "mobile":phone,
            "type":type.rawValue
        ]
        
        let newDict = addSignTo(dict)
        
        let urlString = sendSmsCodeURL
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
        
    }
    
    //验证验证码,成功后保存ssid
    func verifySmsCode(with mobile:String,smsCode:String,completion:DDResultHandler) {
        
        let dict: JSONDictionary = [
            "token":Defaults.userToken.value!,
            "mobile":mobile,
            "code":smsCode
        ]
        
        let newDict = addSignTo(dict)
        
        let urlString = verifySmsCodeURL
        
        Alamofire.request(.POST, urlString, parameters: newDict)
                .responseJSON { (response) in
                    switch response.result {
                    case .Success:
                        let json = JSON(response.result.value!)
                        if json["status"].int! == 1 {
                            let data = json["dataInfo"]
                            let ssid = json["ssid"].string!
                            Defaults.userSSID.value = ssid
                            completion(success: true,json: data,error: nil)
                            
                        }
                        else {
                            let msg = self.getErrorMsgFrom(json)
                            completion(success: false,json: nil,error: msg)
                        }
                        
                    case .Failure(let error):
                        completion(success: false,json: nil,error: error.description)
                    }
        }
    }
    
    //登出
    func userLogOut(completion:DDResultHandler) {
        
        let newDict = generatePostDictWithBaseDictOr(nil)
        let urlString = logOutURL
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
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
    
    //个人认证 提交审核
    func submitPersonalCertificate(completion:DDResultHandler) {
        
        let urlString = personalCertificateSubmitURL
        
        let newDict = generatePostDictWithBaseDictOr(nil)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
        
    }
    
    //获取审核状态
    func getPersonalCertificateStatus(completion:DDResultHandler) {
        
        let urlString = personalCertificateStatusURL
        
        let newDict = generatePostDictWithBaseDictOr(nil)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
        
    }
    
    //MARK:课程管理
    
    //专辑创建
    func createAlbum(dict:JSONDictionary,coverImage:UIImage,completion:((success:Bool,data:JSON)->())) {
        
        
        let newDict = addSignTo(dict)
        
        let urlString = CreateAlbumURL

        Alamofire.upload(.POST, urlString, multipartFormData: { (multipartFormData) in
            
            //json dict 
            for (key, value) in newDict {
                let str = String(value)
                multipartFormData.appendBodyPart(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            //add iamge data 
            if let imageData = UIImagePNGRepresentation(coverImage) {
                multipartFormData.appendBodyPart(data: imageData, name: "cover", fileName: "cover.png", mimeType: "image/png")
            }
            
            
        }) { (encodingResult) in
            
            switch encodingResult {
            case .Success(let upload, _, _ ):
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    let json = JSON(response.result.value!)
                    
                    if json["status"].int == 1 {
                        completion(success: true,data: json)
                    }
                    else {
                        completion(success: false,data: json)
                    }
                    
                })
                
                
            case .Failure(let encodingError):
                print("Failure")
                print(encodingError)
            }
            
        }
    }
    
    
    func getMyAlbumList(completion:DDResultHandler){
        
        let urlString = MyAlbumListURL
        
        let newDict = addSignTo(baseDict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
    }
    
    
    func getOneAlbumLessonListwith(isUserSelf:Bool,albumID:Int,completion:DDResultHandler) {
        
        if isUserSelf {
            //获取我的某张专辑中的课程列表
            requestAlbumLessonListWith(MyAlbumLessonsListURL, albumId: albumID, completion: completion)
        }
        else {
            //获取其他老师某张专辑中的课程列表
            requestAlbumLessonListWith(SomeAlbumCourseListURL, albumId: albumID, completion: completion)
        }
        
    }
    
    func requestAlbumLessonListWith(urlString:String,albumId:Int,completion:DDResultHandler) {
        
        let urlString = urlString
        
        let dict: JSONDictionary = [
            "album_id":albumId
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
        
    }
}


// 课程课件Json上传,下载.
extension NetworkManager {
    
    /**
     上传录制的课程
     
     - parameter dict:       基本json数据结构,最重要的key是时间戳
     - parameter imageDict:  图片集本体 以及 key name
     - parameter audioDict:  音频本体   以及 key name
     - parameter progress:   上传进程回调
     - parameter completion: 完成回调
     */
    func uploadLesson(dict:JSONDictionary,imageDict:JSONDictionary?,audioDict:JSONDictionary,progress:((progress:Float)->()),completion:((success:Bool)->())) {
  
        //json 序列化,加入dict.
        let paramsJSON = JSON(dict)
        guard  let paramsString = paramsJSON.rawString(NSUTF8StringEncoding, options: .PrettyPrinted) else {return}
        
        let fullDict:JSONDictionary = [
            "data"  :paramsString
        ]
        
        let newDict = generatePostDictWithBaseDictOr(fullDict)
        
        Alamofire.upload(.POST,uploadLessonURL , multipartFormData: { (multipartFormData) in
            
            for (key, value) in newDict {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            for (key,value) in audioDict {
                let data = value as! NSData
                multipartFormData.appendBodyPart(data: data, name: key, fileName: "record0.mp3", mimeType: "audio/mp3")
            }
            
            if let imagedict = imageDict {
                for (key,value) in imagedict {
                    let data = value as! NSData
                    //print("Size of Image(bytes):\(data.length)")
                    multipartFormData.appendBodyPart(data: data, name: key, fileName: "\(key).jpg", mimeType: "image/jpg")

                }
            }

            }) { (encodingResult) in
                
                switch encodingResult {
                case .Success(let upload, _, _ ):
                    
                    upload.progress({ (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            let p = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                            progress(progress: p)
                        }
                    })
                    
                    upload.responseJSON(completionHandler: { (response) in
                        
                        switch response.result {
                        case .Success:
                            let json = JSON(response.result.value!)
                            let status = json["status"].int!
                            print(json)
                            if status == 1 {
                                completion(success: true)
                            }
                            else {
                                completion(success: false)
                            }
                        case .Failure(let error):
                            print(error.description)
                            completion(success: false)
                        }
                        
                    })
                    
                    
                case .Failure(let encodingError):
                    print("Failure")
                    print(encodingError)
                    completion(success: false)
                }
                
        }
        
        

        
    }
    
    /**
     获取某课程的数据
     
     - parameter lessonId:   课程ID
     - parameter completion: 回调
     */
    func getLessonInfo(with lessonId:String,completion:DDResultHandler) {
        
        let urlString = getLessonURL
        
        let dict: JSONDictionary = [
            "id"   :lessonId
        ]
        
        //带有签名的dict
        let dictSigned = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: dictSigned, completion: completion)
    }
    
    //获取微信分享的地址.
    func getLessonShareInfo(with lessonID:Int, completion:DDResultHandler) {
        
        let urlString = LessonShareURL
        
        let dict: JSONDictionary = [
            "course_id" :lessonID
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
    }
    
    
}

//订阅，老师
extension NetworkManager {
    
    //订阅
    func subscribeAuthor(with id:String,completion:DDResultHandler) {
        
        let urlString = SubscribeAuthorURL
        
        let dict:JSONDictionary = [
            "author_id":id
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
        
    }
    
    
    //取消订阅
    func cancelSubscribeAuthor(with id:String,completion:DDResultHandler) {
        
        let urlString = CancelSubscribeAuthorURL
        
        let dict:JSONDictionary = [
            "author_id":id
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
    }
    
    //获取订阅老师列表
    func subscribedAuthorList(completion:DDResultHandler) {
        
        let urlString = SubscribedAuthorListURL
        
        let newDict = generatePostDictWithBaseDictOr(nil)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
    }
    
    //获取订阅老师的专辑列表
    func getAuthorAlbumListWith(authorID:Int,completion:DDResultHandler){
        
        let urlString = AuthorAlbumListURL
        
        let dict: JSONDictionary = [
            "author_id":authorID
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
        
    }
    
}

//点赞,取消点赞
extension NetworkManager {
    
    //点赞
    func saveLessonLikedwith(lessonId:String,completion:DDResultHandler) {
        
        let urlString = SaveLessonLikedURL
        
        let dict:JSONDictionary = [
            "course_id":lessonId
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
        
    }
    
    
    //取消点赞
    func cancelSaveLessonLikedwith(lessonId:String,completion:DDResultHandler) {
        
        let urlString = CancelSaveLessonLikedURL
        
        let dict:JSONDictionary = [
            "course_id":lessonId
        ]
        
        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
    }
    
}

//MARK:课程展示列表(推荐,订阅,历史记录..)
extension NetworkManager {
    
    //获取首页推荐
    func getLessonListFromStaffPickWith(pageNumber:Int,pageSize:Int,completion:DDResultHandler) {
        
        let urlString = recommandlessonListURL
        
        requestForLessonListWith(urlString, pageNumber: pageNumber, pageSize: pageSize, completion: completion)
    }
    
    //获取历史记录
    func getHistoryLessonListWith(pageNumber:Int,pageSize:Int,completion:DDResultHandler) {
        
        let urlString = historyRecordListURL
        
        requestForLessonListWith(urlString, pageNumber: pageNumber, pageSize: pageSize, completion: completion)
    }
    
    //获取订阅老师的课程列表
    func getSubscribeLessonListWith(pageNumber:Int,pageSize:Int,completion:DDResultHandler) {
        
        let urlString = SubscribeLessonList
        
        requestForLessonListWith(urlString, pageNumber: pageNumber, pageSize: pageSize, completion: completion)
    }
    
    //获取点赞课程列表(默认当前用户,可查询其他用户)
    func getLikedLessonListWith(pageNumber:Int,pageSize:Int,completion:DDResultHandler) {
        
        let urlString = GetLessonLikedListURL
        
        requestForLessonListWith(urlString, pageNumber: pageNumber, pageSize: pageSize, completion: completion)
    }
    
    private func requestForLessonListWith(urlString:String,pageNumber:Int,pageSize:Int,completion:DDResultHandler) {
    
        let dict: JSONDictionary = [
            "pageNumber":pageNumber,
            "pageSize"  :pageSize
        ]

        let newDict = generatePostDictWithBaseDictOr(dict)
        
        baseRequestWith(urlString, dict: newDict, completion: completion)
    }
    
}


extension NetworkManager {
    
    
    //获取主题库
    func getThemes(completion:DDResultHandler) {
        
        let urlString = GetThemesURL
        
        let dict = generatePostDictWithBaseDictOr(nil)
        
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
        msg = json["errorInfo"]["message"].string!
        
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
                    if json["status"].int! == 1 {
                        let dataInfo = json["dataInfo"]
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


