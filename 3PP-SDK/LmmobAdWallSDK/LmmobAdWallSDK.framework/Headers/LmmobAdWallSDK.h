//
//  LmmobAdWallSDK.h

//  Created by rui sun on 12-2-29.
//  Copyright (c) 2012年 __MyCompany__. All rights reserved.
//  Version 2.1.0 Build20120423
//

#import "LmmobAdWallViewController.h"

NS_AVAILABLE(10_6, 4_0);
@class LmmobAdWallSDK;

@protocol LmmobAdWallDelegate <NSObject>

@required
/*! 
 @method      LmmobAdWallSDK:DismissAdWall:
 
 @abstract    广告墙返回按钮的事件
 
 @param
 sdk          sdk == [LmmobAdWallSDK defaultSDK]
 
 @param
 result       YES
 */
-(void)LmmobAdWallSDK:(LmmobAdWallSDK *)sdk DismissAdWall:(BOOL)result;


@optional
/*! 
 @method      LmmobAdWallSDK:AdWallisON:
 
 @abstract    [[LmmobAdWallSDK defaultSDK] GetAdWallWithEntranceID:AndDelegate:]方法的回调
 
 @param
 sdk          sdk == [LmmobAdWallSDK defaultSDK]
 
 @param
 result         广告墙开关值
 */
-(void)LmmobAdWallSDK:(LmmobAdWallSDK *)sdk AdWallisON:(BOOL)result;


/*! 
 @method      LmmobAdWallSDK:UserScore:ScoreUpdated:
 
 @abstract    [[LmmobAdWallSDK defaultSDK] ScoreSubstract:]的回调
 
 @param
 sdk          sdk == [LmmobAdWallSDK defaultSDK]
 
 @param
 score        用户积分值,double
 result       更新用户积分是否成功
 */
-(void)LmmobAdWallSDK:(LmmobAdWallSDK *)sdk UserScore:(double)score ScoreUpdated:(BOOL)result;


/*! 
 @method      LmmobAdWallSDK:BannerAdRemoved:
 
 @abstract    [[LmmobAdWallSDK defaultSDK] RemoveBannerAd]的回调
 
 @param
 sdk          sdk == [LmmobAdWallSDK defaultSDK]
 
 @param
 result       Banner广告是否永久移除成功/关闭关联的广告位是否成功
 */
-(void)LmmobAdWallSDK:(LmmobAdWallSDK *)sdk BannerAdRemoved:(BOOL)result;

/*! 
 @method      LmmobAdWallSDK:didFailedWithNetError:
 
 @abstract    [[LmmobAdWallSDK defaultSDK] RemoveBannerAd]的回调
 
 @param
 sdk          sdk == [LmmobAdWallSDK defaultSDK]
 
 @param
 error        网络错误返回信息
 */
-(void)LmmobAdWallSDK:(LmmobAdWallSDK *)sdk didFailedWithNetError:(NSError *)error;

@end

@interface LmmobAdWallSDK : NSObject{
    
@private
    NSString * _entranceID;
    id<LmmobAdWallDelegate>_delegate;
    LmmobAdWallViewController * _lmmob;
}
@property(nonatomic,retain)NSString *entranceID;
@property(nonatomic,assign)id<LmmobAdWallDelegate>delegate;
@property(nonatomic,retain)LmmobAdWallViewController * lmmob;

/*! 
 @method        defaultSDK
 
 @abstract
                SDK单例模式,调用举例:  [LmmobAdWallSDK defaultSDK]
 
 */
+(LmmobAdWallSDK *)defaultSDK;

/*! 
 @method        GetAdWallWithEntranceID:AndDelegate:
 
 @abstract 
                初始化广告墙,并请求广告墙
 @param
 entranceid     入口ID,需要在网站媒体主后台管理页面申请,具体内容请浏览 http://www.immob.cn
 
 @param
 delegate       回调方法对象,类型为LmmobAdWallDelegate,当广告墙异步请求成功时将在delegate指向的对象中调用代理方法
 
 @result        异步请求完成后,回调调用
                -(void)LmmobAdWallSDK:(LmmobAdWallSDK *)sdk AdWallStatus:(BOOL)isON, 进行进入广告墙按钮隐藏与否设置等

 */
-(void)GetAdWallWithEntranceID:(NSString *)entranceid AndDelegate:(id)delegate;

/*! 
 @method        ScoreQuery
 
 @abstract      查询用户积分
 
 @result        回调调用LmmobAdWallSDK:UserScore:ScoreUpdated:
 */
-(void)ScoreQuery;

/*! 
 @method        ScoreQuery
 
 @abstract      减少用户积分
 
 @result        回调调用LmmobAdWallSDK:UserScore:ScoreUpdated:
 */
-(void)ScoreSubstract:(double)score;

/*! 
 @method        PushAD:
 
 @abstract      本地推送
 
 @param
 date           本地推送的时间
 */
-(void)PushAD:(NSDate *)date;
/*! 
 @method        ReceiveAD:
 
 @abstract      收到本地推送
 
 @param
 no             本地推送对象
 */
-(void)ReceiveAD:(UILocalNotification *)no;
/*! 
 @method        RemoveBannerAd
 
 @abstract      去除BannerAd,暂无返回
 
 */
-(void)RemoveBannerAd;


#if NS_BLOCKS_AVAILABLE

-(void)GetAdWallWithEntranceID:(NSString *)entranceid AtTarget:(id)target backAction:(SEL)selector completionHandler:(void (^)(BOOL)) handle;

-(void)ScoreQueryWithCompletionHandler:(void (^)(BOOL,double)) handler;

-(void)ScoreSubstract:(double)score completionHandler:(void (^)(BOOL,double)) handler;

-(void)RemoveBannerAdWithCompletionHandler:(void (^)(BOOL)) handler;

#endif

@end
