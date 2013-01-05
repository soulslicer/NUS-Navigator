//
//  SearchRoomsViewController.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchRoomsViewController.h"
#import "RoomDetailParser.h"
#import "RoomDetails.h"
#import "SVProgressHUD.h"

@interface SearchRoomsViewController ()

@end

@implementation SearchRoomsViewController
@synthesize search,names,table,tvCell,mapController2,tabBarController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)allsearch:(id)sender{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.navigationController.view cache:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    convert=[[Conversions alloc]init];
    NSLog(@"LOAD");
    
    for (UIView *view in search.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
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
#pragma mark Search Bar Delegate Methods

-(void)searchAction{
    NSString *searchTerm = [search text];
    RoomDetailParser* parser=[[RoomDetailParser alloc]init];
    [parser initWithContentRoomCode:searchTerm];
    names=[parser returnList];
    
    if ([names count])
        NSLog(@"success");
    else{
        //NSLog(@"fail");
        [parser initWithContentRoomName:searchTerm];
        names=[parser returnList];
        if([names count])
            NSLog(@"success 2");
        else{
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Nothing Found" message:@"Nothing was found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"fail");
        }
    }

    [table reloadData];
    [SVProgressHUD dismiss];


}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    //HUD.delegate = self;
//    HUD.labelText = @"Searching";
//    [HUD showWhileExecuting:@selector(searchAction) onTarget:self withObject:nil animated:YES];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(searchAction) withObject:nil afterDelay:0.5];

    
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm {
//    if ([searchTerm length] == 0) {
//        [self resetSearch];
//        [table reloadData];
//        return;
//    }
//    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    isSearching = NO;
//    search.text = @"";
//    [self resetSearch];
    names=nil;
    [table reloadData];
    [searchBar resignFirstResponder];
}


- (BOOL)textFieldShouldClear:(UISearchBar *)searchBar{
    names=nil;
    [table reloadData];
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [search setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [search setShowsCancelButton:NO animated:YES];
}



#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	if ([names count] == 0)
        return 0;
    return [names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    RoomDetails* room=[names objectAtIndex:row];

    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
	
    UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
													 owner:self options:nil];
        if ([nib count] > 0) {
            cell = self.tvCell;
        } else {
            NSLog(@"failed to load CustomCell nib file!");
        }
    }
    
    UILabel* roomnameLabel=(UILabel*)[cell viewWithTag:1];
    roomnameLabel.text=room.roomName;
    UILabel* roomcodeLabel=(UILabel*)[cell viewWithTag:2];
    roomcodeLabel.text=room.roomCode;
    UILabel* deptlabel=(UILabel*)[cell viewWithTag:3];
    deptlabel.text=room.dept;

    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSUInteger row = [indexPath row];
    RoomDetails* room=[names objectAtIndex:row];

    
    NSMutableArray* MapPointArray=[[NSMutableArray alloc]init];
    MapPoint* mapPoint=[[MapPoint alloc]init];
    mapPoint.title=[room.roomCode uppercaseString];
    mapPoint.subTitle=[convert converter:room.roomCode :room.dept];;
    mapPoint.imagename=@"Room";
    mapPoint.alias=@" ";
    mapPoint.mapInfoType=@"Room";
    [MapPointArray addObject:mapPoint];
    [mapController2 setter];
    mapController2.mapPointArray=MapPointArray;
    [self.tabBarController setSelectedIndex:3];
    
    //NSLog(@"SUBTITLE %@",mapPoint.subTitle);
    
    
    
    
}


@end
