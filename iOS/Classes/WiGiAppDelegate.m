//
//  WiGiAppDelegate.m
//  WiGi
//
//  Created by Vikash Dat on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiGiAppDelegate.h"
#import "WiGiMainViewController.h"

//global contants
//Facebook appID needed for authorization
static NSString* kAppId = @"195151467166916";

@implementation WiGiAppDelegate

@synthesize window;
@synthesize wigiTabController;
@synthesize myFacebook = _myFacebook, isLoggedIn = _isLoggedIn, myPermissions = _myPermissions;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    NSLog(@" in didFinishLaunchWithOptions with options: %@", launchOptions);
	//check for facebook apikey
	if (!kAppId){
		NSLog(@"missing facebook App id");
		exit(1);
		return nil;
	}
	
	//initialize facebook connect
	self.myFacebook = [[Facebook alloc] initWithAppId:kAppId];
	//Check if the user is logged in
	NSString *facebookTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"wigi_facebook_token"];
	NSDate *facebookExpirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"wigi_facebook_expiration_date"];
	
	if (facebookTokenString != nil && facebookExpirationDate !=nil){
		NSLog(@"facebook token string and expiration date set");
		[self.myFacebook setAccessToken:facebookTokenString];
		[self.myFacebook setExpirationDate:facebookExpirationDate];
	}
	
	//determine if session is valid
	if ([self.myFacebook isSessionValid]) {
		NSLog(@"facebook session is valid");
		self.isLoggedIn = TRUE;
	}else{
		NSLog(@"facebook session not valid");
		self.isLoggedIn = FALSE;
	}
	
  /*  
	//Get screen bounds 
	CGRect screenBounds = [[UIScreen mainScreen ] applicationFrame];
	CGRect windowBounds = screenBounds;
	windowBounds.origin.y = 0.0;
	
	//initialize the window
	self.window = [[UIWindow alloc] initWithFrame:screenBounds];
	//initial main view
	self.wigiMainViewController = [[WiGiMainViewController alloc] init];
	self.wigiMainViewController.view.frame = windowBounds;
	[self.window addSubview:self.wigiMainViewController.view];
  */
	[window addSubview:wigiTabController.view];
	[self.window makeKeyAndVisible];
	
	return YES;
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


//Function needed for facebook
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [self.myFacebook handleOpenURL:url];
}


- (void)dealloc {
    [self.window release];
	[self.wigiTabController release];
	[_myFacebook release];
	[_myPermissions release];
	[super dealloc];
}


@end
