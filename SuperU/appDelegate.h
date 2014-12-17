//
//  planbAppDelegate.h
//  LeclercApp
//
//  Created by 2B on 21/10/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MyActivityOverlayViewController.h"


//#define kPWTrackingDisabled @"PWTrackingDisabled"
//#define kPWTrackSignificantLocationChanges @"PWTrackSignificantLocationChanges"
//#define kPWTrackAccurateLocationChanges @"PWTrackAccurateLocationChanges"

//@class FPViewController;




@interface appDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UITabBarDelegate, UITabBarControllerDelegate>{
    MyActivityOverlayViewController *overlayController;
    //UIBackgroundTaskIdentifier bgTask;
}



//@property (strong, nonatomic) FPViewController *rootViewController;
@property (strong, nonatomic) MyActivityOverlayViewController *overlayController;
//@property (nonatomic, retain) PWLocationTracker *locationTracker;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *window2;


@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIView *container;

//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *backgroundMode;

-(void)affLoader :(UIView *)place :(UIView *)place2 :(CGRect) theFrame;
-(void)unLoader;
-(void)unHideLoader;




@property(nonatomic, retain) UINavigationController *navController;




/*@property (assign, nonatomic) BOOL background;
 @property (assign, nonatomic) BOOL sentNotification;
 @property (strong, nonatomic) dispatch_block_t expirationHandler;
 @property (assign, nonatomic) UIDeviceBatteryState lastBatteryState;
 @property (assign, nonatomic) BOOL jobExpired;
 @property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;*/

@end


