//
//  loginViewController.m
//  produvo
//
//  Created by Antony on 17/12/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "loginViewController.h"
#import "newApiConnect.h"
#import "Reachability.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface loginViewController (){
    newApiConnect *connect;
    float step;
    float posmaj;
    int tot,pos;
}

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    tot=0;pos=1;
    
    _login.text = [prefs objectForKey:@"login"];
     _mdp.text  = [prefs objectForKey:@"mdp"];
    // Do any additional setup after loading the view.
    int myInt = [prefs integerForKey:@"selsw"];
    _memo.on = myInt;
    connect = [[newApiConnect alloc] init];
    connect.delegate = self;
    
    
    _sld.progress = 0.0;
    
    //[self performSelectorInBackground:@selector(stepImage) withObject:nil];
    
    //verif connection au reseau
    
    //newApiConnect *connect = [[newApiConnect alloc] init];
    
    
    /*NSMutableArray *tmparr = [connect getAll :@"version" :0];
    NSInteger myInt2 = [prefs integerForKey:@"numversion"];
    if([[[tmparr objectAtIndex:0] objectForKey:@"numversion"] integerValue] > myInt2)[connect getAll :@"vehicule" :1];
    [prefs setInteger:[[[tmparr objectAtIndex:0] objectForKey:@"numversion"] integerValue] forKey:@"numversion"];*/
    

    
    
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


- (NSNumber *) dataNetworkTypeFromStatusBar {
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"]    subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    return [dataNetworkItemView valueForKey:@"dataNetworkType"];
}

- (IBAction)login:(id)sender {
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    
    
    if([self dataNetworkTypeFromStatusBar]>=2){
        NSLog(@"There IS internet connection");
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
            [prefs setObject:[[readlst objectAtIndex:0] objectForKey:@"_id"] forKey:@"marchandid"];
            
            
           // -(NSMutableArray *)getVendeur :(NSString *)collection :(NSString *)idp
            
            NSMutableArray  *vendlst     = [connect getVendeur :@"vendeur" :[[readlst objectAtIndex:0] objectForKey:@"vendeurid"] ];
            [prefs setObject:vendlst forKey:@"vendeurlst"];
            
            [UIView animateWithDuration:0.2 animations:^{
               _prog.text = [NSString stringWithFormat:@"Mise a jour"];
            } completion:^(BOOL finished) {
                NSMutableArray *tmparr = [connect getAll :@"version" :0];
                NSInteger myInt2 = [prefs integerForKey:@"numversion"];
                if([[[tmparr objectAtIndex:0] objectForKey:@"numversion"] integerValue] > myInt2){
                    [connect getAll :@"vehicule" :1];
                    [prefs setInteger:[[[tmparr objectAtIndex:0] objectForKey:@"numversion"] integerValue] forKey:@"numversion"];
                }
                else{
                  [self performSegueWithIdentifier:@"loginsegue" sender:self];
                }
                
            }];

            
            
            
            

            
            
            
        }
        
    }
    else{
        NSLog(@"There IS NO internet connection");
    }

   
    
}

-(void)nbImage:(int)nbImages{
    step = 1.0 / nbImages;
    tot=nbImages;
    posmaj = 0.0;
    NSLog(@"%d->%f",nbImages,step);
    _prog.text = [NSString stringWithFormat:@"Mise a jour 1/%d",tot];
    
}

-(void)stepImage{
    posmaj = posmaj + step;
    [UIView animateWithDuration:0.2 animations:^{
        _sld.progress = (float)posmaj;
        _prog.text = [NSString stringWithFormat:@"Mise a jour %d/%d",pos++,tot];
    } completion:^(BOOL finished) {
        if(posmaj >= 0.999998)[self performSegueWithIdentifier:@"loginsegue" sender:self];
    }];
    
    NSLog(@"%f",posmaj);
    
    
}



@end
