//
//  planbAnalitycs.m
//  planbapp
//
//  Created by 2B on 20/06/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import "planbAnalitycs.h"
#import "GlobalV.h"

@implementation planbAnalitycs

//*********************************************************************
//*********************************************************************
//*********************************************************************
-(void)setLocation:(NSString *)token :(CLLocation *)Location {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNet"];
    if(myInt==1){
        
    
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
        NSString *dateInStringFormated = [dateFormatter stringFromDate:currentTime];
        
        NSString *host = @"www.planb-apps.com";
        NSString *urlString = [NSString stringWithFormat:@"/apnsm.php?task=%@&token=%@&lat=%.12f&lng=%.12f&idClient=%d&date=%@",@"location",token,Location.coordinate.latitude,Location.coordinate.longitude,idClientG,dateInStringFormated];
        NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        }

}
//*********************************************************************
//*********************************************************************
//*********************************************************************
-(void)setAction:(NSString *)token :(NSString *)Action :(float)time {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNet"];
    if(myInt==1){
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentTime];
    
    NSString *host = @"www.planb-apps.com";
    NSString *urlString = [NSString stringWithFormat:@"/apnsm.php?task=%@&token=%@&action=%@&idClient=%d&date=%@&temps=%f",@"action",tokenAsString,Action,idClientG,dateInStringFormated,time];
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    }
}
//*********************************************************************
//*********************************************************************
//*********************************************************************
-(NSMutableArray *)getList:(NSString *)collection :(NSString *)idName :(int)idp :(int)ord{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNet"];
    if(myInt==1){
    NSString *host = @"www.planb-apps.com";
    NSString *urlString = [NSString stringWithFormat:@"/appspages.php?task=getcollection&collection=%@&idp=%d&idname=%@&ord=%d",collection,idp,idName,ord];
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@",url);
    NSError *error;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        temp = [list objectForKey:@"list"];
        return temp;
        }
    else return nil;
    }
    return nil;//
    }
//*********************************************************************
//*********************************************************************
//*********************************************************************
-(NSString *)setCollection:(NSString *)collection :(NSDictionary *)data{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNet"];
    if(myInt==1){
    NSString *urlString = [NSString stringWithFormat:@"task=setcollection&collection=%@",collection];
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    for (id key in data) {
        NSString *keyString = [key description];
       // NSString *valueString = [[data objectForKey:key] description];
        NSString *valueString = [[[data objectForKey:key] description] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [urlWithQuerystring appendFormat:@"&%@=%@", keyString, valueString];
    }
        
        
    NSData *gdata = [urlWithQuerystring dataUsingEncoding:NSISOLatin1StringEncoding];
    NSString *host = @"http://www.planb-apps.com/appspages.php";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",host]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"%@",url);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:gdata];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
        
       // NSLog(@"%@",result);
    NSDictionary *list =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
    NSMutableArray *temp = [list objectForKey:@"ok"];
    return [NSString stringWithFormat:@"%@",[list objectForKey:@"ok"]];
        }
    return nil;//
}
//*********************************************************************
//*********************************************************************
//*********************************************************************
-(void)sndByMail :(NSDictionary *)data{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNet"];
    if(myInt==1){
    NSString *urlString = @"task=sndmail";
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    for (id key in data) {
        NSString *keyString = [key description];
        NSString *valueString = [[data objectForKey:key] description];
        [urlWithQuerystring appendFormat:@"&%@=%@", keyString, valueString];
    }
    NSData *gdata = [urlWithQuerystring dataUsingEncoding:NSISOLatin1StringEncoding];
    NSString *host = @"http://www.planb-apps.com/appspages.php";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",host]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:gdata];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
    //NSLog(@"%@",result);
        }
}
//*********************************************************************
//*********************************************************************
//*********************************************************************
-(NSMutableArray *)getCollection:(NSString *)collection :(NSDictionary *)data{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"isNet"];
    if(myInt==1){
    NSString *host = @"www.planb-apps.com";
    NSString *urlString = [NSString stringWithFormat:@"/appspages.php?task=getcollectionvar&collection=%@",collection];
        
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    for (id key in data) {
        NSString *keyString = [key description];
        NSString *valueString = [[data objectForKey:key] description];
        [urlWithQuerystring appendFormat:@"&%@=%@", keyString, valueString];
    }
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlWithQuerystring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",url);
    NSError *error;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
    
    temp = [list objectForKey:@"list"];
    int i=0;
    if(i==0)return temp;
    i++;
   }
    return temp;
}
//*********************************************************************
//*********************************************************************
//*********************************************************************



@end
