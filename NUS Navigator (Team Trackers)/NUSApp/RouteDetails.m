//
//  RouteDetails.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 30/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteDetails.h"
#import "BusDisplay.h"
#import "BusParsingNew.h"

@interface RouteDetails ()

@end

@implementation RouteDetails
@synthesize table,item,route,mapController,tvCell;

BOOL processLocbool;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)reloadStuff{
    NSLog(@"Run");
    [self process];
    [table reloadData];
    [table setAllowsSelection:NO];
}

- (void)viewDidLoad
{
    closest=-1;
    processLocbool=YES;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Close"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(dismiss)];
    self.item.title=@"Route";
    self.item.rightBarButtonItem=editButton;
    UIBarButtonItem *editButton2 = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Refresh"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(reloadStuff)];
    self.item.leftBarButtonItem=editButton2;
    
    [self process];
    [table reloadData];
    [table setAllowsSelection:NO];
    [self processLocation];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)dismiss{
    processLocbool=NO;
    [self dismissModalViewControllerAnimated:YES];
}

-(void)processLocation{
    if(processLocbool==YES){
    [self distanceProcess];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int counter=0;
        MapPoint* start=[[MapPoint alloc]init];
        BOOL called=NO;
        [start initWithCoordinate:mapController.startingPoint.coordinate];
        for(BusDisplay* busDisp in busDisplayArray){
            if([mapController getDistance:busDisp.mapPoint :start]<=20){
                called=YES;
                closest=counter;
                break;
            }
            counter++;
        }
        
        if(called==NO)
            closest=-1;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
        });
    });
    [self.table reloadData];
    [self.table reloadInputViews];
    [self performSelector:@selector(processLocation) withObject:nil afterDelay:1];
    }
    
}

-(void)distanceProcess{
    //NSMutableArray* newBusDisp=[[NSMutableArray alloc]init];
    for(BusDisplay* busDisplay in busDisplayArray){
        MapPoint* start=[[MapPoint alloc]init];
        [start initWithCoordinate:mapController.startingPoint.coordinate];
        double distance=[mapController getDistance:busDisplay.mapPoint :start];
        busDisplay.distance=distance;
        //[newBusDisp addObject:busDisplay];
    }
    //busDisplayArray=[[NSMutableArray alloc]initWithArray:newBusDisp];
        
//    int x=[busDisplayArray count];
//    BusDisplay* hold=[busDisplayArray objectAtIndex:x-2];
//    BusDisplay* final=[busDisplayArray objectAtIndex:x-1];
//    hold.distance=[mapController getDistance:hold.mapPoint :final.mapPoint];
//    [busDisplayArray replaceObjectAtIndex:x-2 withObject:hold];
    
    
    //busDisplayArray=newBusDisp;
}


-(void)busTimingProcess{
    BusParsingNew* busParsers=[[BusParsingNew alloc]init];

    for(BusDisplay* busDisplay in busDisplayArray){
        
        if([busDisplay.type isEqualToString:@"StartBus"] || [busDisplay.type isEqualToString:@"EndBus"] || [busDisplay.type isEqualToString:@"Switch"] || [busDisplay.type isEqualToString:@"Change"] || [busDisplay.type isEqualToString:@"Alight"]){
            
            [busParsers loadData:busDisplay.mapPoint.title];
            busDisplay.timing=[[busParsers getArrivalTiming:busDisplay.bus] doubleValue];
            busDisplay.nextTiming=[[busParsers getNextArrivalTiming:busDisplay.bus] doubleValue];

 
        }else{
            busDisplay.timing=-1;
            busDisplay.nextTiming=-1;
        }
        
        
    }
    
}

-(void)process{
    NSLog(@"processtart");
    busDisplayArray=[[NSMutableArray alloc]init];
    BusDisplay* busDisplay;
    MapPoint* prevPoint=nil;
    BOOL takeSet=NO;
    for(MapPoint* mapPoint in self.route){
        
        busDisplay=[[BusDisplay alloc]init];
        busDisplay.mapPoint=mapPoint;
        if([busDisplay checkifBus:mapPoint]==NO){//Check if it is a busstop or not
            
            if(prevPoint==nil){//Check if start or end point
                if([busDisplayArray count]==0)
                    busDisplay.type=@"Start";
                else
                    busDisplay.type=@"End";
            }else{
                busDisplay.type=@"End";
            }
            
            [busDisplayArray addObject:busDisplay];
            continue;
        }
        
        NSString* type=[busDisplay getType:mapPoint.bus];//Sets bus too
        
        if([type isEqualToString:@"Switch"]){
            busDisplay.type=@"Switch";
            [busDisplayArray addObject:busDisplay];
            //takeSet=NO;
            continue;
        }
        
        if([type isEqualToString:@"Change"]){
            busDisplay.type=@"Change";
            [busDisplayArray addObject:busDisplay];
            //takeSet=NO;
            continue;
        }
        
        if([type isEqualToString:@"Take"]){
            if(takeSet==NO){
                busDisplay.type=@"StartBus";
                [busDisplayArray addObject:busDisplay];
                takeSet=YES;
                continue;
            }else{
                busDisplay.type=@"Continue";
                [busDisplayArray addObject:busDisplay];
                continue;
            }
        }

        prevPoint=mapPoint;
    }
    
    int counterx=0;
    for(BusDisplay* busDisp in busDisplayArray){
        if([busDisp.type isEqualToString:@"Continue"]){
            BusDisplay* nextBusDisp=[busDisplayArray objectAtIndex:counterx+1];
            if([nextBusDisp.type isEqualToString:@"Change"])
                busDisp.type=@"Alight";
        }
        counterx++;
    }
    
    int x=[busDisplayArray count];
    BusDisplay* hold=[busDisplayArray objectAtIndex:x-2];
    hold.type=@"EndBus";
    [busDisplayArray replaceObjectAtIndex:x-2 withObject:hold];
    
    [self distanceProcess];
    [self busTimingProcess];
    
    NSLog(@"processend");
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [busDisplayArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    NSUInteger row = [indexPath row];
    BusDisplay* busDisplay=[busDisplayArray objectAtIndex:row];
    
    if([busDisplay.type isEqualToString:@"Start"] || [busDisplay.type isEqualToString:@"End"])
        return 44;
    
    if([busDisplay.type isEqualToString:@"Continue"])
        return 22;
    else
        return 53;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL locImage=NO;
    NSUInteger row = [indexPath row];
    BusDisplay* busDisplay=[busDisplayArray objectAtIndex:row];
//    NSString *key = [keys objectAtIndex:section];
//    NSArray *nameSection = [names objectForKey:key];
    if(row==closest)
        locImage=YES;
    
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];

    //if (cell == nil) {
        
        if([busDisplay.type isEqualToString:@"Start"] || [busDisplay.type isEqualToString:@"End"]){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RouteDetailLocCell"
                                                         owner:self options:nil];
            if ([nib count] > 0) {
                cell = tvCell;
            } else {
                NSLog(@"failed to load CustomCell nib file!");
            }
            UILabel* label=(UILabel*)[cell viewWithTag:1];
            label.text=busDisplay.mapPoint.title;
            UILabel* label2=(UILabel*)[cell viewWithTag:2];
            label2.text=[NSString stringWithFormat:@"%1.1f m",busDisplay.distance];
            
            UIImageView* img=(UIImageView*)[cell viewWithTag:7];
            if([busDisplay.type isEqualToString:@"Start"])
                [img setImage:[UIImage imageNamed:@"LocStart"]];
            if([busDisplay.type isEqualToString:@"End"])
                [img setImage:[UIImage imageNamed:@"LocEnd"]];   
            
        }else if([busDisplay.type isEqualToString:@"Continue"]){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RouteDetailHalfCell"
                                                         owner:self options:nil];
            if ([nib count] > 0) {
                cell = tvCell;
            } else {
                NSLog(@"failed to load CustomCell nib file!");
            }
            UILabel* label=(UILabel*)[cell viewWithTag:1];
            label.text=busDisplay.mapPoint.title;
            UIImageView* img=(UIImageView*)[cell viewWithTag:7];
            [img setImage:[UIImage imageNamed:@"HalfContinue"]];
                        
        }else{
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RouteDetailFullCell"
                                                         owner:self options:nil];
            if ([nib count] > 0) {
                cell = tvCell;
            } else {
                NSLog(@"failed to load CustomCell nib file!");
            }
            
            UILabel* busLabel=(UILabel*)[cell viewWithTag:1];
            UILabel* typeLabel=(UILabel*)[cell viewWithTag:2];
            UILabel* nameLabel=(UILabel*)[cell viewWithTag:3];
            UILabel* distanceLabel=(UILabel*)[cell viewWithTag:4];
            UILabel* timingLabel=(UILabel*)[cell viewWithTag:5];
            UILabel* timing2Label=(UILabel*)[cell viewWithTag:6];
            
            busLabel.text=busDisplay.bus;
            typeLabel.text=busDisplay.type;
            nameLabel.text=busDisplay.mapPoint.title;
            distanceLabel.text=[NSString stringWithFormat:@"%1.1f m",busDisplay.distance];
            
            if(busDisplay.timing==-1)
                timingLabel.text=@"unavailable";
            else
                timingLabel.text=[NSString stringWithFormat:@"%1.1f min",busDisplay.timing];
            
            if(busDisplay.nextTiming==-1)
                timing2Label.text=@"unavailable";
            else
                timing2Label.text=[NSString stringWithFormat:@"%1.1f min",busDisplay.nextTiming];
            
            UIImageView* img=(UIImageView*)[cell viewWithTag:7];
            if([busDisplay.type isEqualToString:@"Switch"])
                [img setImage:[UIImage imageNamed:@"FullSwitch"]];
            if([busDisplay.type isEqualToString:@"Change"])
                [img setImage:[UIImage imageNamed:@"FullChange"]];
            if([busDisplay.type isEqualToString:@"StartBus"])
                [img setImage:[UIImage imageNamed:@"FullStartBus"]];
            if([busDisplay.type isEqualToString:@"EndBus"])
                [img setImage:[UIImage imageNamed:@"FullEndBus"]];
            if([busDisplay.type isEqualToString:@"Alight"])
                [img setImage:[UIImage imageNamed:@"FullAlight"]];
            
        }
    //}
    
    UIImageView* locIm=(UIImageView*)[cell viewWithTag:8];
    if(locImage==YES)
        locIm.hidden=NO;
    else
        locIm.hidden=YES;


//    cell.textLabel.text=busDisplay.mapPoint.title;
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"Bus: %@  Type: %@ Tim1: %1.1f Tim2: %1.1f",busDisplay.bus,busDisplay.type,busDisplay.timing,busDisplay.nextTiming];
    return cell;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
