//
//  SearchBusViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchBusViewController.h"
#import "NSDictionary-MutableDeepCopy.h"
#import "MapPoint.h"

@interface SearchBusViewController ()

@end

@implementation SearchBusViewController
@synthesize mapController,tabBarController,table,search,names,allNames,keys,detailList,busStopServices;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

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
    
    unichar firschar=[searchTerm characterAtIndex:0];
    
    if(!(firschar=='-')){
        NSLog(@"RUN1");
        for (NSString *key in self.keys) {
            NSMutableArray *array = [names valueForKey:key];
            NSString* busstopname=[array objectAtIndex:0];
            NSString* busCode=[array objectAtIndex:3];
            if(([busstopname rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound) && ([key rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound) && ([busCode rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound)){
                [toRemove addObject:key];
                //[sectionsToRemove addObject:key];
            }
        }
    }else{
        NSMutableArray* busDisplay=[[NSMutableArray alloc]init];
        NSLog(@"RUN2");
        for(NSString* key in self.keys){
            NSArray* busList=[busStopServices objectForKey:key];
            NSString *newStr = [searchTerm substringFromIndex:1];
            NSLog(@"%@",newStr);
            for(NSString* busnum in busList){
                if([busnum isEqualToString:newStr])
                    [busDisplay addObject:key];
            }
        }
        self.keys=busDisplay;
        
    }
    [self.keys removeObjectsInArray:toRemove];
    [table reloadData];
}



- (void)viewDidLoad
{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"BusLocation"
                                                      ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path1];
    self.allNames = dict;
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"BusStopServices"
                                                      ofType:@"plist"];
    NSDictionary *dict2 = [[NSDictionary alloc]
                          initWithContentsOfFile:path2];
    self.busStopServices = dict2;
    
    
    
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
	
    cell.textLabel.text = [nameSection objectAtIndex:0];
    
    NSArray* busList=[busStopServices objectForKey:key];
    NSMutableString * result = [[NSMutableString alloc] init];
    for(NSString* bus in busList){
        [result appendString:bus];
        [result appendString:@" "];
    }
    cell.detailTextLabel.text=result;

    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    NSString* key=[keys objectAtIndex:row];
    NSArray* detailArray=[names objectForKey:key];
    NSArray* busList=[busStopServices objectForKey:key];
    NSMutableString * result = [[NSMutableString alloc] init];
    for(NSString* bus in busList){
        [result appendString:bus];
        [result appendString:@","];
    }
    
    NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
    MapPoint* mapPoint=[[MapPoint alloc]init];
    mapPoint.title=[detailArray objectAtIndex:0];
    mapPoint.subTitle=result;
    mapPoint.imagename=@"Bus";
    mapPoint.alias=key;
    mapPoint.mapInfoType=@"Bus";
     
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
        NSArray* busList=[busStopServices objectForKey:oneKey];
        NSMutableString * result = [[NSMutableString alloc] init];
        for(NSString* bus in busList){
            [result appendString:bus];
            [result appendString:@","];
        }
        
        MapPoint* mapPoint=[[MapPoint alloc]init];
        mapPoint.title=[detailArray objectAtIndex:0];
        mapPoint.subTitle=result;
        mapPoint.imagename=@"Bus";
        mapPoint.alias=oneKey;
        mapPoint.mapInfoType=@"Bus";
        
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

BOOL searchControl=NO;
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
    if(searchControl==NO)
        [searchBar setShowsCancelButton:NO animated:YES];
    searchControl=NO;
}

- (BOOL)textFieldShouldClear:(UISearchBar *)searchBar{
    searchControl=YES;
    isSearching = NO;
    search.text = @"";
    [self resetSearch];
    [table reloadData];
    [searchBar resignFirstResponder];
    return true;
}



//- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
//    [search setShowsCancelButton:YES animated:NO];
//    for(UIView *subView in search.subviews){
//        if([subView isKindOfClass:UIButton.class]){
//            [(UIButton*)subView setTitle:@"Done" forState:UIControlStateNormal];
//        }
//    }
//}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    alert1=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"A1",@"A2",@"B",@"C",@"More",@"Cancel", nil];
    alert2=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"D1",@"D2",@"BTC",@"Cancel", nil];
    [alert1 show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView==alert1){
        switch (buttonIndex) {
            case 0:{
                isSearching=YES;
                search.text=@"-A1";
                [self handleSearchForTerm:@"-A1"];
                [table reloadData];
                break;
            }
                
            case 1:{
                isSearching=YES;
                search.text=@"-A2";
                [self handleSearchForTerm:@"-A2"];
                [table reloadData];
                break;
            }
                
            case 2:{
                isSearching=YES;
                search.text=@"-B";
                [self handleSearchForTerm:@"-B"];
                [table reloadData];
                break;
            }
                
            case 3:{
                isSearching=YES;
                search.text=@"-C";
                [self handleSearchForTerm:@"-C"];
                [table reloadData];
                break;
            }
                
            case 4:{
                [alert2 show];
                break;
            }
                
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:{
                isSearching=YES;
                search.text=@"-D1";
                [self handleSearchForTerm:@"-D1"];
                [table reloadData];
                break;
            }
                
            case 1:{
                isSearching=YES;
                search.text=@"-D2";
                [self handleSearchForTerm:@"-D2"];
                [table reloadData];
                break;
            }
                
            case 2:{
                isSearching=YES;
                search.text=@"-BTC";
                [self handleSearchForTerm:@"-BTC"];
                [table reloadData];
                break;
            }
            default:
                break;
        }

    }
    
}





@end

