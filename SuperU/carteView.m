//
//  planbMapView.m
//  Bahiana
//
//  Created by antony on 14/01/13.
//  Copyright (c) 2013 antony. All rights reserved.
//

#import "carteView.h"
#import "GlobalV.h"

@interface carteView (){
    CLLocationCoordinate2D coordinateArray[2];
    MKPointAnnotation *annotationPoint;
    int iNb;
}

@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view
@end

@implementation carteView



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [loader    hideme];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Y aller" style:UIBarButtonItemStylePlain target:self action:@selector(goDir)];
    
    self.navigationItem.rightBarButtonItem = nextButton;

    
    
    iNb = 0;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    _indic.hidden =true;
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
    userLocation.location.coordinate;
    
    if(iNb++ ==0){
        
        
        
        coordinateArray[1] = userLocation.location.coordinate;
        NSString* saddr = [NSString stringWithFormat:@"%f,%f", maplatitude, maplongitude];
        NSString* daddr = [NSString stringWithFormat:@"%f,%f", coordinateArray[1].latitude, coordinateArray[1].longitude];
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        //NSLog(@"%@",url);
        
        [request setHTTPMethod:@"POST"];
        //[request setHTTPBody:data];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
        
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        //NSString *response = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"points:\\\"([^\\\"]*)\\\""
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
        if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            [self affCarte:nil];
            // ERROR
        }
        else {
            
            NSString *encodedPoints = [result substringWithRange:rangeOfFirstMatch];
            NSArray *points = [self decodePolyLine:[encodedPoints mutableCopy]];
            
            MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [points count]);
            for(int idx = 0; idx < [points count]; idx++)
            {
                CLLocationCoordinate2D workingCoordinate;
                CLLocation *loc = [points objectAtIndex:idx];
                
                workingCoordinate.latitude =loc.coordinate.latitude;
                workingCoordinate.longitude=loc.coordinate.longitude;
                MKMapPoint point = MKMapPointForCoordinate(workingCoordinate);
                pointArr[idx] = point;
            }
            // create the polyline based on the array of points.
            self.routeLine = [MKPolyline polylineWithPoints:pointArr count:[points count]];
            [_mapView addOverlay:self.routeLine];
            
            
            //self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
            [_mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
            //[_mapView addOverlay:self.routeLine];
            //_indic.hidden =true;
        }
    }
    
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,250,250);
    annotationView.selected =YES;
    [mv setRegion:region animated:YES];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine)
    {
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
            
        }
        
        return self.routeLineView;
    }
    
    
    return nil;
}



- (NSArray *)decodePolyLine:(NSMutableString *)encoded {
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0, [encoded length])];
    [encoded replaceOccurrencesOfString:@"points:\"" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [encoded length])];
    
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *listCoordinates = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len - 1) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [listCoordinates addObject:loc];
    }
    
    return [NSArray arrayWithArray:listCoordinates];
}

- (IBAction)affIti:(id)sender{
    iNb =0;
    _btCarte.enabled =YES;
    _btIti.enabled =NO;
    _indic.hidden =false;
    _mapView.showsUserLocation = YES;
    
    
}
- (IBAction)affCarte:(id)sender{
    _btCarte.enabled =NO;
    _btIti.enabled =YES;
    _indic.hidden =true;
    _mapView.showsUserLocation = NO;
    [_mapView removeOverlay:self.routeLine];
    
    _mapView.centerCoordinate = annotationPoint.coordinate;
    _mapView.delegate =self;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([annotationPoint coordinate] ,250,250);
    [_mapView setRegion:region animated:YES];
}



- (void)goDir{
    // Create an MKMapItem to pass to the Maps app
    CLLocationCoordinate2D coordinate =
    CLLocationCoordinate2DMake(maplatitude, maplongitude);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:maptitle];
    // Pass the map item to the Maps app
    [mapItem openInMapsWithLaunchOptions:nil];
}
@end
