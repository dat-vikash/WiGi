//
//  LoginModalViewController.h
//  WiGi
//
//  Created by Vikash Dat on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WiGiAppDelegate;

@interface LoginModalViewController : UIViewController {
	UIButton *facebookLoginButton;
	UILabel *loginAppLabel;
	WiGiAppDelegate *myAppDelegate;
}
@property(nonatomic, retain) IBOutlet UIButton *facebookLoginButton;
@property(nonatomic, retain) IBOutlet UILabel *loginAppLabel;
@property(nonatomic, retain) WiGiAppDelegate *myAppDelegate;

-(IBAction)doFacebookLogin: (id) sender;
@end
