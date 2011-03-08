//
//  AddInfoViewController.h
//  WiGi
//
//  Created by Vikash Dat on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WiGiAppDelegate.h"

@interface AddInfoViewController : UIViewController {
	//setup UI
	UIButton *cancelButton;
	UIButton *shareWithFacebookButton;
	UIButton *submitButton;
	UISwitch *shareWithFriendsSwitch;
	UIImageView *itemImageView;
	UIImage *_itemImage;
	UITextField *itemTags;
	UITextField *itemComments;
	UILabel *_headerLabel;
	
}

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *shareWithFacebookButton;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) IBOutlet UISwitch *shareWithFriendsSwitch;
@property (nonatomic, retain) IBOutlet UIImageView *itemImageView;
@property (nonatomic, retain) UIImage *itemImage;
@property (nonatomic, retain) IBOutlet UITextField *itemTags;
@property (nonatomic, retain) IBOutlet UITextField *itemComments;
@property (nonatomic, retain) IBOutlet UILabel *headerLabel;

-(IBAction) doneEditingDismissKeyboard: (id) sender;
-(IBAction) cancelItemSubmission: (id) sender;
-(IBAction) submitItem: (id) sender;

@end
