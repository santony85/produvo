//
//  planbAnalitycs.h
//  planbapp
//
//  Created by 2B on 20/06/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface planbAnalitycs : NSObject

-(void)setLocation:(NSString *)token  :(CLLocation *)Location;//replace Global
-(void)setAction:(NSString *)token    :(NSString *)Action  :(float)time;//replace Global
-(NSMutableArray *)getList:(NSString *)collection :(NSString *)idName :(int)idp :(int)ord;//replace Global
-(void)sndByMail :(NSDictionary *)data;
-(NSString *)setCollection:(NSString *)collection :(NSDictionary *)data;
-(NSMutableArray *)getCollection:(NSString *)collection :(NSDictionary *)data;

@end
