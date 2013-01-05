//
//  CarParkParser.h
//  testcar
//
//  Created by Yaadhav Raaj on 20/11/12.
//  Copyright (c) 2012 Yaadhav Raaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarParkParser : NSObject{
    NSData* responseData;
    NSDictionary* json;
}

-(void)refreshData;
-(int)getLots:(NSString*)carpark;

@end
