//
//  IVLELoginParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * IVLE Log in parser
 
 1. Returns a name if log in was a success if not return nothing
 ************************************************************************/

#import <Foundation/Foundation.h>

@interface IVLELoginParser : NSObject<NSXMLParserDelegate>{
    NSString* name;
}
@property(nonatomic)NSString* name;
-(NSString*)returnUserID:(NSString*)token:(NSString*)APIKey;

@end
