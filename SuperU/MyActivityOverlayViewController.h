//
//  MyActivityOverlayViewController.h
//  LeclercOlonne
//
//  Created by 2B on 17/12/2013.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityOverlayViewController : UIViewController{
    UILabel *activityLabel;
    UIActivityIndicatorView *activityIndicator;
    UIView *container;
    CGRect frame;
}
-(id)initWithFrame:(CGRect) theFrame;
-(void)killme;
-(void)hideme;
-(void)showme;
-(void)loadView;
-(void)hidemeFast;
-(void)showmeF;

@end
