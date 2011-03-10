//
//  WiGiMainViewController.h
//  WiGi
//
//  Created by Vikash Dat on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
@class WiGiAppDelegate;


@interface WiGiMainViewController : UIViewController<FBRequestDelegate> {

	//setup UI
	IBOutlet UILabel *_headerLabel;
	IBOutlet UILabel *_userNameLabel;
	IBOutlet UIImageView *_facebookPicture;
	
	WiGiAppDelegate *myAppDelegate;

}
@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UIImageView *facebookPicture;
@property (nonatomic, retain) WiGiAppDelegate *myAppDelegate;

-(void) refreshView;
-(void) retrieveFacebookInfoForUser;
@end
