//
//  LocationsViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationsViewController.h"
#import "MapPoint.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController
@synthesize locations,buildingList,mapController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"LOCATIONSLOADEd");
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* pathfulllist = [path1 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
    buildingList=[[NSDictionary alloc]initWithContentsOfFile:pathfulllist];
    //self.title=@"Locations";
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.locations count];
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
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    }
    
    NSUInteger row = [indexPath row];
    id temp=[locations objectAtIndex:row];
    if([temp isKindOfClass:[NSDictionary class]]){//temp is dict
        NSString* ax=[temp objectForKey:@"Title"];
        NSString* num=[temp objectForKey:@"Telephone"];
        cell.textLabel.text=ax;
        cell.detailTextLabel.text=num;
    }else{
        cell.textLabel.text=temp;
    }
    
    //cell.textLabel.text = temp;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    NSUInteger row = [indexPath row];
    id temp=[locations objectAtIndex:row];
    if([temp isKindOfClass:[NSString class]]){
        return labelSize.height + 21;
    }
    else if([temp isKindOfClass:[NSDictionary class]]){//temp is dict
        return labelSize.height + 35;
    }
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    id temp=[locations objectAtIndex:row];
    if([temp isKindOfClass:[NSString class]]){
        return nil;
    }
    else if([temp isKindOfClass:[NSDictionary class]]){//temp is dict
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    id temp=[locations objectAtIndex:row];
    NSString* num=[temp objectForKey:@"Telephone"];

    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        num=[num stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        NSString* nums=[NSString stringWithFormat:@"telprompt://%@",num];
        NSURL *url = [NSURL URLWithString:nums];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}


#pragma mark -

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    id stringName=[locations objectAtIndex:row];
    NSString* name;
    if([stringName isKindOfClass:[NSString class]]){
        name=stringName;
        
    }
    else if([stringName isKindOfClass:[NSDictionary class]]){//temp is dict
        name=[stringName objectForKey:@"Title"];
    }
    
    //Create a new Map Point object and set it in map Controller once selected
    NSArray* details=[buildingList objectForKey:name];

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
    
}


@end