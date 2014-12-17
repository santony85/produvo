//
//  templateDetailNewsView.m
//  templateNB
//
//  Created by Plan B  on 07/11/12.
//  Copyright (c) 2012 antony. All rights reserved.
//

#import "templateDetailNewsView.h"
#import "GlobalV.h"
#import "UIColor+CreateMethods.h"
#import "AGMedallionView.h"


#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


@interface templateDetailNewsView (){
    NSArray *readlst;

}

@end

@implementation templateDetailNewsView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@",[_param objectForKey:@"titre"]);
    
    
	// Do any additional setup after loading the view.
    self.titre.text=[_param objectForKey:@"titre"];
    self.detail.text = _Sdetail;
    
    if (IPAD){
        self.resume.font = [UIFont systemFontOfSize:22];

    }

    
    self.resume.text = [_param objectForKey:@"d1"];
    self.d2.text     = [_param objectForKey:@"d2"];
    self.d3.text     = [_param objectForKey:@"d3"];
    
    self.Image.image =_Simage;
    
    _Simage = [UIImage imageNamed: @"iconl.png"];
    self.medallionView.image =_Simage;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    float screenWidth = screenSize.width;
    
    if(screenWidth > 700){
        CGRect frame = self.medallionView.frame;
        frame.size.width = frame.size.height;
        NSLog(@"%f %f %f %f",frame.size.width,frame.size.height,frame.origin.x,frame.origin.y);
        self.medallionView.frame = frame;
    }

    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setting navigation's bar tint color
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:@"#365491" alpha:0.5f];

    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {

    [super viewDidUnload];
}


@end
