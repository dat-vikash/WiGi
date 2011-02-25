//
//  WiGiAppDelegate.h
//  WiGi
//
//  Created by Vikash Dat on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WiGiMainViewController.h"
#import "Facebook.h"

@interface WiGiAppDelegate : NSObject <UIApplicationDelegate> {
    //window and tabbar instance
	UIWindow *window;
	UITabBarController *wigiTabController;
	
	//create facebook instance
	Facebook *_myFacebook;
	NSArray *_myPermissions;
	BOOL *_isLoggedIn;

	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *wigiTabController;
@property(nonatomic, retain) Facebook *myFacebook;
@property (nonatomic, retain) NSArray *myPermissions;
@property (nonatomic) BOOL *isLoggedIn;

@end

