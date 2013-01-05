//
//  BusDisplay.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 31/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPoint.h"

@interface BusDisplay : NSObject{
    MapPoint* mapPoint;
    NSString* type;
    NSString* bus;
    double distance;
    double timing;
    double nextTiming;
}
@property(nonatomic)MapPoint* mapPoint;
@property(nonatomic)NSString* type;
@property(nonatomic)NSString* bus;
@property(nonatomic)double distance;
@property(nonatomic)double timing;
@property(nonatomic)double nextTiming;

-(NSString*)getType:(NSString*)string;
-(BOOL)checkifBus:(MapPoint*)mapP;

@end
