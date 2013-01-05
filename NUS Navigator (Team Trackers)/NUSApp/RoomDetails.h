//
//  RoomDetails.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomDetails : NSObject{
    NSString* roomCode;
    NSString* roomName;
    NSString* dept;
}
@property(nonatomic)NSString* roomCode;
@property(nonatomic)NSString* roomName;
@property(nonatomic)NSString* dept;



@end
