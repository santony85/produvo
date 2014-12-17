//
//  templateDetailNewsView.h
//  templateNB
//
//  Created by Plan B  on 07/11/12.
//  Copyright (c) 2012 antony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

@interface templateDetailNewsView : UIViewController{
    UIImageView *Image;
    UILabel *titre;
    UITextView *detail;
}

@property (retain, nonatomic) IBOutlet UIImageView *Image;
@property (retain, nonatomic) IBOutlet UILabel *titre;
@property (retain, nonatomic) IBOutlet UILabel *resume;
@property (retain, nonatomic) IBOutlet UITextView *detail;

@property (retain, nonatomic) IBOutlet UILabel *d2;
@property (retain, nonatomic) IBOutlet UILabel *d3;


@property (nonatomic) NSString *Stitre;
@property (nonatomic) NSString *Sdetail;
@property (nonatomic) NSString *Sresume;
@property (nonatomic) UIImage  *Simage;

@property (nonatomic) NSMutableDictionary  *param;

@property (weak, nonatomic) IBOutlet AGMedallionView *medallionView;


@end
