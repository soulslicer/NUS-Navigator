//
//  BusParsingNew.m
//  TestParsing
//
//  Created by Yaadhav Raaj on 11/10/12.
//  Copyright (c) 2012 Yaadhav Raaj. All rights reserved.
//

#import "BusParsingNew.h"

@implementation BusParsingNew

NSString* stop;

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
    
    assert(@"Fail");
    return nil;
}

-(void)loadData:(NSString*)busStop{
    busStop=[self convert:busStop];
    stop=busStop;
    NSString* busURL=[NSString stringWithFormat:@"https://aces01.nus.edu.sg/prjbus/services/shuttlebus/%@",busStop];
    NSURL* url=[[NSURL alloc]initWithString:busURL];
    NSData* data = [NSData dataWithContentsOfURL:
                    url];
    
    //parse out the json data
    NSError* error;
    json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          
                          options:kNilOptions
                          error:&error];
}

-(id)getArrivalTiming:(NSString*)bus{
    NSLog(@"Searching for Bus %@ in Busstop %@",bus,stop);
    NSDictionary* shuttles=[json objectForKey:@"shuttles"];
    
    //For single bus bus-stop
    @try{
    NSString* time=nil;
    time=[shuttles objectForKey:@"arrivalTime"];
    if(time!=nil)
        return time;
    }@catch(NSException* e){
        
    }
    
    for(NSDictionary* busDict in shuttles){
        NSString* busName=[busDict objectForKey:@"name"];
        if([busName isEqualToString:bus]){
            return [busDict objectForKey:@"arrivalTime"];
        }
    }
    
    return @"-";
}

-(id)getNextArrivalTiming:(NSString*)bus{
    NSDictionary* shuttles=[json objectForKey:@"shuttles"];
    
    //For single bus bus-stop
    @try{
        NSString* time=nil;
        time=[shuttles objectForKey:@"arrivalTime"];
        if(time!=nil)
            return time;
    }@catch(NSException* e){
        
    }
    
    for(NSDictionary* busDict in shuttles){
        NSString* busName=[busDict objectForKey:@"name"];
        if([busName isEqualToString:bus]){
            return [busDict objectForKey:@"nextArrivalTime"];
        }
    }
    
    return @"-";
}

-(int)getFastestTiming{
    NSLog(@"START COMPARE \n");
    
    NSString* busChoice=@"None";
    int currentTiming=19;
    NSDictionary* shuttles=[json objectForKey:@"shuttles"];
    
    //For single bus bus-stop
    @try{
        NSString* times=nil;
        times=[shuttles objectForKey:@"arrivalTime"];
        if(times!=nil)
            return [times intValue];
    }@catch(NSException* e){
        
    }

    for(NSDictionary* busDict in shuttles){
        int actualTime;
        NSString* time=[busDict objectForKey:@"nextArrivalTime"];
        if([time isEqualToString:@"-"])
            actualTime=19;
        else if([time isEqualToString:@"Arr"])
            actualTime=0;
        else
            actualTime=[time intValue];
                
        if(actualTime<currentTiming){
            if( !([([busDict objectForKey:@"name"]) isEqualToString:@"BTC"]))
                currentTiming=actualTime;
        }
    }

    NSLog(@"END COMPARE \n");
    return currentTiming;
}

@end
