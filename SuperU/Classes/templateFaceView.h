//
//  templateFaceView.h
//  Fievra
//
//  Created by Plan B  on 21/11/12.
//  Copyright (c) 2012 antony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>

@interface templateFaceView : UIViewController<UIWebViewDelegate>{

    IBOutlet UIBarButtonItem *retour;
    
}

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *retour;

- (IBAction)affRetour:(UIBarButtonItem*)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indic;



@end
