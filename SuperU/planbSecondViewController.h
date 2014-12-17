//
//  planbSecondViewController.h
//  SuperU
//
//  Created by 2B on 01/07/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface planbSecondViewController : UIViewController


@property (strong, nonatomic)          NSMutableArray *prodArray;
@property (strong, nonatomic)          NSMutableArray *favArray;

- (IBAction)SelectCategorie:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
