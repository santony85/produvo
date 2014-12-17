//
//  newApiConnect.h
//  GestionBaseDeDonnees
//
//  Created by Antony on 09/12/2014.
//  Copyright (c) 2014 planb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface newApiConnect : NSObject

-(NSMutableArray *)getLogin :(NSString *)collection :(NSString *)login :(NSString *)mdp;

-(NSMutableArray *)getAll :(NSString *)collection:(int)save;//replace Global
-(NSMutableArray *)getAllFile :(NSString *)collection;//replace Global

//find
-(NSMutableArray *)getListOf :(NSString *)collection :(NSMutableArray *)catlst;
-(NSMutableArray *)FindMinMax :(NSString *)collection :(int)min :(int)max :(NSMutableArray *)catlst;
-(NSMutableArray *)getListSorted :(NSString *)collection :(NSMutableArray *)catlst :(NSString *)champ :(Boolean)asc;
-(NSMutableArray *)getListText :(NSString *)collection :(NSMutableArray *)catlst :(NSString *)champ;

@end
