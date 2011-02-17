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
	[self.loginLabel setText:@"Please Login"];
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
	NSLog(@"Fb login successful");
}


/* IBACTIONS
 */

-(IBAction)facebookLoginButtonClick:(id) sender {
	NSLog(@"Login button clicked");
	[self facebookLogin];
}

@end
