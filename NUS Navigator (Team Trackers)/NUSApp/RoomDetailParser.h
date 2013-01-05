//
//  XMLParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomDetails.h"

@interface RoomDetailParser : NSObject<NSXMLParserDelegate>{
    NSString* urlstring;
    RoomDetails* roomDetail;
    NSMutableArray* roomList;
}
@property(nonatomic)RoomDetails* roomDetail;
@property(nonatomic)NSMutableArray* roomList;
@property(nonatomic)NSString* urlstring;

-(void)initWithContent:(NSString*)st;
-(void)initWithContentRoomCode:(NSString *)st;
-(void)initWithContentRoomName:(NSString*)st;
-(NSMutableArray*)returnList;
-(void)convertString;

@end
