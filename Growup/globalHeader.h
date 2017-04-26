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

//颜色
//navigation bar color
#define color_navigation_bar @"#F86400"

//各ViewController 的 Identify Name
//首页界面
#define IdentifyNameMainViewController @"czmainnviewcontroller"
//登录界面
#define IdentifyNameLoginViewController @"czloginviewcontroller"
//注册界面
#define IdentifyNameRegisterViewController @"czregisterviewcontroller"
//修改密码
#define IdentifyNameChangePasswordViewController @"czchangepasswordviewcontroller"
//生日设置
#define IdentifyBirthdaySettingViewController @"czbirthdaysettingviewcontroller"
//性别设置
#define IdentifyGenderSettingViewController @"czgendersettingviewcontroller"

//社会能力评测解读界面
#define IdentifySocietyExplainViewController @"czsocietyexplaincontroller"
//能力解读界面
#define IdentifyAbilityExplainViewController @"czabilityexplaincontroller"
//兴趣选择
#define IdentifyInterestSettingViewController @"czinterestingviewcontroller"
//今日任务
#define IdentifyTodayTaskViewController @"cztodaytaskviewcontroller"

//网络请求接口
//测试接口
#define URL_TEST_REQUEST @"http://10.25.32.134:8080/cb/api/v1/"
//根域名
#define URL_REQUEST @"https://api.growtree.cn:443/cb/api/v1/"
//申请验证码
#define URL_REQUEST_SESSION_GET_VERIFYCODE @"session/verifyCode/"
//用户注册
#define URL_REQUEST_SESSION_REGISTER @"session/register"
//用户登录
#define URL_REQUEST_SESSION_LOGIN @"session/login/password"
//孩子数据注册
#define URL_REQUEST_CHILD_SETTING @"child/add"
//根据橙娃动态
#define URL_REQUEST_CHILD_GET_DYNAMIC @"child/getDynamic"


//首页数据请求
#define RequestMainPageData @"http://api.growtree.cn/hby-product/user/info"


//person center
#define TOKEN @"token"

#define COLUMN_BIRTHDAY @"birthday"
#define COLUMN_SEX @"sex"

#define RESPONSE_ERROR_CODE @"errorCode";
#define RESPONSE_ERROR_MSG @"errorMsg"

//存储KEY
#define SAVE_KEY_ACCESS_TOKEN @"accessToken"
#define SAVE_KEY_CHILD_ID @"childId"

#endif /* globalHeader_h */
