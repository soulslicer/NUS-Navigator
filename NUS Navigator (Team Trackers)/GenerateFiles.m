//
//  GenerateFiles.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 13/8/12.
//
//

#import "GenerateFiles.h"

@implementation GenerateFiles

-(void)generateFiles{
    //Building_Cood
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath1 = [path1 stringByAppendingPathComponent:@"Building_Cood.plist"];
    NSDictionary* plistDict1=[[NSDictionary alloc]initWithContentsOfFile:plistpath1];
    if(plistDict1==nil){
        NSString *p1 = [[NSBundle mainBundle] pathForResource:@"Building_Cood" ofType:@"plist"];
        plistDict1=[[NSDictionary alloc]initWithContentsOfFile:p1];
        [plistDict1 writeToFile:plistpath1 atomically:YES];
    }
    
    //Building_Letterlist
    NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath2 = [path2 stringByAppendingPathComponent:@"Building_Letterlist.plist"];
    NSDictionary* plistDict2=[[NSDictionary alloc]initWithContentsOfFile:plistpath2];
    if(plistDict2==nil){
        NSString *p2 = [[NSBundle mainBundle] pathForResource:@"Building_Letterlist" ofType:@"plist"];
        plistDict2=[[NSDictionary alloc]initWithContentsOfFile:p2];
        [plistDict2 writeToFile:plistpath2 atomically:YES];
    }
    
    //Building_Fulllist
    NSString *path3 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath3 = [path3 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
    NSDictionary* plistDict3=[[NSDictionary alloc]initWithContentsOfFile:plistpath3];
    if(plistDict3==nil){
        NSString *p3 = [[NSBundle mainBundle] pathForResource:@"Building_Fulllist" ofType:@"plist"];
        plistDict3=[[NSDictionary alloc]initWithContentsOfFile:p3];
        [plistDict3 writeToFile:plistpath3 atomically:YES];
    }
    
    //FoodDetails
    NSString *path4 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath4 = [path4 stringByAppendingPathComponent:@"FoodDetails.plist"];
    NSDictionary* plistDict4=[[NSDictionary alloc]initWithContentsOfFile:plistpath4];
    if(plistDict4==nil){
        NSString *p4 = [[NSBundle mainBundle] pathForResource:@"FoodDetails" ofType:@"plist"];
        plistDict4=[[NSDictionary alloc]initWithContentsOfFile:p4];
        [plistDict4 writeToFile:plistpath4 atomically:YES];
    }
    
    //BusTracker
    NSString *path5 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath5 = [path5 stringByAppendingPathComponent:@"BusTracker.plist"];
    NSDictionary* plistDict5=[[NSDictionary alloc]initWithContentsOfFile:plistpath5];
    if(plistDict5==nil){
        NSString *p5 = [[NSBundle mainBundle] pathForResource:@"BusTracker" ofType:@"plist"];
        plistDict5=[[NSDictionary alloc]initWithContentsOfFile:p5];
        [plistDict5 writeToFile:plistpath5 atomically:YES];
    }
    
    //BusLocation
    NSString *path6 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath6 = [path6 stringByAppendingPathComponent:@"BusLocation.plist"];
    NSDictionary* plistDict6=[[NSDictionary alloc]initWithContentsOfFile:plistpath6];
    if(plistDict6==nil){
        NSString *p6 = [[NSBundle mainBundle] pathForResource:@"BusLocation" ofType:@"plist"];
        plistDict6=[[NSDictionary alloc]initWithContentsOfFile:p6];
        [plistDict6 writeToFile:plistpath6 atomically:YES];
    }
    
}

-(void)updateFiles{
    //Building_Cood
    NSURL* url1=[[NSURL alloc]initWithString:@"http://www.a-iats.com/App/Building_Cood.plist"];
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath1 = [path1 stringByAppendingPathComponent:@"Building_Cood.plist"];
    NSDictionary* plistDict1=[[NSDictionary alloc]initWithContentsOfURL:url1];
    [plistDict1 writeToFile:plistpath1 atomically:YES];
    
    //Building_Letterlist
    NSURL* url2=[[NSURL alloc]initWithString:@"http://www.a-iats.com/App/Building_Letterlist.plist"];
    NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath2 = [path2 stringByAppendingPathComponent:@"Building_Letterlist.plist"];
    NSDictionary* plistDict2=[[NSDictionary alloc]initWithContentsOfURL:url2];
    [plistDict2 writeToFile:plistpath2 atomically:YES];
    
    //Building_Fulllist
    NSURL* url3=[[NSURL alloc]initWithString:@"http://www.a-iats.com/App/Building_Fulllist.plist"];
    NSString *path3 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath3 = [path3 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
    NSDictionary* plistDict3=[[NSDictionary alloc]initWithContentsOfURL:url3];
    [plistDict3 writeToFile:plistpath3 atomically:YES];
    
    //FoodDetails
    NSURL* url4=[[NSURL alloc]initWithString:@"http://www.a-iats.com/App/FoodDetails.plist"];
    NSString *path4 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath4 = [path4 stringByAppendingPathComponent:@"FoodDetails.plist"];
    NSDictionary* plistDict4=[[NSDictionary alloc]initWithContentsOfURL:url4];
    [plistDict4 writeToFile:plistpath4 atomically:YES];
    
    //BusTracker
    NSURL* url5=[[NSURL alloc]initWithString:@"http://www.a-iats.com/App/NUSApp/BusTracker.plist"];
    NSString *path5 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath5 = [path5 stringByAppendingPathComponent:@"BusTracker.plist"];
    NSDictionary* plistDict5=[[NSDictionary alloc]initWithContentsOfURL:url5];
    [plistDict5 writeToFile:plistpath5 atomically:YES];
    
    //BusLocation
    NSURL* url6=[[NSURL alloc]initWithString:@"http://www.a-iats.com/App/BusLocation.plist"];
    NSString *path6 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath6 = [path6 stringByAppendingPathComponent:@"BusLocation.plist"];
    NSDictionary* plistDict6=[[NSDictionary alloc]initWithContentsOfURL:url6];
    [plistDict6 writeToFile:plistpath6 atomically:YES];
    
}
    

@end
