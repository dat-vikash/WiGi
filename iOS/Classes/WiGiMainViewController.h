//
//  WiGiMainViewController.h
//  WiGi
//
//  Created by Vikash Dat on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface WiGiMainViewController : UIViewController<FBSessionDelegate> {
	//create facebook instance
	Facebook *_myFacebook;
	//setup UI
	IBOutlet UILabel *_loginLabel;
	IBOutlet UIButton *_facebookLoginButton;
	
}
@property (nonatomic, retain) UILabel *loginLabel;
@property(readonly) Facebook *myFacebook;

//setup button actions methods
-(IBAction)facebookLoginButtonClick:(id)sender;
@end
