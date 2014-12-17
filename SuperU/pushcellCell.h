//
//  pushcellCell.h
//  lecookoo
//
//  Created by 2B on 28/06/13.
//  Copyright (c) 2013 antony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pushcellCell : UITableViewCell{
    
    UILabel *textLabel;
    UILabel *dateLabel;
    
}

@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

@end
