//
//  ModuleViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModuleViewController.h"
#import "IVLEModuleListParser.h"
#import "TimeTableViewController.h"

@interface ModuleViewController ()

@end

@implementation ModuleViewController
@synthesize token,APIKey,activity,table,mapController;

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
    self.title=@"IVLE Modules";
    [activity startAnimating];
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
    return [moduleArray count];
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

    }
    
    NSUInteger row = [indexPath row];
    Module* mod=[moduleArray objectAtIndex:row];
    cell.textLabel.text=mod.courseName;
    
    NSString* a=mod.courseAcadYear;
    NSString* b=mod.courseSemester;
    NSString* final=[NSString stringWithFormat:@"%@, %@",a,b];
    cell.detailTextLabel.text=final;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    Module* mod=[moduleArray objectAtIndex:row];
    NSString* courseID=mod.courseID;

    TimeTableViewController* timeController=[[TimeTableViewController alloc]init];
    timeController.APIKey=APIKey;
    timeController.token=token;
    timeController.courseID=courseID;
    timeController.mapController=mapController;
    [self.navigationController pushViewController:timeController animated:YES];
    
    
    
}



@end
