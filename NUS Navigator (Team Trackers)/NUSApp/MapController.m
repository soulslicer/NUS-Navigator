//
//  MapController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapController.h"
#import "PointDetails.h"
#import "GoogleRouteViewController.h"
#import "imageRotate.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"
#import "RouteParser.h"
#import "BusTracker.h"
#import "SVProgressHUD.h"
#import "RouteDetails.h"

/************************************************************************
 * GLOBAL OBJECTS/INTERFACE
 ************************************************************************/

//When more details is hit for a mappoint, this object is set and loaded
__strong PointDetails* pointDetails;

@interface MapController ()

@end

@implementation MapController
@synthesize buildingname,locationname,segmentControl;
@synthesize locationManager,startingPoint,mapView,buildingcood,tempoint,imagename,alias,mapInfoType,arrow,distanceLabel,mapPointArray,busList,activityInd,tool,buttonText,clearButton,routeNameLabel,toolSelect,displayInfo,segmentMapType,gpsButton,busPoint1,routerView,shortestOrFastest,googleImage;

/************************************************************************
 * NUS MAP OVERLAY FUNCTION CALLS
 ************************************************************************/

TileOverlay *overlay1;
TileOverlay *overlay2;
TileOverlay *overlay3;
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    if((overlay==routeLine) || (overlay==utownLine)){
        MKOverlayView* overlayView = nil;
        MKPolylineView* polyView;
        polyView=[[MKPolylineView alloc]initWithPolyline:overlay];
        polyView.fillColor=[UIColor redColor];
        polyView.strokeColor=[UIColor redColor];
        polyView.lineWidth=3;
        overlayView=polyView;
        return overlayView;
    }else if((overlay==overlay1) || (overlay==overlay2) || (overlay==overlay3)){
        TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:overlay];
        view.tileAlpha = 0.7;
        return view;
    }
return nil;
}

-(void)addTiles{
    self.mapView.mapType=MKMapTypeStandard;
    NSString *tileDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Tiles"];
    overlay1 = [[TileOverlay alloc] initWithTileDirectory:tileDirectory];
    [mapView addOverlay:overlay1];
    
    NSString *tileDirectory2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TilesUtown"];
    overlay2 = [[TileOverlay alloc] initWithTileDirectory:tileDirectory2];
    [mapView addOverlay:overlay2];
    
    NSString *tileDirectory3 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TilesBTC"];
    overlay3 = [[TileOverlay alloc] initWithTileDirectory:tileDirectory3];
    [mapView addOverlay:overlay3];
}

/************************************************************************
 * MAP FUNCTION CALLS
 ************************************************************************/

-(void)goToMyPoint{
    CLLocationCoordinate2D userCoordinate=self.locationManager.location.coordinate;
    MKCoordinateRegion reg=MKCoordinateRegionMakeWithDistance(userCoordinate, 350, 350);
    [self.mapView setRegion:reg animated:YES];
}

-(BOOL)swapBool:(BOOL)a{
    if(a==YES)
        return NO;
    else
        return YES;
}

-(void)loadPoints{
    hold=YES;
    
    //Counters for shifting
    int counterShift=0;
    BOOL swap=NO;
    
    //Scan through all points in Array
    for(MapPoint* mapPoint in self.mapPointArray){
        
        if([mapPoint.mapInfoType isEqualToString:@"Bus"]){
            NSArray* busArr=[busList objectForKey:mapPoint.alias];
            CLLocationCoordinate2D newCoord={ [[busArr objectAtIndex:1] doubleValue],[[busArr objectAtIndex:2] doubleValue]};
            [mapPoint initWithCoordinate:newCoord];
            
            //Scan for repeat Points. Temp becomes No if repeat point found
            BOOL norepeatpoint=YES;
            for(MapPoint* tempMap in self.mapView.annotations){
                if([mapPoint.title isEqualToString:tempMap.title] && [mapPoint.mapInfoType isEqualToString:tempMap.mapInfoType]){
                    hold=NO;
                    [mapView selectAnnotation:tempMap animated:YES];
                    norepeatpoint=NO;
                    break;
                }
            }
            
            if(norepeatpoint){
                hold=NO;
                [self.mapView addAnnotation:mapPoint];
            }
            
        }else if([mapPoint.mapInfoType isEqualToString:@"Carpark"]){
            
            NSArray* carArr=[carList objectForKey:mapPoint.alias];
            CLLocationCoordinate2D newCoord={ [[carArr objectAtIndex:1] doubleValue],[[carArr objectAtIndex:2] doubleValue]};
            [mapPoint initWithCoordinate:newCoord];
            
            //Scan for repeat Points. Temp becomes No if repeat point found
            BOOL norepeatpoint=YES;
            for(MapPoint* tempMap in self.mapView.annotations){
                if([mapPoint.title isEqualToString:tempMap.title]){
                    hold=NO;
                    [mapView selectAnnotation:tempMap animated:YES];
                    norepeatpoint=NO;
                    break;
                }
            }
            
            if(norepeatpoint){
                hold=NO;
                [self.mapView addAnnotation:mapPoint];
            }
            
        }else{
            //Coods for MapPoint. MapPoint currently has everything except coods
            NSArray* tempArr=[buildingcood valueForKey:mapPoint.subTitle]; //Coods for MapPoint
            NSString* tempLat=[tempArr objectAtIndex:1];
            NSString* tempLong=[tempArr objectAtIndex:2];
            CLLocationCoordinate2D newCoord={ [tempLat floatValue],[tempLong floatValue]};
            
            //Hence we add in the Coods
            [mapPoint initWithCoordinate:newCoord];
            
            //Scan for repeat Points. Temp becomes No if repeat point found
            BOOL norepeatpoint=YES;
            for(MapPoint* tempMap in self.mapView.annotations){
                if([mapPoint.title isEqualToString:tempMap.title]){
                    hold=NO;
                    [mapView selectAnnotation:tempMap animated:YES];
                    norepeatpoint=NO;
                    break;
                }
            }
            
            //If no repeat point was found
            if(norepeatpoint){
                hold=NO;
                //Shift for same points
                for(MapPoint* tempMap in self.mapView.annotations){
                    if(mapPoint.coordinate.latitude==tempMap.coordinate.latitude){
                        
                        //ShiftingCode
                        if(swap)
                            [mapPoint shiftlat];
                        else
                            [mapPoint shiftlong];
                        counterShift++;
                        
                        if(counterShift>=5){
                            swap=[self swapBool:swap];
                            counterShift=0;
                        }
                        //Shiftingcodeend
                    }
                }
                
                [self.mapView addAnnotation:mapPoint];
            }
            
        }
        
        
    }//end of for loop
    
    [SVProgressHUD dismiss];
    
}

-(void)NUSPins{
    NSString *paths = [[NSBundle mainBundle] pathForResource:@"InitialMapPoints" ofType:@"plist"];
    NSDictionary* initPoints=[[NSDictionary alloc]initWithContentsOfFile:paths];
    NSArray* scanArray=[initPoints allKeys];
    for(NSString* key in scanArray){
        MapPoint* newPoint=[[MapPoint alloc]init]; newPoint.mapInfoType=@"FAC";
        NSArray* aPoint=[initPoints objectForKey:key];
        CLLocationCoordinate2D newCoord={ [[aPoint objectAtIndex:0] doubleValue],[[aPoint objectAtIndex:1] doubleValue]};
        [newPoint initWithCoordinate:newCoord];
        newPoint.title=key;
        newPoint.alias=[aPoint objectAtIndex:2];
        hold=YES;
        [mapView addAnnotation:newPoint];
        hold=YES;
    }
}


/************************************************************************
 * ROUTER UI FUNCTION CALLS
 ************************************************************************/

-(void)loadRouterView{
    NSLog(@"Load Router");
    rV=[[RouterView alloc]init];
    rV.mapController=self;
    rV.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    rV.view.opaque = NO;
    routerView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.0];
    routerView.opaque=NO;
    routerView.alpha=0.8;
    routerView.hidden=NO;
    [UIView transitionWithView:self.routerView duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromBottom //change to whatever animation you like
                    animations:^ { [self.routerView addSubview:rV.view]; }
                    completion:nil];
}

-(void)closeRouterView{
    [UIView animateWithDuration:0.4
                     animations:^{routerView.alpha = 0.0;}
                     completion:^(BOOL finished){    for (UIView *viewb in [self.routerView subviews]) {
        [viewb removeFromSuperview];
    }
                         routerView.hidden=YES;}];


}

-(void)routingActions:(int)value{
    switch (value) {
        case 0://Nearest Bus-Stop
            NSLog(@"Nearest Bus-Stop");
            [self nearestAction:0 :NO :tempoint];
            break;
        case 1://Nearest Bus-Stop Opposite
            NSLog(@"Nearest Bus-Stop");
            [self nearestAction:0.5 :NO :tempoint];
            break;
        case 2://Nearest CarPark Visitor
            NSLog(@"Nearest Car-Park Visitor");
            [self nearestAction:4 :NO :tempoint];
            break;
        case 3://Nearest CarPark All
            NSLog(@"Nearest Car-Park Visitor");
            [self nearestAction:3 :NO :tempoint];
            break;
        case 4:{//CurrPoint Driving
            NSLog(@"Curr Point Driving");
            if(gpsBool==NO){
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Turn On GPS" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]; [alert show];
            }else{
                GoogleRouteViewController* googleView=[[GoogleRouteViewController alloc]init];
                googleView.start=self.startingPoint;
                googleView.transfer=tempoint;
                [self presentModalViewController:googleView animated:YES];
            }
            break;
        }
        case 5:{//CurrPoint Shuttle
            NSLog(@"Curr Shuttle");
            if(gpsBool==NO){
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Turn On GPS" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]; [alert show];
            }else{
                [self routingAlgorithm:NO];
            }
            break;
        }
        case 6:
            NSLog(@"Selected Point Driving");
            googleMap=YES;
            [self openSelector];
            break;
        case 7:
            NSLog(@"Selected Point Shuttle");
            [self openSelector];
            break;
            
            
        default:
            break;
    }
}

/************************************************************************
 * CONSTRUCTOR FUNCTIONS + TAP AND HOLD
 ************************************************************************/

- (void)viewDidLoad
{
    gpsBool=YES;
    NSLog(@"View Did Load");
    self.title=@"Map";
    
    //  1. Load all Data structure from file
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath1 = [path1 stringByAppendingPathComponent:@"Building_Cood.plist"];
    buildingcood=[[NSDictionary alloc]initWithContentsOfFile:plistpath1];
    
    NSString *path6 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath6 = [path6 stringByAppendingPathComponent:@"BusLocation.plist"];
    busList=[[NSDictionary alloc]initWithContentsOfFile:plistpath6];
    
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"CarPark" ofType:@"plist"];
    carList=[[NSDictionary alloc]initWithContentsOfFile:path3];
    
    //  2. Load Location Manager
    self.locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    NSLog(@"%@", [CLLocationManager headingAvailable]?@"YES":@"NO");
    if([CLLocationManager headingAvailable]){
        [locationManager startUpdatingHeading]; 
    }

    //  3. Set Region to middle of NUS Map
    [self.mapView setShowsUserLocation:YES];
    hold=YES;
    mapView.delegate=self;
    CLLocationCoordinate2D nusCod={1.29441,103.773723};
    MKCoordinateRegion nusReg=MKCoordinateRegionMakeWithDistance(nusCod ,350,350);
    [mapView setRegion:nusReg animated:YES];
    
    //  4. Tap and hold gesture
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    self.activityInd.hidden=YES;
    
    //  5. Load NUS Faculty Pins
    //alertNUSPins=[[UIAlertView alloc]initWithTitle:nil message:@"Would you like to view Faculty Locations?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil]; [alertNUSPins show];
    
    [super viewDidLoad];   
}

-(void)setter{
    checker=YES;
}

-(void)viewDidAppear:(BOOL)animated{
    //self.navigationController.navigationBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
    if(checker==YES){
        checker=NO;
        [self loadPoints];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MapPoint* comparePoint=[[MapPoint alloc]init];
    [comparePoint initWithCoordinate:touchMapCoordinate];
    
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* pathfulllist = [path1 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
    NSDictionary* buildingFullList=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
    NSMutableArray* MPA=[[NSMutableArray alloc]init];
    
    NSArray* buildingKeys=[buildingFullList allKeys];
    double smallestvalue=10000;
    for(NSString* key in buildingKeys){
        NSArray* singlePoint=[buildingFullList objectForKey:key];//Building info
        NSString* buildname=[singlePoint objectAtIndex:3];
        NSArray* coodInfo=[self.buildingcood objectForKey:buildname];//Get cood array
        CLLocationCoordinate2D newCoord={ [[coodInfo objectAtIndex:1] doubleValue],[[coodInfo objectAtIndex:2] doubleValue]};
        
        MapPoint* addPoint=[[MapPoint alloc]init];
        [addPoint initWithCoordinate:newCoord];
        addPoint.title=[singlePoint objectAtIndex:0];
        addPoint.subTitle=[singlePoint objectAtIndex:3];
        addPoint.imagename=[singlePoint objectAtIndex:2];
        addPoint.alias=[singlePoint objectAtIndex:1];
        addPoint.mapInfoType=[singlePoint objectAtIndex:2];
        
        if(!([addPoint.mapInfoType isEqualToString:@"Bus"] && [addPoint.mapInfoType isEqualToString:@"Room"] && [addPoint.mapInfoType isEqualToString:@"Carpark"]))
            addPoint.mapInfoType=@"Normal";
        
        if([self getDistance:comparePoint :addPoint]<smallestvalue){
            smallestvalue=[self getDistance:comparePoint :addPoint];
            [MPA removeAllObjects];
            [MPA addObject:addPoint];
        }
        
    }
    
    MapPoint* cPoint=[MPA objectAtIndex:0];
    
    //This code adds in the similar points
    for(NSString* key in buildingKeys){
        NSArray* singlePoint=[buildingFullList objectForKey:key];//Building info
        NSString* buildname=[singlePoint objectAtIndex:3];
        NSArray* coodInfo=[self.buildingcood objectForKey:buildname];//Get cood array
        CLLocationCoordinate2D newCoord={ [[coodInfo objectAtIndex:1] doubleValue],[[coodInfo objectAtIndex:2] doubleValue]};
        
        MapPoint* addPoint=[[MapPoint alloc]init];
        [addPoint initWithCoordinate:newCoord];
        addPoint.title=[singlePoint objectAtIndex:0];
        addPoint.subTitle=[singlePoint objectAtIndex:3];
        addPoint.imagename=[singlePoint objectAtIndex:2];
        addPoint.alias=[singlePoint objectAtIndex:1];
        addPoint.mapInfoType=[singlePoint objectAtIndex:2];
        
        
        
        if([self getDistance:cPoint :addPoint]==0){
            [MPA addObject:addPoint];
        }
    }
    
    self.mapPointArray=MPA;
    [self loadPoints];
    
}

/************************************************************************
 * BUS TRACKING (NO LONGER AVAILABLE)
 ************************************************************************/

-(void)busTracking:(NSString*)busName:(NSString*)busStop{
    busPoint1=[[MapPoint alloc]init]; busPoint1.mapInfoType=@"BusTracker"; busPoint1.title=busName;
    CLLocationCoordinate2D newCoord={1.2988256459765393,103.77426996479855}; [busPoint1 initWithCoordinate:newCoord];
    //hold=YES;
    [self.mapView addAnnotation:busPoint1];
    
    busTracker=[[BusTracker alloc]initWithInfo:busName :busStop];
    busTracker.mapController=self;
    [busTracker startTrack];
    
    MKCoordinateRegion reg=MKCoordinateRegionMakeWithDistance(busPoint1.coordinate ,350,350);
    [self.mapView setRegion:reg animated:YES];
    //[busTracker stopTrack];
}

/************************************************************************
 * ALERT AND ACTION DELEGATES
 ************************************************************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView==alert1){
        //NONE YET
    }else if(alertView==alert2){
        if(buttonIndex==0){//visitor
            MapPoint* start=[[MapPoint alloc]init];
            [start initWithCoordinate:startingPoint.coordinate];
            [self nearestAction:4 :NO :start];
        }else if(buttonIndex==1){//all
            MapPoint* start=[[MapPoint alloc]init];
            [start initWithCoordinate:startingPoint.coordinate];
            [self nearestAction:3 :NO :start];
        }
    }else if(alertView==alert3){
        if(buttonIndex==0){//bustop
            [self nearestAction:0 :NO :tempoint];
        }else if(buttonIndex==1){//carpark
            alert4=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Visitor",@"All", nil];
            [alert4 show];
        }else if(buttonIndex==2){
            alertGoogle=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"From Current Loc",@"From Selected", nil];
            [alertGoogle show];
        }else if(buttonIndex==3){
            alertSelectRoute=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"From Current Loc",@"From Selected", nil];
            [alertSelectRoute show];
        }
    }else if(alertView==alert4){
        if(buttonIndex==0){//visitor
            [self nearestAction:4 :NO :tempoint];
        }else if(buttonIndex==1){//all
            [self nearestAction:3 :NO :tempoint];
        }
    }else if(alertView==alertSelectRoute){
        if(buttonIndex==0){
            if(gpsBool==NO){
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Turn On GPS" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]; [alert show];
            }else{
                [self routingAlgorithm:NO];
            }
        }else if(buttonIndex==1){
            [self openSelector];
        }
    }else if(alertView==alertGoogle){
        if(buttonIndex==0){
            if(gpsBool==NO){
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please Turn On GPS" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]; [alert show];
            }else{
                GoogleRouteViewController* googleView=[[GoogleRouteViewController alloc]init];
                googleView.start=self.startingPoint;
                googleView.transfer=tempoint;
                [self presentModalViewController:googleView animated:YES];
            }
        }else if(buttonIndex==1){
            googleMap=YES;
            [self openSelector];
        }
    }else if(alertView==alertNUSPins){
        if(buttonIndex==0)
            [self NUSPins];
    }
    
    
}

#pragma mark-
#pragma mark ActionSheet Methods

-(void)actionsheet:(int)selection{
    if(selection==0){
        actionSheet1 = [[UIActionSheet alloc]
                        initWithTitle:@"Please select your option"
                        delegate:self
                        cancelButtonTitle:@"Cancel"
                        destructiveButtonTitle:@"Remove Point"
                        otherButtonTitles:@"More Details",@"Add to Favourites",@"Route",nil];
        [actionSheet1 showFromTabBar:self.tabBarController.tabBar];
    }else{
        actionSheet2=[[UIActionSheet alloc]initWithTitle:@"Please select your option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Nearest Bus-Stop",@"Nearest Eating Place",@"Nearest $",@"Nearest Parking", nil];
        [actionSheet2 showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(actionSheet==actionSheet1){
        switch (buttonIndex) {
            case 0://Remove
                [self.mapView removeAnnotation:tempoint];
                break;
                
            case 1:{//More Details
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                pointDetails=[[PointDetails alloc]initWithNibName:@"PointDetails" bundle:nil];
                pointDetails.hideNavBar=YES;
                [pointDetails loadarray:tempoint.title :tempoint.alias :tempoint.imagename :tempoint.subTitle :tempoint.mapInfoType];
                pointDetails.mapController=self;
                pointDetails.hidesBottomBarWhenPushed=YES;
                
                [self performSelector:@selector(pushPoint) withObject:nil afterDelay:0.5];
                                
                break;
            }
                
            case 2:{//Add to Fac
                [self writedata];
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Favourites" message:@"Added to Favourites" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
                
            case 3:{//Route
                [self loadRouterView];
                break;
            }
                
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:{
                NSLog(@"RUN");
                MapPoint* start=[[MapPoint alloc]init];
                [start initWithCoordinate:startingPoint.coordinate];
                [self nearestAction:0 :NO :start];
                break;
            }
                
            case 1:{
                MapPoint* start=[[MapPoint alloc]init];
                [start initWithCoordinate:startingPoint.coordinate];
                [self nearestAction:1 :NO :start];
                break;
            }
                
            case 2:{
                MapPoint* start=[[MapPoint alloc]init];
                [start initWithCoordinate:startingPoint.coordinate];
                [self nearestAction:2 :NO :start];
                break;
            }
                
            case 3:{//Nearest Carpark
                alert2=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Visitor",@"All", nil];
                [alert2 show];
                break;
            }
                
            default:
                break;
        }
    }
}


/************************************************************************
 * UI IBACTION HANDLERS
 ************************************************************************/

-(IBAction)gps:(id)sender{
    if(gpsBool==YES){
        mapView.showsUserLocation = NO;
        [self.gpsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [locationManager stopUpdatingLocation];
        [locationManager stopUpdatingHeading];
        gpsBool=[self swapBool:gpsBool];
    }else{
        mapView.showsUserLocation = YES;
        [self.gpsButton setTitleColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingHeading];
        gpsBool=[self swapBool:gpsBool];
    }
}


-(IBAction)mypoint:(id)sender{
    [self goToMyPoint];
    [segmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

-(IBAction)clearpin:(id)sender{

    hold=YES;
    [mapView removeAnnotations:mapView.annotations]; 
    if(busTracker!=nil)
        [busTracker stopTrack];
    //[self gotomypoint];

}

-(IBAction)valuechanged:(id)sender{
    if(sender==segmentControl){
        switch(segmentControl.selectedSegmentIndex)
        {
            case 0:
            {
                NSLog(@"nusCod");
                CLLocationCoordinate2D nusCod={1.29441,103.773723};
                MKCoordinateRegion nusReg=MKCoordinateRegionMakeWithDistance(nusCod ,350,350);
                [mapView setRegion:nusReg animated:NO];
                break;
            }
            case 1:
            {
                NSLog(@"btc");
                CLLocationCoordinate2D btcCod={1.318951,103.817539};
                MKCoordinateRegion btcReg=MKCoordinateRegionMakeWithDistance(btcCod ,350,350);
                [mapView setRegion:btcReg animated:NO];
                break;
            }
        }
    }
}


-(IBAction)valuechangedMap:(id)sender{
    switch(segmentMapType.selectedSegmentIndex)
    {
        case 2:{
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText=@"Campus";
            [HUD showWhileExecuting:@selector(addTiles) onTarget:self withObject:nil animated:YES];
            break;
        }
        case 1: //Satellite 
            [self.mapView removeOverlays:[self.mapView overlays]];
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 0:  //Map 
            [self.mapView removeOverlays:[self.mapView overlays]];
            self.mapView.mapType = MKMapTypeStandard;
            break;
    }

}

-(IBAction)pushPoint{
    [self.navigationController pushViewController:pointDetails animated:YES];
    [SVProgressHUD dismiss];
    
}


/************************************************************************
 * MAP/LOCATION MANAGER/COMPASS DELEGATES
 ************************************************************************/

#pragma mark-
#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    //if(startingPoint==nil)
        self.startingPoint=newLocation;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location"
                                                    message:errorType delegate:nil
                                          cancelButtonTitle:@"Okay" otherButtonTitles:nil]; [alert show];
}

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate; 
    //hold=YES; //CHECK THIS
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{    
    if(hold!=YES){
        id<MKAnnotation> mp = [mapPointArray objectAtIndex:0];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,350,350);
        [mv setRegion:region animated:YES];    
        [mapView selectAnnotation:mp animated:YES];
        }
    hold=YES;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    MapPoint* a=[view annotation];
    MapPoint* start=[[MapPoint alloc]init];
    [start initWithCoordinate:startingPoint.coordinate];
    double distance=[self getDistance:a :start];
    NSString *distanceString = [[NSString alloc] initWithFormat: @"%1.1f",distance];
    distanceLabel.text=[NSString stringWithFormat:@"%@ m",distanceString];
    
    if([a.title isEqualToString:@"Current Location"]){
        [self actionsheet:1];
    }
    
    if(selectorOn==YES){
        selectedPoint=a;
        [self displayInfoBut];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil; 
    
    NSString *annotationIdentifier = @"PinViewAnnotation"; 
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];

    MapPoint* temp=annotation;
    
    if(![temp.mapInfoType isEqualToString:@"BusTracker"]){
        pinView = [[MKPinAnnotationView alloc] 
                   initWithAnnotation:annotation 
                   reuseIdentifier:annotationIdentifier];
        
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        // Create a UIButton object to add on the  right
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [pinView setRightCalloutAccessoryView:rightButton];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [leftButton setTitle:annotation.title forState:UIControlStateNormal];
        [pinView setLeftCalloutAccessoryView:leftButton];
        
        if([temp.mapInfoType isEqualToString:@"Bus"]){
            [pinView setPinColor:MKPinAnnotationColorRed];
        }else if([temp.mapInfoType isEqualToString:@"Carpark"]){
            [pinView setPinColor:MKPinAnnotationColorPurple];
        }else{
            [pinView setPinColor:MKPinAnnotationColorGreen];
        }
        
        UIImageView *houseIconView;
        
        if([temp.imagename isEqualToString:@"Food"] || [temp.imagename isEqualToString:@"Canteen"] || [temp.alias isEqualToString:@"Canteen"] || [temp.alias isEqualToString:@"Food"]){
            houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Food.png"]];
        }else if([temp.imagename isEqualToString:@"Library"] || [temp.alias isEqualToString:@"Library"]){
            houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Library.png"]];
        }else if([temp.imagename isEqualToString:@"Room"] || [temp.alias isEqualToString:@"Room"]){
            houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"door.png"]];
        }else if([temp.imagename isEqualToString:@"Money"] || [temp.alias isEqualToString:@"Money"]){
            houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money.png"]];
        }else if([temp.imagename isEqualToString:@"Bus"] || [temp.alias isEqualToString:@"Bus"]){
            houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bus.png"]];
        }else if([temp.imagename isEqualToString:@"Carpark"] || [temp.alias isEqualToString:@"Carpark"]){
            houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parking.png"]];
        }else{
            houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"house.png"]];
        }
        
        [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
        pinView.leftCalloutAccessoryView = houseIconView; 
        
        return pinView; 
        
    }else{
        MKAnnotationView* a = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annot2"];
        a.enabled = YES;
        a.canShowCallout=YES;
        a.image = [UIImage imageNamed:@"busIcon.png"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [a setRightCalloutAccessoryView:rightButton];
        return a;

    }

    
}

- (void)mapView:(MKMapView *)mapView 
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if(selectorOn==YES){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Disabled while selector active" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
            tempoint=[view annotation];
            [self actionsheet:0];
        } else if([(UIButton*)control buttonType] == UIButtonTypeInfoLight) {
            [busTracker stopTrack];
            busTracker=nil;
        }
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
        self.activityInd.hidden=YES;
        [activityInd stopAnimating];
    
}

-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    self.activityInd.hidden=NO;
    [activityInd startAnimating];
}

//Compass
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    double rotation = newHeading.magneticHeading * 3.14159 / 180;    
    [self.arrow setTransform:CGAffineTransformMakeRotation(-rotation)];
}

/************************************************************************
 * ALGORITHM FUNCTIONS
 ************************************************************************/

-(double)getDistance:(MapPoint*)a:(MapPoint*)b{
    CLLocation* apoint=[[CLLocation alloc]initWithLatitude:a.coordinate.latitude longitude:a.coordinate.longitude];
    CLLocation* bpoint=[[CLLocation alloc]initWithLatitude:b.coordinate.latitude longitude:b.coordinate.longitude];
    CLLocationDistance distance = [apoint distanceFromLocation:bpoint];
    return distance;
}

-(MapPoint*)nearestAction:(double)type:(BOOL)returnPoint:(MapPoint*)from{
    NSMutableArray* MPA=[[NSMutableArray alloc]init];
    if((type==0)||(type==0.5)){//Nearest Bus Stop
        hold=NO;
        double smallestdistance=10000000;
        NSArray* busKeyss=[busList allKeys];
        for(NSString* busKeym in busKeyss){
            NSArray* busInfo=[busList objectForKey:busKeym]; //Single mappoint
            CLLocationCoordinate2D newCoord={ [[busInfo objectAtIndex:1] doubleValue],[[busInfo objectAtIndex:2] doubleValue]};
            
            NSString *pathbus = [[NSBundle mainBundle] pathForResource:@"BusStopServices" ofType:@"plist"];
            NSDictionary *busStopServices = [[NSDictionary alloc] initWithContentsOfFile:pathbus];
            NSArray* busLister=[busStopServices objectForKey:busKeym];
            NSMutableString* result=[[NSMutableString alloc]init];
            for(NSString* bus in busLister){
                [result appendString:bus];
                [result appendString:@","];
            }
            
            MapPoint* busPoints=[[MapPoint alloc]init];
            [busPoints initWithCoordinate:newCoord];
            busPoints.title=[busInfo objectAtIndex:0];
            busPoints.subTitle=result;
            busPoints.imagename=@"Bus";
            busPoints.alias=busKeym;
            busPoints.mapInfoType=@"Bus";
            
            if(([self getDistance:busPoints :from]<=smallestdistance) && ([self getDistance:busPoints :from]!=0)){
                smallestdistance=[self getDistance:busPoints :from];
                [MPA removeAllObjects];
                [MPA addObject:busPoints];
            }
        }
        
    }else if(type==1){//Food Place nearest
        
        NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* pathfulllist = [path1 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
        NSDictionary* buildingFullList=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
        
        NSArray* allKeys=[buildingFullList allKeys];
        NSMutableArray* foodKeys=[[NSMutableArray alloc]init];
        
        for(NSString* key in allKeys){
            NSArray* singleElem=[buildingFullList objectForKey:key];
            NSString* nearalias=[singleElem objectAtIndex:2];
            if([nearalias isEqualToString:@"Food"] || [nearalias isEqualToString:@"Canteen"])
                [foodKeys addObject:key];
        }
        
        double smallestdistance=10000;
        for(NSString* key in foodKeys){
            NSArray* singleElem=[buildingFullList objectForKey:key];
            NSString* buildname=[singleElem objectAtIndex:3];//buildingname
            NSArray* buildingElem=[self.buildingcood objectForKey:buildname];
            CLLocationCoordinate2D newCoord={ [[buildingElem objectAtIndex:1] doubleValue],[[buildingElem objectAtIndex:2] doubleValue]};
            
            MapPoint* foodPoint=[[MapPoint alloc]init];
            [foodPoint initWithCoordinate:newCoord];
            foodPoint.title=key;
            foodPoint.subTitle=buildname;
            foodPoint.imagename=[singleElem objectAtIndex:2];
            foodPoint.alias=[singleElem objectAtIndex:1];
            foodPoint.imagename=[singleElem objectAtIndex:2];
            foodPoint.mapInfoType=[singleElem objectAtIndex:2];
            
            if([self getDistance:foodPoint :from]<=smallestdistance){
                smallestdistance=[self getDistance:foodPoint :from];
                [MPA removeAllObjects];
                [MPA addObject:foodPoint];
                MapPoint* tempM=[MPA objectAtIndex:0];
                NSLog(@"Adding: %@",tempM.title);
            }
        }
        

        
    }else if(type==2){//Money Place nearest
        
        NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* pathfulllist = [path1 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
        NSDictionary* buildingFullList=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
        
        NSArray* allKeys=[buildingFullList allKeys];
        NSMutableArray* foodKeys=[[NSMutableArray alloc]init];
        
        for(NSString* key in allKeys){
            NSArray* singleElem=[buildingFullList objectForKey:key];
            NSString* nearalias=[singleElem objectAtIndex:2];
            if([nearalias isEqualToString:@"Money"])
                [foodKeys addObject:key];
        }
        
        double smallestdistance=10000;
        for(NSString* key in foodKeys){
            NSArray* singleElem=[buildingFullList objectForKey:key];
            NSString* buildname=[singleElem objectAtIndex:3];//buildingname
            NSArray* buildingElem=[self.buildingcood objectForKey:buildname];
            CLLocationCoordinate2D newCoord={ [[buildingElem objectAtIndex:1] doubleValue],[[buildingElem objectAtIndex:2] doubleValue]};
            
            MapPoint* foodPoint=[[MapPoint alloc]init];
            [foodPoint initWithCoordinate:newCoord];
            foodPoint.title=key;
            foodPoint.subTitle=buildname;
            foodPoint.imagename=[singleElem objectAtIndex:2];
            foodPoint.alias=[singleElem objectAtIndex:1];
            foodPoint.imagename=[singleElem objectAtIndex:2];
            foodPoint.mapInfoType=[singleElem objectAtIndex:2];
            
            if([self getDistance:foodPoint :from]<=smallestdistance){
                smallestdistance=[self getDistance:foodPoint :from];
                [MPA removeAllObjects];
                [MPA addObject:foodPoint];
            }
        }
    
    }else if((type==3) || (type==4)){//Nearest Carpark
        
        hold=NO;
        double smallestdistance=10000000;
        NSArray* carKeys=[carList allKeys];
        
        if(type==4){
            NSLog(@"called splice");
            NSMutableArray* newArr=[[NSMutableArray alloc]init];
            for(NSString* carKey in carKeys){
                NSArray* carInfo=[carList objectForKey:carKey];
                NSString* carType=[carInfo objectAtIndex:3];
                if([carType isEqualToString:@"Visitor"] || [carType isEqualToString:@"Visitor 2"])
                    [newArr addObject:carKey];
            }
            carKeys=[NSArray arrayWithArray:newArr];
        }
        
        
        for(NSString* carKey in carKeys){
            NSArray* carInfo=[carList objectForKey:carKey]; //Single mappoint
            CLLocationCoordinate2D newCoord={ [[carInfo objectAtIndex:1] doubleValue],[[carInfo objectAtIndex:2] doubleValue]};
            
            MapPoint* carPoint=[[MapPoint alloc]init];
            [carPoint initWithCoordinate:newCoord];
            carPoint.title=[carInfo objectAtIndex:0];
            carPoint.subTitle=[carInfo objectAtIndex:3];
            carPoint.imagename=@"Carpark";
            carPoint.alias=carKey;
            carPoint.mapInfoType=@"Carpark";
            
            if(([self getDistance:carPoint :from]<=smallestdistance) && ([self getDistance:carPoint :from]!=0)){
                smallestdistance=[self getDistance:carPoint :from];
                [MPA removeAllObjects];
                [MPA addObject:carPoint];
            }
        }
    }
    
    if(returnPoint==YES)
        return [MPA objectAtIndex:0];
    else{
        if(type==0.5){
            [self nearestAction:0 :NO :[MPA objectAtIndex:0]];
        }else{
        self.mapPointArray=MPA;
        [self loadPoints];
        }
    }
    return nil;
    
}

/************************************************************************
 * ROUTING ALGORITHM
 ************************************************************************/

//Generate Opposite Bus Stop
-(MapPoint*)busOppGenerator:(MapPoint*)busStart:(BOOL)oppBool{
    NSString* opp;
    if(oppBool==YES)
        opp=[oppBusstops objectForKey:busStart.alias];
    else{
        opp=busStart.alias;
    }
    
    if(![opp isEqualToString:@"None"]){
        NSArray* busInfo=[busList objectForKey:opp];
        CLLocationCoordinate2D newCoord={ [[busInfo objectAtIndex:1] doubleValue],[[busInfo objectAtIndex:2] doubleValue]};
        
        NSString *pathbus = [[NSBundle mainBundle] pathForResource:@"BusStopServices" ofType:@"plist"];
        NSDictionary *busStopServices = [[NSDictionary alloc] initWithContentsOfFile:pathbus];
        NSArray* busLister=[busStopServices objectForKey:opp];
        NSMutableString* result=[[NSMutableString alloc]init];
        for(NSString* bus in busLister){
            [result appendString:bus];
            [result appendString:@","];
        }
        
        MapPoint* busPoints=[[MapPoint alloc]init];
        [busPoints initWithCoordinate:newCoord];
        busPoints.title=[busInfo objectAtIndex:0];
        busPoints.subTitle=result;
        busPoints.imagename=@"Bus";
        busPoints.alias=opp;
        busPoints.mapInfoType=@"Bus";
        return busPoints;
    }
    return nil;
   
}

//Check if that string is a number
BOOL isNumeric(NSString *s)
{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}

//Perform the routing between two points
-(NSMutableArray*)actualRouting:(MapPoint*)pointA:(MapPoint*)pointB:(NSString*)title:(NSString*)bus:(BOOL)simpleRouting{
    
    NSMutableArray* routeArray=[[NSMutableArray alloc]init];//Here we add the route points
    NSArray* routecheck=[busRoutes objectForKey:bus];//Actual route of bus

    //Get index of pointA and pointB
    NSInteger indA=[routecheck indexOfObject:pointA.alias];
    NSInteger indB=[routecheck indexOfObject:pointB.alias];
    
    //LOOP AND ADD POINTS
    BOOL DBUSFAIL=NO;
    @try{
    if(indA<indB){//Foward path
        //PLEASE CHECK THIS
        @try{
        for(int i=indA;i<=indB;i++){
            //printf("%i ",i);
            MapPoint* temps=[[MapPoint alloc]init]; temps.alias=[routecheck objectAtIndex:i];
            MapPoint* toAdd=[self busOppGenerator:temps :NO];
            NSLog(@"%@",toAdd.title);
            toAdd.bus=bus;
            [routeArray addObject:toAdd];
        }
        }@catch (NSException* exp) {
            return nil;
        }

    }
    else{//Loop out
        if([bus isEqualToString:@"D1"] || [bus isEqualToString:@"D2"]){
            //NSLog(@"D1 and D2 cannot loop stops here");
            DBUSFAIL=YES;
        }else{
            NSInteger totalInt=[routecheck count]-1;
            int i=indA;
            while(1){
                if(i==totalInt+1){
                    if(!([bus isEqualToString:@"D1"] || [bus isEqualToString:@"D2"]) && indB==0)
                        i=0;
                    else
                        i=1;
                }
                MapPoint* temps=[[MapPoint alloc]init]; temps.alias=[routecheck objectAtIndex:i];
                MapPoint* toAdd=[self busOppGenerator:temps :NO];
                toAdd.bus=bus;
                [routeArray addObject:toAdd];
                
                i++;
            
                if(i==indB+1)
                    break;
            }
        }
    }
    }@catch (NSException* exp) {
        return nil;
    }

    //Add to Dict
    if(DBUSFAIL==NO)
        return routeArray;
    else
        return nil;
}

//Backtracking from a certain point
-(NSMutableArray*)backTrack:(MapPoint*)pointB:(NSArray*)busStartList:(NSArray*)busEndList:(MapPoint**)changePoint:(NSString**)busToChange:(BOOL)foward{
    
    NSString *pathbus = [[NSBundle mainBundle] pathForResource:@"BusStopServices" ofType:@"plist"];
    NSDictionary *busStopServices = [[NSDictionary alloc] initWithContentsOfFile:pathbus];
    NSMutableArray* backTrackArray=[[NSMutableArray alloc]init];
    
    NSMutableArray* busStartArray=[NSMutableArray arrayWithArray:busStartList];
    NSMutableArray* busEndArray=[NSMutableArray arrayWithArray:busEndList];
    for(NSString* as in busStartList){
        if([as isEqualToString:@""])
            [busStartArray removeObject:as];
        else{
            NSString * newStrings = [as substringWithRange:NSMakeRange(0, 1)];
            unichar a=[newStrings characterAtIndex:0];
            if(isdigit(a))
                [busStartArray removeObject:as];
        }
    }
    for(NSString* as in busEndList){
        if([as isEqualToString:@""])
            [busEndArray removeObject:as];
        else{
            NSString * newStrings = [as substringWithRange:NSMakeRange(0, 1)];
            unichar a=[newStrings characterAtIndex:0];
            if(isdigit(a))
                [busEndArray removeObject:as];
        }
    }
    
    //Backtrack point B till a matching bus found
    NSString* bus=[busEndArray objectAtIndex:0]; //choose random first bus to backtrack
    pointB.bus=bus;
    [backTrackArray addObject:pointB];//add first point
    
    //Get route of that random bus and get some values
    NSArray* routecheck=[busRoutes objectForKey:bus];
    NSInteger index=[routecheck indexOfObject:pointB.alias];
    NSInteger backIndex;
    if(!([bus isEqualToString:@"D1"] || [bus isEqualToString:@"D2"])){//if not d1/d2
        NSLog(@"backtrack called");
        if([bus isEqualToString:@"A1"]){
                //backIndex=14;
            backIndex=15;
        }
        if([bus isEqualToString:@"A2"]){
                //backIndex=15;
            backIndex=17;
        }
        if([bus isEqualToString:@"B"]){
                backIndex=13;
        }
        if([bus isEqualToString:@"C"]){
                backIndex=9;
        }
        //backIndex++;
    }else{//Bus D1 D2, if 0 NO BUS CAN BACKTRACk
        if(index==0){
            //NSLog(@"BUS D CANNOT BACKTRACK FURTHER");
            return nil;
        }
    }
    
    int ix; BOOL endloop=NO;
    if(index==0){
        ix=backIndex;
    }else{
        if(foward==NO)
            ix=index-1;
        else
            ix=index+1;
    }
    @try{
    while(1){
        //NSLog(@"checking index %i",ix);
        NSString* m=[routecheck objectAtIndex:ix];
        NSArray* busStopsFor=[busStopServices objectForKey:m];
        MapPoint* temp=[[MapPoint alloc]init];temp.alias=m; MapPoint* toAdd=[self busOppGenerator:temp :NO];
        
        NSString* asbus=bus;
        for(NSString* bus in busStartArray){//Scan through buses at start while backtracking
            for(NSString* bus2 in busStopsFor){
                if([bus isEqualToString:bus2]){
                    *busToChange=bus;
                    endloop=YES;
                    toAdd.bus=asbus;
                    [backTrackArray addObject:toAdd];
                    break;
                }
            }
            
            if(endloop==YES)
                break;
        }
        
        if(endloop==YES)
            break;
        
        toAdd.bus=bus;
        [backTrackArray addObject:toAdd];
        
        if(foward==NO)
            ix-=1;
        else
            ix+=1;
        
        if(foward==NO){
            if(ix<0){
                ix=backIndex;
            }
        }else{
            if(ix>backIndex)
                ix=0;
        }
    }
    }@catch (NSException* excp) {
        return nil;
    }
    
    
    //Reverse array
    NSArray* reversed = [[backTrackArray reverseObjectEnumerator] allObjects];
    NSMutableArray* backArrayFinal=[NSMutableArray arrayWithArray:reversed];
        
    *changePoint=[backArrayFinal objectAtIndex:0];
    
    return backTrackArray;
}

//Simple Routing if common bus
-(NSMutableArray*)simpleRouting:(MapPoint*)pointA:(MapPoint*)pointB{
    
    NSString* pointABuses=pointA.subTitle;
    NSArray* pointABusArray=[pointABuses componentsSeparatedByString:@","];
    NSString* pointBBus=pointB.subTitle;
    NSArray* pointBBusArray=[pointBBus componentsSeparatedByString:@","];
    
    //Find Common Buses and Eliminate the number ones
    NSMutableArray* commonArr=[[NSMutableArray alloc]init];
    for(NSString* busa in pointABusArray){
        for(NSString* busb in pointBBusArray){
            if([busa isEqualToString:busb])
                [commonArr addObject:busa];
        }
    }
    
    //Remove Rubbish and Non-NUS Bus Values
    NSMutableArray* commonArrCopy=[NSMutableArray arrayWithArray:commonArr];
    for(NSString* as in commonArr){
        if([as isEqualToString:@""])
            [commonArrCopy removeObject:as];
        else{
            NSString * newStrings = [as substringWithRange:NSMakeRange(0, 1)];
            unichar a=[newStrings characterAtIndex:0];
            if(isdigit(a))
                [commonArrCopy removeObject:as];
        }
        if([as isEqualToString:@"BTC"])
            [commonArrCopy removeObject:as];
    }
    
    
    NSMutableArray* routeGroup=[[NSMutableArray alloc]init];
    @try{
    for(NSString* bus in commonArrCopy){
        NSMutableArray* route=[self actualRouting:pointA :pointB :@"CHANGER" :bus :NO];
        if(route!=nil){
            //D bus error? find opp side of d bus, then try again
            [routeGroup addObject:route];
        }
        else{
            MapPoint* oppSide=[self busOppGenerator:pointA :YES];
            NSMutableArray* changedArr=[self simpleRouting:oppSide :pointB];
            [routeGroup addObject:changedArr];
        }
    }
    }@catch (NSException* exception) {
        return nil;
    }
    
    //Find shortest route
    int i=10;
    NSMutableArray* finalRoute;
    for(NSMutableArray* aroute in routeGroup){
        if([aroute count]<i){
            i=[aroute count];
            finalRoute=aroute;
        }
    }
    return finalRoute;
    

}

//Invert an array
-(NSMutableArray*)reverseArray:(NSMutableArray*)take{
    NSArray* array=[[take reverseObjectEnumerator]allObjects];
    NSMutableArray* returns=[NSMutableArray arrayWithArray:array];
    return returns;
}

-(void)busRouter:(MapPoint*)pointA:(MapPoint*)pointB:(NSString*)title{
    NSString* pointABuses=pointA.subTitle;
    NSArray* pointABusArray=[pointABuses componentsSeparatedByString:@","];
    NSString* pointBBus=pointB.subTitle;
    NSArray* pointBBusArray=[pointBBus componentsSeparatedByString:@","];

    //Find Common Buses and Eliminate the number ones
    NSMutableArray* commonArr=[[NSMutableArray alloc]init];
    for(NSString* busa in pointABusArray){
        for(NSString* busb in pointBBusArray){
            if([busa isEqualToString:busb])
                [commonArr addObject:busa];
        }
    }
    
    //Remove Rubbish and Non-NUS Bus Values
    NSMutableArray* commonArrCopy=[NSMutableArray arrayWithArray:commonArr];
    for(NSString* as in commonArr){
        if([as isEqualToString:@""])
            [commonArrCopy removeObject:as];
        else{
            NSString * newStrings = [as substringWithRange:NSMakeRange(0, 1)];
            unichar a=[newStrings characterAtIndex:0];
            if(isdigit(a))
                [commonArrCopy removeObject:as];
        }
        if([as isEqualToString:@"BTC"])
            [commonArrCopy removeObject:as];
    }
    
    
    
    if([commonArrCopy count]==0){

        //NSLog(@"NO BUS CALLED. ALTERNATIVE ROUTING BEGINS");
        
        MapPoint* changePointEnd=nil;
        NSString* bustoChangeToEnd=nil;
        NSMutableArray* FINALROUTE1=nil;
        NSMutableArray* backArrayEnd=[self backTrack:pointB :pointABusArray:pointBBusArray:&changePointEnd:&bustoChangeToEnd:NO];//Backtrack from endpoint
        NSMutableArray* reverseBack1=[self reverseArray:backArrayEnd];
        if(changePointEnd!=nil){
            FINALROUTE1=[self simpleRouting:pointA :changePointEnd];}
        
        NSMutableArray* route1=[[NSMutableArray alloc]init];
        if((FINALROUTE1!=nil) && (reverseBack1!=nil)){
            for(MapPoint* test in FINALROUTE1){
                [route1 addObject:test];
            }
            for(MapPoint* test in reverseBack1){
                [route1 addObject:test];
            }
        }
        if((route1!=nil) && ([route1 count]!=0)){
            NSString* keyname1=[NSString stringWithFormat:@"%d",counter];
            [route1 addObject:tempoint];
            [routeDictionaryAdd setObject:route1 forKey:keyname1];
            counter++;
        }
        
       // NSLog(@"\n -----backtrack from startpoint--------");

        MapPoint* changePointStart=nil;
        NSString* busToChangeToStart=nil;
        NSMutableArray* thatRoute2=nil;
        NSMutableArray* backArrayStart=[self backTrack:pointA :pointBBusArray :pointABusArray:&changePointStart:&busToChangeToStart:YES];//Backfoward from startpoint
        if(changePointStart!=nil){
            thatRoute2=[self simpleRouting:changePointStart :pointB];}


        NSMutableArray* route2=[[NSMutableArray alloc]init];
        if((thatRoute2!=nil) && (backArrayStart!=nil)){
            for(MapPoint* test in backArrayStart){
                [route2 addObject:test];
            }
            for(MapPoint* test in thatRoute2){
                [route2 addObject:test];
            }
        }
        if((route2!=nil) && ([route2 count]!=0)){
            NSString* keyname2=[NSString stringWithFormat:@"%d",counter];
            [route2 addObject:tempoint];
            [routeDictionaryAdd setObject:route2 forKey:keyname2];
            counter++;
        }
        
    }else{
        for(NSString* bus in commonArrCopy){
            NSString* keyname=[NSString stringWithFormat:@"%d",counter];
            NSMutableArray* oneRoute=[self actualRouting:pointA :pointB :title :bus:NO];
            [oneRoute addObject:tempoint];

            if(oneRoute!=nil){
                [routeDictionaryAdd setObject:oneRoute forKey:keyname];
                counter++;
            }
        }
    }
}

//Generate Route combinations
-(void)combinationGenerate:(MapPoint*)busStart:(MapPoint*)busEnd{
    
    MapPoint* busOppStart=[self busOppGenerator:busStart:YES];
    MapPoint* busOppEnd=[self busOppGenerator:busEnd:YES];
    
    //Generate combinations
    int combination;
    if((busOppStart==nil) && (busOppEnd!=nil))
        combination=1;
    else if((busOppEnd==nil) && (busOppStart!=nil))
        combination=2;
    else if((busOppEnd==nil)&&(busOppStart==nil))
        combination=3;
    else
        combination=4;
    
    NSLog(@"COMBINATION %i",combination);
    
    switch (combination) {
        case 1:
            [self busRouter:busStart :busEnd:@"A"];
            [self busRouter:busStart :busOppEnd:@"B"];
            break;
            
        case 2:
            [self busRouter:busStart :busEnd:@"A"];
            [self busRouter:busOppStart :busEnd:@"B"];
            break;
            
        case 3:
            [self busRouter:busStart :busEnd:@"A"];
            break;
            
        case 4:
            [self busRouter:busStart :busEnd:@"A"];
            [self busRouter:busOppStart :busEnd:@"B"];
            [self busRouter:busStart :busOppEnd:@"C"];
            [self busRouter:busOppStart :busOppEnd:@"D"];
            break;
            
        default:
            break;
    }
    NSLog(@"done");
}

-(void)addSelected{
    //Load selectpoint
    if(selectedPoint!=nil){
        [holderArr insertObject:selectedPoint atIndex:0];
    }
}

//Return timing of route
-(double)getTimingsCompare:(NSMutableArray*)routeA{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    double startBusTiming=19;
    MapPoint* mapPoint;
    mapPoint=[routeA objectAtIndex:0];
    if(![mapPoint.mapInfoType isEqualToString:@"Bus"])
        mapPoint=[routeA objectAtIndex:1];
    NSMutableDictionary* busTimingDict=nil;
    
    
    BusParsingNew* busParsers=[[BusParsingNew alloc]init];
    [busParsers loadData:mapPoint.title];
    double x=[busParsers getFastestTiming];
    NSLog(@"Return fastest is Timing %f for Route %@",x,mapPoint.title);
    return x;
}

-(void)function{
    sleep(2);
}

-(void)routingAlgorithm:(BOOL)selected{
    //Logo
    self.googleImage.alpha=0.5;
    self.googleImage.hidden=NO;
    
    //Load some data
    clearButton.enabled=NO;
    counter2=0;
    counter=0;
    NSString *pathfulllist = [[NSBundle mainBundle] pathForResource:@"BusOpposites" ofType:@"plist"];
    oppBusstops=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
    NSString *pathfulllist2 = [[NSBundle mainBundle] pathForResource:@"BusRouter" ofType:@"plist"];
    busRoutes=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist2];
    routeDictionaryAdd=[[NSMutableDictionary alloc]init];
    
    //Toolbar
    tool.alpha = 0;
    tool.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        tool.alpha = 0.7;
    }];
    tool.hidden=NO;
    
    //Busstart,BusOppStart,BusEnd,BusOppEnd
    //Get the nearest bus-stops for start and end point and opp points
    MapPoint* start=[[MapPoint alloc]init]; 
    if(selected==YES){
        start=selectedPoint;
    }else{
        locationBool=YES;
        [start initWithCoordinate:startingPoint.coordinate]; //Actual start
    }
    MapPoint* busStart;
    if((selected==YES) && ([selectedPoint.mapInfoType isEqualToString:@"Bus"])){
        busStart=selectedPoint;
    }else{
        busStart=[self nearestAction:0 :YES :start];
    }
    
    MapPoint* end=tempoint;
    MapPoint* busEnd;
    if(end.mapInfoType!=@"Bus")
        busEnd=[self nearestAction:0 :YES :end];//If of bus type then make end=bus
    else 
        busEnd=end;
    
    BOOL correctType=YES;
    //Route Lousy Busstops and BTC busstops
    //Need to solve the issue for the lousy bus stop
    if([busStart.alias isEqualToString:@"DER3"] || [busStart.alias isEqualToString:@"DER2"] || [busEnd.alias isEqualToString:@"DER3"] || [busEnd.alias isEqualToString:@"DER2"]){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"Sorry, BTC Campus is not supported by NUS Router yet" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        correctType=NO;
        [self close];
    }
    if([busStart.alias isEqualToString:@"16199"]){
        MapPoint* newP=[[MapPoint alloc]init]; newP.alias=@"16189";
        busStart=[self busOppGenerator:newP :NO];
    }
    if([busEnd.alias isEqualToString:@"16199"]){
        MapPoint* newP=[[MapPoint alloc]init]; newP.alias=@"16189";
        busEnd=[self busOppGenerator:newP :NO];
    }
    
    if(correctType==YES){
    [self combinationGenerate:busStart :busEnd];

    //Find Total num of keys and num of shortest route
    NSArray* keyRoute=[routeDictionaryAdd allKeys];
        maxRoutes=0; int routetotal=20; NSString* keyofshortestroute; double startBusTiming=20;
    for(NSString* key in keyRoute){
        int curr=[key intValue];
        NSLog(@"%d",curr);
        if(curr>maxRoutes)
            maxRoutes=curr;
        NSMutableArray* routeA=[routeDictionaryAdd objectForKey:key];
        
        if(shortestOrFastest==YES){
            double currTiming=[self getTimingsCompare:routeA];
            if(currTiming<startBusTiming){
                startBusTiming=currTiming;
                keyofshortestroute=key;
            }
        }else{
            if([routeA count]<routetotal){
                routetotal=[routeA count];
                keyofshortestroute=key;
            }
        }
        //Cleanup
        NSMutableArray* toAddNow=[self cleanUpRoute:routeA];
        [routeDictionaryAdd setObject:toAddNow forKey:key];

    }
    [SVProgressHUD dismiss];
    
    //Jump currRoute to shortest route
    currRoute=[keyofshortestroute intValue];
        NSLog(@"ROUTESHORTES IST %u",currRoute);
    
    //Hide
    [UIView animateWithDuration:0.3 animations:^{
        segmentMapType.alpha = 0;
    } completion: ^(BOOL finished) {
        segmentMapType.hidden = YES;
    }];

        
    //Set Intial Route and clear current annotations
    hold=YES;
    [mapView removeAnnotations:mapView.annotations]; 
    NSString* currRouteS=[NSString stringWithFormat:@"%d",currRoute];
    routeNameLabel.text=[NSString stringWithFormat:@"%d",currRoute];
    holderArr=[routeDictionaryAdd objectForKey:currRouteS];
        
    self.mapPointArray=holderArr;
    [self loadPoints];
    [self selectPointFoward];
    [self generateRouteLines];
    }
}

-(void)removeRouteLines{

    if(utownLine!=nil){
        [mapView removeOverlays:[mapView overlays]];
        if(segmentMapType.selectedSegmentIndex==2){
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText=@"Campus";
        [HUD showWhileExecuting:@selector(addTiles) onTarget:self withObject:nil animated:YES];
        }
        utownLine=nil;
        return;
    }

    if([arrayOfrouteLines count]==0)
        return;
    
    for(MKPolyline* line in arrayOfrouteLines){
        routeLine=line;
        [mapView removeOverlay:routeLine];
    }
}

-(void)displayRouteLine{
    //Counter2 controls which route
    if([arrayOfrouteLines count]==0)
        return;
    
    NSLog(@"DISPLAYROUTELINE CALLED");
    
    for(MKPolyline* line in arrayOfrouteLines){
        routeLine=line;
        [mapView addOverlay:routeLine];
    }

}

-(void)generateRouteLines{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText=@"Routing";
    [HUD showWhileExecuting:@selector(generateRouteLinesMB) onTarget:self withObject:nil animated:YES];
}

-(void)utownLines{
    NSLog(@"UTOWNLINES");
    NSString* coods=@"103.7741775465827,1.300729386994126,103.7744043670556,1.301020858462723,103.7744560433306,1.301388323908652,103.7743840093181,1.301708689648147,103.7740778753099,1.302333457289475,103.7739547931523,1.302634055685435,103.7739443365832,1.303018173839864,103.774103740669,1.303310133045385,103.7743137226276,1.303475540119272,103.7745710576285,1.303584801004147,103.7748787046259,1.303652590707274,103.775301446259,1.303705296600642,103.7754934100497,1.303767022996825,103.7754970524111,1.303841374091813,103.7755528058263,1.303907663308031,103.7756149627436,1.30392627061046,103.7756834034083,1.303897124336633,103.7757222503408,1.30384977846869,103.7757195619992,1.303805026237309,103.7756813958466,1.303753993777925,103.7756312100559,1.303735601221883,103.7755690179608,1.303740875538973,103.775494753881,1.303769828603379";
    NSArray* coodArr=[coods componentsSeparatedByString:@","];
    NSMutableArray* points=[[NSMutableArray alloc]init];
    for(int i=0;i<[coodArr count];i+=2){
        double lat=[[coodArr objectAtIndex:i] doubleValue];
        double lon=[[coodArr objectAtIndex:i+1] doubleValue];
        CLLocation* oneLoc=[[CLLocation alloc]initWithCoordinate:CLLocationCoordinate2DMake(lon,lat) altitude:1 horizontalAccuracy:1 verticalAccuracy:1 timestamp:nil];
        [points addObject:oneLoc];
    }
    CLLocationCoordinate2D *locations = malloc(sizeof(CLLocationCoordinate2D) * points.count);
    int count = 0;
    for (int i = 0; i < points.count; i++)
    {
        CLLocation* temp=[points objectAtIndex:i]; double lat=temp.coordinate.latitude; double longi=temp.coordinate.longitude;
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(lat,longi);
        locations[count] = point;
        count++;
    }
    utownLine = [MKPolyline polylineWithCoordinates:locations count:points.count];
    [self.mapView addOverlay:utownLine];
    free(locations);
}

-(void)generateRouteLinesMB{
    RouteParser* routeParser=[[RouteParser alloc]init];
    arrayOfrouteLines=[[NSMutableArray alloc]init];
    
    int num=1; 
    if(locationBool==YES)
        num=0;
    
    int end=[holderArr count]-1;
    BOOL utownfound=NO;
    for(int i=num;i<end;i++){
        //Get start and end busstops
        MapPoint* startPoint=[holderArr objectAtIndex:i];
        MapPoint* endPoint;
        @try{
        endPoint=[holderArr objectAtIndex:i+1];
        }@catch (NSException* exp) {
            break;
        }
        if(![endPoint.mapInfoType isEqualToString:@"Bus"])
            break;
        
        //Cancel if utown location. Google no support utown
        if([startPoint.alias isEqualToString:@"UT"] || [endPoint.alias isEqualToString:@"UT"]){
            [self utownLines];
            CLLocationCoordinate2D intercept=CLLocationCoordinate2DMake(1.300729386994126, 103.7741775465827);
            MapPoint* prevPoint;
            NSMutableArray* oneRoute;
            if([startPoint.alias isEqualToString:@"UT"]){
                prevPoint=[holderArr objectAtIndex:i+1];
                oneRoute=[routeParser returnRoute:intercept :prevPoint.coordinate];
            }else if([endPoint.alias isEqualToString:@"UT"]){
                prevPoint=[holderArr objectAtIndex:i-1];
                oneRoute=[routeParser returnRoute:prevPoint.coordinate :intercept];
            }
            for(MKPolyline* oneLine in oneRoute){
                routeLine=oneLine;
                [arrayOfrouteLines addObject:routeLine];
            }
            utownfound=YES;
            continue;
        }
        MapPoint* tempEndPoint=[holderArr objectAtIndex:end];
        if([tempEndPoint.alias isEqualToString:@"UT"]){
            [self utownLines];
            MapPoint* prevPoint;
            NSMutableArray* oneRoute;
            CLLocationCoordinate2D intercept=CLLocationCoordinate2DMake(1.300729386994126, 103.7741775465827);
            prevPoint=[holderArr objectAtIndex:i+1];
            if(![prevPoint.title isEqualToString:@"UT"]){
                prevPoint=[holderArr objectAtIndex:i-1];
                oneRoute=[routeParser returnRoute:prevPoint.coordinate :intercept];
            }else{
                oneRoute=[routeParser returnRoute:intercept :prevPoint.coordinate];
            }
            for(MKPolyline* oneLine in oneRoute){
                routeLine=oneLine;
                [arrayOfrouteLines addObject:routeLine];
            }
            utownfound=YES;
            continue;
        }
        
        //NSLog(@"STARTPOINT %@",startPoint.title);
        NSMutableArray* oneRoute=[routeParser returnRoute:startPoint.coordinate :endPoint.coordinate];
        for(MKPolyline* oneLine in oneRoute){
            routeLine=oneLine;
            [arrayOfrouteLines addObject:routeLine];
        }
    }
    
    //if(utownfound==NO){
        [self displayRouteLine];
//    }else{
//        NSLog(@"UTOWN ROUTE REMOVE ALL OBJECTS");
//        [arrayOfrouteLines removeAllObjects];
//    }

}

-(NSMutableArray*)cleanUpRoute:(NSMutableArray*)takeIn{
    NSMutableArray* changeNow=[NSMutableArray arrayWithArray:takeIn];
    MapPoint* prevPoint=nil;
    for(MapPoint* ex in takeIn){
        if(prevPoint!=nil){
            if([prevPoint.title isEqualToString:ex.title] && [prevPoint.bus isEqualToString:ex.bus])
                [changeNow removeObject:ex];
        }
        prevPoint=ex;
    }
    takeIn=changeNow;
    
    NSMutableArray* changeNowFinal=[[NSMutableArray alloc]init];
    NSString* prevBus=nil;
    for(MapPoint* ex in takeIn){
        if(ex.bus!=nil){
            
            NSString* newBusTitle;
            if(([ex.alias isEqualToString:@"PGP0"] || [ex.alias isEqualToString:@"ED1"] || [ex.alias isEqualToString:@"11111"]) && prevBus!=nil){
                newBusTitle=[NSString stringWithFormat:@"Switch Bus\n%@",ex.bus];
            }else{
                if([ex.bus isEqualToString:prevBus] || prevBus==nil)
                    newBusTitle=[NSString stringWithFormat:@"Take Bus\n%@",ex.bus];
                else
                    newBusTitle=[NSString stringWithFormat:@"Change Bus\n%@",ex.bus];
            }
            prevBus=ex.bus;
            ex.bus=newBusTitle;
        }
        
        [changeNowFinal addObject:ex];
    }
    
    if(selectedPoint!=nil){
        [changeNowFinal insertObject:selectedPoint atIndex:0];
    }
    
    takeIn=changeNowFinal;
    return takeIn;

}


-(IBAction)addRoutes{
    counter2=0;
    currRoute++;
    
    if(currRoute>maxRoutes){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Max Route reached" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        currRoute--;
    }else{
        hold=YES;
        [mapView removeAnnotations:mapView.annotations]; 
        NSString* currRouteS=[NSString stringWithFormat:@"%d",currRoute];
        routeNameLabel.text=[NSString stringWithFormat:@"%d",currRoute];//rlabel
        holderArr=[routeDictionaryAdd objectForKey:currRouteS];
        
        if(holderArr==nil)
            NSLog(@"error");
        self.mapPointArray=holderArr;
        [self loadPoints];
        [self selectPointFoward];
        
        [self removeRouteLines];
        [self generateRouteLines];
    }
}

-(IBAction)backRoute:(id)sender{
    counter2=0;
    currRoute--;
    
    if(currRoute<0){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Back Route reached" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        currRoute++;
    }else{
        hold=YES;
        [mapView removeAnnotations:mapView.annotations]; 
        NSString* currRouteS=[NSString stringWithFormat:@"%d",currRoute];
        routeNameLabel.text=[NSString stringWithFormat:@"%d",currRoute];//rlabel
        holderArr=[routeDictionaryAdd objectForKey:currRouteS];
        
        if(holderArr==nil)
            NSLog(@"error");
        self.mapPointArray=holderArr;
        [self loadPoints];
        [self selectPointFoward];
        
        [self removeRouteLines];
        [self generateRouteLines];
    }
}

-(IBAction)selectPointFoward{
    if(counter2>=[holderArr count]){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"No More Foward" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        hold=YES;
        tempSelect=[holderArr objectAtIndex:counter2];
        [self.mapView selectAnnotation:tempSelect animated:YES];
        
        buttonText.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        buttonText.titleLabel.numberOfLines = 3;
        buttonText.titleLabel.textAlignment = UITextAlignmentCenter;
        if(tempSelect.bus==nil){
            [buttonText setTitle:[NSString stringWithFormat:@"Walk to/from\n%@",tempSelect.subTitle] forState:UIControlStateNormal];
        }else{
            [buttonText setTitle:[NSString stringWithFormat:@"%@",tempSelect.bus] forState:UIControlStateNormal]; 
        }

        counter2++;
    }
}

-(IBAction)selectPointBackward{
    counter2--;
    if(counter2<0){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"No More Backward" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        counter2++;
    }else{
        tempSelect=[holderArr objectAtIndex:counter2];
        [self.mapView selectAnnotation:tempSelect animated:YES];
        
        buttonText.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        buttonText.titleLabel.numberOfLines = 3;
        buttonText.titleLabel.textAlignment = UITextAlignmentCenter;
        if(tempSelect.bus==nil){
            [buttonText setTitle:[NSString stringWithFormat:@"Walk to/from\n%@",tempSelect.subTitle] forState:UIControlStateNormal];
        }else{
            [buttonText setTitle:[NSString stringWithFormat:@"%@",tempSelect.bus] forState:UIControlStateNormal]; 
        } 
    }
}

-(IBAction)close{
    self.googleImage.hidden=YES;
    if(busTracker!=nil)
        [busTracker stopTrack];
    
    locationBool=NO;
    
    [self removeRouteLines];
    [mapView removeOverlay:utownLine];
    
    [mapView removeOverlay:routeLine];
    clearButton.enabled=YES;
    hold=YES;
    [mapView removeAnnotations:mapView.annotations]; 
    routeNameLabel.text=@"";
    
    [routeDictionaryAdd removeAllObjects];
    [holderArr removeAllObjects];
    selectedPoint=nil;
    
    NSMutableArray* ar=[[NSMutableArray alloc]initWithObjects:tempoint, nil];
    mapPointArray=ar;
    [self loadPoints];
    
    [UIView animateWithDuration:0.3 animations:^{
        segmentMapType.alpha = 0.7;
    } completion: ^(BOOL finished) {
        segmentMapType.hidden = NO;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        tool.alpha = 0;
    } completion: ^(BOOL finished) {
        tool.hidden = YES;
    }];
}

//Code for Point Selector///////////////////////////////

-(void)displayInfoBut{
    //Display Info
    displayInfo.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    displayInfo.titleLabel.numberOfLines = 2;
    displayInfo.titleLabel.textAlignment = UITextAlignmentCenter;
    [displayInfo setTitle:[NSString stringWithFormat:@"You have selected\n%@",selectedPoint.title] forState:UIControlStateNormal];
}

-(void)actualRouteDetails{
    RouteDetails* routeDetails=[[RouteDetails alloc]init];
    routeDetails.route=holderArr;
    routeDetails.mapController=self;
    [self presentModalViewController:routeDetails animated:YES];
    [SVProgressHUD dismiss];
}

-(IBAction)routeDetails{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(actualRouteDetails) withObject:nil afterDelay:0.5];
}

-(void)openSelector{
    selectedPoint=nil;
    //Toolbar
    toolSelect.alpha = 0;
    toolSelect.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        toolSelect.alpha = 0.7;
    }];
    toolSelect.hidden=NO;
    
    //Hold temppoint for later
    holdtemppoint=tempoint;
    
    selectorOn=YES;
    [mapView deselectAnnotation:tempoint animated:YES];
    [self displayInfoBut];
    
    
}

-(IBAction)goRoute{
    if((selectedPoint==nil) || [selectedPoint.title isEqualToString:tempoint.title]){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"You have selected the same or no point" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        if(googleMap==YES){
            [self closePointSelect];
            GoogleRouteViewController* googleView=[[GoogleRouteViewController alloc]init];
            CLLocation* locs=[[CLLocation alloc]initWithLatitude:selectedPoint.coordinate.latitude longitude:selectedPoint.coordinate.longitude];
            googleView.start=locs;
            googleView.transfer=tempoint;
            [self presentModalViewController:googleView animated:YES];
            googleMap=NO;
        }else{
            [self closePointSelect];
            [self routingAlgorithm:YES];
        }
    }
}

-(IBAction)closePointSelect{
    selectorOn=NO;
    [UIView animateWithDuration:0.3 animations:^{
        toolSelect.alpha = 0;
    } completion: ^(BOOL finished) {
        toolSelect.hidden = YES;
    }];
}

/************************************************************************
 * ADD TO FAV
 ************************************************************************/

-(void)writedata{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"FavData.plist"];
    NSLog(@"LOOK %@",plistpath);
    
        NSMutableDictionary* tempDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistpath];

       
        NSLog(@"IMAGENAME: %@",tempoint.imagename);
        NSLog(@"ALIAS: %@",tempoint.alias);
    if([tempoint.alias isEqualToString:@""] || tempoint.alias==nil)
        tempoint.alias=@" ";
    if([tempoint.imagename isEqualToString:@""] || tempoint.imagename==nil)
        tempoint.imagename=@" ";

    
        NSArray* tempArr=[[NSArray alloc]initWithObjects:tempoint.title,tempoint.alias,tempoint.imagename,tempoint.subTitle,tempoint.mapInfoType, nil];
    NSLog(@"ARAY COUNT: %u",[tempArr count]);
        [tempDict setObject:tempArr forKey:tempoint.title];
    
    BOOL a=[tempDict writeToFile:plistpath atomically:YES];
    if(!a){
        NSLog(@"FAIL");
    }else{
        NSLog(@"pass");
    }

}




@end
