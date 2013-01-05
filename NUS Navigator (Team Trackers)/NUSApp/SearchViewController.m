//
//  SectionsViewController.m
//  Sections
//
//  Created by Dave Mark on 12/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "NSDictionary-MutableDeepCopy.h"
#import "SearchRoomsViewController.h"
#import "MapPoint.h"

@implementation SearchViewController
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;
@synthesize detailList;
@synthesize mapController;
@synthesize tabBarController;
//@synthesize searchRoomsViewController;

//Temp remove this

#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch {

    NSMutableDictionary *allNamesCopy = [self.allNames mutableDeepCopy];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    //[keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
    
}

- (void)handleSearchForTerm:(NSString *)searchTerm {
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
	
    for (NSString *key in self.keys) {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in array) {
            
            NSArray* tempArr=[detailList valueForKey:name];
            NSString* alias=[tempArr objectAtIndex:1];
            NSString* type=[tempArr objectAtIndex:2];
            NSString* building=[tempArr objectAtIndex:3];
            if (([name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound) && ([alias rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound) && ([type rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound) && ([building rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)){
                [toRemove addObject:name];
            }
            
            //Take the name above, and search the key of it
            
            //            if ([tempS rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
            //                [toRemove addObject:name];
            
        }
        
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
		
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}

- (void)viewDidLoad {
    self.title=@"Search";
    NSLog(@"LOAD2");
    
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"Building_Letterlist"
//                                                      ofType:@"plist"];
    
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath1 = [path1 stringByAppendingPathComponent:@"Building_Letterlist.plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:plistpath1];
    self.allNames = dict;
    
//    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Building_Fulllist"
//                                                      ofType:@"plist"];
    NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* plistpath2 = [path2 stringByAppendingPathComponent:@"Building_Fulllist.plist"];
    NSDictionary* dict2=[[NSDictionary alloc]initWithContentsOfFile:plistpath2];
    
    self.detailList=dict2;
	
    [self resetSearch];
    

    
    [table reloadData];
    //[table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];	
    
    
    for (UIView *view in search.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }
    }
    
    for(UIView *view in [search subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            [(UIBarItem *)view setTitle:@"Add All!"];
        }
    }
    [search setShowsCancelButton:NO animated:NO];
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.table = nil;
    self.search = nil;
    self.allNames = nil;
    self.names = nil;	
    self.keys = nil;
    self.detailList=nil;
    [super viewDidUnload];
}


#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([keys count] > 0) ? [keys count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	if ([keys count] == 0)
        return 0;
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [search setShowsBookmarkButton:YES];
    //NSLog(@"LOAD");
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
	
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
	
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:SectionsTableIdentifier];
        
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    }
	
    cell.textLabel.text = [nameSection objectAtIndex:row];
    
    NSString* titlename=[nameSection objectAtIndex:row];
    NSArray* subtitlearray=[detailList valueForKey:titlename];
    NSString* subtitle=[subtitlearray objectAtIndex:3];
    cell.detailTextLabel.text=subtitle;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];

    return labelSize.height+35;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SEARCHTEXT %@",search.text);
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    NSString* titlename=[nameSection objectAtIndex:row];
    NSArray* subtitlearray=[detailList valueForKey:titlename];
    NSString* subtitle=[subtitlearray objectAtIndex:3];
    if(self.mapController==nil){
//        MapController* temp=[[MapController alloc]init];
//        self.mapController=temp;
        NSLog(@"FAIL");
    }
    //[mapController gotomypoint];
    //    mapController.buildingname=subtitle;
    //    mapController.locationname=[subtitlearray objectAtIndex:0];
    //    mapController.imagename=[subtitlearray objectAtIndex:2];
    //    mapController.alias=[subtitlearray objectAtIndex:1];
    //    mapController.mapInfoType=@"Normal";
    //    [mapController setter];
    //    [self.tabBarController setSelectedIndex:2];
    
    //mapController.mapView.delegate=mapController;
    NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
    MapPoint* mapPoint=[[MapPoint alloc]init];
    mapPoint.title=[subtitlearray objectAtIndex:0];
    mapPoint.subTitle=subtitle;
    mapPoint.imagename=[subtitlearray objectAtIndex:2];
    mapPoint.alias=[subtitlearray objectAtIndex:1];
    mapPoint.mapInfoType=@"Normal";
    [MapPointArray addObject:mapPoint];
    [mapController setter];
    mapController.mapPointArray=MapPointArray;
    [self.tabBarController setSelectedIndex:3];
    search.text=holdSearch;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
	if ([keys count] == 0)
        return nil;
    
    NSString *key = [keys objectAtIndex:section];
	if (key == UITableViewIndexSearch)
        return nil;
    return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (isSearching)
//        return nil;
    return keys;	
}


#pragma mark -
#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [search resignFirstResponder];
    isSearching = NO;
    search.text = @"";
    [tableView reloadData];
    return indexPath;	
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm {
    if ([searchTerm length] == 0) {
        [self resetSearch];
        [table reloadData];
        return;
    }
    [self handleSearchForTerm:searchTerm];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
    NSMutableArray* finalNames=[[NSMutableArray alloc]init];
    for(NSString* oneKey in keys){
        NSArray* temp=[self.names objectForKey:oneKey];
        for(NSString* oneName in temp){
            [finalNames addObject:oneName];
        }
    }
    
    for(NSString* oneName in finalNames){
        MapPoint* mapPoint=[[MapPoint alloc]init];
        NSArray* onePoint=[detailList objectForKey:oneName];
        mapPoint.title=[onePoint objectAtIndex:0];
        mapPoint.subTitle=[onePoint objectAtIndex:3];
        mapPoint.imagename=[onePoint objectAtIndex:2];
        mapPoint.alias=[onePoint objectAtIndex:1];
        mapPoint.mapInfoType=@"Normal";
        [MapPointArray addObject:mapPoint];
    }
    
    if([MapPointArray count]<=37){
    [mapController setter];
    mapController.mapPointArray=MapPointArray;
    [self.tabBarController setSelectedIndex:3];
    }else{
        NSLog(@"%u",[MapPointArray count]);
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Too many items to add" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    isSearching = NO;
    search.text = @"";
    [self resetSearch];
    [table reloadData];
    [searchBar resignFirstResponder];
}

BOOL searchControls=NO;
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [search setShowsCancelButton:YES animated:YES];
    for(UIView *view in [search subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            [(UIBarItem *)view setTitle:@"Add All!"];
        }
    }
    isSearching = YES;
    [table reloadData];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    holdSearch=search.text;
    if(searchControls==NO)
        [searchBar setShowsCancelButton:NO animated:YES];
    searchControls=NO;
}

- (BOOL)textFieldShouldClear:(UISearchBar *)searchBar{
    searchControls=YES;
    isSearching = NO;
    search.text = @"";
    [self resetSearch];
    [table reloadData];
    [searchBar resignFirstResponder];
    return true;
}


- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
			   atIndex:(NSInteger)index {
    return index;
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Library",@"Food",@"Money",@"Store",@"Canteen",@"Cancel", nil];
    alert.frame = CGRectMake( 70.0, 200., 150.0, 150.0);
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            isSearching=YES;
            search.text=@"Library";
            [self handleSearchForTerm:@"Library"];
            [table reloadData];
            break;
        }
            
        case 1:{
            isSearching=YES;
            search.text=@"Food";
            [self handleSearchForTerm:@"Food"];
            [table reloadData];
            break;
        }
            
        case 2:{
            isSearching=YES;
            search.text=@"Money";
            [self handleSearchForTerm:@"Money"];
            [table reloadData];
            break;
        }
            
        case 3:{
            isSearching=YES;
            search.text=@"Store";
            [self handleSearchForTerm:@"Store"];
            [table reloadData];
            break;
        }
            
        case 4:{
            isSearching=YES;
            search.text=@"Canteen";
            [self handleSearchForTerm:@"Canteen"];
            [table reloadData];
            break;
        }
            
        default:
            break;
    }
    
}



@end
