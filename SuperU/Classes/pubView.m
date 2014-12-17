//
//  pubView.m
//  LeclercOlonne
//
//  Created by 2B on 30/10/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import "pubView.h"
#import "GlobalV.h"

#define kBoarderWidth 2.0
#define kCornerRadius 8.0

@interface pubView (){
    NSTimer *timer;
}

@end

@implementation pubView
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{

}





- (CGSize) aspectScaledImageSizeForImageView:(UIImageView *)iv image:(UIImage *)im {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    
    float x,y;
    float a,b;
    
    x = screenWidth-44;//iv.frame.size.width;
    y = screenHeight-44;//iv.frame.size.height;
    
    a = im.size.width;
    b = im.size.height;
    
    if ( x == a && y == b ) {           // image fits exactly, no scaling required
        // return iv.frame.size;
    }
    else if ( x > a && y > b ) {         // image fits completely within the imageview frame
        if ( x-a > y-b ) {              // image height is limiting factor, scale by height
            a = y/b * a;
            b = y;
        } else {
            b = x/a * b;                // image width is limiting factor, scale by width
            a = x;
        }
    }
    else if ( x < a && y < b ) {        // image is wider and taller than image view
        if ( a - x > b - y ) {          // height is limiting factor, scale by height
            a = y/b * a;
            b = y;
        } else {                        // width is limiting factor, scale by width
            b = x/a * b;
            a = x;
        }
    }
    else if ( x < a && y > b ) {        // image is wider than view, scale by width
        b = x/a * b;
        a = x;
    }
    else if ( x > a && y < b ) {        // image is taller than view, scale by height
        a = y/b * a;
        b = y;
    }
    else if ( x == a ) {
        a = y/b * a;
        b = y;
    } else if ( y == b ) {
        b = x/a * b;
        a = x;
    }
    
    
    NSLog(@"a:%f -> b:%f",a,b);
    return CGSizeMake(a,b);
    
}


- (BOOL)prefersStatusBarHidden {return YES;}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    NSString *
        contentString = [[NSString alloc]
                                   initWithFormat:@"<html><head></head><body bgcolor='black'><img width=960 src='http://planb-apps.com/elements/%d/pub/pub.jpg'/></body></html>",idClientG];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseUrl = [NSURL fileURLWithPath:path];
        [webView loadHTMLString:contentString baseURL:baseUrl];
    
    NSString *rawStr = [NSString stringWithFormat:@"http://planb-apps.com/elements/%d/pub/pub.jpg",idClientG];
    NSURL *imageURL = [NSURL URLWithString:rawStr];
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *imageA = [UIImage imageWithData:imageData];


    

    
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    

    
    
    CGSize recct = [self aspectScaledImageSizeForImageView:_imagectrl image:imageA];
    _imagectrl.image =imageA;

    
    
    
    float newHeight = recct.height;
    float newWidth  = recct.width;
    
    float pTop  = ((screenHeight - newHeight) /2)-16;
    float pLeft = ((screenWidth - newWidth) /2)-16;
    
    
    
    CGRect imageRect = CGRectMake(pLeft, pTop, recct.width, recct.height);
    

    
    _imagectrl.frame = imageRect;

    
    
    CGRect imageRect2 = CGRectMake(pLeft+8, pTop+8, newWidth+16, newHeight+16);
    _rndView.frame=imageRect2;
    
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (_rndView.frame.size.width), (_rndView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:kCornerRadius];
    [borderLayer setBorderWidth:kBoarderWidth];
    [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_rndView.layer addSublayer:borderLayer];

    imageRect2 = _btClose.frame;
    imageRect2.origin.y = pTop;
    imageRect2.origin.x = pLeft;
    _btClose.frame = imageRect2;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelWeb{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    //CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    self.tabBarController.view.frame = CGRectMake(0,0,bounds.size.width,bounds.size.height);
    
    [self dismissModalViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}


- (IBAction)closePub:(id)sender {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.tabBarController.view.frame = CGRectMake(0,0,bounds.size.width,bounds.size.height);
    [self dismissModalViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}

#pragma mark UIWebView delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
}

@end
