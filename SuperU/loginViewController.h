//
//  loginViewController.h
//  produvo
//
//  Created by Antony on 17/12/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *login;
@property (strong, nonatomic) IBOutlet UITextField *mdp;

@property (strong, nonatomic) IBOutlet UISwitch *memo;

- (IBAction)login:(id)sender;

@end
