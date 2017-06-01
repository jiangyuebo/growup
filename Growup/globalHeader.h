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

//腾讯云SDK TXYUploadPersistenceId
#define TXYUploadPersistenceId @"TXYUploadPersistenceId"

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
//宝宝信息
#define IdentifyNameBabyInfoViewController @"babyinfoviewcontroller"
//用户信息
#define IdentifyNamePersonInfoViewController @"personinfoviewcontroller"
//个人中心
#define IdentifyNamePersonCenterTableViewController @"personcentertableviewcontroller"
//发现信息列表
#define IdentifyNameDiscoverInfoListViewController @"czdiscoverinfolistviewcontroller"

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
//体验列表
#define IdentifyExperienceListViewController @"experiencelistviewcontroller"
//体验详细
#define IdentifyExperienceDetailViewController @"experiencedetailviewcontroller"
//webview viewController
#define IdentifyNameWebViewController @"czwebviewviewcontroller"
//橙长记图片详细
#define IdentifyNamePicDetailViewController @"picdetailviewcontroller"

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
//通过验证码登录
#define URL_REQUEST_SESSION_LOGIN_VERIFY_CODE @"session/login/verifyCode"
//忘记密码
#define URL_REQUEST_SESSION_PASSWORD_RESET @"session/password/reset"
//通过accesstoken重置密码
#define URL_REQUEST_SESSION_PASSWORD_RESET_BY_TOKEN @"session/password/resetByAccessToken"
//孩子数据注册
#define URL_REQUEST_CHILD_SETTING @"child/add"
//根据橙娃ID获取气泡信息
#define URL_REQUEST_POP_GET_DYNAMIC @"child/getDynamic"
//通过access-token获取用户信息
#define URL_REQUEST_GET_USER_INFO @"user/get"
//获取橙娃能力动态
#define URL_REQUEST_CHILD_STATUS_INFO @"user/ability/getResult"
//获取题目
#define URL_REQUEST_TEST_SUBJECT_LIST @"user/evaluation/get"
//提交答案
#define URL_REQUEST_SEND_ANWSER @"user/evaluation/submit"
//提交行动结果
#define URL_REQUEST_SUBMIT_ACTION @"user/action/submit"
//获取题目列表
#define URL_REQUEST_GET_ACTION_LIST @"user/action/getAll"
//获取体验内容列表
#define URL_REQUEST_GET_EXPERIENCE_LIST @"experience/getAll"
//获取体验内容明细
#define URL_REQUEST_GET_EXPERIENCE_DETAIL @"experience/get"
//获取成长记列表
#define URL_REQUEST_GET_GROWUP_RECORD @"record/getAll"
//获取橙长记详细
#define URL_RECORD_DETAIL @"record/get"
//上传成长记
#define URL_RECORD_UPLOAD @"record/add"
//获取咨询信息
#define URL_INFO_GET @"info/getAll"

//******total key
#define RESULT_KEY_JUMP_PATH @"jumpPath"
#define RESULT_KEY_ERROR_CODE @"errorCode"
#define RESULT_KEY_ERROR_MESSAGE @"errorMessage"
#define RESULT_KEY_DATA @"resultData"

#define OBSERVE_KEY_ERROR_MESSAGE @"errorMessage"

//注册
//验证码
#define VERIFY_CODE_REGISTER @"D02B01"//注册
#define VERIFY_CODE_FORGET_PASSWORD @"D02B02"//忘记密码
#define VERIFY_CODE_CHANGE_PASSWORD @"D02B03"//修改密码
#define VERIFY_CODE_VERIFY_CODE_LOGIN @"D02B04"//验证码登录
//主页
#define VALUE_VERYGOOD @"D18B01"
#define VALUE_GOOD @"D18B02"
#define VALUE_NORMAL @"D18B03"

#define OPTION_RESULT_TYPE_Y @"D46B01" //CAN
#define OPTION_RESULT_TYPE_N @"D46B02" //CANT
#define OPTION_RESULT_TYPE_O @"D46B03" //NOT SURE

//体验
#define EXPERIENCE_GAME @"D26B01" //互动游戏
#define EXPERIENCE_SCIENCE @"D26B02" //科学实验
#define EXPERIENCE_GAMEGUAID @"D26B03" //游戏攻略
#define EXPERIENCE_SONG @"D26B04" //互动儿歌
#define EXPERIENCE_STORY @"D26B05" //互动故事
#define EXPERIENCE_SCHOOL @"D26B09" //幼升小
#define EXPERIENCE_ALL @"D26B99" //综合
//橙长记
#define GROWUP_INITIATIVE @"D31B01" //主动
#define GROWUP_QUOTE @"D31B02" //引用
#define GROWUP_RECORD_FREEDOM @"D34B01" //自由
#define GROWUP_RECORD_PUBLIC_ALL @"D32B01" //完全公开
#define GROWUP_RECORD_PUBLIC_FRIEND @"D32B02" //好友公开
#define GROWUP_RECORD_PUBLIC_PRIVITE @"D32B03"//隐私
#define GROWUP_RECORD_PUBLIC_TYPE_PUBLIC @"D33B02"//发布

//资源类型
#define RESOURCE_TYPE_KEY_PIC @"D20B02"

//资讯
#define INFO_BABY @"D29B01"//萌娃
#define INFO_ARTICLE @"D29B02"//文章
#define INFO_TOURISM @"D29B03"//旅游
#define INFO_ALL @"D29B99"//综合

#define INFO_DETAIL_TYPE_INSPIRE @"D30B01" //励志
#define INFO_DETAIL_TYPE_SCHOOL @"D30B02" //上学
#define INFO_DETAIL_TYPE_FEED @"D30B03" //育儿
#define INFO_DETAIL_TYPE_MIND @"D30B04" //心理
#define INFO_DETAIL_TYPE_ALL @"D30B99" //综合

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

//view tag
#define TAG_CELL_ACTION_BUTTON_CAN 50 //首页行动项卡片按钮，能
#define TAG_CELL_ACTION_BUTTON_CANT 51 //首页行动项卡片按钮，不能
#define TAG_CELL_ACTION_BUTTON_CANTSURE 52 //首页行动项卡片按钮，不确定

//UI
#define icon_game 20//互动游戏
#define icon_science 21//科学实验
#define icon_gameguide 22//游戏攻略
#define icon_song 23//儿歌
#define icon_story 24//故事
#define icon_school 25//互动面试

//#define SIGH @"BDiZujK4f3D3tgHhG9fFh6KofSJhPTEyNTMxMTYyMDEmaz1BS0lEQU9VUUFBWmU5VmVmVTZEbXNsU3dHVFZMeVBlaUNKbzYmZT0xNTAyNTUzNTk5JnQ9MTQ5NDgxNDg1MCZyPTUxNjg2ODQ5NSZmPS8xMjUzMTE2MjAxL2NidS90ZXN0JmI9Y2J1"

#define SIGH @"f97cKyHy+30LTHzpsbBqzTIekg9hPTEyNTMxMTYyMDEmaz1BS0lEQU9VUUFBWmU5VmVmVTZEbXNsU3dHVFZMeVBlaUNKbzYmZT0xNTAyNTUzNTk5JnQ9MTQ5NTA0MTg2OCZyPTE2MDI5MDgzMTImZj0vMTI1MzExNjIwMS9jYnUvcmVjJmI9Y2J1"

#define SHOTCUT_TAIL @"?imageMogr2/interlace/0|imageMogr2/gravity/center/crop/100x100|watermark/2/text/5qmZ5aiD/font/bXN5aGJk5b6u6L2v6ZuF6buRYm9sZC50dGY/fontsize/10/fill/IzAwMDAwMA/dissolve/100/gravity/southest/dx/5/dy/5"

#define Height_Action_Subject_Cell 240
#define Height_Action_exp_Cell 390

#endif /* globalHeader_h */
