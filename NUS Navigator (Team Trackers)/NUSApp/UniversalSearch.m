//
//  UniversalSearch.m
//  NUSApp
//
//  Created by Yaadhav Raaj on 19/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UniversalSearch.h"
#import "SearchViewController.h"
#import "SearchRoomsViewController.h"
#import "SearchBusViewController.h"
#import "SearchCarParkViewController.h"
#import "UpdateController.h"

@interface UniversalSearch ()

@end

@implementation UniversalSearch
@synthesize mapController,views,tool,tabBarController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    SearchViewController* searchView=[[SearchViewController alloc]init];
    searchView.mapController=self.mapController;
    searchView.tabBarController=self.tabBarController;
    [views addSubview:searchView.view];
    [self.view bringSubviewToFront:self.tool];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)toggleControls:(id)sender {
    
    for (UIView *viewb in [self.views subviews]) {
        [viewb removeFromSuperview];
    }
    NSLog(@"%u",[[self.views subviews] count]);
    
    if ([sender selectedSegmentIndex] == 0)
    {
        SearchViewController* searchView=[[SearchViewController alloc]init];
        searchView.mapController=self.mapController;
        searchView.tabBarController=self.tabBarController;
        
        [UIView transitionWithView:self.views duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [self.views addSubview:searchView.view]; }
                        completion:nil];
        //searchView.tabBarController=self.tabBarController;

    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        SearchRoomsViewController* searchRooms=[[SearchRoomsViewController alloc]init];
        searchRooms.mapController2=self.mapController;
        searchRooms.tabBarController=self.tabBarController;
        
        [UIView transitionWithView:self.views duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [self.views addSubview:searchRooms.view]; }
                        completion:nil];
    }
    else if ([sender selectedSegmentIndex] == 2)
    {
        SearchBusViewController* searchBus=[[SearchBusViewController alloc]init];
        searchBus.mapController=self.mapController;
        searchBus.tabBarController=self.tabBarController;
        
        [UIView transitionWithView:self.views duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [self.views addSubview:searchBus.view]; }
                        completion:nil]; 
    }
    else if ([sender selectedSegmentIndex] == 3)
    {
        SearchCarParkViewController* searchCar=[[SearchCarParkViewController alloc]init];
        searchCar.mapController=self.mapController;
        searchCar.tabBarController=self.tabBarController;
        
        [UIView transitionWithView:self.views duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [self.views addSubview:searchCar.view]; }
                        completion:nil]; 
    }
    else if ([sender selectedSegmentIndex] == 4)
    {
        UpdateController* updateController=[[UpdateController alloc]init];
        updateController.mapController=self.mapController;
        updateController.tabBarController=self.tabBarController;
        
        [UIView transitionWithView:self.views duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [self.views addSubview:updateController.view]; }
                        completion:nil];
    }
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

@end
