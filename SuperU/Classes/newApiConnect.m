//
//  newApiConnect.m
//  GestionBaseDeDonnees
//
//  Created by Antony on 09/12/2014.
//  Copyright (c) 2014 planb. All rights reserved.
//

#import "newApiConnect.h"

@implementation newApiConnect

-(void)afficherAlertReseau{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Attention"
                                                    message: @"Connection au réseau impossible!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(NSMutableArray *)getAll :(NSString *)collection :(int)save{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4215/1.0/list/%@",collection];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){
            result = list;
            if(save==1){
                [self saveFile:collection :result];
                [self getImages:collection :result];
            }
        }
    }
    else [self afficherAlertReseau];
    
    return result;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}


-(void)getImages:(NSString *)collection:(NSMutableArray *)result{
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for(int i=0;i< [result count];i++){
        NSString *nbp = [[result objectAtIndex:i] objectForKey:@"Photos"];
        NSString *idp = [[result objectAtIndex:i] objectForKey:@"_id"];
        NSArray *myArray = [nbp componentsSeparatedByString:@"|"];
        //for(int j=0;j<[myArray count];j++){
            UIImage * imageFromURL = [self getImageFromURL:[NSString stringWithFormat:@"http://www.pro-du-vo.com/media/thumbnails/%@",[myArray objectAtIndex:0]]];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@",[myArray objectAtIndex:0]]);
            [self saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"%@",[myArray objectAtIndex:0]] ofType:@"jpg" inDirectory:documentsDirectoryPath];
      //  }
        
    }
    
    
}

-(void)saveFile:(NSString *)collection:(NSMutableArray *)result{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",collection]];
    [result writeToFile:path atomically:YES];
    
}

-(NSMutableArray *)getAllFile :(NSString *)collection{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",collection]];
    result = [[NSMutableArray alloc] initWithContentsOfFile: path];
    return result;
}

-(NSMutableArray *)getListOf :(NSString *)collection :(NSMutableArray *)catlst{
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:catlst
                                                    forKeys:[catlst valueForKey:@"Marque"]];
    NSArray *produitsSectionTitles = [[dict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return produitsSectionTitles;
    
}

-(NSMutableArray *)FindMinMax :(NSString *)collection :(int)min :(int)max :(NSMutableArray *)catlst{
    NSMutableArray *yourArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in catlst) {
        NSString *res=[dict valueForKey:collection];
        int iKm = [res intValue];
        if((iKm >= min)&&(iKm <= max)){
            [yourArray addObject:dict];
        }
    }
    return yourArray;
}

-(NSMutableArray *)getListSorted :(NSString *)collection :(NSMutableArray *)catlst :(NSString *)champ:(Boolean)asc{
    
    NSSortDescriptor *sortIdClient = [NSSortDescriptor sortDescriptorWithKey:champ ascending:asc comparator: ^(id obj1, id obj2){
        
        return [obj1 compare:obj2 options:NSNumericSearch];
        
    } ];
    
    NSArray *sortDescriptors = @[sortIdClient];
    NSArray *arrTemp = [catlst sortedArrayUsingDescriptors:sortDescriptors];
    return arrTemp;
    
}

-(NSMutableArray *)getListText :(NSString *)collection :(NSMutableArray *)catlst :(NSString *)champ{
     NSString *stringToSearch = champ;
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",stringToSearch]; // if you need case sensitive search avoid '[c]' in the predicate
     NSArray *results = [catlst filteredArrayUsingPredicate:predicate];
    return results;
    
}


-(NSMutableArray *)getLogin :(NSString *)collection :(NSString *)login :(NSString *)mdp{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/login/%@/%@/%@",collection,login,mdp];
    
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &error];
    if(error==nil){
        NSDictionary *list =[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
        if(error==nil){
            result = list;
        }
    }
    else [self afficherAlertReseau];
    
    return result;
}


@end
