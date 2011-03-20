//
//  AddItemViewController.m
//  WiGi
//
//  Created by Vikash Dat on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddItemViewController.h"


@implementation AddItemViewController
@synthesize selectedItem = _selectedItem, userHasSelectedItem = _userHasSelectedItem, myAppDelegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	NSLog(@"additemviewcontroller initwithnib");
	self.userHasSelectedItem = FALSE;
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"additemviewcontroller viewdidload");
	// get appdelicate
	self.myAppDelegate = (WiGiAppDelegate*) [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated {
	NSLog(@"in viewdidAppear");
	[super viewWillAppear:animated];
	if (self.userHasSelectedItem) {
		NSLog(@"about to show modal");
		[self showAddInfoModal];	
	}else {
		NSLog(@"about to show actionsheet");
		//show actionsheet with add item options
		[self showItemOptionsActionSheet];		
	}

	
}

-(void) viewDidDisappear:(BOOL)animated {
	NSLog(@"in viewDidDisappear");
	[super viewDidDisappear:animated];
	
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
	NSLog(@"IN DEALLOC");
	[_selectedItem release];
	[self.myAppDelegate release];
    [super dealloc];
}


-(void)showItemOptionsActionSheet {
	UIActionSheet *popupItemOptions = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil 
														 otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
	popupItemOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupItemOptions showFromTabBar: self.myAppDelegate.wigiTabController.view];
	[popupItemOptions release];
	
}

-(void)showAddInfoModal {
	NSLog(@"in showAddInfoModal");
	AddInfoViewController *addItemViewController = [[AddInfoViewController alloc] init];
	addItemViewController.itemImage = self.selectedItem;
	[self presentModalViewController:addItemViewController animated:YES];
	[addItemViewController release];
	//reset item flag
	self.userHasSelectedItem = FALSE;
}

/* UIActionSheetDelegate methods 
 */

-(void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
	NSLog(@"button index: %d",buttonIndex);
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	
	switch (buttonIndex) {
		case 0:
			//take photons
			NSLog(@"take photo");
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			picker.delegate = self;
			[self presentModalViewController:picker animated:YES];
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
			break;
		case 1:
			//take photo from library
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
			break;
		case 2:
			//cancel button
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
			[self.myAppDelegate.wigiTabController setSelectedIndex:0];
			break;
		default:
			//default same as cancel
			break;
	}
	[picker release];
	NSLog(@"hereadasdfas");
	
		
}

/*UIImagePickerControllerDelegate methods
 */
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
		//dismiss modal
	NSLog(@"in didFinishPickingMediaWithInfo");
	[picker dismissModalViewControllerAnimated:YES];
	self.selectedItem = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	self.userHasSelectedItem = TRUE;
	//[self performSelector:@selector(showAddInfoModal) withObject:nil afterDelay:0.5];
	//[self showAddInfoModal];
}


@end
