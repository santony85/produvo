//
//  apiconnect.h
//  template
//
//  Created by 2B on 12/06/2014.
//  Copyright (c) 2014 antony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface apiconnect : NSObject

-(NSMutableArray *)getAll :(NSString *)collection;//replace Global
-(NSMutableArray *)getUnit:(NSString *)collection :(NSString *)idp ;//replace Global
-(NSMutableArray *)getList:(NSString *)collection :(int)idp ;//replace Global
-(NSMutableArray *)getSpec:(NSString *)collection :(NSString *)idname :(NSString *)idp ;//replace Global
-(NSMutableArray *)getSpecIdc:(NSString *)collection :(NSString *)idname :(NSString *)idp ;
-(NSMutableArray *)getSpecDate:(NSString *)collection :(int)idname :(NSString *)idp;
-(NSMutableArray *)getSpecDateParam:(NSString *)collection :(int)idname :(NSString *)idp :(NSString *)champ :(NSString *)val ;




-(NSString *)postUnit :(NSString *)collection :(NSDictionary *)data;
-(NSString *)setLocation:(NSString *)token  :(CLLocation *)Location;//replace Global
-(NSString *)updateLocation:(NSString *)token  :(CLLocation *)Location;//replace Global

-(int)setAction  :(NSString *)token  :(NSString *)Action :(float)time;//replace Global
-(int)setStat    :(NSString *)token  :(NSString *)Action :(NSString *)idp;//replace Global

@end
