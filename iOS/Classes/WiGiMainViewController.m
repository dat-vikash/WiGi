//
//  WiGiMainViewController.m
//  WiGi
//
//  Created by Vikash Dat on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiGiMainViewController.h"

WiGiAppDelegate *myAppDelegate;

@implementation WiGiMainViewController

@synthesize loginLabel = _loginLabel, itemView = _cameraImage,
			snapItem = _snapItemButton;

// UIVIEWCONTROLLER METHODS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSLog(@"in here");
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
        
    }
    return self;
}
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"In viewDidLoad...checking if user is logged in");
	// get appdelicate
	myAppDelegate = (WiGiAppDelegate*) [[UIApplication sharedApplication] delegate];
	if (myAppDelegate.isLoggedIn) {
		//user is logged in
		[self fbDidLogin];
	}else {
		[self.loginLabel setText:@" Login"];
	}

	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_loginLabel release];
	[_facebookPicture release];
	[_facebookLoginButton release];
	[_cameraImage release];
	[_snapItemButton release];
	
    [super dealloc];
}

/*Public functions
 */
-(void)facebookLogin {
	NSLog(@"in facebooklogin");
	//authorize takes array of permissions
	[myAppDelegate.myFacebook authorize:nil delegate:self];
}

/* Implemented facebook callbacks
 */
- (void)fbDidLogin {
	//hide login button
	_facebookLoginButton.hidden = YES;
	[myAppDelegate.myFacebook requestWithGraphPath:@"me" andDelegate:self];
	[myAppDelegate.myFacebook requestWithGraphPath:@"me/picture" andDelegate:self];
	NSLog(@"Fb login successful");
	//update accesstoken and expirDate
	[[NSUserDefaults standardUserDefaults] setObject:[myAppDelegate.myFacebook accessToken] forKey:@"wigi_facebook_token"];
	[[NSUserDefaults standardUserDefaults] setObject:[myAppDelegate.myFacebook expirationDate] forKey:@"wigi_facebook_expiration_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


/* IBACTIONS
 */

-(IBAction)facebookLoginButtonClicked:(id) sender {
	NSLog(@"Login button clicked");
	[self facebookLogin];
}


-(IBAction) getPhoto: (id) sender {
	NSLog(@"in getPhoto");
	//get image picture controller for camera
	UIImagePickerController *picker = [[UIImagePickerController alloc] init] ;
	picker.delegate = self;
	
	//determine which button was pressed
	if((UIButton *) sender == self.snapItem) {
		//Snap Item button pressed
		//set picker source type as camera
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	
	[self presentModalViewController:picker animated:YES];
	
}

/////////////////////////////////////////////////////
// UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
		//dimiss popup modal
	NSLog(@"in didFinishPickingMeidaWithInfo: %@", info);
	[picker dismissModalViewControllerAnimated:YES];
	self.itemView.image =  [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 * If you need access to the raw response, use
 * (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	NSLog(@"RESULT CLASS: %@", [result class]);

	if ([result isKindOfClass:[NSArray class]]) {
		NSLog(@"is of NSArray class");
		result = [result objectAtIndex:0];
	}
	if ([result isKindOfClass:[NSData class]]) {
		NSLog(@"1");
		UIImage *img = [[UIImage alloc] initWithData: result];
		[_facebookPicture setImage:img];
	}
	if ([result isKindOfClass:[NSDictionary class]]) {
			NSLog(@"2");
			[self.loginLabel setText:[result objectForKey:@"name"]];
	}
		 NSLog(@"result: %@",result);
		
};

/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"didFailWithError: %@",[error localizedDescription]);
};


@end
