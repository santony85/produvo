//
//  findViewController.h
//  produvo
//
//  Created by Antony on 05/01/2015.
//  Copyright (c) 2015 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface findViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerview;

- (IBAction)affMarque:(id)sender;
- (IBAction)affModele:(id)sender;
- (IBAction)affCouleur:(id)sender;
- (IBAction)affKil:(id)sender;

- (IBAction)closePk:(id)sender;
- (IBAction)execRec:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *nbv;

@property (weak, nonatomic) IBOutlet UILabel *labMarque;
@property (weak, nonatomic) IBOutlet UILabel *labCouleur;
@property (weak, nonatomic) IBOutlet UILabel *labModele;
@property (weak, nonatomic) IBOutlet UILabel *labKilo;
@property (weak, nonatomic) IBOutlet UIView *pkview;

@end
