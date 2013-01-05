//
//  XMLTEST.h
//  nusbushtml
//
//  Created by Yaadhav Raaj on 16/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusParserVer1 : NSObject<NSXMLParserDelegate>{
    NSMutableArray* arrayPower;
}
-(void)function:(NSData*)data;
-(NSMutableDictionary*)getTimings:(NSString*)station;
@end
