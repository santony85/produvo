//
//  Test.h
//  ExternVariable
//
//  Created by ashish on 08/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "planbAnalitycs.h"
#import "apiconnect.h"
#import "dataBase.h"
#import "MyActivityOverlayViewController.h"
#import "AppDelegate.h"

extern appDelegate *mappDelegate;
extern MyActivityOverlayViewController *loader;

extern NSString *appliNom;
extern NSString *appliTitre;
extern NSString *guestTitre;


extern  NSString *nomCompteTwitter;
extern  NSString *urlServer;

extern NSString *shakeTextLab;
extern NSString *shakeLienPage;
extern Boolean shakeEnabled;

extern  int idClientG;
extern  int nbPageMenu;

// map
extern float maplatitude;
extern float maplongitude;
extern NSString *maptitle;
extern NSString *mapsubtitle;

//------
extern Boolean affTopBar;
extern Boolean affTopBarButton;
extern Boolean isAudio;
extern Boolean isComment;

// K9ViewController
extern NSArray *ListePages;

// Contact
extern NSString *numTel;
extern NSString *appliEmail;
extern NSString *lienFb;
extern NSString *contactText;

// copyright
extern NSString *versionTxt;
extern NSString *copyrightTxt;

extern NSMutableArray *arrayOfSong;
extern NSArray *arrayOfTitreSong;
extern NSArray *arrayOfinterSong;

extern NSArray *arrayOfVideo;
extern NSArray *arrayOfTitreVideo;

extern NSString *tokenAsString;

extern NSString *presTitre;
extern NSString *textPres;

extern NSString *richpush;

@interface GlobalV : NSObject

- (void)setVar;

@end
