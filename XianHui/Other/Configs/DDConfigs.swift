//
//  DDConfigs.swift
//  DingDong
//
//  Created by Seppuu on 16/3/2.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import CoreLocation

let OwnSystemLoginSuccessNoti = NSNotification.Name("OwnSystemLoginSuccessNoti")

let XHAppNewUserFirstLoginNoti = NSNotification.Name("XHAppNewUserFirstLoginNoti")

var IOS10_OR_LATER:Bool {
    return (UIDevice.current.systemVersion.toFloat()! >= Float(10.0))
}

var IOS9_OR_LATER:Bool {
    return (UIDevice.current.systemVersion.toFloat()! >= Float(9.0))
}

var IOS8_OR_LATER:Bool {
    return (UIDevice.current.systemVersion.toFloat()! >= Float(8.0))
}

var IOS7_OR_LATER:Bool {
    return (UIDevice.current.systemVersion.toFloat()! >= Float(7.0))
}


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

let DDTimeNeverReach = 12000

//let ProdBaseUrl = "http://sso.sosys.cn:8080/mybook"
//let DevBaseUrl = "http://sso.sosys.cn:8080/mybook"
let BaseUrl = "http://sso.sosys.cn:8080/mybook"
let XHPublicKey = "1addfcf4296d60f0f8e0c81cea87a099"
var DDBaseUrl:String {
    return Defaults.actualApiUrl.value!
}

var allUserIds = [String]()

///用户登录
let loginWithPhoneURL          = BaseUrl + "/rest/loginmobile"

//用户登出
let logOutURL          = BaseUrl + "/rest/logout"

//获取手机验证码
let getPhoneCodeUrl    = BaseUrl + "/rest/loginsmsgot"

//验证手机验证码
let verifyPhoneCodeUrl = BaseUrl + "/rest/loginsmsverify"

//更新密码
let updatePassWordUrl  = BaseUrl + "/rest/changeloginpassword"

//获取端口(企业)列表
let getCompanyListUrl  = BaseUrl + "/rest/getagentlist"

//设置当前端口(企业)
let setCurrentCompanyUrl = BaseUrl + "/rest/setdefaultagent"

//帮助中心
let helperCenterUrl = BaseUrl + "/rest/help"

//上传头像
var updateAvatarURL:String {
    return DDBaseUrl + "/rest/employee/uploadavator"
}

//完善用户资料
var updateUserInfoURL:String {
    return DDBaseUrl + "/user/index/rest?returnDataType=json&action=updateUserInfo"
}

///二维码
//通过扫码登陆ERP
var logInERPWithQRCodeUrl:String {
    return DDBaseUrl + "/rest/employee/loginqrdo"
}


//手机端指挥退出ERP
var logOutERPWithQRCodeUrl:String {
    return DDBaseUrl + "/rest/employee/logoutqrdo"
}

//获取二维码登陆状态
var getERPLogInStatusUrl:String {
    return DDBaseUrl + "/rest/employee/loginqrstatus"
}


///即时通讯

//获取最近会话ID列表(包含系统消息)
var GetConversationListUrl:String {
    return DDBaseUrl + "/rest/employee/getconversationlist"
}


//保存最近会话ID列表(包含系统消息)
var SaveConversationListUrl:String {
    return DDBaseUrl + "/rest/employee/setconversationlist"
}




/// 日报表

//获取日报表峰值
var GetDailyReportMaxVauleUrl:String {
    return DDBaseUrl + "/rest/employee/getdailyreportsetting"
}

//保存日报表峰值
var SaveDailyReportMaxVauleUrl:String {
    return DDBaseUrl + "/rest/employee/setdailyreportsetting"
}


//获取助手列表
var GetHelperListUrl:String {
    return DDBaseUrl +  "/rest/employee/gethelperlist"
}



//获取日报表数据
var GetDailyReportDataUrl:String {
    return DDBaseUrl + "/rest/employee/getdailyreportdata"
}


//提醒,通知列表
var GetNoticeListUrl:String {
    return  DDBaseUrl + "/rest/employee/getnoticelist"
}

//获取通知明细
var GetNoticeDetailUrl:String {
    return DDBaseUrl +  "/rest/employee/getnoticedetail"
}

//获取顾客顾问列表
var GetcustomerAdviserlistUrl:String {
    return DDBaseUrl + "/rest/employee/getcustomeradviserlist"
}

//设置顾客顾问
var SetCustomerAdviserUrl:String {
    
    return DDBaseUrl + "/rest/employee/setcustomeradviser"
}



///我的工作 -- 计划

//获取顾客筛选选项
var getMyCustomerListFilterDataUrl:String {
    return DDBaseUrl + "/rest/employee/gethelpercustomerlistsearchinfo"
}

//获取同事筛选选项
var getMyColleaguesListFilterDataUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperworkerlistsearchinfo"
}


//获取项目筛选选项
var getMyProjectListFilterDataUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperprojectlistsearchinfo"
}

//获取产品筛选选项
var getMyProdListFilterDataUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperproductlistsearchinfo"
}


//获取计划顾客列表
var GetCustomerPlanListUrl:String {
    return DDBaseUrl + "/rest/employee/getplantable"
}


//获取预约顾客列表
var getCustomerScheduleListUrl:String {
    return DDBaseUrl + "/rest/employee/getscheduletable"
}


//获取某顾客明细
var GetCustomerDetailUrl:String {
    return DDBaseUrl + "/rest/employee/getcustomerdetail"
}

//获取顾客消费记录
var GetCustomerConsumeUrl:String {
    return DDBaseUrl + "/rest/employee/getcustomerconsumelist"
}

//获取顾客预约记录
var GetCustomerSchedulesUrl:String {
    return DDBaseUrl + "/rest/employee/getcustomerschedulelist"
}

//获取顾客卡包列表
var GetCustomerCardListUrl:String {
    return DDBaseUrl + "/rest/employee/getcustomercardlist"
}

//获取顾客卡包明细 会员卡/疗程卡操作记录
var GetCustomerCardDetailUrl:String {
    return DDBaseUrl + "/rest/employee/getcustomercardlog"
}


//获取项目,产品计划
var GetGoodPlanListUrl:String {
    return DDBaseUrl + "/rest/employee/getplanaddlist"
}

//保存项目,产品计划
var SaveGoodPlanUrl:String {
    return DDBaseUrl + "/rest/employee/setplanitem"
}

//获取顾客列表
var GetMyWorkCustomerUrl:String {
    return DDBaseUrl + "/rest/employee/gethelpercustomerlist"
}

//获取同事列表
var GetMyWorkEmployeeUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperworkerlist"
}

//获取同事明细
var GetEmployeeDetailUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperworkerdetail"
}

//获取项目列表
var GetMyWorkProjectUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperprojectlist"
}

//获取产品列表
var GetMyWorkProdUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperproductlist"
}

//获取预约列表(顾客)
var getMyWorkScheduleListFromCustomerUrl:String {
    return DDBaseUrl + "/rest/employee/gethelpercustomerschedulelist"
}

//获取预约列表(同事)
var getMyWorkScheduleListFromEmployeeUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperworkerschedulelist"
}

//获取预约列表(项目)
var getMyWorkScheduleListFromProjectUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperprojectorders"
}

//获取预约列表(产品)
var getMyWorkScheduleListFromProdUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperproductorders"
}


//详细资料

//项目
var getMyWorkProjectProfileUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperprojectdetail"
}

//产品
var getMyWorkProdProfileUrl:String {
    return DDBaseUrl + "/rest/employee/gethelperproductdetail"
}

///进度

//获取任务选项
var getTaskOptionsUrl:String {
    return DDBaseUrl + "/rest/employee/gettaskaddinfo"
}

//保存任务
var saveTaskUrl:String {
    return DDBaseUrl + "/rest/employee/savetask"
}

//获取任务列表
var getTaskListUrl:String {
    return DDBaseUrl + "/rest/employee/gettasklist"
}

//获取任务明细
var getTaskDetailUrl:String {
    return DDBaseUrl + "/rest/employee/gettaskdetail"
}

//获取任务明细中的列表
var getTaskDetailListUrl:String {
    return DDBaseUrl + "/rest/employee/gettasklistdetail"
}


//置顶任务
var setTaskTopUrl:String {
    return DDBaseUrl + "/rest/employee/settoptask"
}

//TODO:删除任务
var deleteTaskUrl:String {
    return DDBaseUrl + "/rest/employee/deletetask"
}

/// 用户关系管理

//用户联系人列表
var userListUrl:String {
    return DDBaseUrl + "/rest/employee/getuserlist"
}

/// 系统管理
var submitFeedBackURL:String {
    return DDBaseUrl + "/system/index/rest?returnDataType=json&action=submitFeedback"
}

//用户协议
var userArgeementURL:String {
    return DDBaseUrl + "/user/signup/agreement"
}

//暂时的固定的token
var defaultToken = ""

