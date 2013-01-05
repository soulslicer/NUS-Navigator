//
//  Conversions.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conversions:NSObject


-(NSString*)converter:(NSString*)st: (NSString*)dep;
-(NSString*)lectureConvert:(NSString*)input;
-(NSInteger)dayConvert:(NSString*)input;


@end
