//
//  PointDetails.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"
#import "Conversions.h"
#import "BusParsingNew.h"
#import "CarParkParser.h"

@interface PointDetails : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    //Tabel Data structures
    NSMutableDictionary* names;
    NSMutableArray* keys;
    
    //Tables and Cells
    UITableView* table;
    NSMutableArray* information;
    UITableViewCell* tvCell;
    
    //Other Data structures
    NSString* phoneNumber;
    Conversions* convert;
    NSMutableDictionary* busTimingsDictionary;
    NSArray* busList;
    NSString* mapInfoType;
    
    //UI Elements
    BOOL hideNavBar;
    UIImage* image;
    UIImageView* imageView;
    UIImageView* carparkImage;
    UIImageView* darkImage;
    UIButton* takePicture;
    UIButton* deletePic;
    UIButton* grabPicture;
    CGRect imageFrame;
    
    //Link to Map Controller
    MapController* mapController;
    
    //Parsers
    BusParsingNew* busParser;
    CarParkParser* carparkParser;
    
}

//Data structures
@property (nonatomic,strong) NSMutableDictionary *names;
@property (nonatomic,strong) NSMutableArray *keys;
@property(nonatomic,strong)NSMutableArray* information;
@property(nonatomic,strong)NSString* mapInfoType;
@property(nonatomic,strong)NSString* phoneNumber;

//Images
@property (nonatomic,strong) UIImage *image;
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic)BOOL hideNavBar;

//UI Elements
@property(nonatomic,strong)IBOutlet UIButton* takePicture;
@property(nonatomic,strong)IBOutlet UIButton* deletePic;
@property(nonatomic,strong)IBOutlet UIButton* grabPicture;
@property(nonatomic,strong)IBOutlet UITableView* table;
@property(nonatomic,strong)IBOutlet UITableViewCell *tvCell;

//Link to Map Controller
@property(nonatomic,strong)MapController* mapController;

//Actions
- (IBAction)toggleControls:(id)sender;
- (IBAction)shootPictureOrVideo:(id)sender;
- (IBAction)deletePic:(id)sender;
- (IBAction)selectExistingPictureOrVideo:(id)sender;
- (IBAction)busTracks:(id)sender event:(id)event;

//Constructor that loads point details
-(void)loadarray:(NSString*)one: (NSString*)two: (NSString*)three: (NSString*)four: (NSString*)five;


@end
