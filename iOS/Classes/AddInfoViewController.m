//
//  AddInfoViewController.m
//  WiGi
//
//  Created by Vikash Dat on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddInfoViewController.h"

WiGiAppDelegate *myAppDelegate;

@implementation AddInfoViewController

@synthesize cancelButton, shareWithFriendsSwitch, shareWithFacebookButton, submitButton, itemImage, itemTags,
itemComments, headerLabel = _headerLabel;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
	
	[cancelButton release];
	[shareWithFacebookButton release];
	[submitButton release];
	[shareWithFriendsSwitch release];
	[itemImage release];
	[itemTags release];
	[itemComments release];
	[_headerLabel release];
	[myAppDelegate release];
	
    [super dealloc];
}


@end
