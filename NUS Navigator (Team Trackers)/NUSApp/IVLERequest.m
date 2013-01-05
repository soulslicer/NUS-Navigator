//
//  IVLELoginParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IVLERequest.h"

@implementation IVLERequest

bool successBool;
bool tokenBool;
bool success;

-(NSString*)returnUserID:(NSData*)a{
    
    //NSLog(@"%@",url);
    NSXMLParser* parser=[[NSXMLParser alloc]initWithData:a];
    //NSLog(@"run");
    [parser setDelegate:self];
    [parser parse];
    //return self.name;
    return token;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //NSLog(@"ELEMENT '%@'",elementName);
    if([elementName isEqualToString:@"a:Success"])
        successBool=YES;
    if([elementName isEqualToString:@"a:Token"])
        tokenBool=YES;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //NSLog(@"STRING %@",string);
    if(successBool){
        if([string isEqualToString:@"true"])
            success=YES;
        successBool=NO;
    }
    if(tokenBool){
        if(success)
            token=string;
        tokenBool=NO;
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    
}

@end
