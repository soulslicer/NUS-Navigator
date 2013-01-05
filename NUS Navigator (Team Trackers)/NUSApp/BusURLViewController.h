//
//  BusURLViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusURLViewController : UIViewController<UINavigationBarDelegate>{
    NSURL* busInfoURL;
    NSString* BusName;
    NSString* stringURL;
    UINavigationItem* item;
    UIWebView* webView;
}
@property(nonatomic)NSURL* busInfoURL;
@property(nonatomic)NSString* busName;
@property(nonatomic)NSString* stringURL;
@property(nonatomic)IBOutlet UINavigationItem* item;
@property(nonatomic)IBOutlet UIWebView* webView;

-(IBAction)dismiss;

@end
