//
//  RouteParser.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 16/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteParser : NSObject<NSXMLParserDelegate>{
    NSMutableArray* arrayPower;
    NSMutableArray* routelineArray;
    NSString* urlstring;
}
-(NSMutableArray*)returnRoute:(CLLocationCoordinate2D)start:(CLLocationCoordinate2D)end;

@end
