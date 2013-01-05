//
//  IVLELoginParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IVLEValidateParser.h"

@implementation IVLEValidateParser;
@synthesize validate;
@synthesize token;

BOOL successBool;
BOOL tokenBool;

-(NSString*)returnValidate:(NSString*)tokens:(NSString*)APIKey{
    
    NSString* urlstring=[NSString stringWithFormat:@"https://ivle.nus.edu.sg/api/Lapi.svc/Validate?APIKey=%@&Token=%@&output=xml",APIKey,tokens];
    //NSLog(@"%@",urlstring);
    NSURL* url=[[NSURL alloc]initWithString:urlstring];
    NSXMLParser* parser=[[NSXMLParser alloc]initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
    return self.token;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"Success"])
        successBool=YES;
    if([elementName isEqualToString:@"Token"])
        tokenBool=YES;
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //NSLog(@"STRING %@",string);
    if(successBool){
        if([string isEqualToString:@"true"])
            validate=YES;
        else
            validate=NO;
        
        successBool=NO;
    }
    
    if(tokenBool){
        self.token=string;
        tokenBool=NO;
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    
}

@end
