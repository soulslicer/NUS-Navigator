//
//  MapController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * MAP CONTROLLER
 
 This class does the following:
 
 1. Handles MapPoints which contain relevant information
 2. Handles compass needele
 3. Handles user location
 4. Handles overlay of Map
 5. Handles Routing Algorithm and UI
 6. Passes info to Point Details to view more about that MapPoint
 7. Handles Bus Tracker (Deprec.)
 ************************************************************************/

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#import "MBProgressHUD.h"
#import "RouterView.h"

@class BusTracker;
@class RouterView;

@interface MapController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UIApplicationDelegate,UITextFieldDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>{
    
    //These values must be set to load a single map point in
    __weak NSString* buildingname;
    __weak NSString* locationname;
    __weak NSString* imagename;
    __weak NSString* alias;
    __weak NSString* mapInfoType;
    __weak MapPoint* tempoint;
    NSMutableArray* mapPointArray;
    
    //UI Elements
    UISegmentedControl* segmentControl;
    UIImageView* arrow;
    UILabel* distanceLabel;
    UIButton* clearButton;
    UISegmentedControl* segmentMapType;
    UIButton* gpsButton;
    UIToolbar* tool;
    UIButton* buttonText;
    UIActivityIndicatorView* activityInd;
    MBProgressHUD *HUD;
    
    //Map Objects
    CLLocationManager* locationManager;
    CLLocation* startingPoint;
    IBOutlet MKMapView* mapView;
    
    //Data structures to hold information
    NSDictionary* buildingcood;
    NSDictionary* busList;
    NSDictionary* carList;

    //Random booleans (hold prevents map shifting function from being called)
    BOOL checker;
    BOOL hold;
    BOOL hold2;
    BOOL gpsBool;
    
    //Actionsheets and alerts
    UIActionSheet *actionSheet1;
    UIActionSheet *actionSheet2;
    UIAlertView* alert1;
    UIAlertView* alert2;
    UIAlertView* alert3;
    UIAlertView* alert4;
    UIAlertView* alertSelectRoute;
    UIAlertView* alertGoogle;
    UIAlertView* alertNUSPins;
    
    //Routing data structures
    NSDictionary* oppBusstops;
    NSDictionary* busRoutes;
    NSMutableDictionary* routeDictionaryAdd;
    NSMutableArray* holderArr;
    int counter; int counter2; int maxRoutes; int currRoute; 

    //Routing objects
    MapPoint* tempSelect;
    UILabel* routeNameLabel;
    BOOL selectorOn; BOOL googleMap;
    MapPoint* selectedPoint;
    MapPoint* holdtemppoint;
    UIToolbar* toolSelect;
    UIButton* displayInfo;
    MKPolyline* routeLine;
    NSMutableArray* arrayOfrouteLines;
    BOOL locationBool;
    MKPolyline *utownLine;
    
    //Bus Tracker (Current Disabled since server is gone)
    BusTracker* busTracker;
    MapPoint* busPoint1;
    
    //Text based route details
    UIView* routerView;
    RouterView* rV;
    
    BOOL shortestOrFastest;
    UIImageView* googleLogo;
}

//You need to set these details, or set mapPointArray then call the loading function
@property(nonatomic,weak)NSString* buildingname;
@property(nonatomic,weak)NSString* locationname;
@property(nonatomic,weak)NSString* alias;
@property(nonatomic,weak)NSString* imagename;
@property(nonatomic,weak)NSString* mapInfoType;
@property(nonatomic,strong)NSMutableArray* mapPointArray;

//Map Objects
@property (nonatomic,strong) CLLocationManager *locationManager; 
@property (nonatomic,strong) CLLocation *startingPoint;
@property(nonatomic,strong)IBOutlet MKMapView* mapView;

//Data structures
@property(nonatomic,strong)NSDictionary* buildingcood;
@property(nonatomic,strong)NSDictionary* busList;
@property(nonatomic,weak)MapPoint* tempoint;

//UI Elements
@property(nonatomic,strong)IBOutlet UISegmentedControl*segmentControl;
@property(nonatomic,strong)IBOutlet UIImageView* arrow;
@property(nonatomic,strong)IBOutlet UILabel* distanceLabel;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView* activityInd;
@property(nonatomic,strong)IBOutlet UISegmentedControl* segmentMapType;
@property(nonatomic,strong)IBOutlet UIButton* clearButton;
@property(nonatomic,strong)IBOutlet UIToolbar* tool;
@property(nonatomic,strong)IBOutlet UIButton* buttonText;
@property(nonatomic,strong)IBOutlet UILabel* routeNameLabel;
@property(nonatomic,strong)IBOutlet UIToolbar* toolSelect;
@property(nonatomic,strong)IBOutlet UIButton* displayInfo;
@property(nonatomic,strong)IBOutlet UIButton* gpsButton;

//Routing objects
@property(nonatomic,strong)MapPoint* busPoint1;
@property(nonatomic,strong)IBOutlet UIView* routerView;
@property(nonatomic)BOOL shortestOrFastest;
@property(nonatomic,strong)IBOutlet UIImageView* googleImage;


-(void)goToMyPoint;                                                         //Move map to current location
-(void)loadPoints;                                                          //Load the map points from mapPointArray
-(void)NUSPins;                                                             //Load Faculty Pins (For Info Only)

-(void)addTiles;                                                            //Load the Map Tiles

-(void)busTracking:(NSString*)busName:(NSString*)busStop;                   //Bus Tracking

-(void)loadRouterView;                                                      //Loads the white routing window
-(void)closeRouterView;                                                     //Closes the routing window
-(void)routingActions:(int)value;                                           //Receive the option and perform action

-(double)getDistance:(MapPoint*)a:(MapPoint*)b;                             //Get Distance between 2 Map Points
-(MapPoint*)nearestAction:(double)type:(BOOL)returnPoint:(MapPoint*)from;   //Get nearest ATM etc.

-(IBAction)valuechanged:(id)sender;                                         //Select Campus Map Location
-(IBAction)mypoint:(id)sender;                                              //Go To Current Location
-(IBAction)clearpin:(id)sender;                                             //Clear all Pins
-(IBAction)gps:(id)sender;                                                  //Turn off GPS
-(IBAction)valuechangedMap:(id)sender;                                      //Map Type Changed (Satellite etc.)

-(IBAction)closePointSelect;                                                //Close the point selector
-(void)openSelector;                                                        //Open point selector
-(void)displayInfoBut;                                                      //Get Info of Map Point
-(IBAction)goRoute;                                                         //Select Tick in point selector
-(void)setter;                                                              //Function
-(void)actionsheet:(int)selection;                                          //Load correct action sheet function
-(void)writedata;                                                           //Add to Favourites


-(void)routingAlgorithm:(BOOL)selected;                                     //Begin routing algorithm
-(IBAction)close;                                                           //Close router
-(IBAction)addRoutes;                                                       //Hit next route
-(IBAction)backRoute:(id)sender;                                            //Hit Prev Route
-(IBAction)selectPointFoward;                                               //Move foward in current route
-(IBAction)selectPointBackward;                                             //Move backward in current route
-(IBAction)routeDetails;                                                    //Load text based route details
-(NSMutableArray*)cleanUpRoute:(NSMutableArray*)takeIn;                     //Clear junk values in current route

@end
