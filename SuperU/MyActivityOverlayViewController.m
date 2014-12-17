//
//  MyActivityOverlayViewController.m
//  LeclercOlonne
//
//  Created by 2B on 17/12/2013.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import "MyActivityOverlayViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface MyActivityOverlayViewController ()


@end

@implementation MyActivityOverlayViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(id)initWithFrame:(CGRect)theFrame {
    if (self = [super init]) {
        frame = theFrame;
        self.view.frame = theFrame;
        //[self loadView];


    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView {
    [super loadView];
    //container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    /*container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    container.backgroundColor = [UIColor clearColor];

    container.layer.borderWidth = 2.0f;
    container.layer.borderColor = [UIColor blackColor].CGColor;
    container.layer.cornerRadius = CGRectGetHeight(container.bounds) / 2;
    
    
    activityLabel = [[UILabel alloc] init];
    activityLabel.text = NSLocalizedString(@"Chargement", @"string1");
    activityLabel.textColor = [UIColor blackColor];
    activityLabel.font = [UIFont boldSystemFontOfSize:17];
    [container addSubview:activityLabel];
    activityLabel.frame = CGRectMake(20, 13, 100, 25);
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [container addSubview:activityIndicator];
    activityIndicator.frame = CGRectMake(120, 10, 30, 30);
    
    [self.view addSubview:container];
    container.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.view.backgroundColor = [UIColor clearColor];
    self.view.alpha = 0.8f;
    [activityIndicator startAnimating];*/
}

-(void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [activityIndicator startAnimating];
}

-(void)viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    [activityIndicator stopAnimating];
}

-(void)killme{
 [self.view removeFromSuperview];
}
-(void)hideme{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [self.view    setAlpha: 0.0];
    [UIView setAnimationDidStopSelector:@selector(animAffContent:finished:context:)];
    [UIView commitAnimations];

}
-(void)hidemeFast{

    [self.view    setAlpha: 0.0];

    
}


-(void)showme{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [self.view    setAlpha: 1.0];
    [UIView setAnimationDidStopSelector:@selector(animAffContent:finished:context:)];
    [UIView commitAnimations];
    
}

-(void)showmeF{
    //[UIView beginAnimations:NULL context:NULL];
    //[UIView setAnimationDuration:0.2];
    //[UIView setAnimationDelegate:self];
    [self.view    setAlpha: 1.0];
    //[UIView setAnimationDidStopSelector:@selector(animAffContent:finished:context:)];
    //[UIView commitAnimations];
   // [[self superview] bringSubviewToFront:grandchildview];
}


@end
