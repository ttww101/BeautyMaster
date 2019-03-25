#ifndef iHealthS_common_h
#define iHealthS_common_h

#define MAX_PAGE_COUNT 20
#define ADMIN_EMAIL @"whitelok@163.com"
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

// 主页列表接
#define INDEX_URL @"http://wp.asopeixun.com:5000/get_post_from_category_id?category_id=16"

// 左侧列表接口
//#define LEFT_URL @"http://wp01.asopeixun.com:5000/get_category_list?app_id=1"
#define LEFT_URL @"http://wp.asopeixun.com:5000/get_category_list?app_id=1111925325"

// 文章显示接口
#define SHOW_URL @"http://wp.asopeixun.com"

// 广告接口
#define AD_URL @"http://wp.asopeixun.com:5000/get_ad?ad_tag=advertise"

// 浮动广告接口
#define POPUP_AD_URL @"http://wp.asopeixun.com:5000/get_popup_ad?app_id=1111925568"

// 顶端广告栏
#define TOPBAR_URL @"http://wp.asopeixun.com:5000/get_topbar_ad?app_id=1111925568"

// TalkingData ID
#define TD_ID @"845430B5A0CAB4F105DB1F34261B25C7"

// google广告接口开关
#define GOOGLE_AD_SWITCH @"http://wp.asopeixun.com:5000/get_other_ad_switch?id=1&type=0"

// UMeng ID
#define UM_ID @""

// 客户信息端口
#define CLIENT_INFO_URL @"http://wp.asopeixun.com:5000/get_client?app_id=1111925568"

// 上传统计信息
#define STAT_INFO_URL @"http://wp.asopeixun.com:5000/statistics_client?app_id=1111925568&raw_data="

// APP_ID
#define APP_ID 1111925568

// 更新通知接口
#define UPDATE @"http://wp.wrok.cn/check_version/appid"

#define kAdMobInterstitialKey     @"ca-app-pub-7952766642809221/2975665994"//google插页广告ID

#endif
