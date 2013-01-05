//
//  IVLELoginParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IVLEModuleListParser.h"

@implementation IVLEModuleListParser;
@synthesize validate;
@synthesize token;
@synthesize data;
@synthesize moduleArray;

BOOL Data_Module;
BOOL CourseAcadYear;
BOOL CourseCode;
BOOL CourseName;
BOOL CourseSemester;
BOOL ID;
BOOL isActive;

-(NSMutableArray*)returnMods:(NSString*)tokens:(NSString*)APIKey{
    
    moduleArray=[[NSMutableArray alloc]init];
    NSXMLParser* parser=[[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    return moduleArray;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //NSLog(@"ELEMENT %@",elementName);
    if([elementName isEqualToString:@"Data_Module"]){
        Data_Module=YES;
        oneModule=[[Module alloc]init];
    }
    
    if([elementName isEqualToString:@"CourseAcadYear"]){
        CourseAcadYear=YES;
    }
    
    if([elementName isEqualToString:@"CourseAcadYear"]){
        CourseAcadYear=YES;
    }
    
    if([elementName isEqualToString:@"CourseCode"]){
        CourseCode=YES;
    }
    
    if([elementName isEqualToString:@"CourseName"]){
        CourseName=YES;
    }
    
    if([elementName isEqualToString:@"CourseSemester"]){
        CourseSemester=YES;
    }
    
    if([elementName isEqualToString:@"ID"]){
        ID=YES;
    }
    

    
    
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //NSLog(@"STRING %@",string);
    if(CourseAcadYear){
        oneModule.courseAcadYear=string;
        CourseAcadYear=NO;
    }
    if(CourseCode){
        oneModule.courseCode=string;
        CourseCode=NO;
    }
    if(CourseName){
        oneModule.courseName=string;
        CourseName=NO;
    }
    if(CourseSemester){
        oneModule.courseSemester=string;
        CourseSemester=NO;
    }
    if(ID){
        oneModule.courseID=string;
        ID=NO;
    }
    
    
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"isActive"]){
        [moduleArray addObject:oneModule];
        //NSLog(@"%u",[moduleArray count]);
    }
}

@end
