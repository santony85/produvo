//
//  ViewController.m
//  BTGlassScrollViewExample
//
//  Created by Byte on 10/18/13.
//  Copyright (c) 2013 Byte. All rights reserved.
//

#define SIMPLE_SAMPLE NO


#import "ViewControllerME.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewControllerME (){
    CGRect innerScrollFrame;
    UIImageView *imageForZooming;
    UIScrollView *pageScrollView;
}
@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;



- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;


@end

@implementation ViewControllerME
{
   
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
    //_txtSport.text = [self.textSport objectAtIndex:page];
    //_actImg.image = [self.imageSport objectAtIndex:page];
    //images
    //UIView *pageView = [self.pageViews objectAtIndex:page];
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 0.0f, 0.0f);
        frame.size.height= screenHeight;//568;
        //frame.size.width= screenWidth;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        
        newPageView.contentMode = UIViewContentModeScaleAspectFill;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the content size of the scroll view
    
    //self.scrollView.frame = [[UIScreen mainScreen] bounds];
    //CGSize pagesScrollViewSize = self.scrollView.frame.size;
    //self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    //[self loadVisiblePages];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create a UIImage to hold Info.png
    // Set up the image we want to scroll & zoom and add it to the scroll view
    /*self.pageImages = [[NSMutableArray alloc] init];

    for (NSInteger i = 1; i < 6; ++i) {
        [self.pageImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"p%d.jpg", i]]];

        
    }
    NSInteger pageCount = self.pageImages.count;
    
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }*/
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    innerScrollFrame = self.scrollView.bounds;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    float screenWidth = screenSize.width;
    float screenHeight = screenSize.height;
    
    for (NSInteger i = 1; i < 6; ++i) {
        UIImage *imageA = [UIImage imageNamed:[NSString stringWithFormat:@"p%d.jpg", i]];
        
        imageForZooming = [[UIImageView alloc] initWithImage:imageA];
        imageForZooming.bounds = CGRectMake(0,0, screenWidth, screenHeight);
        imageForZooming.frame  = CGRectMake(0,0, imageA.size.width, imageA.size.height);
        imageForZooming.frame  = CGRectMake(0,0, screenWidth, screenHeight);
        imageForZooming.contentMode  = UIViewContentModeScaleAspectFill;
        
        
        
        
        pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        //pageScrollView.minimumZoomScale = ratio;
        //pageScrollView.maximumZoomScale = 2.0f;
        //pageScrollView.zoomScale = ratio;
        pageScrollView.contentSize = imageForZooming.bounds.size;
        //pageScrollView.delegate = self;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        [pageScrollView addSubview:imageForZooming];
        
        //[mainScrollView addSubview:pageScrollView];
        imageForZooming.clipsToBounds = YES;
        
        [self.scrollView addSubview:pageScrollView];
        
        innerScrollFrame.origin.x += innerScrollFrame.size.width;

        
    }
  innerScrollFrame.origin.x -= innerScrollFrame.size.width;
  self.scrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x +
                                            innerScrollFrame.size.width, self.scrollView.bounds.size.height);
  self.scrollView.delegate = self;
  [self.view addSubview:self.scrollView];
    _affNbPage.numberOfPages   = 5;
    _affNbPage.layer.zPosition = 1;
    UIColor *toto = _btClose.backgroundColor;
    _btClose = [[APRoundedButton alloc] initWithFrame:CGRectMake(10, 40, 89, 33)];
    [_btClose setTitle:@"Fermer" forState:UIControlStateNormal];
    [_btClose addTarget:self
               action:@selector(affRetour:)
     forControlEvents:UIControlEventTouchUpInside];
    _btClose.style = 10;
    _btClose.backgroundColor = toto;
    [_btClose awakeFromNib];
    [self.view addSubview:_btClose];
    

    
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    NSLog(@"%f",self.scrollView.contentSize.width);
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
   // [self loadVisiblePages];
}
- (IBAction)affRetour:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    
}




@end
