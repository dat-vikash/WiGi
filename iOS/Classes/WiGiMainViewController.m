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

@synthesize headerLabel = _headerLabel, userNameLabel = _userNameLabel, facebookPicture = _facebookPicture;

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
	NSLog(@"In viewDidLoad");
	// get appdelicate
	myAppDelegate = (WiGiAppDelegate*) [[UIApplication sharedApplication] delegate];	
	//set up view
	[self.headerLabel setText:myAppDelegate.HEADER_TEXT];
	//check if user is logged in
	if (myAppDelegate.isLoggedIn) {
		//user is logged in
		NSLog(@"HERE");
		//get facebook information to populate view
		[self retrieveFacebookInfoForUser];
	}else {
		//user is not logged in
		NSLog(@"user not logged in");
		//show login modal
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
	
	[_headerLabel release];
	[_userNameLabel release];
	[_facebookPicture release];
	[myAppDelegate release];
	[super dealloc];
}


/*
 Methods
 */

/* This method retrieves the users profile picture and name
 by initiating a graph request to facebook. Request triggers a facebook
 callback method.
 */
-(void) retrieveFacebookInfoForUser {
	NSLog(@"retrieveFacebookInfoForUser");
	[myAppDelegate.myFacebook requestWithGraphPath:@"me" andDelegate:self];
	[myAppDelegate.myFacebook requestWithGraphPath:@"me/picture" andDelegate:self];	
	
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
		//setimage 
		UIImage *img = [[UIImage alloc] initWithData: result];
		[self.facebookPicture setImage:img];
		[img release];
	
	}
	if ([result isKindOfClass:[NSDictionary class]]) {
			//set name
		[self.userNameLabel setText:[result objectForKey:@"name"]];
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
