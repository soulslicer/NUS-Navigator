//
//  SearchCarParkViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface SearchCarParkViewController : UIViewController{
    MapController* mapController;
    UITabBarController *tabBarController;
    
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray *keys;
    NSDictionary* detailList;
    NSDictionary* carParkList;
    
    BOOL    isSearching;
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
@property (nonatomic,strong) NSDictionary* carParkList;

@end
