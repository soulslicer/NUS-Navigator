//
//  BusDisplay.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 31/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusDisplay.h"

@implementation BusDisplay
@synthesize mapPoint,type,bus,distance,timing,nextTiming;

-(NSString*)getType:(NSString*)string{
    NSArray* split=[string componentsSeparatedByString:@" "];
    string=[split objectAtIndex:0];
    
    NSString* busget=[split objectAtIndex:1];
    NSArray* ss=[busget componentsSeparatedByString:@"\n"];
    bus=[ss objectAtIndex:1];
    
    return string;
}

-(BOOL)checkifBus:(MapPoint*)mapP{
    if(mapPoint.bus==nil)
        return NO;
    return YES;
}

-(id)initWithValues:(MapPoint*)mapP{
    mapPoint=mapP;
    return self;
}

@end
