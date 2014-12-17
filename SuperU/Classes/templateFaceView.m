//
//  templateFaceView.m
//  Fievra
//
//  Created by Plan B  on 21/11/12.
//  Copyright (c) 2012 antony. All rights reserved.
//

#import "templateFaceView.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalV.h"

@interface templateFaceView ()

@end

@implementation templateFaceView


@synthesize webView,retour;






- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"body-bg.jpg"]];
    // Do any additional setup after loading the view from its nib.
    //[mappDelegate affLoader:nil:nil];
    [webView setDelegate:self];
    _indic.hidden = NO;

    NSString *url = lienFb;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//indic

}

//***********************************************
//***********************************************
//***********************************************
//***********************************************
-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    //I want to only support portrait mode
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

- (IBAction)affRetour:(UIButton *)sender{
    [self dismissModalViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}

#pragma mark UIWebView delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _indic.hidden = YES;

}


- (void) webView:(UIWebView*) webView didFailLoadWithError:(NSError *)error {
    
    _indic.hidden = YES;
}



@end
