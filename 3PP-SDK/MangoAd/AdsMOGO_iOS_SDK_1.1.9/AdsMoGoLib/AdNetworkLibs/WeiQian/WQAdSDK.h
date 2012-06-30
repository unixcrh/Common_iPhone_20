//
//  MyClass.h
//  WQMobileDemo
//
//  Created by Topsun on 3/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQAdSDK : NSObject 
/**
 * ��ʼ��sdk, �ڴ����ؼ�֮ǰ����
 * @param appID Ӧ�ó���ID ����վ���
 * @param pubID ������ID ����վ���
 * @param refreshRate ���ˢ��ʱ��
 * @param isTestMode �Ƿ����ò���ģʽ
 **/
+(void) init: (NSString*) appID withPubID:(NSString*) pubID withRefreshRate:(int) refreshRate isTestMode:(BOOL) isTestMode;

@end

