//
//  pubView.h
//  LeclercOlonne
//
//  Created by 2B on 30/10/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pubView : UIViewController<UIWebViewDelegate>
- (IBAction)closePub:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imagectrl;
@property (weak, nonatomic) IBOutlet UIView *rndView;
@property (weak, nonatomic) IBOutlet UIButton *btClose;


@end
