//
//  SearchCarParkViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchCarParkViewController.h"
#import "NSDictionary-MutableDeepCopy.h"


@interface SearchCarParkViewController ()

@end

@implementation SearchCarParkViewController
@synthesize mapController,tabBarController,table,search,names,allNames,keys,detailList,carParkList;


#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch {
    
    NSMutableDictionary *allNamesCopy = [self.allNames mutableDeepCopy];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    //[keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    //[keyArray addObjectsFromArray:[self.allNames allKeys]];
    self.keys = keyArray;
    
}

- (void)handleSearchForTerm:(NSString *)searchTerm {
    //NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
	
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];

    for (NSString *key in self.keys) {
        NSMutableArray *array = [names valueForKey:key];
        NSString* carparkname=[array objectAtIndex:0];
        NSString* carparktype=[array objectAtIndex:3];
        if(([carparkname rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound) && ([key rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound) && ([carparktype rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound)){
            [toRemove addObject:key];
            //[sectionsToRemove addObject:key];
        }
    }
    
    [self.keys removeObjectsInArray:toRemove];
    [table reloadData];
}



- (void)viewDidLoad
{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"CarPark"
                                                      ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path1];
    self.allNames = dict;
    
    [self resetSearch];
    [table reloadData];
    
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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
	if ([keys count] == 0)
        return 0;
    return [keys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [search setShowsBookmarkButton:YES];
    //NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
	
    NSString *key = [keys objectAtIndex:row];
    //NSLog(@"%@",key);
    NSArray *nameSection = [names objectForKey:key];
	
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:SectionsTableIdentifier];
    }
	
    cell.textLabel.text = key;
    cell.detailTextLabel.text=[nameSection objectAtIndex:0];

    //cell.detailTextLabel.text=result;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    NSString* key=[keys objectAtIndex:row];
    NSArray* detailArray=[names objectForKey:key];
    
    NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
    MapPoint* mapPoint=[[MapPoint alloc]init];
    mapPoint.title=[detailArray objectAtIndex:0];
    mapPoint.subTitle=[detailArray objectAtIndex:3];
    mapPoint.imagename=@"Carpark";
    mapPoint.alias=key;
    mapPoint.mapInfoType=@"Carpark";
    
    [MapPointArray addObject:mapPoint];
    [mapController setter];
    mapController.mapPointArray=MapPointArray;
    [self.tabBarController setSelectedIndex:3];
    search.text=holdSearch;
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];;
}

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
    for(NSString* oneKey in keys){
        NSArray* detailArray=[names objectForKey:oneKey];
        
        MapPoint* mapPoint=[[MapPoint alloc]init];
        mapPoint.title=[detailArray objectAtIndex:0];
        mapPoint.subTitle=[detailArray objectAtIndex:3];
        mapPoint.imagename=@"Carpark";
        mapPoint.alias=oneKey;
        mapPoint.mapInfoType=@"Carpark";
        
        [MapPointArray addObject:mapPoint];
        NSLog(@"%@",mapPoint.title);
    }
    [mapController setter];
    mapController.mapPointArray=MapPointArray;
    [self.tabBarController setSelectedIndex:3];
    
    isSearching = NO;
    search.text = @"";
    [self resetSearch];
    [table reloadData];
    [searchBar resignFirstResponder];
    NSLog(@"called");
}

BOOL searchControla=NO;
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
    if(searchControla==NO)
        [searchBar setShowsCancelButton:NO animated:YES];
    searchControla=NO;
}

- (BOOL)textFieldShouldClear:(UISearchBar *)searchBar{
    searchControla=YES;
    isSearching = NO;
    search.text = @"";
    [self resetSearch];
    [table reloadData];
    [searchBar resignFirstResponder];
    return true;
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Visitor",@"Reserved",@"Staff",@"Cancel", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            isSearching=YES;
            search.text=@"Visitor";
            [self handleSearchForTerm:@"Visitor"];
            [table reloadData];
            break;
        }
            
        case 1:{
            isSearching=YES;
            search.text=@"Reserved";
            [self handleSearchForTerm:@"Reserved"];
            [table reloadData];
            break;
        }
            
        case 2:{
            isSearching=YES;
            search.text=@"Staff";
            [self handleSearchForTerm:@"Staff"];
            [table reloadData];
            break;
        }
            
        default:
            break;
    }
    
}


@end
