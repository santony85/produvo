//
//  findViewController.m
//  produvo
//
//  Created by Antony on 05/01/2015.
//  Copyright (c) 2015 Planb. All rights reserved.
//

#import "findViewController.h"
#import "newApiConnect.h"


@interface findViewController (){
    NSMutableArray *readlst;
    NSMutableArray *tmpreadlst;
    NSMutableArray *tmpreadlst2;
    NSMutableArray *afflst;
    newApiConnect *connect;
    
    NSMutableArray *complst;
    
    NSMutableArray *marquelst;
    NSMutableArray *modellst;
    NSArray * kmlst;
    NSArray * kmtab;
    NSArray * prixlst;
    NSArray * prixtab;
    NSString *strMarque;
    int numOfType;
    
    int selPos;
    int oldMar,oldMod,oldPri,oldKms;

}

@end

@implementation findViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    connect     = [[newApiConnect alloc] init];
    readlst     = [[NSMutableArray alloc] init];
    tmpreadlst  = [[NSMutableArray alloc] init];
    tmpreadlst2  = [[NSMutableArray alloc] init];
    
    marquelst   = [[NSMutableArray alloc] init];

    modellst    = [[NSMutableArray alloc] init];
    
    afflst      = [[NSMutableArray alloc] init];
    
    readlst     = [connect getAllFile :@"vehicule"];
    complst     = readlst;
    tmpreadlst  = readlst;
    tmpreadlst2  = readlst;
    numOfType = 0;
    
    oldMar=0;
    oldMod=0;oldPri=0;oldKms=0;
    
    strMarque = @"TOUS";
    
    //init marque
    marquelst   = [connect getListOf  :@"Marque" :readlst];
    marquelst   = [@[@"TOUS"] arrayByAddingObjectsFromArray:marquelst];
    
    NSLog(@"%@",marquelst);
    
    modellst  = [connect getListOf  :@"Famille" :readlst];
    modellst  = [@[@"TOUS"] arrayByAddingObjectsFromArray:modellst];
    

    
    
    kmlst = [NSArray arrayWithObjects: @"TOUS",
                             @"<= 10",
                             @"<= 100",
                             @"<= 1000",
                             @"<= 10000",
                             @"> 10000",
                             nil];
    kmtab = [NSArray arrayWithObjects:@"0",@"11",@"101",@"1001",@"10001",@"10002",nil];
    prixlst = [NSArray arrayWithObjects: @"TOUS",
             @"0 à 4000",
             @"4000 à 6000",
             @"6000 à 8000",
             @"8000 a 12000",
             @"12000 a 16000",
             @"16000 a 20000",
             @"> 20000",
             nil];
    
    prixtab = [NSArray arrayWithObjects:@"0",@"0",@"4000",@"6000",@"8000",@"12000",@"16000",@"20000",@"200001",nil];
    
    afflst = marquelst;
    selPos = -1;
    
    _nbv.text =  [NSString stringWithFormat:@"%d véhicules trouvés",readlst.count];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"isback"];
    [prefs setObject:[[NSMutableArray alloc] init] forKey:@"reclst"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSInteger *size = [_pickerData count];
    return [afflst count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return afflst[row];
    //return [NSString stringWithFormat:@"%d",row];
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


-(NSMutableArray *)getListOfProd:(NSString *)collection :(NSMutableArray *)catlst :(NSString *)champ{
    NSString *stringToSearch = champ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.%@ contains[c] %@",collection,stringToSearch]; // if you need case sensitive search avoid '[c]' in the predicate
    NSArray *results = [catlst filteredArrayUsingPredicate:predicate];
    return results;
    
}



// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
  {
  //
      selPos=row;
      
   }
- (IBAction)closePk:(id)sender{
    
    int row = selPos;
    if(selPos != -1){
        

    //************ ok ************
    if(numOfType==0){
        oldMar=row;
        _labMarque.text  = afflst[row];
        _labModele.text  = @"TOUS";
        _labCouleur.text = @"TOUS";
        _labKilo.text    = @"TOUS";
        readlst     = [connect getAllFile :@"vehicule"];
        if(row>0){
          readlst     = [self getListOfProd  :@"Marque" :readlst :afflst[row]];
          modellst    = [connect getListOf  :@"Famille" :readlst];
          modellst    = [@[@"TOUS"] arrayByAddingObjectsFromArray:modellst];
          }
        tmpreadlst = readlst;
    }
    //******************************
    else if(numOfType==1){
        _labModele.text = afflst[row];
        
        oldMod=row;
        if(row>0){
          readlst   = tmpreadlst;
          modellst  = [connect getListOf  :@"Famille" :readlst];
          modellst  = [@[@"TOUS"] arrayByAddingObjectsFromArray:modellst];
          readlst   = [self getListOfProd  :@"Famille" :readlst :afflst[row]];
          }
        else {
            _labCouleur.text = @"TOUS";
            if( [_labMarque.text isEqualToString:@"TOUS"]){
              readlst     = [connect getAllFile :@"vehicule"];
              modellst    = [connect getListOf  :@"Famille" :readlst];
              modellst    = [@[@"TOUS"] arrayByAddingObjectsFromArray:modellst];
              }
            else{
              readlst     = [connect getAllFile :@"vehicule"];
                
              readlst     = [self getListOfProd  :@"Marque" :readlst :_labMarque.text];
              modellst    = [connect getListOf  :@"Famille" :readlst];
              modellst    = [@[@"TOUS"] arrayByAddingObjectsFromArray:modellst];
              }
        }
        tmpreadlst2 = readlst;
    }
    //************ /ok ************
    else if(numOfType==2){
        oldPri = row;
        _labCouleur.text = afflst[row];
       // NSLog(@"%d->%d",[prixtab[row] intValue],[prixtab[row+1] intValue]);
        if(row>0){
          readlst  = [self FindMinMax  :@"PrixVenteTTC" :[prixtab[row] intValue] :[prixtab[row+1] intValue] :readlst];
          
          }
        else{
          if(oldMod==0)readlst = tmpreadlst;
          else readlst = tmpreadlst2;
          }
        
        
    }
    
    else if(numOfType==3){
        _labKilo.text = afflst[row];
        
        NSLog(@"%d->%d",0,[kmtab[row] intValue]);
        if(row>0){
            readlst  = [self FindMinMax  :@"Kilometrage" :0 :[kmtab[row] intValue] :readlst];
            
        }
        else{
            if(oldMod==0)readlst = tmpreadlst;
            else readlst = tmpreadlst2;
            
        }
        
        
    }

    
    NSLog(@"nb : %lu",(unsigned long)readlst.count);
    
    NSUserDefaults *prefs  = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:2 forKey:@"isback"];
    [prefs setObject:readlst forKey:@"reclst"];
    
    
    }
    _nbv.text =  [NSString stringWithFormat:@"%d véhicules trouvés",readlst.count];
    selPos = -1;
    self.closePicker;

}

- (IBAction)affMarque:(id)sender{
    numOfType=0;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _pkview.frame = CGRectMake(_pkview.frame.origin.x,
                                                        screenBounds.size.height, //Displays the view off the screen
                                                        _pkview.frame.size.width,
                                                        _pkview.frame.size.height);
                         
                     } 
                     completion:^(BOOL finished) {
                         afflst = marquelst;
                         [_pickerview reloadAllComponents];
                         [self showPicker:sender :oldMar];
                         
                     }
     ];
    
    
    
    


}
- (IBAction)affModele:(id)sender{
    numOfType=1;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _pkview.frame = CGRectMake(_pkview.frame.origin.x,
                                                        screenBounds.size.height, //Displays the view off the screen
                                                        _pkview.frame.size.width,
                                                        _pkview.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         afflst = modellst;
                         [_pickerview reloadAllComponents];
                         [self showPicker:sender :oldMod];
                         
                     }
     ];
    
    
    
    

    
}
- (IBAction)affCouleur:(id)sender{
    numOfType=2;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _pkview.frame = CGRectMake(_pkview.frame.origin.x,
                                                        screenBounds.size.height, //Displays the view off the screen
                                                        _pkview.frame.size.width,
                                                        _pkview.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         afflst = prixlst;
                         [_pickerview reloadAllComponents];
                         [self showPicker:sender :oldPri];
                         
                     }
     ];
    
    
    
    
}
- (IBAction)affKil:(id)sender{
    numOfType=3;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _pkview.frame = CGRectMake(_pkview.frame.origin.x,
                                                        screenBounds.size.height, //Displays the view off the screen
                                                        _pkview.frame.size.width,
                                                        _pkview.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         afflst = kmlst;
                         [_pickerview reloadAllComponents];
                         [self showPicker:sender :0];
                         
                     }
     ];
    

}

-(void)closePicker
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 animations:^{
        _pkview.frame = CGRectMake(_pkview.frame.origin.x,
                                       screenBounds.size.height, //Displays the view off the screen
                                       _pkview.frame.size.width,
                                       _pkview.frame.size.height);
    }];
}

-(void)showPicker:(id) sender :(int)row
{
    
    [_pickerview selectRow:row inComponent:0 animated:YES];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 animations:^{
        _pkview.frame = CGRectMake(_pkview.frame.origin.x,
                                       (screenBounds.size.height - _pkview.frame.size.height), //Displays the view a little past the
                                       //center ling of the screen
                                       _pkview.frame.size.width,
                                       _pkview.frame.size.height);
    }];
}

- (IBAction)execRec:(id)sender{
     [self.navigationController popViewControllerAnimated:YES];
}

@end
