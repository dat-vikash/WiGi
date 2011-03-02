//
//  AddItemViewController.m
//  WiGi
//
//  Created by Vikash Dat on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddItemViewController.h"

WiGiAppDelegate *myAppDelegate;
@implementation AddItemViewController
@synthesize selectedItem = _selectedItem;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	NSLog(@"additemviewcontroller initwithnib");
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"additemviewcontroller viewdidload");
	// get appdelicate
	myAppDelegate = (WiGiAppDelegate*) [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	//show actionsheet with add item options
	[self showItemOptionsActionSheet];
	
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
	[_selectedItem release];
	[myAppDelegate release];
    [super dealloc];
}


-(void)showItemOptionsActionSheet {
	UIActionSheet *popupItemOptions = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil 
														 otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
	popupItemOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupItemOptions showFromTabBar:myAppDelegate.wigiTabController.view];
	[popupItemOptions release];
	
}

/* UIActionSheetDelegate methods 
 */

-(void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
	NSLog(@"button index: %d",buttonIndex);
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	
	switch (buttonIndex) {
		case 0:
			//take photo
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			[self presentModalViewController:picker animated:YES];
			break;
		case 1:
			//take photo from library
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
			break;
		case 2:
			//cancel button
			break;
		default:
			//default same as cancel
			break;
	}
		
}

/*UIImagePickerControllerDelegate methods
 */
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
		//dismiss modal
	[picker dismissModalViewControllerAnimated:YES];
	self.selectedItem = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
}

@end
