//
//  BusParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusParserVer2.h"

@implementation BusParserVer2


-(NSString*)returnTime:(NSString*)busNum:(NSString*)busStop{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BusStopAP" ofType:@"plist"];
    APList=[[NSDictionary alloc]initWithContentsOfFile:path];
    NSString* ap=[APList objectForKey:busStop];
    ap=[ap stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString* stringURL=[NSString stringWithFormat:@"https://inetapps.nus.edu.sg/ws/nextsbus/WSNextShuttleBus.asmx/getNextArrTime?bus=%@&ap=%@",busNum,ap];
    
    NSURL* url=[NSURL URLWithString:stringURL];
//    NSData* jsonData=[NSData dataWithContentsOfURL:url];
//    NSString* test=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"LOOK %@",test);
    
    NSXMLParser* parser=[[NSXMLParser alloc]initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
    return final;
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    NSLog(@"Element %@",elementName);
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    NSLog(@"item %@",string);
    
    if([string isEqualToString:@" "] || string==nil)
        NSLog(@"error");
    
    NSArray* temp=[string componentsSeparatedByString:@":\""];
    NSString* temp2=[temp objectAtIndex:1];
    NSArray* temp3=[temp2 componentsSeparatedByString:@"\""];
    final=[temp3 objectAtIndex:0];
   
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    
}

@end
