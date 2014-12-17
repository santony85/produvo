//
//  planbFirstViewController.h
//  SuperU
//
//  Created by 2B on 01/07/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface planbFirstViewController : UIViewController<UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)affPush:(id)sender;
- (IBAction)closepush:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btNotif;

@property (strong, nonatomic) IBOutlet UIView *pushView;

-(void)setNbBadge;


@end
