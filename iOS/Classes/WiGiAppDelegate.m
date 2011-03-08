//
//  WiGiAppDelegate.m
//  WiGi
//
//  Created by Vikash Dat on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiGiAppDelegate.h"


//global contants
//Facebook appID needed for authorization
static NSString* kAppId = @"195151467166916";

@implementation WiGiAppDelegate

@synthesize window;
@synthesize wigiTabController;

@synthesize myFacebook = _myFacebook, isLoggedIn = _isLoggedIn, myPermissions = _myPermissions;
@synthesize HEADER_TEXT;

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
	
	//set app header
	self.HEADER_TEXT = @"WANT IT, GET IT";
	
	//initialize facebook connect
	self.myFacebook = [[Facebook alloc] initWithAppId:kAppId];
	//[self facebookLogout];
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
		[window setRootViewController:wigiTabController];
	}else{
		NSLog(@"facebook session not valid");
		//[self facebookLogin];
		self.isLoggedIn = FALSE;
		[self showLoginModal];
	}
	
  /*  
	//Get screen bounds 
	CGRect screenBounds = [[UIScreen mainScreen ] applicationFrame];
	CGRect windowBounds = screenBounds;
	windowBounds.origin.y = 0.0;
	
	//initialize the window
	self.window = [[UIWindow alloc] initWithFrame:screenBounds];
	//initial main view
	
	self.wigiMainViewController.view.frame = windowBounds;
	[self.window addSubview:self.wigiMainViewController.view];
  */
	NSLog(@"about to make visibile");
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

/* functions
 */

-(void) showLoginModal {
	NSLog(@"in showLoginModal");
	if (_loginModalRootView == nil){
		NSLog(@"root view nil");
		//create root view to present modal onto
		_loginModalRootView = [[UIViewController alloc] init];
	}
	if (_modalLogin == nil){
		NSLog(@"_modallogin is nil");
		//create modal view
		_modalLogin = [[LoginModalViewController alloc] init];
	}
	
	//push view so it can be used to present modal view
	[window addSubview:_loginModalRootView.view];
	[_loginModalRootView presentModalViewController:_modalLogin animated:YES];
	
}

-(void)facebookLogin {
	NSLog(@"in facebooklogin");
	//authorize takes array of permissions
	[self.myFacebook authorize:nil delegate:self];
}

-(void)facebookLogout {
	[self.myFacebook logout:self];
}

/* Implemented facebook callbacks
 */

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin {
	NSLog(@"Fb login successful");
	//update accesstoken and expirDate
	[[NSUserDefaults standardUserDefaults] setObject:[self.myFacebook accessToken] forKey:@"wigi_facebook_token"];
	[[NSUserDefaults standardUserDefaults] setObject:[self.myFacebook expirationDate] forKey:@"wigi_facebook_expiration_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	//update login status
	self.isLoggedIn = TRUE;
	//show wigitabcontroller
	//[window addSubview:wigiTabController.view];
	[_modalLogin dismissModalViewControllerAnimated:NO];
	[window setRootViewController:wigiTabController];
	[_loginModalRootView release];
	
}
/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"fbDidNotLogin");
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout{
	NSLog(@"fbDidLogout");
	//clear userdefaults
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"wigi_facebook_token"];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"wigi_facebook_expiration_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	//update login status
	self.isLoggedIn = TRUE;
	 
}




- (void)dealloc {

    [self.window release];
	[self.wigiTabController release];
	[_myFacebook release];
	[_myPermissions release];
	[self.HEADER_TEXT release];
	[_loginModalRootView release];
	[_modalLogin release];
	[super dealloc];
}


@end
