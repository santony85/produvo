//
//  listepromoCell.h
//  SuperU
//
//  Created by 2B on 20/08/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listepromoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *bkLabel;
@property (strong, nonatomic) IBOutlet UILabel *categorie;
@property (strong, nonatomic) IBOutlet UILabel *promos;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *prix;
@property (strong, nonatomic) IBOutlet UILabel *qte;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
