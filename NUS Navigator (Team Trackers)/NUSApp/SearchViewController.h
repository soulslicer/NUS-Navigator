//
//  SectionsViewController.h
//  Sections
//
//  Created by Dave Mark on 12/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

//@class SearchRoomsViewController;
@interface SearchViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray *keys;
	
	BOOL    isSearching;
    
    NSDictionary* detailList;
    
    MapController* mapController;
    //SearchRoomsViewController* searchRoomsViewController;
    
    UITabBarController *tabBarController;
    
    NSMutableArray* holdArr;
    NSString* holdSearch;
}
@property (nonatomic,strong) IBOutlet UITableView *table;
@property (nonatomic,strong) IBOutlet UISearchBar *search;
@property (nonatomic,strong) NSDictionary *allNames;
@property (nonatomic,strong) NSMutableDictionary *names;
@property (nonatomic,strong) NSMutableArray *keys;
@property (nonatomic,strong) NSDictionary* detailList;
@property(nonatomic,strong)MapController* mapController;
@property(nonatomic,strong)UITabBarController *tabBarController;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
