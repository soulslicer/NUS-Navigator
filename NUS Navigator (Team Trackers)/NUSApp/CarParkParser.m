//
//  CarParkParser.m
//  testcar
//
//  Created by Yaadhav Raaj on 20/11/12.
//  Copyright (c) 2012 Yaadhav Raaj. All rights reserved.
//

#import "CarParkParser.h"

@implementation CarParkParser

-(void)refreshData{
    NSString* busURL=[NSString stringWithFormat:@"https://aces01.nus.edu.sg/prjbus/services/carpark/Carparks/"];
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

-(int)getLots:(NSString*)carparkID{
    NSArray* carparkArray=[json objectForKey:@"carpark"];
    for(NSDictionary* item in carparkArray){
        NSString* ID=[item objectForKey:@"name"];
        if([carparkID isEqualToString:ID]){
            return [[item objectForKey:@"lots"] intValue];
        }
    }
    NSLog(@"No Carparks found");
    return 0;
}

@end
