//
//  SelectViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectViewController.h"
#import "SubcategoryViewController.h"
#import "LocationsViewController.h"
#import "thumbNail.h"
@interface SelectViewController ()

@end

@implementation SelectViewController
@synthesize campus,mapController;


- (void)viewDidLoad
{
    self.title=@"Select";
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"LocationHierarchy" ofType:@"plist"];
    campus = [[NSArray alloc] initWithContentsOfFile:path1];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    self.title=@"Select";
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
    return [self.campus count];
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
    NSDictionary* temp=[campus objectAtIndex:row];
    NSString* text=[temp objectForKey:@"Title"];
    cell.textLabel.text = text;
    
    NSString* ip=[self selectImage:text];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:ip ofType:@"png"];
    
    UIImage* images=[[UIImage alloc]initWithContentsOfFile:path1];
    UIImage *thumb = [images makeThumbnailOfSize:CGSizeMake(20,20)];
    cell.imageView.image = thumb;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Table Delegate Methods


-(NSString*)selectImage:(NSString*)text{
    if([text isEqualToString:@"Admins"])
        return @"adminss";
    if([text isEqualToString:@"Faculties / Schools"])
        return @"faculties";
    if([text isEqualToString:@"Research Institutes & Centres"])
        return @"research";
    if([text isEqualToString:@"Lecture Theatres"])
        return @"lecture";
    if([text isEqualToString:@"Libraries"])
        return @"lib";
    if([text isEqualToString:@"Cultural / Recreational / Social Facilities"])
        return @"cultural";
    if([text isEqualToString:@"Campus Services (Retail outlets)"])
        return @"services";
    if([text isEqualToString:@"Residences"])
        return @"residence";
    if([text isEqualToString:@"Campus Dining"])
        return @"dining";
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSDictionary* temp=[campus objectAtIndex:row];
    NSArray* category=[temp objectForKey:@"Subcategory"];
    NSArray* locations=[temp objectForKey:@"Locations"];
    if(category!=nil){
        SubcategoryViewController* categoryController=[[SubcategoryViewController alloc]init];
        categoryController.subcategory=category;
        categoryController.title=[temp objectForKey:@"Title"];
        categoryController.mapController=mapController;
        [self.navigationController pushViewController:categoryController animated:YES];
    }else{
        LocationsViewController* locController=[[LocationsViewController alloc]init];
        locController.locations=locations;
        locController.title=[temp objectForKey:@"Title"];
        locController.mapController=mapController;
        [self.navigationController pushViewController:locController animated:YES];
    }


}



@end
