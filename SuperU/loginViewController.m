//
//  loginViewController.m
//  produvo
//
//  Created by Antony on 17/12/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "loginViewController.h"
#import "newApiConnect.h"

@interface loginViewController (){
    newApiConnect *connect;
}

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    
    
    _login.text = [prefs objectForKey:@"login"];
     _mdp.text  = [prefs objectForKey:@"mdp"];
    // Do any additional setup after loading the view.
    int myInt = [prefs integerForKey:@"selsw"];
    _memo.on = myInt;

    connect = [[newApiConnect alloc] init];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _login) {
        [_mdp becomeFirstResponder];
    }
    
    else{
        [textField resignFirstResponder];
    }
    return YES;
}



- (IBAction)login:(id)sender {
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    NSMutableArray  *readlst     = [connect getLogin :@"marchand" :_login.text :_mdp.text];
    if([readlst count]>0){
        if(_memo.isOn==YES){
            //save mdp
            [prefs setObject:_login.text forKey:@"login"];
            [prefs setObject:_mdp.text   forKey:@"mdp"];
            [prefs setInteger:1 forKey:@"selsw"];
        }
        else {
            //save mdp
            [prefs setObject:@"" forKey:@"login"];
            [prefs setObject:@""  forKey:@"mdp"];
            [prefs setInteger:0 forKey:@"selsw"];
        }

        [prefs setObject:[[readlst objectAtIndex:0] objectForKey:@"vendeur"] forKey:@"vendeur"];
        [prefs setObject:[[readlst objectAtIndex:0] objectForKey:@"vendeurid"] forKey:@"vendeurid"];
        
        [self performSegueWithIdentifier:@"loginsegue" sender:self];
    }
    
    
    
}
@end
