//
//  ViewController.h
//  BTGlassScrollViewExample
//
//  Created by Byte on 10/18/13.
//  Copyright (c) 2013 Byte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APRoundedButton.h"


@interface ViewControllerME : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)affRetour:(id)sender;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet APRoundedButton *btClose;
@property (weak, nonatomic) IBOutlet UIPageControl *affNbPage;
@property (weak, nonatomic) IBOutlet UIButton *btCl;

@end
