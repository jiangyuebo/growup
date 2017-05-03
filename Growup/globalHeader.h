//
//  globalHeader.h
//  OrangeGrowup
//
//  Created by Jerry on 2016/12/19.
//  Copyright © 2016年 Jerry. All rights reserved.
//

#ifndef globalHeader_h
#define globalHeader_h

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

//******颜色
//navigation bar color
#define color_navigation_bar @"#F86400"

//******各ViewController 的 Identify Name
//首页界面
#define IdentifyNameMainViewController @"czmainnviewcontroller"
//登录界面
#define IdentifyNameLoginViewController @"czloginviewcontroller"
//注册界面
#define IdentifyNameRegisterViewController @"czregisterviewcontroller"
//修改密码
#define IdentifyNameChangePasswordViewController @"czchangepasswordviewcontroller"
//生日设置
#define IdentifyNameBirthdaySettingViewController @"czbirthdaysettingviewcontroller"
//性别设置
#define IdentifyNameGenderSettingViewController @"czgendersettingviewcontroller"
//我的
#define IdentifyNamePersonCenterViewController @"czpersoncenterviewcontroller"

//社会能力评测解读界面
#define IdentifyNameSocietyExplainViewController @"czsocietyexplaincontroller"
//能力解读界面
#define IdentifyNameAbilityExplainViewController @"czabilityexplaincontroller"
//兴趣选择
#define IdentifyNameInterestSettingViewController @"czinterestingviewcontroller"
//今日任务
#define IdentifyNameTodayTaskViewController @"cztodaytaskviewcontroller"
//综合报告
#define IdentifyNameDetailReportViewController @"czdetailreportviewcontroller"
//快速测评
#define IdentifyFastTestViewController @"cztestviewcontroller"

//******网络请求接口
//根域名
//#define URL_REQUEST @"http://192.168.0.125:8080/cb/api/v1/"
#define URL_REQUEST @"https://api.growtree.cn:443/cb/api/v1/"
//申请验证码
#define URL_REQUEST_SESSION_GET_VERIFYCODE @"session/verifyCode/"
//用户注册
#define URL_REQUEST_SESSION_REGISTER @"session/register"
//用户登录
#define URL_REQUEST_SESSION_LOGIN @"session/login/password"
//孩子数据注册
#define URL_REQUEST_CHILD_SETTING @"child/add"
//根据橙娃ID获取气泡信息
#define URL_REQUEST_POP_GET_DYNAMIC @"child/getDynamic"
//获取橙娃能力动态
#define URL_REQUEST_CHILD_STATUS_INFO @"user/ability/getResult"
//获取题目
#define URL_REQUEST_TEST_SUBJECT_LIST @"user/evaluation/get"
//提交答案
#define URL_REQUEST_SEND_ANWSER @"user/evaluation/submit"
//获取题目列表
#define URL_REQUEST_GET_ACTION_LIST @"user/action/getAll"

//******total key
#define RESULT_KEY_JUMP_PATH @"jumpPath"
#define RESULT_KEY_ERROR_CODE @"errorCode"
#define RESULT_KEY_ERROR_MESSAGE @"errorMessage"
#define RESULT_KEY_DATA @"resultData"

#define OBSERVE_KEY_ERROR_MESSAGE @"errorMessage"

//主页
#define VALUE_VERYGOOD @"D18B01"
#define VALUE_GOOD @"D18B02"
#define VALUE_NORMAL @"D18B03"

//person center
#define TOKEN @"token"

#define COLUMN_BIRTHDAY @"birthday"
#define COLUMN_SEX @"sex"

#define RESPONSE_ERROR_CODE @"errorCode"
#define RESPONSE_ERROR_MSG @"errorMsg"
#define RESPONSE_ERROR_MESSAGE_NIL @"服务器错误"

//存储KEY
#define SAVE_KEY_ACCESS_TOKEN @"accessToken"
#define SAVE_KEY_CHILD_ID @"childId"

#endif /* globalHeader_h */
