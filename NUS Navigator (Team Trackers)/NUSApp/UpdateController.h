//
//  UpdateController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 13/8/12.
//
//

#import <UIKit/UIKit.h>
#import "MapController.h"
#import <MessageUI/MessageUI.h>

@interface UpdateController : UIViewController<MFMailComposeViewControllerDelegate>{
    MapController* mapController;
    UITabBarController *tabBarController;
    UIWebView* webview;
}
@property(nonatomic,strong)MapController* mapController;
@property(nonatomic,strong)UITabBarController *tabBarController;
@property(nonatomic,strong)IBOutlet UIWebView* webview;

-(IBAction)update:(id)sender;
-(IBAction)mail:(id)sender;

@end
