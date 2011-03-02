//
//  LoginModalViewController.h
//  WiGi
//
//  Created by Vikash Dat on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WiGiAppDelegate.h"

@interface LoginModalViewController : UIViewController {
	UIButton *facebookLoginButton;
	UILabel *loginAppLabel;
		
}
@property(nonatomic, retain) IBOutlet UIButton *facebookLoginButton;
@property(nonatomic, retain) IBOutlet UILabel *loginAppLabel;

-(IBAction)doFacebookLogin: (id) sender;
@end
