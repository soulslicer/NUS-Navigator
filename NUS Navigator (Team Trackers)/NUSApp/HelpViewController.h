//
//  GoogleRouteViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPoint.h"

@interface HelpViewController : UIViewController{
    UINavigationItem* item;
    UIWebView* webView;

}
@property(nonatomic)IBOutlet UINavigationItem* item;
@property(nonatomic)IBOutlet UIWebView* webView;

-(IBAction)dismiss;

@end
