//
//  BusTracker.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapController.h"
#import "BusParserVer1.h"

@class MapController;
@interface BusTracker : NSObject{
    MapController* mapController2;
    BOOL cont;
    BusParserVer1* busParser;
    NSString* bus;
    NSString* station;
    NSDictionary* busTrackDict;
    NSDictionary* busTrackList;
    NSArray* oneBusArray;
}
@property(nonatomic)MapController* mapController;

-(id)initWithInfo:(NSString*)_bus:(NSString*)_station;
-(void)startTrack;
-(void)stopTrack;

@end
