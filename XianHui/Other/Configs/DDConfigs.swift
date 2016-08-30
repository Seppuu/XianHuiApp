//
//  DDConfigs.swift
//  DingDong
//
//  Created by Seppuu on 16/3/2.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import CoreLocation

let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height

let DDTimeNeverReach = 12000

let BaseUrl = "http://sso.sosys.cn:8080/mybook"
var DDBaseUrl = Defaults.actualApiUrl.value!
let DefaultThemeUrl = "http://dingdong.sosys.cn:8080/themes/common/background/default.png"

var allUserIds = [String]()

///用户登录
let loginURL          = BaseUrl + "/rest/login"

//用户登出
let logOutURL         = BaseUrl + "/rest/logout"

//上传头像
let updateAvatarURL      = DDBaseUrl + "/rest/employee/uploadavator"

//完善用户资料
let updateUserInfoURL = DDBaseUrl + "/user/index/rest?returnDataType=json&action=updateUserInfo"


/// 日报表

//获取日报表峰值
let GetDailyReportMaxVauleUrl = DDBaseUrl + "/rest/employee/getdailyreportsetting"

//保存日报表峰值
let SaveDailyReportMaxVauleUrl = DDBaseUrl + "/rest/employee/setdailyreportsetting"



/// 用户关系管理

//用户联系人列表
let userListUrl       = DDBaseUrl + "/rest/employee/getuserlist"

/// 系统管理
let submitFeedBackURL = DDBaseUrl + "/system/index/rest?returnDataType=json&action=submitFeedback"

//用户协议
let userArgeementURL = DDBaseUrl + "/user/signup/agreement"

//暂时的固定的token
let defaultToken = ""

