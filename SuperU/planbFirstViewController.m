//
//  planbFirstViewController.m
//  SuperU
//
//  Created by 2B on 01/07/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "planbFirstViewController.h"
//#import "LiveFrost.h"
#import "pushcellCell.h"
#import "GlobalV.h"
#import "pubView.h"
#import "ViewControllerME.h"
//#import "AppDelegate.h"
#import "JSBadgeView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>




@interface planbFirstViewController (){
    int isUp;
    NSArray *readlst;
    int valDep;
    NSArray *welcomePhotos;
    int photoCount;
    JSBadgeView *badgeView;
   
}

@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation planbFirstViewController


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [loader    hideme];
    //[self.avplayer play];
    
    //isUp =0;
    [self closepush:nil];
    //isUp=1;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger isPub = [prefs integerForKey:@"isPub"];
    if(isPub == 1){
        [prefs setInteger:0 forKey:@"isPub"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        NSString *contentString = [[NSString alloc]
                                   initWithFormat:@"http://planb-apps.com/elements/%d/pub/pub.jpg",idClientG];
        NSURL * imageURL = [NSURL URLWithString:contentString];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        if (imageData){
            pubView *controller2 = (pubView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"pubView"];
            [self presentViewController:controller2 animated:YES completion: nil];
            
        }
    }
    


   /* NSInteger isFirst = [prefs integerForKey:@"isFirst"];
    if((isFirst==0)&&(isPub == 0)){
        [prefs setInteger:1 forKey:@"isFirst"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        ViewControllerME *controller = (ViewControllerME*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ViewControllerME"];
        [self presentViewController:controller animated:YES completion: nil];
    }*/
    

    
    /*loader = [[MyActivityOverlayViewController alloc] initWithFrame:
              CGRectMake(self.view.frame.origin.x,
                         self.view.frame.origin.y+44,
                         self.view.frame.size.width,
                         self.view.frame.size.height-180)];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:loader];
    //[self presentModalViewController:navigationController animated:YES];
    [self presentViewController:navigationController animated:YES completion: nil];
    [loader.view    setAlpha: 1.0];*/
}
-(void)transitionPhotos{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"nbPush"];

    if(myInt>0)badgeView.badgeText = [NSString stringWithFormat:@"%d", myInt];
    else badgeView.badgeText = @"";

    
    if (photoCount < [welcomePhotos count] - 1){
        photoCount ++;
    }else{
        photoCount = 0;
    }
    [UIView transitionWithView:self.imgView
                      duration:2.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ self.imgView.image = [UIImage imageNamed:[welcomePhotos objectAtIndex:photoCount]]; }
                    completion:NULL];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  

    //[self.tabBarController.view addSubview:loader.view];
    //[loader loadView];
    //[self.view insertSubview:loader.view aboveSubview:self.view];
    [loader.view    setAlpha: 1.0];
    
    
    
    photoCount = 0;
    
    
    welcomePhotos = [NSArray arrayWithObjects:@"montage-diapo1.png",@"montage-diapo2.png", nil];
    self.imgView.image = [UIImage imageNamed:[welcomePhotos objectAtIndex:0]];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(transitionPhotos) userInfo:nil repeats:YES];

    
    
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeD:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGestureU = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeU:)];
    [swipeGestureU setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeGestureU];
            //[self getDate];
    isUp=1;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    CGFloat screenWidth = screenSize.width;
    valDep =screenHeight;
    

    
    _pushView.frame = CGRectMake(0, 0, screenWidth, screenHeight-56);
    valDep =screenHeight-50;
    CGPoint target = CGPointMake(_pushView.center.x, _pushView.center.y-valDep);
    [_pushView setCenter:target];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"nbPush"];

      badgeView = [[JSBadgeView alloc] initWithParentView:_btNotif alignment:JSBadgeViewAlignmentTopLeft];
    
    if(myInt>0)badgeView.badgeText = [NSString stringWithFormat:@"%d", myInt];
    
    
    // Do any additional setup after loading the view from its nib.
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"produvo-vendeur" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:self.view.frame];
   // [self.movieView.layer addSublayer:avPlayerLayer];
    
    //Not affecting background music playing
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];

      
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeD:(UISwipeGestureRecognizer*)sender {
    if(isUp==1){
        
        isUp =0;
        [self getDate];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
        CGPoint target = CGPointMake(_pushView.center.x, _pushView.center.y+valDep);
        [_pushView setCenter:target];
    }];
    }

}
-(void)swipeU:(UISwipeGestureRecognizer*)sender {
    if(isUp==0){
        isUp =1;
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint target = CGPointMake(_pushView.center.x, _pushView.center.y-valDep);
        [_pushView setCenter:target];
    }];
    
        }
    
}

- (void)getDate{
    //NSString *idclient = [NSString stringWithFormat:@"%d",idClientG];
    NSString *idclient = @"68";
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"delivered" , @"state",
                          idclient,@"idclient",
                          nil];
    apiconnect *connect = [[apiconnect alloc] init];
    readlst = [connect getSpecIdc :@"messagePush" :@"state" :@"delivered"];
    [loader    hideme];
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [readlst count];
}

-(NSString *)convertDate :(NSString *)datein{
    
    if([datein length]==0)return @"";
    NSArray *substrings = [datein componentsSeparatedByString:@"-"];
    NSString *first = [NSString stringWithFormat: @"%@-%@-%@", [substrings objectAtIndex:2], [substrings objectAtIndex:1],[substrings objectAtIndex:0]];
    
    return first;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PushCell";
    pushcellCell *cell = (pushcellCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[pushcellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.dateLabel.text = [self convertDate:[[readlst objectAtIndex:indexPath.row] objectForKey:@"dateenvoi"]];
    cell.textLabel.text = [[readlst objectAtIndex:indexPath.row] objectForKey:@"message"];
    return cell;
    
    
}

- (IBAction)affPush:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"nbPush"];
    badgeView.badgeText = @"";
    if(isUp==1){
        
        isUp =0;
        [self getDate];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint target = CGPointMake(_pushView.center.x, _pushView.center.y+valDep-30);
            [_pushView setCenter:target];
        }];
    }

}

- (IBAction)closepush:(id)sender {
    
   
    
    if(isUp==0){
        isUp =1;
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint target = CGPointMake(_pushView.center.x, _pushView.center.y-valDep);
            [_pushView setCenter:target];
        }];
        
    }

}
@end
