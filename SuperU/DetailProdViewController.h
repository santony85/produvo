//
//  DetailProdViewController.h
//  SuperU
//
//  Created by 2B on 22/08/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>







@interface DetailProdViewController : UIViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>


- (IBAction)affShareMenu:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *longTapShareButton;
- (IBAction)affRetour:(id)sender;
- (IBAction)ActionClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic) NSString *sId;

@property (strong, nonatomic) IBOutlet UILabel *ico1;
@property (strong, nonatomic) IBOutlet UILabel *ico2;
@property (strong, nonatomic) IBOutlet UILabel *ico3;


@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)btnEmail_Clicked:(id)sender;
- (IBAction)btnMessage_Clicked:(id)sender;


@end
