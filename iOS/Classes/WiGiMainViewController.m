//
//  WiGiMainViewController.m
//  WiGi
//
//  Created by Vikash Dat on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiGiMainViewController.h"

//global contants
//Facebook appID needed for authorization
static NSString* kAppId = @"195151467166916";

@implementation WiGiMainViewController

@synthesize loginLabel = _loginLabel, myFacebook = _myFacebook;

// UIVIEWCONTROLLER METHODS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //check for facebook apikey
	if (!kAppId){
		NSLog(@"missing facebook App id");
		exit(1);
		return nil;
	}
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"In viewDidLoad...initializing facebook");
	_myFacebook = [[Facebook alloc] initWithAppId:kAppId];
	[self.loginLabel setText:@" Login"];
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
	[_myFacebook release];
	[_loginLabel release];
	[_facebookPicture release];
	[_facebookLoginButton release];
    [super dealloc];
}

/* Private functions
 */
-(void)facebookLogin {
	//authorize takes array of permissions
	[self.myFacebook authorize:nil delegate:self];
}

/* Implemented facebook callbacks
 */
- (void)fbDidLogin {
	//hide login button
	_facebookLoginButton.hidden = YES;
	[self.myFacebook requestWithGraphPath:@"me" andDelegate:self];
	[self.myFacebook requestWithGraphPath:@"me/picture" andDelegate:self];
	NSLog(@"Fb login successful");
	
}


/* IBACTIONS
 */

-(IBAction)facebookLoginButtonClicked:(id) sender {
	NSLog(@"Login button clicked");
	[self facebookLogin];
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
