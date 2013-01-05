//
//  BusParsingNew.h
//  TestParsing
//
//  Created by Yaadhav Raaj on 11/10/12.
//  Copyright (c) 2012 Yaadhav Raaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusParsingNew : NSObject<NSURLConnectionDelegate>{
    NSData* responseData;
    NSDictionary* json;
}

-(void)loadData:(NSString*)busStop;
-(id)getArrivalTiming:(NSString*)bus;
-(id)getNextArrivalTiming:(NSString*)bus;
-(int)getFastestTiming;

@end
