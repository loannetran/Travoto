//
//  AppDelegate.h
//  Travoto
//
//  Created by Loanne Tran on 9/10/15.
//  Copyright (c) 2015 Loanne Tran. All rights reserved.
//
@class Reachability;

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;

-(void) checkNetworkStatus:(NSNotification *)notice;

@end
