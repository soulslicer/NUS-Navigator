//
//  BusParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusParserVer2 : NSObject<NSXMLParserDelegate>{
    NSDictionary* APList;
    NSString* final;
}

-(NSString*)returnTime:(NSString*)busNum:(NSString*)busStop;

@end
