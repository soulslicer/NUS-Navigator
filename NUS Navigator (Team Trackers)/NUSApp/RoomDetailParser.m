//
//  XMLParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoomDetailParser.h"

@implementation RoomDetailParser
@synthesize roomList,roomDetail,urlstring;

bool boolroom;
bool boolroomcode;
bool boolroomname;
bool booldept;


-(void)convertString{
    urlstring=[urlstring stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

-(void)initWithContent:(NSString*)st{
    urlstring=st;
    urlstring=[NSString stringWithFormat:@"http://nuslivinglab.nus.edu.sg/api/Dept?name=%@",urlstring];
    [self convertString];
}

-(void)initWithContentRoomCode:(NSString *)st{
    urlstring=st;
    urlstring=[NSString stringWithFormat:@"http://nuslivinglab.nus.edu.sg/api/Room?RoomCode=%@",urlstring];
}

-(void)initWithContentRoomName:(NSString *)st{
    urlstring=st;
    urlstring=[NSString stringWithFormat:@"http://nuslivinglab.nus.edu.sg/api/Room?RoomName=%@",urlstring];
    [self convertString];
}

-(NSMutableArray*)returnList{
    //NSLog(@"Parser run");
    self.roomList=[[NSMutableArray alloc]init];
    [self convertString];
    NSURL* url=[[NSURL alloc]initWithString:urlstring];
    //NSLog(@"URL %@",url);
    NSXMLParser* parser=[[NSXMLParser alloc]initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
    return self.roomList;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
 
    if([elementName isEqualToString:@"room"]){
        self.roomDetail=[[RoomDetails alloc]init];
    }
    
    if([elementName isEqualToString:@"roomcode"]){
        boolroomcode=YES;
    }
    
    if([elementName isEqualToString:@"roomname"]){
        boolroomname=YES;
    }
    
    if([elementName isEqualToString:@"dept"]){
        booldept=YES;
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
 
    if(boolroomcode){
        self.roomDetail.roomCode=string;
        boolroomcode=NO;
    }
    
    if(boolroomname){
        self.roomDetail.roomName=string;
        boolroomname=NO;
    }
    
    if(booldept){
        self.roomDetail.dept=string;
        booldept=NO;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
 
    if([elementName isEqualToString:@"room"]){
        [self.roomList addObject:self.roomDetail];
    }
    
}





@end
