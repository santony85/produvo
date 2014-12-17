//
//  JBViewController.h
//  JBParallaxTable
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Javier Berlana @jberlana
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface ViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)SelectCategorie:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btRecherche;

@property (strong, nonatomic)          NSMutableArray *prodArray;
@property (strong, nonatomic)          NSMutableArray *favArray;

@property (weak, nonatomic) IBOutlet UILabel *nbChoix;
- (IBAction)afftous:(id)sender;


- (IBAction)changeTypeAff:(id)sender;
- (IBAction)sortlst:(id)sender;

- (IBAction)kma:(id)sender;
- (IBAction)kmd:(id)sender;
- (IBAction)pra:(id)sender;
- (IBAction)prd:(id)sender;
- (IBAction)aana:(id)sender;
- (IBAction)aand:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;

@end
