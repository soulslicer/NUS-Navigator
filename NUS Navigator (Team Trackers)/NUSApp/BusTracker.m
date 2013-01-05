//
//  BusTracker.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusTracker.h"
#import "MapController.h"

@implementation BusTracker
@synthesize mapController;

-(id)initWithInfo:(NSString*)_bus:(NSString*)_station{
    NSString *path5 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath5 = [path5 stringByAppendingPathComponent:@"BusTracker.plist"];
    busTrackDict=[[NSDictionary alloc]initWithContentsOfFile:plistpath5];
    busTrackList=[busTrackDict objectForKey:@"Buses"];
    
    cont=YES;
    bus=_bus;
    station=_station;
    return self;
}

-(void)getCoords:(NSString*)location{
    location=[location stringByReplacingOccurrencesOfString:@"  " withString:@" &"];
    NSArray* arr=[busTrackList objectForKey:location];
    CLLocationCoordinate2D newCoord={ [[arr objectAtIndex:0] doubleValue],[[arr objectAtIndex:1] doubleValue]};
    NSLog(@"%f %@",newCoord.latitude,location);
    
    if(cont==NO){
        return;
    }

    NSString* title=[NSString stringWithFormat:@"%@ (%@)",bus,[oneBusArray objectAtIndex:2]];
    NSString* subtitles=[NSString stringWithFormat:@"%@ (%@)",location,[oneBusArray objectAtIndex:1]];
    self.mapController.busPoint1.title=title;
    [self.mapController.mapView removeAnnotation:self.mapController.busPoint1];
    [self.mapController.busPoint1 initWithCoordinate:newCoord];
    self.mapController.busPoint1.subTitle=subtitles;
    [self.mapController.mapView addAnnotation:self.mapController.busPoint1];

}

-(void)startTrack{
    
    busParser=[[BusParserVer1 alloc]init];
    NSDictionary* busData=[busParser getTimings:station];
    oneBusArray=[busData objectForKey:bus];
    
    NSString* location;
    if([oneBusArray count]==0 || oneBusArray==nil){
        location=@"error";
    }else{
        location=[oneBusArray objectAtIndex:0];
        [self getCoords:location];
    }
    
    if(cont==YES)
        [self performSelector:@selector(startTrack) withObject:nil afterDelay:8];
    

}

-(void)stopTrack{
    NSLog(@"Stop Tracker");
    cont=NO;
    [self.mapController.mapView removeAnnotation:self.mapController.busPoint1];

}

@end
