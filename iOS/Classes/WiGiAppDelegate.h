//
//  WiGiAppDelegate.h
//  WiGi
//
//  Created by Vikash Dat on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModalViewController.h"
#import "Facebook.h"
#import "WiGiRestClient.h"

@interface WiGiAppDelegate : NSObject <FBSessionDelegate,UIApplicationDelegate> {
    //window and tabbar instance
	UIWindow *window;
	UITabBarController *wigiTabController;
	UIViewController *_loginModalRootView;
	UIViewController *_modalLogin;
	
	NSString *HEADER_TEXT;
	WiGiRestClient* restClient;
	//create facebook instance
	Facebook *_myFacebook;
	NSArray *_myPermissions;
	BOOL _isLoggedIn;

	
	
}

@property (nonatomic, retain) NSString * HEADER_TEXT;
@property (nonatomic, retain) WiGiRestClient* restClient;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *wigiTabController;
@property(nonatomic, retain) Facebook *myFacebook;
@property (nonatomic, retain) NSArray *myPermissions;
@property (nonatomic) BOOL isLoggedIn;

-(void)facebookLogin;
-(void)facebookLogout;
-(void)showLoginModal;
-(void) wigiLoginWithFbId: (NSString *) fb_id ;
@end

