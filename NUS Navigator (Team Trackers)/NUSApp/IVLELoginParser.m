//
//  IVLELoginParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IVLELoginParser.h"

@implementation IVLELoginParser
@synthesize name;

-(NSString*)returnUserID:(NSString*)token:(NSString*)APIKey{

    NSString* urlstring=[NSString stringWithFormat:@"https://ivle.nus.edu.sg/api/Lapi.svc/UserName_Get?APIKey=%@&Token=%@&output=xml",APIKey,token];
    NSURL* url=[[NSURL alloc]initWithString:urlstring];
    //NSLog(@"%@",url);
    NSXMLParser* parser=[[NSXMLParser alloc]initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
    return self.name;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //NSLog(@"ELEMENT %@",elementName);
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //NSLog(@"STRING %@",string);
    name=string;
}
    

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    
}

@end
