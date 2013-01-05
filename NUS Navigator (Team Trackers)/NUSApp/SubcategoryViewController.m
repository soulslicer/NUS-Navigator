//
//  SubcategoryViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubcategoryViewController.h"
#import "LocationsViewController.h"

@interface SubcategoryViewController ()

@end

@implementation SubcategoryViewController
@synthesize subcategory,mapController;

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
    //self.title=@"Subcategory";
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
    return [self.subcategory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
        
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary* temp=[subcategory objectAtIndex:row];
    cell.textLabel.text = [temp objectForKey:@"Title"];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    
    NSUInteger row = [indexPath row];
    id temp=[subcategory objectAtIndex:row];
    if([temp isKindOfClass:[NSString class]]){
        return labelSize.height + 21;
    }
    else if([temp isKindOfClass:[NSDictionary class]]){//temp is dict
        return labelSize.height + 35;
    }

}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSDictionary* temp=[subcategory objectAtIndex:row];
    NSArray* locations=[temp objectForKey:@"Locations"];
        LocationsViewController* locController=[[LocationsViewController alloc]init];
        locController.locations=locations;
    locController.mapController=mapController;
        [self.navigationController pushViewController:locController animated:YES];
    
}


@end

