//
//  FavouritesViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 10/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavouritesViewController.h"
#import "thumbNail.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController
@synthesize list,tableViews,listDict,mapController;

- (IBAction)toggleEdit:(id)sender {
    [self.tableViews setEditing:!self.tableViews.editing animated:YES];
	
    if (self.tableViews.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
}

- (void)viewDidLoad {
    
    self.title=@"Favourites";
    //[self loaddata];
    //[tableViews reloadData];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(toggleEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;
	
    [super viewDidLoad];
}

-(void)loaddata{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"FavData.plist"];
    //NSLog(@"LOOK %@",plistpath);
    
    listDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistpath];
    NSArray* tempArr=[listDict allKeys];
    self.list=[[NSMutableArray alloc]init];
    [self.list addObjectsFromArray:tempArr];
    
    NSComparator compareStuff = ^(id obj1, id obj2) {
        NSArray* a=[listDict objectForKey:obj1];
        NSArray* b=[listDict objectForKey:obj2];
        NSString* sa=[a objectAtIndex:2];
        NSString* sb=[b objectAtIndex:2];
        if([sa isEqualToString:@"Canteen"]){
            sa=@"Food";
        }
        if([sb isEqualToString:@"Canteen"]){
            sb=@"Food";
        }

        if([sa isEqualToString:sb])
            return NSOrderedSame;
        return NSOrderedDescending;
    };
    [list sortUsingComparator:compareStuff];
//    self.list=[[NSArray arrayWithArray:tempArr]retain];
//    NSLog(@"%u",[tempArr count]);
    
    //self.list=[[NSMutableArray alloc]initWithObjects:@"aa", nil];
    
}

-(void)writedata{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath = [path stringByAppendingPathComponent:@"FavData.plist"];
    [listDict writeToFile:plistpath atomically:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self loaddata];
    [tableViews reloadData];
    self.navigationController.navigationBarHidden=NO;
}



#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DeleteMeCellIdentifier = @"DeleteMeCellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             DeleteMeCellIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:DeleteMeCellIdentifier];
    }
    NSInteger row = [indexPath row];
    NSString* tempName=[list objectAtIndex:row];
    NSArray* tempArr=[self.listDict objectForKey:tempName];
    cell.textLabel.text = [self.list objectAtIndex:row];
    cell.detailTextLabel.text=[tempArr objectAtIndex:3];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* imagepath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[self.list objectAtIndex:row]]];
    //NSLog(@"NAME: %@",imagepath);
    
    
    UIImage* images=[[UIImage alloc]initWithContentsOfFile:imagepath];
    if(images==nil){
        NSString* obType=[tempArr objectAtIndex:2];
        if([obType isEqualToString:@"Food"] || [obType isEqualToString:@"Canteen"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"png"];
            images=[[UIImage alloc]initWithContentsOfFile:path];
        }
        else if([obType isEqualToString:@"Room"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"door" ofType:@"png"];
            images=[[UIImage alloc]initWithContentsOfFile:path];
        }
        else if([obType isEqualToString:@"Money"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"money" ofType:@"png"];
            images=[[UIImage alloc]initWithContentsOfFile:path];
        }
        else if([obType isEqualToString:@"Bus"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"bus" ofType:@"png"];
            images=[[UIImage alloc]initWithContentsOfFile:path];
        }else if([obType isEqualToString:@"Library"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Library" ofType:@"png"];
            images=[[UIImage alloc]initWithContentsOfFile:path];
        }else if([obType isEqualToString:@"Carpark"]){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"parking" ofType:@"png"];
            images=[[UIImage alloc]initWithContentsOfFile:path];
        }
        else{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"house" ofType:@"png"];
            images=[[UIImage alloc]initWithContentsOfFile:path];
        }
        
    }
    
    
    UIImage *thumb = [images makeThumbnailOfSize:CGSizeMake(50,50)];
    cell.imageView.image = thumb;
    
    return cell;
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger row = [indexPath row];
    NSString* temp=[self.list objectAtIndex:row];
    [self.list removeObjectAtIndex:row];
    [self.listDict removeObjectForKey:temp];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    [self writedata];
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    NSString* tempName=[list objectAtIndex:row];
    NSArray* tempArr=[self.listDict objectForKey:tempName];
    
    pointDetails=[[PointDetails alloc]initWithNibName:@"PointDetails" bundle:nil];
    pointDetails.hideNavBar=NO;
    [pointDetails loadarray:[tempArr objectAtIndex:0] :[tempArr objectAtIndex:1] :[tempArr objectAtIndex:2] :[tempArr objectAtIndex:3] :[tempArr objectAtIndex:4]];
    pointDetails.mapController=self.mapController;
    
    //
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
	//HUD.graceTime = 0.5;
	//HUD.minShowTime = 2.0;
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(actionPush) onTarget:self withObject:nil animated:YES];
    //
    
}

-(IBAction)actionPush{
    [self.navigationController pushViewController:pointDetails animated:YES];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    NSString* tempName=[list objectAtIndex:row];
    NSArray* tempArr=[self.listDict objectForKey:tempName];
    
//    mapController.buildingname=[tempArr objectAtIndex:3];
//    mapController.locationname=[tempArr objectAtIndex:0];
//    mapController.imagename=[tempArr objectAtIndex:2];
//    mapController.alias=[tempArr objectAtIndex:1];
//    mapController.mapInfoType=[tempArr objectAtIndex:4];
    
    NSLog(@"\n");
    NSLog(@"buildingname %@",[tempArr objectAtIndex:3]);
    NSLog(@"locatonaname %@",[tempArr objectAtIndex:0]);
    NSLog(@"imagename %@",[tempArr objectAtIndex:2]);
    NSLog(@"alias %@",[tempArr objectAtIndex:1]);
    NSLog(@"mapinfotype %@",[tempArr objectAtIndex:4]);
    
//    [mapController setter];
//    [self.tabBarController setSelectedIndex:2];
    
    NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
    MapPoint* mapPoint=[[MapPoint alloc]init];
    mapPoint.title=[tempArr objectAtIndex:0];
    mapPoint.subTitle=[tempArr objectAtIndex:3];
    mapPoint.imagename=[tempArr objectAtIndex:2];
    mapPoint.alias=[tempArr objectAtIndex:1];
    mapPoint.mapInfoType=[tempArr objectAtIndex:4];
    [MapPointArray addObject:mapPoint];
    [mapController setter];
    mapController.mapPointArray=MapPointArray;
    [self.tabBarController setSelectedIndex:3];
    
    
}

@end

