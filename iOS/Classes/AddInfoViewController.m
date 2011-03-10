//
//  AddInfoViewController.m
//  WiGi
//
//  Created by Vikash Dat on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddInfoViewController.h"


@implementation AddInfoViewController

@synthesize cancelButton, shareWithFriendsSwitch, shareWithFacebookButton, submitButton, itemImageView, itemTags,
itemComments, headerLabel = _headerLabel, itemImage=_itemImage, myAppDelegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSLog(@"in init with nib add info");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"in viewdidload addinfo");
	self.myAppDelegate = (WiGiAppDelegate*) [[UIApplication sharedApplication] delegate];
	self.itemImageView.image = self.itemImage;
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

-(IBAction)doneEditingDismissKeyboard: (id) sender {
	
	[sender resignFirstResponder];
}

-(IBAction)cancelItemSubmission: (id) sender{
	[self dismissModalViewControllerAnimated:YES];
	//[myAppDelegate.wigiTabController setSelectedIndex:2];
	//[self dealloc];
}


-(IBAction) submitItem: (id) sender{
	//get text fields
	[self.myAppDelegate wigiItemSubmit];
	 
}



- (void)dealloc {
	
	[cancelButton release];
	[shareWithFacebookButton release];
	[submitButton release];
	[shareWithFriendsSwitch release];
	[itemImageView release];
	[_itemImage release];
	[itemTags release];
	[itemComments release];
	[_headerLabel release];
	[self.myAppDelegate release];
	
    [super dealloc];
}


@end
