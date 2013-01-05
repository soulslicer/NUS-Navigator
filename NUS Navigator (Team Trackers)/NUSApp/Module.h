//
//  Module.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Module : NSObject
{
    NSString* courseAcadYear;
    NSString* courseCode;
    NSString* courseName;
    NSString* courseSemester;
    NSString* courseID;
}
@property(nonatomic)NSString* courseAcadYear;
@property(nonatomic)NSString* courseCode;
@property(nonatomic)NSString* courseName;
@property(nonatomic)NSString* courseSemester;
@property(nonatomic)NSString* courseID;





@end
