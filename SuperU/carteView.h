//
//  planbMapView.h
//  Bahiana
//
//  Created by antony on 14/01/13.
//  Copyright (c) 2013 antony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface carteView : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView       *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btIti;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btCarte;

- (IBAction)affIti:(id)sender;
- (IBAction)affCarte:(id)sender;
//- (IBAction)affRetour:(id)sender;
//- (IBAction)goDir:(id)sender;

//@property (strong, nonatomic) IBOutlet UINavigationBar               *NavBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indic;




@end
