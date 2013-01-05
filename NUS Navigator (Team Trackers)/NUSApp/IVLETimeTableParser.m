//
//  IVLELoginParser.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IVLETimeTableParser.h"

@implementation IVLETimeTableParser;
@synthesize data;
@synthesize courseArray;

BOOL ModuleCode;
BOOL CourseID;
BOOL StartTime;
BOOL EndTime;

BOOL WeekCode;
BOOL WeekText;

BOOL DayCode;
BOOL DayText;

BOOL LessonType;
BOOL Venue;

-(NSMutableArray*)returnMods:(NSString*)tokens:(NSString*)APIKey{
    
    courseArray=[[NSMutableArray alloc]init];
    NSXMLParser* parser=[[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    return courseArray;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //NSLog(@"ELEMENT: %@",elementName);
    if([elementName isEqualToString:@"CourseID"]){
        oneCourse=[[Course alloc]init];
        CourseID=YES;
    }
    if([elementName isEqualToString:@"ModuleCode"]){
        ModuleCode=YES;
    }
    if([elementName isEqualToString:@"StartTime"]){
        StartTime=YES;
    }
    if([elementName isEqualToString:@"EndTime"]){
        EndTime=YES;
    }
    if([elementName isEqualToString:@"WeekCode"]){
        WeekCode=YES;
    }
    if([elementName isEqualToString:@"WeekText"]){
        WeekText=YES;
    }
    if([elementName isEqualToString:@"DayCode"]){
        DayCode=YES;
    }
    if([elementName isEqualToString:@"DayText"]){
        DayText=YES;
    }
    if([elementName isEqualToString:@"LessonType"]){
        LessonType=YES;
    }
    if([elementName isEqualToString:@"Venue"]){
        Venue=YES;
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    

    //NSLog(@"STRING: %@",string);
    if(CourseID){
        oneCourse.courseID=string;
        CourseID=NO;
    }
    if(ModuleCode){
        oneCourse.moduleCode=string;
        ModuleCode=NO;
    }
    if(StartTime){
        oneCourse.startTime=string;
        StartTime=NO;
    }
    if(EndTime){
        oneCourse.endTime=string;
        EndTime=NO;
    }
    if(StartTime){
        oneCourse.startTime=string;
        StartTime=NO;
    }
    if(WeekCode){
        oneCourse.weekCode=string;
        WeekCode=NO;
    }
    if(WeekText){
        oneCourse.weekText=string;
        WeekText=NO;
    }
    if(DayCode){
        oneCourse.dayCode=string;
        DayCode=NO;
    }
    if(DayText){
        oneCourse.dayText=string;
        DayText=NO;
    }
    if(LessonType){
        oneCourse.lessonType=string;
        LessonType=NO;
    }
    if(Venue){
        oneCourse.venue=string;
        Venue=NO;
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"CourseID"]){
        [courseArray addObject:oneCourse];
        //NSLog(@"%u",[courseArray count]);
    }

}

@end
