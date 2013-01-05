//
//  IntroViewController.h
//  NUSApp
//
//  Created by Yaadhav Raaj on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroViewController : UIViewController{
    UITextField* usernameTextField;
    UITextField* passwordTextField;
    
    NSString* usernameValue;
    NSString* passwordValue;
    NSString* token;
    NSString* domain;
    NSData* responseData;
    UIActivityIndicatorView* activity;
    UISegmentedControl* segment;
}
@property (nonatomic) IBOutlet UITextField *usernameTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;
@property(nonatomic)IBOutlet  UISegmentedControl* segment;
@property (nonatomic) NSString *usernameValue;
@property (nonatomic) NSString *passwordValue;
@property(nonatomic)NSString* token;
@property(nonatomic)IBOutlet UIActivityIndicatorView* activity;

-(IBAction)login;                       //Attempt log in with data
-(IBAction)dismissTheModalView;         //Dismiss log in window to FirstView
-(IBAction)valuechanged:(id)sender;     //Change the log in type

-(void)writeDatas;                      //Write the Token and log in data to file


@end
