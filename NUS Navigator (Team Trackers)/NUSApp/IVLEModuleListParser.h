//
//  IVLELoginParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * IVLE Module Parser
 
 1. Returns list of modules
 ************************************************************************/

#import <Foundation/Foundation.h>
#import "Module.h"

@interface IVLEModuleListParser : NSObject<NSXMLParserDelegate>{
    BOOL validate;
    NSString* token;
    NSData* data;
    
    Module* oneModule;
    NSMutableArray* moduleArray;
}
@property(nonatomic)BOOL validate;
@property(nonatomic)NSString* token;
@property(nonatomic)NSData* data;
@property(nonatomic)NSMutableArray* moduleArray;
-(NSMutableArray*)returnMods:(NSString*)token:(NSString*)APIKey;

@end
