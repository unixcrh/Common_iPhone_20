//
//  ImpressionADView.h
//  Wooboo iOS SDK 2.0
//
//  Created by wooboo on 2010/1.
//  Updated by Wooboo at 2011/10.
//  Copyright 2011 www.wooboo.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CFNetwork/CFNetwork.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class AnimatedGif;
@class ImpressionADColor;

typedef enum {
	BannerScreen = 0,
	HalfScreen,
	FullScreen
} DisplayType;

typedef enum{
	OrientationPortrait = 0,
	OrientationLandscapeRight,
	OrientationLandscapeLeft
}InterfaceOrietation;

@protocol ADListenerDelegate;

@interface ImpressionADView: UIImageView<MFMailComposeViewControllerDelegate,MKMapViewDelegate,UIWebViewDelegate, UIAlertViewDelegate>{
}

@property(nonatomic,retain) UILabel *contentLabel;
@property(nonatomic,assign) float requestADTimeIntervel;//***广告请求间隔时间***//

/*
 参数说明：本类型广告后台请求的间隔时间，可选择手动设定，默认为10，后台会根据该值返回时段内不同的广告内容 请在初始化方法后使用。
 */
-(id)initWithADWith:(NSString *)Wooboo_PID status:(BOOL)isTesting offsetX:(int)x offsetY:(int)y  displayType:(int)screenState horizontalOrientation:(int) horizontal;//***映像式广告初始化方法***//
/*
 参数说明：本类型广告的初始化方法，包含Wooboo_PID，测试模式和起始点坐标。
 */
-(void)startADRequest;//***广告请求开始***//
/*
 广告请求开始，计时器开始运行。
 */
-(void)requestADWillStop;//***广告请求暂停或取消***//
/*
 计时器暂停。
 */
-(void)requestADWillContinue;//***广告请求继续***//
/*
 计时器继续。
 */

-(void)setDisplayType:(int)screenState setX:(int)x setY:(int)y;//***改变广告展示类型(全/半屏，条形)***//
@end


@protocol ADListenerDelegate<NSObject>

@optional

/* 点击广告条 */
- (void)onClickAD;

/* 成功获取广告时候调用 */
- (void)receiveAD;

/* 获取广告失败的时候调用 */
- (void)onFailedToReceiveAD:(NSString*)error;

@end
