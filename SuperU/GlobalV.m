#import "GlobalV.h"
#import "AppDelegate.h"

appDelegate *mappDelegate;
MyActivityOverlayViewController *loader;
NSString *appliNom;
NSString *appliTitre;
NSString *guestTitre;

NSString *nomCompteTwitter;
NSString *urlServer;

int idClientG;
int nbPageMenu;

float maplatitude;
float maplongitude;

NSString *maptitle;
NSString *mapsubtitle;

Boolean isAudio;
Boolean isComment;
Boolean affTopBar;
Boolean affTopBarButton;

NSArray *ListePages;

NSString *numTel;
NSString *appliEmail;
NSString *lienFb;
NSString *contactText;

NSString *versionTxt;
NSString *copyrightTxt;

NSMutableArray *arrayOfSong;
NSArray *arrayOfTitreSong;
NSArray *arrayOfinterSong;

NSArray *arrayOfVideo;
NSArray *arrayOfTitreVideo;

NSString *tokenAsString;

NSString *shakeTextLab;
NSString *shakeLienPage;
Boolean shakeEnabled;
NSString *presTitre;
NSString *textPres;
NSString *richpush;

@implementation GlobalV
-(void)setVar{
mappDelegate = (appDelegate *)[[UIApplication sharedApplication] delegate];
arrayOfSong = [[NSMutableArray alloc] init];
idClientG = 68;


appliNom = @"Midstar";
appliTitre = @"Le Midstar";



numTel = @"0241957170";
appliEmail = @"hyperu.lucon.administratif@systeme-u.fr";
lienFb = @"https://www.facebook.com/HyperULucon";
nomCompteTwitter = @"";
contactText = @"";
maplatitude = 46.463846;
maplongitude = -1.173895;
maptitle = @"Hyper U";
mapsubtitle = @"Luçon";
versionTxt = @"v 1.2 12/08/2013";
copyrightTxt = @"2013";
guestTitre = @"Entrez sur la Guest List du Mid'Star";
urlServer = @"http://www.planb-apps.com/";
nbPageMenu = 0;
presTitre = @"";
textPres = @"";
richpush = @"0";
shakeEnabled  = NO;
shakeTextLab  = @"shake your phone for strobo";
shakeLienPage = @"lien";

ListePages = [[NSArray alloc]initWithObjects:
@"carteView",
@"VideoView",
@"GaleriePhotoView",
@"MusicView",
@"NewsView",
@"GuestList",
@"ContactView",
@"copyrightView",
nil];

tokenAsString = @"base";
affTopBar = YES;
affTopBarButton = YES;

arrayOfTitreSong = [[NSArray alloc]initWithObjects:
@"MIX 1 (2014)",
@"MIX 2 (2014)",
@"MIX 3 (2014)",
@"MIX 4 (2014) ",
nil];
arrayOfinterSong = [[NSArray alloc]initWithObjects:
@"DJ CHAMMANSKA",
@"DJ CHAMMANSKA",
@"DJ CHAMMANSKA",
@"DJ CHAMMANSKA",
nil];
isAudio = YES;
isComment = NO;
}
@end
