//
//  masterTabBarController.m
//  SuperU
//
//  Created by 2B on 21/08/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "masterTabBarController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "GlobalV.h"
#import "appDelegate.h"



@interface masterTabBarController ()

@end

@implementation masterTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    UITabBar *tb = self.tabBar;
    //self.currentController = [[tabController viewControllers] objectAtIndex:0];
    NSArray *items = tb.items;
     
     for (UITabBarItem *tbi in items) {
       UIImage *image = tbi.image;
       tbi.selectedImage = image;
       tbi.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       }
    
    
     
     [[UITabBar appearance] setTintColor:[UIColor colorWithRed:(92/255.0) green:(203/255.0) blue:(255/255.0) alpha:0.6]];
     
     // doing this results in an easier to read unselected state then the default iOS 7 one
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
     NSForegroundColorAttributeName : [UIColor colorWithRed:(92/255.0) green:(203/255.0) blue:(255/255.0) alpha:1]
     } forState:UIControlStateNormal];
     
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
     NSForegroundColorAttributeName : [UIColor colorWithRed:(92/255.0) green:(203/255.0) blue:(255/255.0) alpha:0.6]
     } forState:UIControlStateSelected];
     
     
    

    
    
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    

    
    
    
}

@end
