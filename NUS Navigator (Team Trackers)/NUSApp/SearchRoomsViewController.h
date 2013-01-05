//
//  SearchRoomsViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"
#import "Conversions.h"
//#import "MBProgressHUD.h"


@interface SearchRoomsViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UISearchBar* search;
    NSArray* names;
    UITableView* table;
    UITableViewCell* tvCell;
    MapController* mapController2;
    Conversions* convert;
    
    UITabBarController *tabBarController;
    //MBProgressHUD *HUD;
}
@property (nonatomic,strong) IBOutlet UISearchBar *search;
@property(nonatomic,strong)NSArray* names;
@property(nonatomic,strong)IBOutlet UITableView* table;
@property (nonatomic,strong) IBOutlet UITableViewCell *tvCell;
@property(nonatomic,strong)MapController* mapController2;
@property(nonatomic,strong)UITabBarController *tabBarController;

-(IBAction)allsearch:(id)sender;
-(void)searchAction;

@end
