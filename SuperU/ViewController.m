//
//  JBViewController.m
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


#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "GlobalV.h"
#import "KxMenu.h"
#import "detailViewController.h"
#import "NSFavoris.h"
#import "ODRefreshControl.h"
#import "NSString+URLEncoding.h"

// Table cells
#import "JBParallaxCell.h"
#import "newApiConnect.h"
#import "selectionViewController.h"
#import "BBBadgeBarButtonItem.h"




@interface ViewController () <UIScrollViewDelegate>{
    NSMutableArray *readlst;
    NSArray *catlst;
    NSMutableArray *imagesArray;
    NSMutableArray *menuItems2;
    
    NSMutableArray *tmplst;
    NSMutableArray *initial;
    
    int isLstFav;
    newApiConnect *connect;
    
   // NSMutableArray *catlst;
    NSMutableArray *marquelst;
    NSMutableArray *energielst;
    int poscollapse;
    int isSel;
    int isPrix;
    int oldpos;
    
    NSMutableArray *favorislst;

    
}


@property (nonatomic, strong) NSMutableArray *tableItems;
@property (nonatomic) BOOL useCustomCells;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    isPrix=0;
    
    poscollapse =0;
    isSel  = 0;
    oldpos = 0;
    
    connect = [[newApiConnect alloc] init];
    
    

    
    //_login.text = [prefs objectForKey:@"login"];
    //_mdp.text  = [prefs objectForKey:@"mdp"];

    
    
    
    //[favorislst addObject:@"66385844493"];
    //[favorislst addObject:@"111379524493"];
    
    favorislst = [[NSMutableArray alloc] init];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    //[mappDelegate unHideLoader];
    self.useCustomCells = NO;
    isLstFav =0;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Retour"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
  [self.navigationItem setBackBarButtonItem: backButton];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bkbar.png"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.btRight.badgeBGColor   = [UIColor redColor];
    self.btRight.badgeTextColor = [UIColor whiteColor];
    self.btRight.badgeFont      = [UIFont systemFontOfSize:12.0];
    self.btRight.badgePadding   = 6;
    self.btRight.badgeMinSize   = 8;
    self.btRight.badgeOriginX   = 38;
    self.btRight.badgeOriginY   = -6;
    self.btRight.shouldHideBadgeAtZero = YES;
    self.btRight.shouldAnimateBadge = YES;
    
    self.btRight.badgeValue=[NSString stringWithFormat:@"%d",[favorislst count] ];
    
    
    [self getData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // called only once
    return YES;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:NO];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    if([searchText isEqualToString:@""])[self getData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    

    
     NSString *uppercase = [searchBar.text uppercaseString];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"(Marque CONTAINS[cd] %@) or (Modele CONTAINS[cd] %@) or (Couleur CONTAINS[cd] %@)",
                              uppercase,uppercase,uppercase];
    
    
    readlst = [initial filteredArrayUsingPredicate:predicate];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
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


- (UIColor *)colorFromHexString:(NSString *)hexString :(float)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:nil];
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    int isBack = [prefs integerForKey:@"isback"];
    if(isBack == 1){
        favorislst = [prefs objectForKey:@"favlst"];
        self.btRight.badgeValue=[NSString stringWithFormat:@"%d",[favorislst count] ];
        [self.tableView reloadData];
    }
    else if(isBack == 2){
        readlst = [prefs objectForKey:@"reclst"];
        [self.tableView reloadData];
    }

    /*else {
        favorislst = [[NSMutableArray alloc] init];
        [self getData];
    }*/
    
    [prefs setInteger:0 forKey:@"isback"];
    [prefs setObject:[[NSMutableArray alloc] init] forKey:@"favlst"];
    [prefs setObject:[[NSMutableArray alloc] init] forKey:@"reclst"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mappDelegate unLoader];
    //[self.theSearchBar resignFirstResponder];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNewPromo"];
    if(myInt==0){
        //[mappDelegate unHideLoader];
    }


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _nbChoix.text = [NSString stringWithFormat:@"%d véhicules selectionnés",[readlst count] ];
    return readlst.count;
}

- (NSArray *)DelButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Supprimer"];
    
    return rightUtilityButtons;
}

- (NSArray *)AddButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Favoris"];

    
    return rightUtilityButtons;
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"idRow -> %d poscollapse = %d",indexPath.row,poscollapse);
    
   
    if(indexPath.row==poscollapse)return 130;//poscollapse
    else return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"parallaxCell";
    JBParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[JBParallaxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *ref =  [NSString stringWithFormat:@"%@ %@",
                      [[readlst objectAtIndex:indexPath.row] objectForKey:@"Marque"],
                      [[readlst objectAtIndex:indexPath.row] objectForKey:@"Modele"]];
    cell.catTitle.text = ref;
    cell.catTitle.textColor = [UIColor whiteColor];
    
    if(isPrix==0)cell.prix.text = [NSString stringWithFormat:@"Prix : %@ €",[[readlst objectAtIndex:indexPath.row] objectForKey:@"PrixVenteTTC"]];
    else cell.prix.text = @"Prix : N.C";
    
    if(indexPath.row %2 !=0){
       cell.bkLabel.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(76/255.0) blue:(138/255.0) alpha:1];
       cell.prix.textColor = [UIColor colorWithRed:(36/255.0) green:(76/255.0) blue:(138/255.0) alpha:1];
        
       }
    else {
      cell.bkLabel.backgroundColor = [UIColor colorWithRed:(92/255.0) green:(203/255.0) blue:(255/255.0) alpha:1];
      cell.prix.textColor = [UIColor colorWithRed:(92/255.0) green:(203/255.0) blue:(255/255.0) alpha:1];
      }
    
    
    cell.titleLabel.text = [NSString stringWithFormat:@"Carburant : %@",[[readlst objectAtIndex:indexPath.row] objectForKey:@"EnergieLibelle"]];
    
    cell.subtitleLabel.text = [NSString stringWithFormat:@"Année : %@",[[readlst objectAtIndex:indexPath.row] objectForKey:@"Annee"]];
    cell.ssId.text = [NSString stringWithFormat:@"Kilometrage : %@",[[readlst objectAtIndex:indexPath.row] objectForKey:@"Kilometrage"]];
    
    NSString *nbp = [[readlst objectAtIndex:indexPath.row] objectForKey:@"Photos"];
    NSArray *myArray = [nbp componentsSeparatedByString:@"|"];

    
    //NSLog(@"%@",[[readlst objectAtIndex:indexPath.row] objectForKey:@"IdentifiantVehicule"]);
    
    cell.image.image = [self loadImage:[myArray objectAtIndex:0] ofType:@"jpg" inDirectory:documentsDirectoryPath];
    cell.idVehicule = [[readlst objectAtIndex:indexPath.row] objectForKey:@"IdentifiantVehicule"];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:favorislst
                                                     forKeys:[favorislst valueForKey:@"IdentifiantVehicule"]];
    NSArray *produitsSectionTitles = [[dict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    int myIndex = -1;
    
    if(favorislst.count)myIndex = [produitsSectionTitles indexOfObject: [[readlst objectAtIndex:indexPath.row] objectForKey:@"IdentifiantVehicule"]];

    
    NSLog(@"%d",myIndex);
    cell.idFav = myIndex;
    
    if (myIndex >= 0 ){
      cell.favImg.hidden = NO;
      [cell setRightUtilityButtons:[self DelButtons] WithButtonWidth:90.0f];
      }
    else {
      cell.favImg.hidden = YES;
      [cell setRightUtilityButtons:[self AddButtons] WithButtonWidth:90.0f];
        
      }
    
    cell.delegate = self;
    
    cell.tag = indexPath.row;
    
    //cell.catTitle.text =  [NSString stringWithFormat:@"indrow %d",indexPath.row];
    
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Fin...");
    NSArray *visibleCells = [self.tableView visibleCells];
    int ii=0;
    int ctag=0;
    for (JBParallaxCell *cell in visibleCells) {
        if(ii==0){
            NSLog(@"tag = %ld  nb = %lu",(long)cell.tag,(unsigned long)[visibleCells count]);
            ctag = cell.tag;
        }
        ii++;
    }
    
    
    poscollapse=ctag ;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:ctag inSection:0];
    [self.tableView beginUpdates];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:path, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    //18 pour 7
    
    NSArray *visibleCells = [self.tableView visibleCells];

    for (JBParallaxCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
        cell.catTitle.textColor = [UIColor whiteColor];
    }
     //poscollapse=0 ;
}

- (IBAction)affPrix:(id)sender{
    
    if(isPrix==0)isPrix=1;
    else isPrix=0;
    
    NSIndexPath *path = [_tableView indexPathForSelectedRow];
    
    //NSIndexPath *path = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    [self.tableView reloadData];
    /*[self.tableView beginUpdates];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:path, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];*/

}

- (void)getData{
    
    
    
    readlst     = [connect getAllFile :@"vehicule"];
    initial     = [connect getAllFile :@"vehicule"];
    //marquelst   = [connect getListOf  :@"marque" :readlst];
    //energielst  = [connect getListOf  :@"EnergieLibelle" :readlst];

    
    [self.tableView reloadData];
    [mappDelegate unLoader];


    _nbChoix.text = [NSString stringWithFormat:@"%d véhicules selectionnés",[readlst count] ];
    
    
    
    
    
}



// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    poscollapse=100000 ;
    [tableView reloadData];
    static NSString *CellIdentifier = @"parallaxCell";
    JBParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    for(int i=0;i<[[tableView visibleCells] count];i++){
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:i inSection:0] ;
        cell = (JBParallaxCell *)[tableView cellForRowAtIndexPath:myIP];
        cell.catTitle.textColor = [UIColor whiteColor];
    }
    cell = (JBParallaxCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.catTitle.textColor = [UIColor yellowColor];
    
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:indexPath.row inSection:0] ;

   /* [tableView scrollToRowAtIndexPath:myIP
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];*/
    
    poscollapse=indexPath.row ;

    isSel =1;
    [tableView reloadData];
    
    //
    if(oldpos == indexPath.row){
        detailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProdViewController"];
        dvc.mdata = [readlst objectAtIndex:indexPath.row];
        // dvc.sId =[[readlst objectAtIndex:indexPath.row] objectForKey:@"_id"];
        [self.navigationController pushViewController:   dvc animated:YES];
        dvc = nil;
    }


    oldpos = indexPath.row;
    
    
    
    

    
    
    
}


- (IBAction)afftous:(id)sender {
  self.theSearchBar.text=@"";
    
    
 [self getData];
    
}

- (IBAction)delSelection:(id)sender{
 favorislst = [[NSMutableArray alloc] init];
 self.btRight.badgeValue=[NSString stringWithFormat:@"%d",[favorislst count] ];   
 [self.tableView reloadData];
    
}


- (IBAction)pra:(id)sender {

    readlst     = [connect getListSorted :@"vehicule" :readlst :@"PrixVenteTTC" :YES];
    [self.tableView reloadData];
}

- (IBAction)prd:(id)sender {
    
    readlst     = [connect getListSorted :@"vehicule" :readlst :@"PrixVenteTTC" :NO];
    [self.tableView reloadData];
}

- (IBAction)aana:(id)sender {
    
    readlst     = [connect getListSorted :@"vehicule" :readlst :@"Annee" :NO];
    [self.tableView reloadData];
}

- (IBAction)aand:(id)sender {
    
    readlst     = [connect getListSorted :@"vehicule" :readlst :@"Annee" :YES];
    [self.tableView reloadData];
}

- (IBAction)kma:(id)sender {
    
    readlst     = [connect getListSorted :@"vehicule" :readlst :@"Kilometrage" :NO];
    [self.tableView reloadData];
}

- (IBAction)kmd:(id)sender {
    
    //readlst     = [connect getListSorted :@"vehicule" :readlst :@"Kilometrage" :YES];
    readlst     = [connect getListText :@"vehicule" :readlst :@"C4"];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"selectionview"])
    {
        // Get reference to the destination view controller
        selectionViewController *vc = [segue destinationViewController];
        
        
        vc.mdata = favorislst;
        vc.cdata = readlst;
        // Pass any objects to the view controller here, like...
    }
}


- (IBAction)affSelection:(id)sender{
    
    [self performSegueWithIdentifier:@"selectionview" sender:self];
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    

    
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:YES];
            NSIndexPath *path = [NSIndexPath indexPathForRow:cell.tag inSection:0];
            JBParallaxCell *cell2  = (JBParallaxCell *)[self.tableView cellForRowAtIndexPath:path];
            NSLog(@"%d->%@",cell2.tag,cell2.idVehicule);
            if(cell2.idFav>=0){
              [favorislst removeObjectAtIndex:cell2.idFav];
              }
            else{
              //[favorislst addObject:cell2.idVehicule];
              [favorislst addObject:[readlst objectAtIndex:cell2.tag]];
                
              }
            /*[self.tableView reloadData];*/
            [self.tableView beginUpdates];
             NSArray *indexPaths = [[NSArray alloc] initWithObjects:path, nil];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            


            
             self.btRight.badgeValue=[NSString stringWithFormat:@"%d",[favorislst count] ];


            break;
        }
                default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


@end
