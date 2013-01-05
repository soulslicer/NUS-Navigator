//
//  Conversions.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Conversions.h"

@implementation Conversions

-(NSString*)converter:(NSString*)st: (NSString*)dep{
    st=[st uppercaseString];
    NSRange range = [st rangeOfString:@"-"];
    st=[st substringToIndex:range.location];
    NSString* test=[st stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]];
    test=[test uppercaseString];
    NSLog(@"LOOKING AT %@",test);
    
    if ([test isEqualToString:@"AS"]){
        test=[st uppercaseString];
    }else if ([test isEqualToString:@"BIZ"]){
        test=st;
    }else if ([test isEqualToString:@"ADM"]){
        test=@"Block ADM";
    }else if ([test isEqualToString:@"COM"]){
        test=[st uppercaseString];
    }else if (([test isEqualToString:@"E"]) || ([ test isEqualToString:@"EA"]) || ([ test isEqualToString:@"EW"])){
        test=[st uppercaseString];
    }else if ([test isEqualToString:@"I"]){
        test=[st uppercaseString];
    }else if ([test isEqualToString:@"CLB"] || ([ test isEqualToString:@"HSS"])){
        test=@"Central Library";
    }else if ([test isEqualToString:@"CCE"]){
        test=@"Computer Centre";
    }else if ([test isEqualToString:@"CELS"]){
        test=@"Centre for Life Sciences";
    }else if ([test isEqualToString:@"CEMS"]){
        test=@"Centre for Maritime Studies";
    }else if ([test isEqualToString:@"YSTCM"]){
        test=@"Conservatory of Music";
    }else if ([test isEqualToString:@"YSTCM"]){
        test=@"Conservatory of Music";
    }else if ([test isEqualToString:@"FOD"] || ([test isEqualToString:@"DSO"])){ //CHECK THIS
        test=@"Faculty of Dentistry";
    }else if ([test isEqualToString:@"ISS"]){
        test=@"Institute of Systems Science";
    }else if ([test isEqualToString:@"KRHALL"]){
        test=@"Kent Ridge Hall";
    }else if ([test isEqualToString:@"H8"]){
        test=@"Kuok Foundation House";
    }else if ([test isEqualToString:@"MD"]){
        test=[st uppercaseString];
    }else if ([test isEqualToString:@"OED"]){ //CHECK UHL and UHT
        test=@"Office of Estate ";
    }else if ([test isEqualToString:@"PGP"]){
        test=@"Prince George";
    }else if ([test isEqualToString:@"CFA"]){ //CHECK COORDINATES
        test=@"University Cultural Centre";
    }else if (([test isEqualToString:@"H1A"]) || ([ test isEqualToString:@"H1B"])){
        test=@"Ridge View Tower Block";
    }else if ([test isEqualToString:@"S"]){
        test=[st uppercaseString];
    }else if ([test isEqualToString:@"SDE"]){
        test=[st uppercaseString];
    }else if ([test isEqualToString:@"SFAH"]){
        test=@"Shaw Foundation Alumni House";
    }else if ([test isEqualToString:@"SH"]){
        test=@"Sheares Hall";
    }else if ([test isEqualToString:@"UHL"] || [test isEqualToString:@"UHT"]){
        test=@"University Hall";
    }else if (([test isEqualToString:@"yih"]) || ([ test isEqualToString:@"YIH"])){
        test=@"Yusof Ishak House";
    }else if([test isEqualToString:@"UHC"]){
        test=@"University Cultural Centre";
    }else if([test isEqualToString:@"BTC"]){
        test=@"Tower Block, BTC";
    }else if([test isEqualToString:@"CH"]){
        test=dep;
    }else if([test isEqualToString:@"FCB"]){
        test=@"Staff Club";
    }else if([test isEqualToString:@"SRC"]){
        test=@"Sports and Recreation Centre";
    }else if([test isEqualToString:@"SRC"]){
        test=@"Sports and Recreation Centre";
    }
    
    NSLog(@"RETURN %@",test);
    return test;
}


-(NSString*)lectureConvert:(NSString*)input{
    NSString* newStr=[input substringFromIndex:2];
    NSString* final=[NSString stringWithFormat:@"Lecture Theatre %@",newStr];
    return final;
}

-(NSInteger)dayConvert:(NSString*)input{
    if([input isEqualToString:@"Monday"])
        return 0;
    else if([input isEqualToString:@"Tuesday"])
        return 1;
    else if([input isEqualToString:@"Wednesday"])
        return 2;
    else if([input isEqualToString:@"Thursday"])
        return 3;
    else if([input isEqualToString:@"Friday"])
        return 4;
    else if([input isEqualToString:@"Saturday"])
        return 5;
    else if([input isEqualToString:@"Sunday"])
        return 6;
}


@end
