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


///我的工作 -- 计划

//获取计划顾客列表
let GetCustomerPlanListUrl = DDBaseUrl + "/rest/employee/getplantable"


//获取预约顾客列表
let getCustomerScheduleListUrl = DDBaseUrl + "/rest/employee/getscheduletable"


//获取某顾客明细
let GetCustomerDetailUrl = DDBaseUrl + "/rest/employee/getcustomerdetail"

//获取顾客消费记录
let GetCustomerConsumeUrl = DDBaseUrl + "/rest/employee/getcustomerconsumelist"

//获取顾客预约记录
let GetCustomerSchedulesUrl = DDBaseUrl + "/rest/employee/getcustomerschedulelist"


//获取项目,产品计划
let GetGoodPlanListUrl = DDBaseUrl + "/rest/employee/getplanaddlist"

//保存项目,产品计划
let SaveGoodPlanUrl = DDBaseUrl + "/rest/employee/setplanitem"

/// 用户关系管理

//用户联系人列表
let userListUrl       = DDBaseUrl + "/rest/employee/getuserlist"

/// 系统管理
let submitFeedBackURL = DDBaseUrl + "/system/index/rest?returnDataType=json&action=submitFeedback"

//用户协议
let userArgeementURL = DDBaseUrl + "/user/signup/agreement"

//暂时的固定的token
let defaultToken = ""

