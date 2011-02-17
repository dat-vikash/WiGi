//
//  WiGiAppDelegate.h
//  WiGi
//
//  Created by Vikash Dat on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WiGiMainViewController.h"

@interface WiGiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	//create instance of our main view controller
	WiGiMainViewController *wigiMainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WiGiMainViewController *wigiMainViewController;
@end

