//
//  FirstViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/************************************************************************
 * FIRST VIEW CONTROLLER
 
 This class does the following:
 
 1. Act as the main screen to view IVLE Modules, Help File and Log
    in page
 ************************************************************************/

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
#import "MapController.h"


@interface FirstViewController : UIViewController{
    
    IntroViewController* introViewController;
    MapController* mapController;
    
    BOOL loggedin;
    BOOL viewloading;
    
    UIWebView* webview;
    UILabel* nameLabel;
    
    NSString* message;
    NSString* token;
    NSString* APIKey;
    
    UIButton* moduleButton;
    UIButton* todayButton;
    
}
@property(nonatomic)IntroViewController* introViewController;
@property(nonatomic)MapController* mapController;

@property(nonatomic)NSString* message;
@property(nonatomic)NSString* token;
@property(nonatomic)NSString* APIKey;

@property (nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic)IBOutlet UIWebView* webview;

@property(nonatomic)IBOutlet UIButton* moduleButton;
@property(nonatomic)IBOutlet UIButton* todayButton;

-(IBAction)logout:(id)sender;                   //Log Out to LogInController
-(IBAction)modules:(id)sender;                  //View all Modules
-(IBAction)today:(id)sender;                    //View today's schedule only

-(void)loadFirstView;                           //Load the class
-(void)LoadHelpController;                      //Load Help Controller
-(void)deleteInfo;                              //Deletes saved user Info
-(void)updateCurrUser:(BOOL)userExists;         //Updates who the current user is
-(void)buttonRemoveLoad:(BOOL)unlinkSelected;   //Select Type of Button

-(void)loadToken;                               //Load Token
-(void)writeLoginData:(BOOL)x;                  //Write Login data to file
-(void)logoutErase;                             //Logout and erase user info

@end
