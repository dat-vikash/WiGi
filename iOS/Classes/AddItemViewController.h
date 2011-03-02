//
//  AddItemViewController.h
//  WiGi
//
//  Created by Vikash Dat on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WiGiAppDelegate.h"

@interface AddItemViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate> {
	UIImage *_selectedItem;
	
}
@property(nonatomic, retain) UIImage *selectedItem;

@end
