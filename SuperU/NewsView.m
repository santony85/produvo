//
//  NewsView.m
//  templateNB
//
//  Created by Plan B  on 06/11/12.
//  Copyright (c) 2012 antony. All rights reserved.
//

#import "NewsView.h"
#import "templateNewsCell.h"
#import "templateDetailNewsView.h"
#import "GlobalV.h"
#import "UIColor+CreateMethods.h"
#import "UIScrollView+APParallaxHeader.h"
#import "AGMedallionView.h"
#import "ODRefreshControl.h"



#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


@interface NewsView (){
    NSArray *readlst;
    BOOL parallaxWithView;
}

@end

@implementation NewsView

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[mappDelegate unHideLoader];
    
    // Setting navigation's bar tint color
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:@"#365491" alpha:0.5f];
    
}



- (void)viewDidLoad
{

    [super viewDidLoad];
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    
    
    int maxH = 160;
    if(IPAD) maxH = 300;
    
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [mappDelegate unHideLoader];
    [self.tableView addParallaxWithImage:[UIImage imageNamed:@"montage-parallax.png"] andHeight:maxH];
    self.medallions = [NSMutableArray array];
    readlst = [[NSArray alloc] init];
    [self getData];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Retour"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bkbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};


}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self getData];
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    });
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [readlst count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NewsCell";
    
    templateNewsCell *cell = (templateNewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[templateNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //if(indexPath.row %2 )cell.bkImage.image = [UIImage imageNamed:@"l2.png"];

    NSString *tmp = [NSString stringWithFormat:@"%@ %@ %@",[[readlst objectAtIndex:indexPath.row] objectForKey:@"d1"],[[readlst objectAtIndex:indexPath.row] objectForKey:@"d2"],[[readlst objectAtIndex:indexPath.row] objectForKey:@"d3"]];
    
    
    cell.titre.text = [[readlst objectAtIndex:indexPath.row] objectForKey:@"titre"];
    cell.l1.text    = [[readlst objectAtIndex:indexPath.row] objectForKey:@"d1"];
    cell.l2.text    = [[readlst objectAtIndex:indexPath.row] objectForKey:@"d2"];
    cell.l3.text    = [[readlst objectAtIndex:indexPath.row] objectForKey:@"d3"];
    
    //image
    NSString *rawStr = [NSString stringWithFormat:@"http://www.planb-apps.com/elements/%d/news/%@.jpg",idClientG,[[readlst objectAtIndex:indexPath.row] objectForKey:@"_id"]];
    
    NSURL * imageURL = [NSURL URLWithString:rawStr];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];

    UIImage * image;
    if(imageData.length >0)image = [UIImage imageWithData:imageData];
    else image = [UIImage imageNamed:@"no_image.jpg"];
    //cell.Image.image= image;
    cell.medallionView.image = image;

    ///
    return cell;  
    }





// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    templateDetailNewsView *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"templateDetailNewsView"];
    
    dvc.Stitre  = [[readlst objectAtIndex:indexPath.row] objectForKey:@"titre"];
    dvc.Sdetail = [[readlst objectAtIndex:indexPath.row] objectForKey:@"descl"];
    
    dvc.param = [readlst objectAtIndex:indexPath.row] ;
    
    
    NSString *rawStr = [NSString stringWithFormat:@"http://www.planb-apps.com/elements/%d/news/%@.jpg",idClientG,[[readlst objectAtIndex:indexPath.row] objectForKey:@"_id"]];
    
    NSURL * imageURL = [NSURL URLWithString:rawStr];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    
    UIImage * image;
    if(imageData.length >0)image = [UIImage imageWithData:imageData];
    else image = [UIImage imageNamed:@"no_image.jpg"];
    
    dvc.Simage= image;
    dvc.medallionView.image = image;
    
    NSString *tmp = [NSString stringWithFormat:@"%@ %@ %@",[[readlst objectAtIndex:indexPath.row] objectForKey:@"d1"],[[readlst objectAtIndex:indexPath.row] objectForKey:@"d2"],[[readlst objectAtIndex:indexPath.row] objectForKey:@"d3"]];
    
    dvc.Sresume = tmp;
    
    apiconnect *connect = [[apiconnect alloc] init];
    int res= [connect setStat:tokenAsString :@"news" :[[readlst objectAtIndex:indexPath.row] objectForKey:@"_id"]];
    
    
    [self.navigationController pushViewController:   dvc animated:YES];
    dvc = nil;
    

    
}


- (void)getData{
    
    
    apiconnect *connect = [[apiconnect alloc] init];
    readlst = [connect getList :@"news" :idClientG];

    //planbAnalitycs *pbAna = [[planbAnalitycs alloc] init];
    //readlst = [pbAna getList:@"news" :@"idclient" :idClientG :-1];
    [self.tableView reloadData];
    [mappDelegate unLoader];
    
}


@end
