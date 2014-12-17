//
//  DetailProdViewController.m
//  SuperU
//
//  Created by 2B on 22/08/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "DetailProdViewController.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "GlobalV.h"
#import "KxMenu.h"
#import "NSFavoris.h"

@interface DetailProdViewController (){
        int isFav;
}

@end

@implementation DetailProdViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view, typically from a nib.
    [_ico1 setFont:[UIFont fontWithName:@"share" size:16]];
    [_ico2 setFont:[UIFont fontWithName:@"share" size:16]];
    [_ico3 setFont:[UIFont fontWithName:@"share" size:16]];
    NSString *rawStr = [NSString stringWithFormat:@"http://www.planb-apps.com/elements/%d/promosu/%@.jpg",idClientG,_sId];
    NSURL * imageURL = [NSURL URLWithString:rawStr];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    _img.image = image;
    
    
    dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
    NSMutableArray *readlst = [[NSMutableArray alloc] init];
    readlst = [sqlManager findFavoris :_sId];
    NSLog(@"%@",readlst);
    if([readlst count]>0){
        NSFavoris *favoris = [[NSFavoris alloc] init];
        favoris = [readlst objectAtIndex:0];
        isFav   = [favoris.idFav intValue];
    }
    else isFav =0;
    
    
    apiconnect *connect = [[apiconnect alloc] init];
    int res= [connect setStat:tokenAsString :@"produits" :_sId];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)affRetour:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self.view removeFromSuperview];
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}


-(UIImage *)resImg:(NSString *)Nom{
    
    UIImage *image = [UIImage imageNamed:Nom];
    UIImage *tempImage = nil;
    
    CGSize targetSize = CGSizeMake(30,30);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tempImage;
}
//[self resImg:@"sms.png"]


- (IBAction)affShareMenu:(UIButton *)sender{
    
    NSMutableArray *menuItems2= [[NSMutableArray alloc] init];
    KxMenuItem *mn;
    
    if(isFav>0){
        mn =[KxMenuItem menuItem:@"  Supprimer des Favoris"
                           image:[UIImage imageNamed:@"Icon16-Small.png"]
                          target:self
                          action:@selector(delFav:)];
    }
    else{
        mn =[KxMenuItem menuItem:@"  Ajoutez aux Favoris"
                           image:[UIImage imageNamed:@"Icon16-Small.png"]
                          target:self
                          action:@selector(addFavoris:)];
    }
    
    [menuItems2 addObject:mn];
    
    mn =[KxMenuItem menuItem:@"  Partagez par Email"
                   image:[UIImage imageNamed:@"Icon14-Small.png"]
                  target:self
                  action:@selector(btnEmail_Clicked:)];
    [menuItems2 addObject:mn];
    
    mn = [KxMenuItem menuItem:@"  Partagez par Sms"
                   image:[UIImage imageNamed:@"Icon15-Small.png"]
                  target:self
                  action:@selector(btnMessage_Clicked:)];
    [menuItems2 addObject:mn];
    
    
    
    
    /*NSArray *menuItems =
    @[
     [KxMenuItem menuItem:@"  Ajoutez aux favoris"
                     image:[UIImage imageNamed:@"Favorite.png"]
                    target:self
                    action:@selector(addFavoris:)],
      
      [KxMenuItem menuItem:@"  Partagez par Email"
                     image:[UIImage imageNamed:@"Mail.png"]
                    target:self
                    action:@selector(btnEmail_Clicked:)],
      
      [KxMenuItem menuItem:@"  Partagez par Sms"
                     image:[UIImage imageNamed:@"sms.png"]
                    target:self
                    action:@selector(btnMessage_Clicked:)],
     
      ];*/

    [KxMenu showMenuInView:self.view
                fromRect:sender.frame
                 menuItems:menuItems2];
    
}
- (IBAction)addFavoris:(id)sender {
    dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
    int idFav = [sqlManager saveData:_sId];
    isFav = idFav;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"isNewPromo"];
}

- (IBAction)delFav:(id)sender {
    dataBase *sqlManager = [[dataBase alloc] initDatabase:0];
    [sqlManager delData :isFav];
    isFav = 0;
}


- (void)btnEmail_Clicked:(id)sender
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[NSArray arrayWithObject:@""]];
    [controller setSubject:@"Mes Promos U"];
    [controller setMessageBody:@"Bonjour, j'utilise l'application Mes Promos HYPER U Luçon. Faites comme moi, téléchargez la sur votre mobile !" isHTML:NO];
    [self presentModalViewController:controller animated:YES];
    //[self actionAnimBack:[sender tag] :1];
    
}

- (void)btnMessage_Clicked:(id)sender{
    NSString *t1 = @"";
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Bonjour, j'utilise l'application Mes Promos HYPER U Luçon. Faites comme moi, téléchargez la sur votre mobile !";
        controller.recipients = [NSArray arrayWithObjects:t1, nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
    //[self actionAnimBack:[sender tag] :1];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            NSLog(@"Send");
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}



@end
