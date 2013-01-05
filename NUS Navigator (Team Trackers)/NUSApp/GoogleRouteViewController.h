//
//  GoogleRouteViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPoint.h"

@interface GoogleRouteViewController : UIViewController{
    UINavigationItem* item;
    UIWebView* webView;
    NSString *googleMapsURLString;
    
    MapPoint* transfer;
    CLLocation* start;
}
@property(nonatomic)IBOutlet UINavigationItem* item;
@property(nonatomic)IBOutlet UIWebView* webView;
@property(nonatomic)MapPoint* transfer;
@property(nonatomic)CLLocation* start;

-(IBAction)dismiss;

@end
