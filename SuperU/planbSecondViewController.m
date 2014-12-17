//
//  planbSecondViewController.m
//  SuperU
//
//  Created by 2B on 01/07/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "planbSecondViewController.h"
#import "listepromoCell.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "GlobalV.h"
#import "KxMenu.h"
#import "NSFavoris.h"




@interface planbSecondViewController (){
    NSMutableArray *readlst;
    NSArray *catlst;
    NSMutableArray *imagesArray;

}




@end

@implementation planbSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self getData];
    
	}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getData];
    
}


- (UIColor *)colorFromHexString:(NSString *)hexString :(float)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [readlst count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listepromoCell";
    listepromoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.categorie.text = [[readlst objectAtIndex:indexPath.row] objectForKey:@"cat"];
    cell.promos.text    = [[readlst objectAtIndex:indexPath.row] objectForKey:@"titre"];
    cell.desc.text      = [[readlst objectAtIndex:indexPath.row] objectForKey:@"desc"];
    cell.prix.text      = [[readlst objectAtIndex:indexPath.row] objectForKey:@"prix"];
    cell.qte.text       = [[readlst objectAtIndex:indexPath.row] objectForKey:@"qte"];
    int val=0;
    for(int i=0;i<[catlst count];i++){
      if([[[catlst objectAtIndex:i] objectForKey:@"type"] isEqualToString:cell.categorie.text])val =i;
      }
    cell.bkLabel.backgroundColor = [self colorFromHexString :[[catlst objectAtIndex:val] objectForKey:@"couleur"] :0.7];
    cell.categorie.textColor = [self colorFromHexString :[[catlst objectAtIndex:val] objectForKey:@"couleur"] :1];
    cell.image.image= [imagesArray objectAtIndex:indexPath.row];
    
    
    return cell;
}


- (void)getData{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *convertedString = [dateFormatter stringFromDate:now];
    
    apiconnect *connect = [[apiconnect alloc] init];
    readlst = [connect getSpecDate :@"promosu"    :idClientG :convertedString];
    catlst  = [connect getList :@"catpromosu" :idClientG];
    imagesArray  = [[NSMutableArray alloc] init];
    

    

    
    
    for(int i=0;i<[readlst count];i++){
        NSString *newStr = [NSString stringWithFormat:@"%@", [[readlst objectAtIndex:i] objectForKey:@"_id"] ];
        NSString *rawStr = [NSString stringWithFormat:@"http://www.planb-apps.com/elements/%d/promosu/%@.jpg",idClientG,newStr];
        NSURL * imageURL = [NSURL URLWithString:rawStr];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [imagesArray addObject:image];
        //NSLog(@"%@",rawStr);
    }

    
    [self.tableView reloadData];
    [loader    hideme];
    
    
}





- (IBAction)SelectCategorie:(id)sender {
    
    NSMutableArray *menuItems2= [[NSMutableArray alloc] init];
    
    for(int i=0;i<[catlst count];i++){
        
        KxMenuItem *mn =[KxMenuItem menuItem:[[catlst objectAtIndex:i] objectForKey:@"type"]
                                       image:nil
                                      target:nil
                                      action:@selector(pushMenuItem:)];
        
        [menuItems2 addObject:mn];
        
        //if([[[catlst objectAtIndex:i] objectForKey:@"type"] isEqualToString:cell.categorie.text])val =i;
    }
    
    NSLog(@"%@",menuItems2);
    
    
    
    
    NSArray *menuItems =
    @[
      

      
      [KxMenuItem menuItem:@"ACTION MENU 1234456"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"Share this"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Check this menu"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Reload page"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Search"
                     image:[UIImage imageNamed:@"search_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Go home"
                     image:[UIImage imageNamed:@"home_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    //KxMenuItem *first = menuItems[0];
    //first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    //first.alignment = NSTextAlignmentCenter;
    CGRect frame;
    frame.origin.x=25;
    frame.origin.y=65;
    NSLog(@"%@",menuItems);
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems2];
    
    

}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
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
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              favoris.idProd , @"_id",
                              nil];
        planbAnalitycs *pbAna = [[planbAnalitycs alloc] init];
        NSMutableArray* tmp  = [pbAna getCollection:@"promos" :data];
        if([tmp count]>0)[self.prodArray addObject:[tmp objectAtIndex:0]];
        else [sqlManager delData :number];
    }
    
    [self.tableView reloadData];
    
}

@end
