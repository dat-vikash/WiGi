//
//  AddItemViewController.h
//  WiGi
//
//  Created by Vikash Dat on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddInfoViewController.h"
@class WiGiAppDelegate;

@interface AddItemViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate> {
	UIImage *_selectedItem;
	BOOL _userHasSelectedItem;
	WiGiAppDelegate *myAppDelegate;
}
@property(nonatomic, retain) UIImage *selectedItem;
@property(nonatomic) BOOL userHasSelectedItem;
@property(nonatomic, retain) WiGiAppDelegate *myAppDelegate;
@end
