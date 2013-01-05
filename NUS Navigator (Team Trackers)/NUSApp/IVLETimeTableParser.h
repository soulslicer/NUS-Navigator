//
//  IVLETimeTableParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * IVLE TimeTable Parser
 
 1. Returns time table
 ************************************************************************/

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "Course.h"

@interface IVLETimeTableParser : NSObject<NSXMLParserDelegate>{
    NSData* data;

    Course* oneCourse;
    NSMutableArray* courseArray;
}
@property(nonatomic)NSData* data;
@property(nonatomic)NSMutableArray* courseArray;
-(NSMutableArray*)returnMods:(NSString*)token:(NSString*)APIKey;

@end

