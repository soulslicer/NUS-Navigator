//
//  SearchBusViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface SearchBusViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    MapController* mapController;
    UITabBarController *tabBarController;
    
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray *keys;
    NSDictionary* detailList;
    NSDictionary* busStopServices;
    
    BOOL    isSearching;
    
    UIAlertView* alert1;
    UIAlertView* alert2;

    NSString* holdSearch;
}
@property(nonatomic,strong)MapController* mapController;
@property(nonatomic,strong)UITabBarController *tabBarController;
@property (nonatomic,strong) IBOutlet UITableView *table;
@property (nonatomic,strong) IBOutlet UISearchBar *search;
@property (nonatomic,strong) NSDictionary *allNames;
@property (nonatomic,strong) NSMutableDictionary *names;
@property (nonatomic,strong) NSMutableArray *keys;
@property (nonatomic,strong) NSDictionary* detailList;
@property (nonatomic,strong) NSDictionary* busStopServices;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
