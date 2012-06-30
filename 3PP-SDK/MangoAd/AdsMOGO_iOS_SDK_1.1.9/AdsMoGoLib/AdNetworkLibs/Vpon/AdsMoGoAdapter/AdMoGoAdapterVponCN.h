//
//  File: AdMoGoAdapterVponCN.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.


#import "AdMoGoAdNetworkAdapter.h"
#import "AdOnDelegate.h"
#import "VponAdOnView.h"

@interface AdMoGoAdapterVponCN: AdMoGoAdNetworkAdapter<VponAdOnDelegate>{
	NSTimer *timer;
    VponAdOnView *adOnView;
}

+ (AdMoGoAdNetworkType)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
