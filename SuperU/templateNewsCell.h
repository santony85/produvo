//
//  templateNewsCell.h
//  templateNB
//
//  Created by Plan B  on 06/11/12.
//  Copyright (c) 2012 antony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

@interface templateNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bkImage;
@property (weak, nonatomic) IBOutlet UILabel *titre;
@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UILabel *l3;

@property (weak, nonatomic) IBOutlet UIImageView *Image;


@property (weak, nonatomic) IBOutlet AGMedallionView *medallionView;



@end
