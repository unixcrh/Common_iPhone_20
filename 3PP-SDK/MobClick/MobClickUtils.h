//
//  MobClickUtils.h
//  Draw
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"

@interface MobClickUtils : NSObject

+ (int)getIntValueByKey:(NSString*)key defaultValue:(int)defaultValue;
+ (NSString*)getStringValueByKey:(NSString*)key defaultValue:(NSString*)defaultValue;
+ (int)getBoolValueByKey:(NSString*)key defaultValue:(BOOL)defaultValue;

@end
