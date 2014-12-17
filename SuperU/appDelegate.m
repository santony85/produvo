//
//  planbAppDelegate.m
//  LeclercApp
//
//  Created by 2B on 21/10/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import "appDelegate.h"
//#import "pubView.h"
#import "GlobalV.h"
//#import "SSZipArchive.h"
#import <QuartzCore/QuartzCore.h>
#import "apiconnect.h"
#import "NSString+URLEncoding.h"
#import "GeofenceMonitor.h"
#import "DetailProdViewController.h"

#import "newApiConnect.h"



#define USE_LOCATION

#import "AMTumblrHud.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]





@implementation appDelegate{
    NSString *myToken;
    UIView *mainView1;
    UIView *mainView2;
    NSDateFormatter* dateFormatter;
    NSDate *date1;
    NSDate *date2;
    NSString *IdIosLocation;
    GeofenceMonitor  * gfm;
 
   
    
}

@synthesize  overlayController;





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    
    newApiConnect *connect = [[newApiConnect alloc] init];
    NSMutableArray *tmparr = [connect getAll :@"version" :0];
    NSInteger myInt = [prefs integerForKey:@"numversion"];
    if([[[tmparr objectAtIndex:0] objectForKey:@"numversion"] integerValue] > myInt)[connect getAll :@"vehicule" :1];
    [prefs setInteger:[[[tmparr objectAtIndex:0] objectForKey:@"numversion"] integerValue] forKey:@"numversion"];
    
    
    
    
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:self.window.bounds]; // you must release the window somewhere, when you do not need it anymore
    alertWindow.windowLevel     = UIWindowLevelAlert; // puts it above the status bar
    alertWindow.backgroundColor = [UIColor clearColor];
    self.window2                = alertWindow;
    self.container = [[UIView alloc] initWithFrame:self.window.bounds];
    self.container.backgroundColor = [UIColor clearColor];
    
    AMTumblrHud *tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake((CGFloat) ((self.window.frame.size.width - 55) * 0.5),
                                                                           (CGFloat) ((self.window.frame.size.height - 40) * 0.9), 55, 20)];
    tumblrHUD.hudColor = UIColorFromRGB(0xF1F2F3);//[UIColor magentaColor];
    [tumblrHUD showAnimated:YES];
    [self.container addSubview:tumblrHUD];
    
    
    
    [self.container setNeedsDisplay];
    
    [self.window2 addSubview:self.container];
    [self.window2 makeKeyAndVisible];
    [self.window2 setHidden:YES];
    

    
    IdIosLocation =@"";
    //[FBProfilePictureView class];
    
    GlobalV *setVar = [[GlobalV alloc] init];
    [setVar setVar];
    

    
    
    
    //-- Set Notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeNewsstandContentAvailability |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    
    
    //dataBase *sqlManager = [[dataBase alloc] initDatabase:0];

    application.applicationIconBadgeNumber = 0;
    [prefs setObject:@"" forKey:@"myId"];
    [prefs setInteger:1 forKey:@"isStart"];
    [prefs setInteger:1 forKey:@"isPub"];

    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *currentTime = [NSDate date];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    date1 = [dateFormatter dateFromString:resultString];
    
    //[self getCategories];
    
    gfm = [GeofenceMonitor sharedObj];
    //[self getGeofenceData];
    
    NSDictionary* userInfo =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self processRemoteNotification:application :userInfo];
        return YES;
    }
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSDate *currentTime = [NSDate date];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    date2 = [dateFormatter dateFromString:resultString];
    NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];
    //apiconnect *connect = [[apiconnect alloc] init];
    //int res= [connect setAction:tokenAsString :@"Background" :diff];
    NSLog(@"Entered background");
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    //apiconnect *connect = [[apiconnect alloc] init];
    //int res= [connect setAction:tokenAsString :@"Active" :0.0];
    
    /*isInBackground = false;
     //self.backgroundMode = kPWTrackAccurateLocationChanges;*/
    //[self.locationManager stopMonitoringSignificantLocationChanges];
    //[self.locationManager startUpdatingLocation];
    application.applicationIconBadgeNumber = 0;
    //[self updateLocationTrackingMode];
    NSLog(@"The return");

    
}

/*- (BOOL)application:(UIApplication *)application
 openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
 annotation:(id)annotation {
 // return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
 }
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[FBAppEvents activateApp];
    //[FBAppCall handleDidBecomeActive];
    //isInBackground =false;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[FBSession.activeSession close];
    //planbAnalitycs *pbAna = [[planbAnalitycs alloc] init];
    //[pbAna setAction:tokenAsString :@"terminate" :0.0];
    
    //apiconnect *connect = [[apiconnect alloc] init];
    //int res= [connect setAction:tokenAsString :@"Terminate" :0.0];
    
}



-(void)affLoader :(UIView *)place :(UIView *)place2 :(CGRect) theFrame{
    overlayController = [[MyActivityOverlayViewController alloc] initWithFrame:theFrame];
    [place insertSubview:overlayController.view aboveSubview:place2];
}


-(void) unHideLoader{
    [_container     setAlpha: 1.0];
    [self.window2 setHidden:NO];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    [self.window2 setHidden:YES];
}

-(void)unLoader{
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [_container     setAlpha: 0.0];
    //[self.window2 setHidden:YES];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
    
    
}


/*
 * --------------------------------------------------------------------------------------------------------------
 *  BEGIN APNS CODE
 * --------------------------------------------------------------------------------------------------------------
 */

/**
 * Fetch and Format Device Token and Register Important Information to Remote Server
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSString *devMode;
    apiconnect *connect = [[apiconnect alloc] init];
    
#ifdef DEBUG
    devMode =@"sandbox";
#else
    devMode =@"production";
#endif
    
    
    
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *appName    = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *pushBadge;
    NSString *pushAlert;
    NSString *pushSound;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNew"];
    
    /*if(myInt ==0){
    	NSUInteger rntypes   = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
     pushBadge  = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
     pushAlert  = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
     pushSound  = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";
     }
     
     else {*/
    pushBadge  =  @"enabled";
    pushAlert  =  @"enabled";
    pushSound  =  @"enabled";
    //     [prefs setInteger:0 forKey:@"isNew"];
    // }
    
    
    
    
    
    
    UIDevice *dev = [UIDevice currentDevice];
    
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    myToken = deviceToken;
    NSString *host = @"www.planb-apps.com";
    
    NSString *urlString = [NSString stringWithFormat:@"/apnsm.php?task=%@&appname=%@&appversion=%@&devicetoken=%@&devicename=%@&devicemodel=%@&deviceversion=%@&pushbadge=%@&pushalert=%@&pushsound=%@&clientid=%d&development=%@", @"register", appName,appVersion, deviceToken, deviceName, deviceModel, deviceSystemVersion, pushBadge, pushAlert, pushSound,idClientG,devMode];
    
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    tokenAsString =myToken;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    
#endif
}




/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Error in registration. Error: %@", error);
    
#endif
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //load the new available content and call the completionhandler.
    
    NSLog(@"%@",userInfo);
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSLog(@"%@",apsInfo);
    int loadData = [[apsInfo objectForKey:@"type"] intValue];
    if(loadData ==1){
        [self getGeofenceData];
    }
    else {
        [self processRemoteNotification:application :userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ////
    // parser les pushs ////
    
}

- (void)processRemoteNotification:(UIApplication *)application :(NSDictionary *)userInfo{
    NSLog(@"remote notification: %@",[userInfo description]);
#if !TARGET_IPHONE_SIMULATOR
    
    
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"nbPush"];

    
    [prefs setInteger:myInt+1 forKey:@"nbPush"];

    //[self.delegate BadgeNbDelegate:self];
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSDictionary *apsMes  = [apsInfo  objectForKey:@"alert"];
    NSDictionary *apsAcm  = [userInfo  objectForKey:@"acme2"];
    
    
    
    NSString *alert = [apsMes objectForKey:@"body"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
    
    
    NSString  *loadId   = [apsAcm objectForKey:@"id"] ;
    NSString  *loadLien = [apsAcm objectForKey:@"lien"] ;
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setInteger:1 forKey:@"isNet"];

    
    NSLog(@"%@",apsAcm);
    NSLog(@"%@ %@",loadId,loadLien);
    
    //if([loadLien length] > 0)
    if ([loadLien isKindOfClass:[NSString class]])[[UIApplication sharedApplication] openURL:[NSURL URLWithString:loadLien]];
    if([loadId length] > 0){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        DetailProdViewController *dvc = [sb instantiateViewControllerWithIdentifier:@"DetailProdViewController"];
        dvc.sId =loadId;
        [self.window.rootViewController presentModalViewController:dvc animated:YES];
        dvc = nil;
        
    }
    
    
#endif
    
    
}



-(void)getGeofenceData {
    [gfm clearGeofences];
    apiconnect *connect = [[apiconnect alloc] init];
    NSArray *readlst = [connect getList:@"geopush" :idClientG ];
    if([gfm checkLocationManager]){
        for (int i = 0; i < [readlst count]; i++)
        {
            NSMutableDictionary * fence1 = [NSMutableDictionary new];
            [fence1 setValue:[[readlst objectAtIndex:i] objectForKey:@"_id"]   forKey:@"identifier"];
            [fence1 setValue:[[readlst objectAtIndex:i] objectForKey:@"lat"]   forKey:@"latitude"];
            [fence1 setValue:[[readlst objectAtIndex:i] objectForKey:@"lng"]   forKey:@"longitude"];
            [fence1 setValue:[[readlst objectAtIndex:i] objectForKey:@"dist"]  forKey:@"radius"]; //en metre
            [fence1 setValue:[[readlst objectAtIndex:i] objectForKey:@"inout"] forKey:@"inout"]; //en metre
            [gfm addGeofence:fence1];
        }
        [gfm findCurrentFence];
    }
    
    
    
}



@end
