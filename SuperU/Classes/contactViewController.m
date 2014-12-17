//
//  contactViewController.m
//  HyperU
//
//  Created by 2B on 04/09/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "contactViewController.h"
#import "GlobalV.h"
#import "ViewControllerME.h"


@interface contactViewController (){
    CLLocationCoordinate2D coordinateArray[2];
    MKPointAnnotation *annotationPoint;
    int iNb;
}


@end

@implementation contactViewController

@synthesize message;


- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    //if ([self tabBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height-50;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.0 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}


-(void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //[self setTabBarVisible:YES animated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    //[self setTabBarVisible:YES animated:NO];
    
    self.locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //[self.locationManager performSelector:@selector(requestWhenInUseAuthorization)];
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    //CGRect frame = self.btTel.frame;
    //NSLog(@"%f * %f",frame.size.width,frame.size.height);
    //frame.origin.y = frame.origin.y+20;
    //UIButton *myButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    //[myButton setTitle:[NSString stringWithFormat:@"hello"] forState:UIControlStateNormal];
    //[myButton setFrame: frame];
    [self.btTel.titleLabel setFont: [UIFont boldSystemFontOfSize:40.0]];
    self.btTel.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    //[self.btTel sizeToFit];
    self.btTel.titleLabel.minimumFontSize = 12;
    
    //[myButton setTitleColor:[UIColor blueColor]
               //        forState:UIControlStateNormal];
    //myButton.frame = CGRectInset(myButton.frame, 64, 0);
    
   // [myButton addTarget:self action:@selector(tel:) forControlEvents:UIControlEventTouchUpInside];
   // [_actionView addSubview:myButton];
    
    
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude = maplatitude;
    annotationCoord.longitude = maplongitude;
    
    annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = maptitle;
    annotationPoint.subtitle = mapsubtitle;
    [_mapView addAnnotation:annotationPoint];
    _mapView.centerCoordinate = annotationPoint.coordinate;
    _mapView.delegate =self;
    coordinateArray[0] = CLLocationCoordinate2DMake(maplatitude, maplongitude);
    
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,100500,100500);
    annotationView.selected =YES;
    [mv setRegion:region animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tel:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", @"0251560206"]]];
    
}

- (IBAction)mail:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    
    
}



- (void)viewDidUnload {
    
    [super viewDidUnload];
    

    
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:[NSString stringWithFormat:@"contact appli Hyper U Luçon"]];//appliNom
    
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:appliEmail]; //contact@canberra-olona.fr
    
	//NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
	
	[picker setToRecipients:toRecipients];
    
	//[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
	//[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    //[picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message.text = @"Result: failed";
			break;
		default:
			message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@&subject=contact appli %@",appliEmail, @"Hyper U Luçon"];
    //?cc=welcome@planbmobile.fr
    
	NSString *body = @"&body=";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
- (IBAction)affME:(id)sender{
    self.navigationController.navigationBar.hidden = NO;
    
    
    //destViewController.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:[[ViewControllerME alloc] init] animated:YES];
    
    ViewControllerME *controller = [[ViewControllerME alloc] init];
    
    // This is the line! :)
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}



@end
