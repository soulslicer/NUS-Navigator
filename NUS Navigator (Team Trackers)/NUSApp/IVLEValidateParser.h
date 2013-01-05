//
//  IVLELoginParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * IVLE Log in parser
 
 1. Attempt to validate the token with API Key
 ************************************************************************/

#import <Foundation/Foundation.h>

@interface IVLEValidateParser : NSObject<NSXMLParserDelegate>{
    BOOL validate;
    NSString* token;
}
@property(nonatomic)BOOL validate;
@property(nonatomic)NSString* token;
-(NSString*)returnValidate:(NSString*)token:(NSString*)APIKey;

@end
