//
//  apiconnect.m
//  template
//
//  Created by 2B on 12/06/2014.
//  Copyright (c) 2014 antony. All rights reserved.
//

#import "apiconnect.h"
#import "GlobalV.h"
#import "NSString+URLEncoding.h"

@implementation apiconnect

-(void)afficherAlertReseau{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Attention"
                                                    message: @"Connection au réseau impossible!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(NSMutableArray *)getAll :(NSString *)collection{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/all/%@",collection];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
     NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){result = list;}
    }
    else [self afficherAlertReseau];
    
  return result;
}

-(NSMutableArray *)getUnit:(NSString *)collection :(NSString *)idp {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/unit/%@/%@",collection,idp];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){result = list;}
    }
    else [self afficherAlertReseau];
    
    return result;

}

-(NSMutableArray *)getList:(NSString *)collection :(int)idp {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/list/%@/%d",collection,idp];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){result = list;}
    }
    else [self afficherAlertReseau];
    
    return result;

}

-(NSMutableArray *)getSpec:(NSString *)collection :(NSString *)idname :(NSString *)idp  {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/spec/%@/%@/%@",collection,idname,idp];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){result = list;}
    }
    else [self afficherAlertReseau];
    
    return result;
    
}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}


-(NSMutableArray *)getSpecIdc:(NSString *)collection :(NSString *)idname :(NSString *)idp  {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    
    NSString *encodedString = [NSString stringWithFormat:@"%@",[idp urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@",encodedString);

    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/specidc/%@/%d/%@/%@",collection,idClientG,idname,encodedString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){result = list;}
    }
    else [self afficherAlertReseau];
    
    return result;
    
}

-(NSMutableArray *)getSpecDate:(NSString *)collection :(int)idname :(NSString *)idp  {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/listdateinf/%@/%d/%@",collection,idClientG,idp];
    
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){result = list;}
    }
    else [self afficherAlertReseau];
    
    return result;
    
}


-(NSString *)postUnit :(NSString *)collection :(NSDictionary *)data{
  NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/unit/%@",collection];
  NSMutableString *urlWithQuerystring = [[NSMutableString alloc] init];
    for (id key in data) {
        NSString *keyString = [key description];
        NSString *valueString = [[data objectForKey:key] description];
        [urlWithQuerystring appendFormat:@"&%@=%@", keyString, valueString];
    }
    [urlWithQuerystring appendFormat:@"&idclient=%d", idClientG];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[urlWithQuerystring dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"%@",urlWithQuerystring);
    
    
    NSString *yourStr= [[NSString alloc] initWithData:returnData
                                             encoding:NSUTF8StringEncoding];
    
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        return @"0";
    }
    else {
        //success
         return yourStr;
    }

    

    return 0;
}

-(int)setAction  :(NSString *)token  :(NSString *)Action :(float)time{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentTime];
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/unit/ios_action/"];
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] init];
    
    [urlWithQuerystring appendFormat:@"&idclient=%d", idClientG];
    [urlWithQuerystring appendFormat:@"&devicetoken=%@", token];
    [urlWithQuerystring appendFormat:@"&action=%@", Action];
    [urlWithQuerystring appendFormat:@"&temps=%f", time];
    [urlWithQuerystring appendFormat:@"&date=%@", dateInStringFormated];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[urlWithQuerystring dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:&error];
    
    
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        return 0;
      }
    else {
        //success
        return 1;
    }
    
    
    NSLog(@"%@",urlWithQuerystring);
    
    return 0;
    
}

-(NSString *)setLocation:(NSString *)token  :(CLLocation *)Location{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentTime];
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/unit/ios_location/"];
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] init];

    [urlWithQuerystring appendFormat:@"&idclient=%d", idClientG];
    [urlWithQuerystring appendFormat:@"&devicetoken=%@", token];
    [urlWithQuerystring appendFormat:@"&lat=%f", Location.coordinate.latitude];
    [urlWithQuerystring appendFormat:@"&lng=%f", Location.coordinate.longitude];
    [urlWithQuerystring appendFormat:@"&date=%@", dateInStringFormated];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[urlWithQuerystring dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response error:&error];
    NSString *yourStr= [[NSString alloc] initWithData:returnData
                                              encoding:NSUTF8StringEncoding];


    
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        return @"0";
    }
    else {
        //success
        return yourStr;
    }
    
    
    NSLog(@"%@",urlWithQuerystring);
    
    return 0;
    
}

-(NSString *)updateLocation:(NSString *)token  :(CLLocation *)Location{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentTime];
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/loc/ios_location/%@",token];
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] init];
    
    [urlWithQuerystring appendFormat:@"&idclient=%d", idClientG];
    [urlWithQuerystring appendFormat:@"&devicetoken=%@", tokenAsString];
    [urlWithQuerystring appendFormat:@"&lat=%f", Location.coordinate.latitude];
    [urlWithQuerystring appendFormat:@"&lng=%f", Location.coordinate.longitude];
    [urlWithQuerystring appendFormat:@"&date=%@", dateInStringFormated];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"PUT"];
    [request setHTTPBody:[urlWithQuerystring dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSLog(@"%@", urlWithQuerystring);
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response error:&error];
    NSString *yourStr= [[NSString alloc] initWithData:returnData
                                             encoding:NSUTF8StringEncoding];
    
    
    
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        return @"0";
    }
    else {
        //success
        return yourStr;
    }
    
    
    NSLog(@"%@",urlWithQuerystring);
    
    return 0;
    
}

-(int)setStat    :(NSString *)token  :(NSString *)Action :(NSString *)idp{
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentTime];
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/unit/ios_stats/"];
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] init];
    
    [urlWithQuerystring appendFormat:@"&idclient=%d", idClientG];
    [urlWithQuerystring appendFormat:@"&devicetoken=%@", token];
    [urlWithQuerystring appendFormat:@"&action=%@", Action];
    [urlWithQuerystring appendFormat:@"&id=%@", idp];
    [urlWithQuerystring appendFormat:@"&date=%@", dateInStringFormated];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[urlWithQuerystring dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        return 0;
    }
    else {
        //success
        return 1;
    }
    
    
    NSLog(@"%@",urlWithQuerystring);
    
    return 0;
    
}


-(NSMutableArray *)getSpecDateParam:(NSString *)collection :(int)idname :(NSString *)idp :(NSString *)champ :(NSString *)val  {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    
    val = [val stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/listdateinfparam/%@/%d/%@/%@/%@",collection,idClientG,idp,champ,val];
    
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){result = list;}
    }
    else [self afficherAlertReseau];
    
    return result;
    
}




@end
