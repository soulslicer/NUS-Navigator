//
//  TodayViewControllerViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TodayViewControllerViewController.h"
#import "Module.h"
#import "Course.h"
#import "IVLETimeTableParser.h"
#import "RoomDetails.h"
#import "RoomDetailParser.h"
#import "IVLEModuleListParser.h"

@interface TodayViewControllerViewController ()

@end

@implementation TodayViewControllerViewController
@synthesize token,APIKey,activity,table,mapController,name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    
    convert=[[Conversions alloc]init];
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay =  [theDateFormatter stringFromDate:[NSDate date]];
    
    self.title=weekDay;
    [activity startAnimating];
    courseArray=[[NSMutableArray alloc]init];
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* pathfulllist = [path1 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
    buildingList=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
    NSString* urlstring=[NSString stringWithFormat:@"https://ivle.nus.edu.sg/api/Lapi.svc/Modules_Student?APIKey=%@&AuthToken=%@&Duration=1&IncludeAllInfo=false&output=xml",APIKey,token];
    NSURL* urla=[NSURL URLWithString:urlstring];
    NSURLRequest* url=[NSURLRequest requestWithURL:urla];
    //moduleData=[NSURLConnection connectionWithRequest:url delegate:self];
    NSURLConnection* connection=[NSURLConnection connectionWithRequest:url delegate:self];
    
    
    NSLog(@"end");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    responseData=[[NSData alloc]initWithData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    IVLEModuleListParser* modParser=[[IVLEModuleListParser alloc]init];
    modParser.data=responseData;
    moduleArray=[modParser returnMods:token :APIKey];
    [activity stopAnimating];
    activity.hidden=YES;
    
    //Get today's day
    int todayDay=[convert dayConvert:self.title]+1;
    NSString* dayString=[NSString stringWithFormat:@"%d",todayDay];
    
    //Scan for everything of that day
    for(Module* mod in moduleArray){
        NSArray* modFullList=[[NSArray alloc]init];
        NSString* courseID=mod.courseID;
        NSString* urlstring=[NSString stringWithFormat:@"https://ivle.nus.edu.sg/api/Lapi.svc/Timetable_Module?APIKey=%@&AuthToken=%@&CourseID=%@&output=xml",APIKey,token,courseID];
        NSURL* urla=[NSURL URLWithString:urlstring];
        NSData* rspData=[[NSData alloc]initWithContentsOfURL:urla];
        IVLETimeTableParser* modParser=[[IVLETimeTableParser alloc]init];
        modParser.data=rspData;
        modFullList=[modParser returnMods:token :APIKey];
        
        for(Course* course in modFullList){
            //NSLog(@"%@",course.dayCode);
            if([course.dayCode isEqualToString:dayString]){
                [courseArray addObject:course];
            }
        }
    }
    NSLog(@"%@",dayString);
    NSLog(@"%u",[courseArray count]);
    [table reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [courseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:SimpleTableIdentifier];
        
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        
//        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
//        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
        
    }
    
    NSUInteger row = [indexPath row];
    Course* oneCourse=[courseArray objectAtIndex:row];
    NSString* modCode=oneCourse.moduleCode;
    NSString* lesType=oneCourse.lessonType;
    NSString* title=[NSString stringWithFormat:@"%@-%@",modCode,lesType];
    cell.textLabel.text=title;
    
    NSString* week=oneCourse.weekText;
    NSString* day=oneCourse.dayText;
    NSString* starttime=oneCourse.startTime;
    NSString* endtime=oneCourse.endTime;
    NSString* venue=oneCourse.venue;
    NSString* final=[NSString stringWithFormat:@"%@; %@; %@-%@; %@",week,day,starttime,endtime,venue];
    
    cell.detailTextLabel.text=final;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger row = [indexPath row];
    Course* oneCourse=[courseArray objectAtIndex:row];
    NSString* venue=oneCourse.venue;
    NSString* final;
    
    if ([venue rangeOfString:@"-"].location == NSNotFound) {
        final=[convert lectureConvert:venue];
        NSArray* details=[buildingList objectForKey:final];
        NSLog(@"%@",[details objectAtIndex:0]);
        NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
        MapPoint* mapPoint=[[MapPoint alloc]init];
        mapPoint.title=[details objectAtIndex:0];
        mapPoint.subTitle=[details objectAtIndex:3];
        mapPoint.imagename=[details objectAtIndex:2];
        mapPoint.alias=[details objectAtIndex:1];
        mapPoint.mapInfoType=@"Normal";
        [MapPointArray addObject:mapPoint];
        [mapController setter];
        mapController.mapPointArray=MapPointArray;
        [self.tabBarController setSelectedIndex:3];
    } else {
        final=venue;
        RoomDetailParser* parser=[[RoomDetailParser alloc]init];
        [parser initWithContentRoomCode:venue];
        NSArray* array=[parser returnList];
        RoomDetails* room=[array objectAtIndex:0];
        
        NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
        MapPoint* mapPoint=[[MapPoint alloc]init];
        mapPoint.title=room.roomCode;
        mapPoint.subTitle=[convert converter:room.roomCode :room.dept];;
        mapPoint.imagename=@"Room";
        mapPoint.alias=@" ";
        mapPoint.mapInfoType=@"Room";
        [MapPointArray addObject:mapPoint];
        NSLog(@"%@",mapPoint.title);
        [mapController setter];
        mapController.mapPointArray=MapPointArray;
        [self.tabBarController setSelectedIndex:3];
    }
   
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;  
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    Course* oneCourse=[courseArray objectAtIndex:row];
    NSString* week=oneCourse.weekText;
    NSString* day=oneCourse.dayText;
    NSString* starttime=oneCourse.startTime;
    NSString* endtime=oneCourse.endTime;
    NSString* venue=oneCourse.venue;
    NSString* final=[NSString stringWithFormat:@"%@; %@; %@-%@; %@",week,day,starttime,endtime,venue];
    NSString* realFinal=[NSString stringWithFormat:@"%@-%@>%@",oneCourse.moduleCode,oneCourse.lessonType,final];
    
    if ([venue rangeOfString:@"-"].location == NSNotFound) {
        venue=[convert lectureConvert:venue];
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"IVLESave.plist"];
    NSMutableDictionary* ivleDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistpath];
    NSString* currUser=[ivleDict objectForKey:@"CurrUser"];
    NSMutableDictionary* userDict=[ivleDict objectForKey:currUser];
    
    BOOL repeat=NO;
    if([userDict objectForKey:venue]!=nil){
        NSMutableArray* newArray=[userDict objectForKey:venue];
        for(NSString* temp in newArray){
            if([temp isEqualToString:realFinal])
                repeat=YES;
        }
        if(repeat==NO)
            [newArray addObject:realFinal];
        else{
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Repeat" message:@"This has been added already" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
        [userDict setObject:newArray forKey:venue];
    }else{
        NSMutableArray* newArray=[[NSMutableArray alloc]init];
        [newArray addObject:realFinal];
        [userDict setObject:newArray forKey:venue];
    }
    
    [ivleDict setObject:userDict forKey:currUser];
    
    [ivleDict writeToFile:plistpath atomically:YES];
    if(repeat==NO){
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Added Link" message:[NSString stringWithFormat:@"Added for %@",venue] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"%u",repeat);
    
}

@end