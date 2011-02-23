//
//  WiGiMainViewController.h
//  WiGi
//
//  Created by Vikash Dat on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface WiGiMainViewController : UIViewController<FBSessionDelegate,FBRequestDelegate> {
	//create facebook instance
	Facebook *_myFacebook;
	//setup UI
	IBOutlet UILabel *_loginLabel;
	IBOutlet UIImageView *_facebookPicture;
	IBOutlet UIButton *_facebookLoginButton;
	IBOutlet UIImageView *_cameraImage;
	IBOutlet UIButton *_snapItemButton;
}
@property (nonatomic, retain) UILabel *loginLabel;
@property(readonly) Facebook *myFacebook;
@property(nonatomic, retain) UIImageView *itemView;
@property(nonatomic, retain) UIButton *snapItem;

//setup button actions methods
-(IBAction)facebookLoginButtonClicked:(id)sender;
-(IBAction)getPhoto:(id)sender;

@end
