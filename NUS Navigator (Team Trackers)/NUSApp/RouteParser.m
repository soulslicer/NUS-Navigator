//
//  RouteParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 16/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteParser.h"

@implementation RouteParser

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}

BOOL route;
int delaycount;

-(NSMutableArray*)returnRoute:(CLLocationCoordinate2D)start:(CLLocationCoordinate2D)end{
    delaycount=2;
    arrayPower=[[NSMutableArray alloc]init];
    
    urlstring=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/xml?origin=%1.6f,%1.6f&destination=%1.6f,%1.6f&sensor=true",start.latitude,start.longitude,end.latitude,end.longitude];

    [self beginParse];
    
    return routelineArray;
}

-(void)beginParse{
    NSXMLParser* parser=nil;
    NSURL* url=[[NSURL alloc]initWithString:urlstring];
    parser=[[NSXMLParser alloc]initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
    
    routelineArray=[[NSMutableArray alloc]init];
    for(NSString* astring in arrayPower){
        MKPolyline* oneline=[self polylineWithEncodedString:astring];
        [routelineArray addObject:oneline];
    }
    
    if([routelineArray count]==0){//ERROR REDO URL
        [self performSelector:@selector(beginParse) withObject:nil afterDelay:delaycount];
        delaycount+=2;
        NSLog(@"WAITING");
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"points"])
        route=YES;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //NSLog(@"STRING %@",string);
    if(route){
        //NSLog(@"STRING %@",string);
        [arrayPower addObject:string];
        route=NO;
    }
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    //    if([elementName isEqualToString:@"points"])
    //        NSLog(@"end");
}

@end
