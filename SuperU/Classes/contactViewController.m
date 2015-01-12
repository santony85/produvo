//
//  contactViewController.m
//  HyperU
//
//  Created by 2B on 04/09/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "contactViewController.h"
#import "GlobalV.h"



@interface contactViewController (){
    NSString *sTel;
    NSString *sMel;
    NSString *sFax;
    
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
   // self.navigationController.navigationBar.hidden = YES;
    //[self setTabBarVisible:YES animated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    //[self setTabBarVisible:YES animated:NO];
    
    
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    NSDictionary *readlst = [prefs objectForKey:@"vendeurlst"];
    NSLog(@"%@",readlst);
    
    NSString *txt = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@",[readlst  objectForKey:@"nom"],[readlst  objectForKey:@"adresse"],[readlst  objectForKey:@"email"],[readlst  objectForKey:@"tel"],[readlst  objectForKey:@"tel"]  ];
    NSLog(@"%@",txt);
    message.text = txt;
    sTel = [[readlst  objectForKey:@"tel"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    sMel = [readlst  objectForKey:@"email"];
    sFax = [[readlst  objectForKey:@"fax"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tel:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", sTel]]];
    
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
	
	[picker setSubject:[NSString stringWithFormat:@"contact appli Pro-Du-Vo"]];//appliNom
    
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:sMel]; //contact@canberra-olona.fr
    
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




@end
