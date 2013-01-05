//
//  IVLELoginParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVLERequest : NSObject<NSXMLParserDelegate>{
    NSString* token;
}
-(NSString*)returnUserID:(NSData*)a;

@end
