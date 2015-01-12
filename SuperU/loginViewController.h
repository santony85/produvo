//
//  loginViewController.h
//  produvo
//
//  Created by Antony on 17/12/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newApiConnect.h"

@interface loginViewController : UIViewController<UITextFieldDelegate,newApiConnectDelegate>

@property (strong, nonatomic) IBOutlet UITextField *login;
@property (strong, nonatomic) IBOutlet UITextField *mdp;

@property (strong, nonatomic) IBOutlet UISwitch *memo;
@property (strong, nonatomic) IBOutlet UILabel *prog;

- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *sld;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@end
