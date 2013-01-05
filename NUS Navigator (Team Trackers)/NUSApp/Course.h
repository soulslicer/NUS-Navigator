//
//  Course.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject{
    NSString* moduleCode;
    NSString* courseID;
    NSString* startTime;
    NSString* endTime;
    
    NSString* weekCode;
    NSString* weekText;
    
    NSString* dayCode;
    NSString* dayText;
    
    NSString* lessonType;
    NSString* venue;
}
@property(nonatomic)NSString* moduleCode;
@property(nonatomic)NSString* courseID;
@property(nonatomic)NSString* startTime;
@property(nonatomic)NSString* endTime;

@property(nonatomic)NSString* weekCode;
@property(nonatomic)NSString* weekText;

@property(nonatomic)NSString* dayCode;
@property(nonatomic)NSString* dayText;

@property(nonatomic)NSString* lessonType;
@property(nonatomic)NSString* venue;

@end
