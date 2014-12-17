//
//  catalogueCell.h
//  SuperU
//
//  Created by 2B on 22/08/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface catalogueCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageCat;



@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UILabel *titre;
@end
