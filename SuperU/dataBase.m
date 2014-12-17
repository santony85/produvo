//
//  dataBase.m
//  LeclercOlonne
//
//  Created by 2B on 05/12/13.
//  Copyright (c) 2013 2B. All rights reserved.
//

#import "dataBase.h"
#import "NSFavoris.h"

@implementation dataBase{
    NSMutableArray *sqliteData;
}


-(id)initDatabase:(int)isGet{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"leclerc.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
      {
      const char *dbpath = [databasePath UTF8String];
      if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
        {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FAVORIS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDPROD TEXT)";
        if (sqlite3_exec(favDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //status.text = @"Failed to create table";
            }
        sql_stmt = "CREATE TABLE IF NOT EXISTS CATEGORIE (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDPROD TEXT)";
            if (sqlite3_exec(favDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //status.text = @"Failed to create table";
            }
        sqlite3_close(favDB);
    
        } else {
            //status.text = @"Failed to open/create database";
        }
    }
    return self;
}
//***************************************************
- (NSMutableArray *) findAllFavoris{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
                NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM FAVORIS"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSFavoris *favoris = [[NSFavoris alloc] init];
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *idP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                favoris.idFav = idField;
                favoris.idProd = idP;
                
                [sqliteData addObject:favoris];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
//***************************************************
- (NSMutableArray *) findFavoris :(NSString *)idProd{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM FAVORIS WHERE IDPROD='%@'",idProd];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSFavoris *favoris = [[NSFavoris alloc] init];
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *idP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                favoris.idFav = idField;
                favoris.idProd = idP;
                
                [sqliteData addObject:favoris];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
- (int) saveData :(NSString *)mid{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
      {
      NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO FAVORIS (IDPROD) VALUES (\"%@\")", mid];
      const char *insert_stmt = [insertSQL UTF8String];
      sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
      if (sqlite3_step(statement) == SQLITE_DONE)
        {
        //[self setFavOkB:1];
        lastRowId = sqlite3_last_insert_rowid(favDB);
        NSLog(@"%ld",lastRowId);
        } else {
            //status.text = @"Failed to add contact";
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;
}
//***************************************************
- (void) delData:(int)val{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
      {
      NSString *insertSQL = [NSString stringWithFormat: @"DELETE FROM FAVORIS WHERE ID=%d", val];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self findFavoris:];
            // NSLog(@"ok");
        } else {
            //status.text = @"Failed to add contact";
            //NSLog(@"pas ok");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
}
//***************************************************
- (NSMutableArray *) findAllCat{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqliteData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM CATEGORIE"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(favDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                //NSFavoris *favoris = [[NSFavoris alloc] init];
                //NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *idP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                //favoris.idFav = idField;
                //favoris.idProd = idP;
                
                [sqliteData addObject:idP];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(favDB);
    }
    return sqliteData;
}
//***************************************************
- (int) saveDataCat :(NSString *)mid{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSInteger lastRowId = 0;
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CATEGORIE (IDPROD) VALUES (\"%@\")", mid];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
          {
          //[self setFavOkB:1];
          lastRowId = (int)sqlite3_last_insert_rowid(favDB);
           //NSLog(@"%ld",lastRowId);
          }
        else
          {
          //status.text = @"Failed to add contact";
          }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
    return lastRowId;
}
//***************************************************
//***************************************************
- (void) delDataCat{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &favDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"DELETE FROM CATEGORIE"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(favDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //[self findFavoris:];
            // NSLog(@"ok");
        } else {
            //status.text = @"Failed to add contact";
            //NSLog(@"pas ok");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(favDB);
    }
}
//***************************************************



@end
