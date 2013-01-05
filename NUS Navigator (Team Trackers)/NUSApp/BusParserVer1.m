//
//  XMLTEST.m
//  nusbushtml
//
//  Created by Yaadhav Raaj on 16/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusParserVer1.h"

@implementation BusParserVer1

NSString* currBus;
BOOL busactive;
int counter;
NSMutableArray* arrInfo;
NSMutableDictionary* dic;
BOOL nextbus;

-(NSString*)convert:(NSString*)input{
    if([input isEqualToString:@"AS7 Bus"])
        return @"AS7";
    else if([input isEqualToString:@"BIZ 2"])
        return @"BIZ2";
    else if([input isEqualToString:@"Oei Tiong Ham Building"])
        return @"BUKITTIMAH-BTC2";
    else if([input isEqualToString:@"Ctrl Lib, Kent Ridge Crescent"])
        return @"CENLIB";
    else if([input isEqualToString:@"Carpark 13@BIZ"])
        return @"COM2";
    else if([input isEqualToString:@"Computer Ctr, Kent Ridge Crescent"])
        return @"COMCEN";
    else if([input isEqualToString:@"E3A"])
        return @"E3A";
    else if([input isEqualToString:@"Eusoff Hall Bus"])
        return @"EUSOFF";
    else if([input isEqualToString:@"Opp Hon Sui Sen Memorial Library"])
        return @"HSSML-OPP";
    else if([input isEqualToString:@"Kent Vale Terminal"])
        return @"JAPSCHOOL";
    else if([input isEqualToString:@"LT13, FASS"])
        return @"LT13";
    else if([input isEqualToString:@"Opp LT13, FASS"])
        return @"LT13-OPP";
    else if([input isEqualToString:@"LT 29"])
        return @"LT27";
    else if([input isEqualToString:@"School of Computing 1"])
        return @"S17";
    else if([input isEqualToString:@"National University Hospital"])
        return @"NUH";
    else if([input isEqualToString:@"Opposite National University Hospital"])
        return @"NUH-OPP";
    else if([input isEqualToString:@"Office of Estate and Development"])
        return @"OED";
    else if([input isEqualToString:@"House 7"])
        return @"PGP7";
    else if([input isEqualToString:@"House 12"])
        return @"PGP12";
    else if([input isEqualToString:@"Opp House 12"])
        return @"PGP12-OPP";
    else if([input isEqualToString:@"Between House 14 and 15"])
        return @"PGP14-15";
    else if([input isEqualToString:@"PGP Terminal"])
        return @"PGP";
    else if([input isEqualToString:@"NUS Raffles Hall"])
        return @"RAFFLES";
    else if([input isEqualToString:@"Staff Club"])
        return @"STAFFCLUB";
    else if([input isEqualToString:@"Opposite Staff Club"])
        return @"STAFFCLUB-OPP";
    else if([input isEqualToString:@"Temasek Hall Bus"])
        return @"TEMASEK";
    else if([input isEqualToString:@"University Hall"])
        return @"UHALL";
    else if([input isEqualToString:@"Opposite University Hall"])
        return @"UHALL-OPP";
    else if([input isEqualToString:@"Utown"])
        return @"UTOWN";
    else if([input isEqualToString:@"Yusof Ishak House"])
        return @"YIH";
    else if([input isEqualToString:@"Opposite Yusof Ishak House"])
        return @"YIH-OPP";
    
    
    
    
    return nil;
}

-(NSMutableDictionary*)getTimings:(NSString*)station{
    NSString* test=station;
    station=[self convert:station];
    
    if(station==nil){
        NSLog(@"Return NIL for bus stop for %@",test);
        return nil;
    }
    
    NSURL* url=[[NSURL alloc]initWithString:@"http://businfo.nuscomputing.com/"];  //ADD THIS BACK
    NSData* data=[[NSData alloc]initWithContentsOfURL:url];        //ADD THIS BACK
    
    //NSData* data=[[NSData alloc]initWithContentsOfFile:@"/Users/Raaj/Desktop/BUSINFOTEXT.txt"];  //REMOVE
    
    NSString* newStr = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    //    [newStr writeToFile:@"/Users/Raaj/Desktop/BUSINFOTEXT.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //<h3><a name="AS7">AS7</a></h3>
    NSArray* arr=[newStr componentsSeparatedByString:[NSString stringWithFormat:@"<h3><a name=\"%@\">",station,station]];
    NSString* s=[arr objectAtIndex:1];
    NSArray* arr1=[s componentsSeparatedByString:@"</h3>"];
    s=[arr1 objectAtIndex:1];
    NSArray* arr2=[s componentsSeparatedByString:@"<div class=\"row bus-station\">"];
    NSString* final=[arr2 objectAtIndex:0];
    
    //[final writeToFile:@"/Users/Raaj/Desktop/BUSINFOTEXT.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    final=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n %@",final];
    final=[final stringByReplacingOccurrencesOfString:@"<tbody>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"</tbody>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"<table>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"</table>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"<table>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"</table>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"<thead>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"</thead>" withString:@""];
    final=[final stringByReplacingOccurrencesOfString:@"&" withString:@" "];
    
    NSData *datas = [NSData dataWithBytes:[final UTF8String] length:[final lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    

    
    [self function:datas];
    
    BOOL x=[dic writeToFile:@"/Users/Raaj/Desktop/BUSINFOTEXT.plist" atomically:YES];
    if(x==NO){
        NSLog(@"WRITE FAIL");
    }
    
    return dic;
    //return nil;
}

-(void)function:(NSData*)data{
    busactive=NO; counter=0; arrInfo=[[NSMutableArray alloc]init]; dic=[[NSMutableDictionary alloc]init];
    //NSLog(@"PARSER CALLED");
    NSXMLParser* parser=[[NSXMLParser alloc]initWithData:data];
    
    //    NSString* newStr = [[NSString alloc] initWithData:data
    //                                             encoding:NSUTF8StringEncoding];
    //    [newStr writeToFile:@"/Users/Raaj/Desktop/BUSINFOTEXT2.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [parser setDelegate:self];
    [parser parse];
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    //NSLog(@"ELEMENT %@",elementName);
    
}

-(NSString*)convertBus:(NSString*)input{
    if([input isEqualToString:@"B1"] || [input isEqualToString:@"B2"])
        return @"B";
    if([input isEqualToString:@"NB1"] || [input isEqualToString:@"NB2"])
        return @"NB";
    if([input isEqualToString:@"C1"] || [input isEqualToString:@"C2"])
        return @"C";
    if([input isEqualToString:@"NC1"] || [input isEqualToString:@"NC2"])
        return @"NC";
    if([input isEqualToString:@"BTC1"] || [input isEqualToString:@"BTC2"])
        return @"BTC";
    
    return input;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(![trimmedString isEqualToString:@""]){
        trimmedString=[trimmedString stringByReplacingOccurrencesOfString:@" minutes" withString:@""];
        while(1){
            if(busactive==YES){
                if([trimmedString isEqualToString:@"Timing information not available"]){
                    NSMutableArray* arrEmtp=[[NSMutableArray alloc]init];
                    id ob=[dic objectForKey:currBus];
                    if(ob==nil)
                        [dic setObject:arrEmtp forKey:[self convertBus:currBus]];
                    busactive=NO;
                    break;
                }else{
                    counter++;
                    [arrInfo addObject:trimmedString];
                    //NSLog(@"ADDING %@ for %@",trimmedString,currBus);
                    if(counter==3){
                        
//                        for(NSString* as in arrInfo){
//                            NSLog(@"ADDING %@ into %@",as,currBus);
//                        }
                        
                        //NSLog(@"ADDING FOR NUM %u",[arrInfo count]);
                        [dic setObject:arrInfo forKey:currBus];
                        busactive=NO;
                        counter=0;
                    }
                    break;
                }
            }
            break;
        }
        
        
        
        if([trimmedString isEqualToString:@"A1"] || [trimmedString isEqualToString:@"A2"] || [trimmedString isEqualToString:@"B1"] || [trimmedString isEqualToString:@"B2"] || [trimmedString isEqualToString:@"C1"] || [trimmedString isEqualToString:@"C2"] || [trimmedString isEqualToString:@"D1"] || [trimmedString isEqualToString:@"D2"]){
            busactive=YES;
            
            arrInfo=[[NSMutableArray alloc]init];
            
            if([trimmedString isEqualToString:currBus])
                currBus=[NSString stringWithFormat:@"N%@",[self convertBus:trimmedString]];
            else
                currBus=[self convertBus:trimmedString];
            
        }
        
        
    }else{
        return;
    }
    
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    //    if([elementName isEqualToString:@"points"])
    //        NSLog(@"end");
    //NSLog(@"ENDELEM: %@",elementName);
}
@end
