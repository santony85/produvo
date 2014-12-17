//
//  contactViewController.h
//  HyperU
//
//  Created by 2B on 04/09/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface contactViewController : UIViewController<MFMailComposeViewControllerDelegate,MKMapViewDelegate>

- (IBAction)tel:(id)sender;
- (IBAction)mail:(id)sender;
- (IBAction)affME:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *message;
@property (weak, nonatomic)   IBOutlet UIButton *btTel;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIView *actionView;

@property (strong, nonatomic) IBOutlet MKMapView       *mapView;


@end
