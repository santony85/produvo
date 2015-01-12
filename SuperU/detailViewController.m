//
//  detailViewController.m
//  hyperulucon
//
//  Created by Mickael NAULET on 10/12/2014.
//  Copyright (c) 2014 Planb. All rights reserved.
//

#import "detailViewController.h"



#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface detailViewController ()

{
    int isInfos;
    float vHeight;
    NSString *myStr;
    float rHeight;
    NSInteger page ;
    NSMutableArray *thumbarr;
    NSMutableArray *bigarr;
}

@end

@implementation detailViewController

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.tag=0;
    _scrollImg.tag=1;
    
    
    
    _scrollZoom.maximumZoomScale = 3.0;
    _scrollZoom.minimumZoomScale = 1.0;
    _scrollZoom.clipsToBounds = YES;
    _scrollZoom.delegate = self;
    _scrollZoom.tag = 2;
    

    thumbarr = [[NSMutableArray alloc] init];
    NSLog(@"%f",_scrollView.frame.size.height);
    rHeight= _scrollView.frame.size.height+30;
    isInfos=0;
    if (IPAD) {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, rHeight+100);
    } else {
        
        CGRect frame =_scrollView.frame;
        frame.origin.y = frame.origin.y -60;
        _scrollView.frame = frame;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, rHeight);
        
    }
    
    [_scrollView setContentOffset:CGPointMake(0, -100) animated:NO];
    
    
    _scrollImg.contentSize = CGSizeMake(_dum.frame.size.width*6, 70);
    
    
    // Do any additional setup after loading the view.
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Retour"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bkbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    NSString *ref =  [NSString stringWithFormat:@"%@ %@",
                      [_mdata objectForKey:@"Marque"],
                      [_mdata  objectForKey:@"Modele"]];
    
    _titre.text = ref;
    NSString *nbp = [_mdata objectForKey:@"Photos"];
    NSArray *myArray = [nbp componentsSeparatedByString:@"|"];
    
    NSString *contentString = [[NSString alloc]
                               initWithFormat:@"http://www.planb-apps.com/produvo/media/%@",[myArray objectAtIndex:0]];
    
    NSLog(@"%@",contentString);
    
   /* NSURL * imageURL = [NSURL URLWithString:contentString];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    if (imageData){
       UIImage *imageA = [UIImage imageWithData:imageData];
        _image.image = imageA;
        [thumbarr addObject:imageA];
        
        
        for(int i=1;i<[myArray count];i++){
            NSString *strl = [[NSString alloc]
                                       initWithFormat:@"http://www.pro-du-vo.com/media/%@",[myArray objectAtIndex:i]];
            NSURL * imageURL = [NSURL URLWithString:strl];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *imageA = [UIImage imageWithData:imageData];
            [thumbarr addObject:imageA];
            
            
            
            
        }
        
    }
   else*/
    
    
    
    _image.image = [self loadImage:[myArray objectAtIndex:0] ofType:@"jpg" inDirectory:documentsDirectoryPath];
    
    
    

    
    
    _prix.text = [NSString stringWithFormat:@"Prix : %@ €",
                  [_mdata objectForKey:@"PrixVenteTTC"]];
    _marque.text = [NSString stringWithFormat:@"Marque : %@",
                  [_mdata objectForKey:@"Marque"]];
    _version.text = [NSString stringWithFormat:@"Modele : %@",
                    [_mdata objectForKey:@"Famille"]];
    _serie.text = [NSString stringWithFormat:@"Serie : %@",
                     [_mdata objectForKey:@"Version"]];
    _ref.text = [NSString stringWithFormat:@"Réf : %@",
                   [_mdata objectForKey:@"NumeroPolice"]];
    _annee.text = [NSString stringWithFormat:@"Année : %@",
                 [_mdata objectForKey:@"Annee"]];
    _km.text = [NSString stringWithFormat:@"Kilométrage : %@",
                   [_mdata objectForKey:@"Kilometrage"]];
    
    _energie.text = [NSString stringWithFormat:@"Energie : %@",
                [_mdata objectForKey:@"EnergieLibelle"]];
    _couleur.text = [NSString stringWithFormat:@"Couleur : %@",
                [_mdata objectForKey:@"Couleur"]];
    _bv.text = [NSString stringWithFormat:@"Transmition : %@",
                [_mdata objectForKey:@"BoiteLibelle"]];
    
    NSString *com  = [_mdata objectForKey:@"EquipementsSerie"];
    NSArray *myCom = [com componentsSeparatedByString:@"|"];
    
    myStr=@"";
    for(int i=0;i<[myCom count]-1;i++){
        //myStr = [NSString stringWithFormat:@"%@%@\r\n",myStr,[myCom objectAtIndex:i]];
        myStr = [NSString stringWithFormat:@"%@%@, ",myStr,[myCom objectAtIndex:i]];
        
    }

    //[self createMenuWithButtonSize];
    
    /*for(int i=1;i<[myArray count];i++){
    UIImage *tmpimg  = [UIImage imageNamed:@"nd.png"];
    [thumbarr addObject:tmpimg];
    }*/
    
   // NSLog(@"%d %@",[myArray count],myArray);
    if([myArray count] > 1){
    for(int i=0;i<[myArray count];i++){
        NSString *strl = [[NSString alloc]
                          initWithFormat:@"http://www.planb-apps.com/produvo/media/%@",[myArray objectAtIndex:i]];
     NSURL * imageURL = [NSURL URLWithString:strl];
    // download the image asynchronously
    [self downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            [thumbarr addObject:image];
            if(i==[myArray count]-1){
                [self createMenuWithButtonSize];
                self.loader.hidden = YES;
                _image.image = [thumbarr objectAtIndex:0];
                
            }

            
        }
    }];
   }
   }
    
}





- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}




- (void)aMethod:(id)sender {
    NSLog(@"%d",[sender tag]);
    _image.image = [thumbarr objectAtIndex:[sender tag]];


}


-(void)createMenuWithButtonSize{

    
    
    for (int i = 0; i < [thumbarr count]; i++) {
            UIImageView * imageview = [[UIImageView alloc]initWithImage:[thumbarr objectAtIndex:i]];
            [imageview setContentMode:UIViewContentModeScaleAspectFit];
            imageview.frame = CGRectMake((i*(2.0+_dum.frame.size.width))+2, 2, _dum.frame.size.width, _dum.frame.size.height);
            NSLog(@"%f",i*(2.0+_dum.frame.size.width));
            [imageview setTag:i];
            [self.scrollImg addSubview:imageview];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(aMethod:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"" forState:UIControlStateNormal];
            button.frame = CGRectMake((i*(2.0+_dum.frame.size.width))+2, 0, _dum.frame.size.width, _dum.frame.size.height);
            [button setTag:i];
            [self.scrollImg addSubview:button];
        
    }
    
    self.scrollImg.contentSize=CGSizeMake((_dum.frame.size.width + 2.0) * [thumbarr count], _dum.frame.size.height);
}


//=================================================================================
#pragma mark - UIScrollViewDelegate
//=================================================================================
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(scrollView.tag==1){
        CGFloat pageWidth = _dum.frame.size.width;
        page = (NSInteger)floor((self.scrollImg.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    }

    
}

-(void) scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    if(scrollView.tag==1){
    CGFloat pageWidth = _dum.frame.size.width;
    page = (NSInteger)floor((self.scrollImg.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    [self.scrollImg setContentOffset:CGPointMake(page*77, 0) animated:YES];
    //self.pageControlM.currentPage = page;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
 return _image;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    int iva= 40;
    
    if (IPAD){
    _com.font = [UIFont systemFontOfSize:14];
        iva= 100;
    }
    else _com.font = [UIFont systemFontOfSize:9];
    
    _com.numberOfLines = 0;
    _com.text = myStr;
    [_com sizeToFit];
    //taile de la vue
    CGRect frame1= _com.frame;
    CGRect frame =_comView.frame;
    frame.size.height = frame1.size.height+iva;
    _comView.frame = frame;
    
    vHeight = frame.size.height;
    



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)affInfos:(id)sender {
    if(isInfos == 0){
        isInfos = 1;
        _comView.hidden = NO;
        if (IPAD) {
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, rHeight+50+vHeight);
            [_scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
        } else {
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, rHeight+vHeight);
            [_scrollView setContentOffset:CGPointMake(0, vHeight) animated:YES];
        }
        
    }
    else {
        if (IPAD) {
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, rHeight+50);
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        } else {
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, rHeight);
            [_scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
        }

        isInfos =0;
        _comView.hidden = YES;
    }
    
}
@end
