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


    
    poscollapse =0;
    isSel  = 0;
    oldpos = 0;
    
    connect = [[newApiConnect alloc] init];
    
    favorislst = [[NSMutableArray alloc] init];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [mappDelegate unHideLoader];
    self.useCustomCells = NO;
    isLstFav =0;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Retour"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
  [self.navigationItem setBackBarButtonItem: backButton];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bkbar.png"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //[self.theSearchBar becomeFirstResponder];
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
    [self getData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[loader    hideme];
    //[self.theSearchBar resignFirstResponder];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNewPromo"];
    if(myInt==0){
        [mappDelegate unHideLoader];
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

    if(indexPath.row==poscollapse)return 130;
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
    
    cell.prix.text = [NSString stringWithFormat:@"Prix : %@ €",[[readlst objectAtIndex:indexPath.row] objectForKey:@"PrixVenteTTC"]];
    
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

    
    cell.image.image = [self loadImage:[myArray objectAtIndex:0] ofType:@"jpg" inDirectory:documentsDirectoryPath];
    
    
    /*if([idFav count]>0){
        NSFavoris *favoris = [[NSFavoris alloc] init];
        favoris = [idFav objectAtIndex:0];
        cell.favImg.hidden = NO;
        [cell setRightUtilityButtons:[self DelButtons] WithButtonWidth:90.0f];
        cell.tag = 1;
        cell.idFav = [favoris.idFav  intValue];
        cell.idFav2 = 1;
        
    }
    else {*/
        [cell setRightUtilityButtons:[self AddButtons] WithButtonWidth:90.0f];
    //}

    
    cell.delegate = self;
    
    cell.tag = indexPath.row;
    return cell;
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];

    for (JBParallaxCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
        cell.catTitle.textColor = [UIColor whiteColor];
    }
    
     poscollapse=0 ;
    /*if(isSel==1){
        poscollapse=0;
        [self.tableView reloadData];
    }
    
    isSel =0;*/
    
}


- (void)getData{
    
    
    
    readlst     = [connect getAllFile :@"vehicule"];
    initial     = [connect getAllFile :@"vehicule"];
    marquelst   = [connect getListOf  :@"marque" :readlst];
    energielst  = [connect getListOf  :@"EnergieLibelle" :readlst];

    
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



- (IBAction)SelectCategorie:(UIButton *)sender {
    //_btRecherche.enabled = NO;
    CGRect frame = sender.frame;
    //frame.origin.x=25;
    frame.origin.y=frame.origin.y+30;
    //frame.size.height=100;
    //frame.size.width=140;
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems2];
}

-(void)listFavoris{
    //prendre tout les fav
    dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
    self.favArray = [[NSMutableArray alloc] init];
    self.favArray = [sqlManager findAllFavoris];
    readlst  = [[NSMutableArray alloc] init];
    for(int i=0;i<[self.favArray count];i++)
    {
        
        NSFavoris *favoris = [[NSFavoris alloc] init];
        favoris = [self.favArray objectAtIndex:i];
        int number = [favoris.idFav intValue];
     
 
     
        apiconnect *connect = [[apiconnect alloc] init];
        NSMutableArray* tmp = [connect getUnit :@"promosu"    :favoris.idProd];
     
        NSLog(@"%@",tmp);
     
        if([tmp count]>0)[readlst addObject:tmp];
        else [sqlManager delData :number];
    }
    

    
    [self.tableView reloadData];
    
}

- (IBAction)afftous:(id)sender {
  self.theSearchBar.text=@"";
    
    
 [self getData];
    
}

- (IBAction)changeTypeAff:(id)sender {
    if(isLstFav ==0){
      isLstFav =1;
        tmplst = readlst;
      [self listFavoris];
      [_button setImage:[UIImage imageNamed:@"bullet4.png"] forState:UIControlStateNormal];
      }
    else {
      //[mappDelegate unHideLoader];
      readlst = tmplst;
      isLstFav =0;
      [_button setImage:[UIImage imageNamed:@"favorites3.png"] forState:UIControlStateNormal];
      [self.tableView reloadData];
      
      //[self getData];
      }
  
    
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
    
    NSLog(@"%d",index);
    
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            /*NSIndexPath *path = [NSIndexPath indexPathForRow:cell.tag inSection:0];
            JBParallaxCell *cell2  = (JBParallaxCell *)[self.tableView cellForRowAtIndexPath:path];
            if(cell2.idFav2==1){
              dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
              [sqlManager delData :cell2.idFav];
              }
            else {
              dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
              int idFav = [sqlManager saveData:cell2.bkLabel.text];
              }
            

            
            [cell hideUtilityButtonsAnimated:YES];
            
            [self.tableView reloadData];
            
            [self.tableView beginUpdates];
             NSArray *indexPaths = [[NSArray alloc] initWithObjects:path, nil];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];*/


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
