//
//  dataBase.h
//  LeclercOlonne
//
//  Created by 2B on 05/12/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "/usr/include/sqlite3.h"
#import <sqlite3.h>

@interface dataBase : NSObject{
  sqlite3   *favDB;
  NSString  *databasePath;
  }
-(id)initDatabase:(int)isGet; //Constructeur

- (int) saveData :(NSString *)mid;
- (void) delData:(int)val;
- (NSMutableArray *) findAllFavoris;
- (NSMutableArray *) findFavoris :(NSString *)idProd;

- (NSMutableArray *) findAllCat;
- (int) saveDataCat :(NSString *)mid;
- (void) delDataCat;

@end
