//
//  detailViewController.h
//  hyperulucon
//
//  Created by Mickael NAULET on 10/12/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface detailViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollZoom;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) NSMutableDictionary  *mdata;
@property (weak, nonatomic) IBOutlet UILabel *titre;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *prix;

@property (weak, nonatomic) IBOutlet UILabel *marque;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *serie;
@property (weak, nonatomic) IBOutlet UILabel *ref;
@property (weak, nonatomic) IBOutlet UILabel *annee;
@property (weak, nonatomic) IBOutlet UILabel *km;

@property (weak, nonatomic) IBOutlet UILabel *energie;
@property (weak, nonatomic) IBOutlet UILabel *couleur;
@property (weak, nonatomic) IBOutlet UILabel *bv;
@property (weak, nonatomic) IBOutlet UILabel *com;
@property (weak, nonatomic) IBOutlet UIView *comView;
@property (weak, nonatomic) IBOutlet UIButton *affInfos;
@property (weak, nonatomic) IBOutlet UIImageView *dum;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;


- (IBAction)affInfos:(id)sender;




@end
