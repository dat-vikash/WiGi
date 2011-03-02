//
//  LoginModalViewController.m
//  WiGi
//
//  Created by Vikash Dat on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginModalViewController.h"

WiGiAppDelegate *myAppDelegate;

@implementation LoginModalViewController
@synthesize facebookLoginButton, loginAppLabel;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSLog(@"in loginmodalviewcontroller initiwithnibname");
	//get appDelegate
	myAppDelegate = (WiGiAppDelegate*) [[UIApplication sharedApplication] delegate];	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"in loginbmodalviewcontroller viewdidload");
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
	[loginAppLabel release];
	[facebookLoginButton release];
    [super dealloc];
}


-(IBAction) doFacebookLogin: (id) sender {
	[myAppDelegate facebookLogin];
}

@end
