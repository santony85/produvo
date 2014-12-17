//
//  NewsView.h
//  templateNB
//
//  Created by Plan B  on 06/11/12.
//  Copyright (c) 2012 antony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "templateDetailNewsView.h"

@interface NewsView : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *medallions;


@end
