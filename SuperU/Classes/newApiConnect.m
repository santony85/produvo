//
//  newApiConnect.m
//  GestionBaseDeDonnees
//
//  Created by Antony on 09/12/2014.
//  Copyright (c) 2014 planb. All rights reserved.
//

#import "newApiConnect.h"

@implementation newApiConnect
@synthesize delegate = _delegate;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _delegate = nil;

    }
    return self;
}


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
            [self.delegate nbImage:(int)result.count];
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

-(NSArray *)findFiles:(NSString *)extension{
    
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    // >>> this section here adds all files with the chosen extension to an array
    for (item in contents){
        if ([[item pathExtension] isEqualToString:extension]) {
            [matches addObject:item];
        }
    }
    return matches;
}

-(void)getImages:(NSString *)collection:(NSMutableArray *)result{
    
    /*NSArray *todel= [self findFiles:@"jpg"];
    
    NSLog(@"%@",todel);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(int i=0;i<[todel count] ;i++)
    [fileManager removeItemAtPath:[todel objectAtIndex:i] error:NULL];*/
    
    NSString *extension = @"jpg";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for(int i=0;i< [result count];i++){
        NSString *nbp = [[result objectAtIndex:i] objectForKey:@"Photos"];
        NSString *idp = [[result objectAtIndex:i] objectForKey:@"_id"];
        NSArray *myArray = [nbp componentsSeparatedByString:@"|"];
        

        dispatch_queue_t queue = dispatch_queue_create("com.company.app.imageQueue", 0);
        dispatch_async(queue, ^{
            UIImage * imageFromURL = [self getImageFromURL:[NSString stringWithFormat:@"http://www.planb-apps.com/produvo/thumb/%@",[myArray objectAtIndex:0]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",[NSString stringWithFormat:@"%@",[myArray objectAtIndex:0]]);
                [self.delegate stepImage];
                [self saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"%@",[myArray objectAtIndex:0]] ofType:@"jpg" inDirectory:documentsDirectoryPath];
            });//end
        });//end
        
        
        

        
        
        //for(int j=0;j<[myArray count];j++){
           /* UIImage * imageFromURL = [self getImageFromURL:[NSString stringWithFormat:@"http://www.planb-apps.com/produvo/thumb/%@",[myArray objectAtIndex:0]]];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@",[myArray objectAtIndex:0]]);
        [self.delegate stepImage];
            [self saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"%@",[myArray objectAtIndex:0]] ofType:@"jpg" inDirectory:documentsDirectoryPath];*/
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
                                                    forKeys:[catlst valueForKey:collection]];
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

-(NSMutableArray *)getListTmp : (NSString *)collection : (NSMutableArray *)catlst : (NSDictionary *)dictCat{
    NSMutableArray *list = catlst;
    NSDictionary *dictTmp;
    
    NSString *requete;
    for(NSString *key in dictCat){
        if(requete){
            if([key  isEqual: @"Prix"] || [key  isEqual: @"Kilometrage"]){
                requete = [NSString stringWithFormat:@"%@%@",requete,[NSString stringWithFormat:@" AND %@ <= '%@'", key, [dictCat valueForKey:key]]];
            }
            else{
                requete = [NSString stringWithFormat:@"%@%@",requete,[NSString stringWithFormat:@" AND %@ = '%@'", key, [dictCat valueForKey:key]]];
            }
            
            //requete = @"AND " + key + @" = " + [dictCat valueForKey:key];
        }
        else{
            requete = [NSString stringWithFormat:@"%@ = '%@'", key, [dictCat valueForKey:key]];
            //requete = key . @" = " . [dictCat valueForKey:key];
        }
    }
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:requete];
    NSMutableArray *filteredlst = [catlst filteredArrayUsingPredicate:filter];
    
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:filteredlst
                                                     forKeys:[filteredlst valueForKey:collection]];
    NSArray *produitsSectionTitles = [[dict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    /*NSMutableArray * array = [[NSMutableArray alloc ]init];
     for (NSString * name in dictCat) {
     for (NSMutableArray * object in catlst) {
     if ([object indexOfObject:name]) {
     [array addObject:object];
     }
     }
     }*/
    
    //dictTmp = [NSDictionary dictionaryWithObjects:array
    //forKeys:[array valueForKey:collection]];
    
    
    /*for (NSUInteger i=0; i<[dictCat count]; i++) {
     if(!dictTmp){
     dictTmp = [NSDictionary dictionaryWithObjects:list
     forKeys:[list valueForKey:[dictCat objectAtIndex:i]]];
     }
     else{
     dictTmp = [NSDictionary dictionaryWithObjects:dictTmp
     forKeys:[dictTmp valueForKey:[dictCat objectAtIndex:i]]];
     }
     }*/
    
    //list = [[dictTmp allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return produitsSectionTitles;
}

-(NSMutableArray *)getListFinal : (NSString *)collection : (NSMutableArray *)catlst : (NSDictionary *)dictCat{
    NSMutableArray *list = catlst;
    NSDictionary *dictTmp;
    
    NSString *requete;
    for(NSString *key in dictCat){
        if(requete){
            if([key  isEqual: @"Prix"] || [key  isEqual: @"Kilometrage"]){
                requete = [NSString stringWithFormat:@"%@%@",requete,[NSString stringWithFormat:@" AND %@ <= '%@'", key, [dictCat valueForKey:key]]];
            }
            else{
                requete = [NSString stringWithFormat:@"%@%@",requete,[NSString stringWithFormat:@" AND %@ = '%@'", key, [dictCat valueForKey:key]]];
            }
            
            //requete = @"AND " + key + @" = " + [dictCat valueForKey:key];
        }
        else{
            requete = [NSString stringWithFormat:@"%@ = '%@'", key, [dictCat valueForKey:key]];
            //requete = key . @" = " . [dictCat valueForKey:key];
        }
    }
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:requete];
    NSMutableArray *filteredlst = [catlst filteredArrayUsingPredicate:filter];
    
    return filteredlst;
}

-(NSString *)postUnit :(NSString *)collection :(NSDictionary *)data{
    NSString *url =  [NSString stringWithFormat:@"http://planb-apps.com:4205/1.0/unit/%@",collection];
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] init];
    for (id key in data) {
        NSString *keyString = [key description];
        NSString *valueString = [[data objectForKey:key] description];
        [urlWithQuerystring appendFormat:@"&%@=%@", keyString, valueString];
    }
    [urlWithQuerystring appendFormat:@"&idclient=%d", 68];
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

-(NSMutableArray *)getVendeur :(NSString *)collection :(NSString *)idp {
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
        if(error==nil){
            result = list;
        }
    }
    else [self afficherAlertReseau];
    
    return result;
}


@end
