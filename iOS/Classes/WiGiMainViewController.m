//
//  WiGiMainViewController.m
//  WiGi
//
//  Created by Vikash Dat on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiGiMainViewController.h"
#import "WiGiAppDelegate.h"

@implementation WiGiMainViewController

@synthesize headerLabel = _headerLabel, userNameLabel = _userNameLabel, facebookPicture = _facebookPicture,
myAppDelegate, wigiLists, itemsList,itemImageBuffers;

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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWigiList:) name:@"wigiItemUpdate" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWigiItems) name:@"facebookLoginComplete" object:nil];
	
	// get appdelicate
	self.myAppDelegate = (WiGiAppDelegate*) [[UIApplication sharedApplication] delegate];	
	//setup tableview
	self.wigiLists.delegate = self;
	self.wigiLists.dataSource = self;

	//setup image buffers
	self.itemImageBuffers = [[NSMutableDictionary alloc] init];
	
	//set up view
	[self.headerLabel setText:self.myAppDelegate.HEADER_TEXT];
	//check if user is logged in
	if (self.myAppDelegate.isLoggedIn) {
		//user is logged in
		NSLog(@"HERE");
		//get facebook information to populate view
		[self retrieveFacebookInfoForUser];
		//[self.myAppDelegate retrieveWigiItems];
	}else {
		//user is not logged in
		NSLog(@"user not logged in");
		//show login modal
	}
	//[self.wigiLists reloadData];
	[super viewDidLoad];
}
-(void) viewWillAppear:(BOOL)animated {
	NSLog(@"in view will appear");
	[[self wigiLists] reloadData];
}
-(void) viewDidAppear:(BOOL)animated {
	NSLog(@"in wigimain viewdidAppear");

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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.itemsList release];
	[self.wigiLists release];
	[self.itemImageBuffers release];
	[_headerLabel release];
	[_userNameLabel release];
	[_facebookPicture release];
	[self.myAppDelegate release];
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
	[self.myAppDelegate.myFacebook requestWithGraphPath:@"me" andDelegate:self];
	[self.myAppDelegate.myFacebook requestWithGraphPath:@"me/picture" andDelegate:self];	
	
}

-(void) getWigiItems {
	NSLog(@"in getwigiitems");
	[self.myAppDelegate retrieveWigiItems];
	
}
																			  
-(void) reloadWigiList: (NSNotification *) notification {
	if ([NSThread isMainThread]) {
		NSLog(@"main thread");
	}else{
		NSLog(@"MEHTOD NOT CALLED ON MAIN THREAD!");
	}
	NSLog(@"notification recieved:%@", notification.userInfo);
	//setup tableview
	//self.wigiLists = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	//self.wigiLists.delegate = self;
	//self.wigiLists.dataSource = self;

	NSLog(@"in reloadwigilists:%@", wigiLists );
	NSLog(@"list size:%@", self.itemsList);
	NSLog(@"delegate:%@",self.wigiLists.delegate);
	NSLog(@"datasource:%@",self.wigiLists.dataSource);
	//[itemsList
//	[self.itemsList release];self.itemsList = nil;
	
	//[self.itemsList setArray:[notification.userInfo objectForKey:@"items"]];
	self.itemsList = [[NSArray alloc] initWithArray:[notification.userInfo objectForKey:@"items"]];
	//self.itemsList = [[NSArray alloc] initWithObjects:@"one",@"two",@"three",nil];
	NSLog(@"list size:%@", self.itemsList);
	//[self.wigiLists reloadData];
	//
	//[[self wigiLists] reloadData];
	[self.wigiLists reloadData];
	//[[self wigiLists] reloadRowsAtIndexPaths:self.itemsList withRowAnimation:UITableViewRowAnimationNone]; 
	//[self.wigiLists setNeedsDisplay];
	//[self performSelector
}


/////////////////////////////////////
// UITableViewDelegate protocols
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	//NSLog(@"numberofsections: %@", [self.itemsList count]);
	return 1;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
	NSLog(@"7t87giuiu%@",self.itemsList);
	NSLog(@"numberofrows: %i", [self.itemsList count]);
	NSLog(@"section:%i",section);
	if (self.itemsList.count == 0) {
		return 1;	
	}else {
		return [self.itemsList count];
	}
//	return 1;	
	//return 6;

}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSLog(@"trying to return cell");
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell==nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	//grab the item
	if ([self.itemsList count] >0) {
		NSDictionary *currentItem =(NSDictionary *) [self.itemsList objectAtIndex:indexPath.row];
		NSLog(@"%i",indexPath.row);
		//setup the cell
		//NSLog(@"currentItem: %@", self.itemsList);
		[cell.textLabel setText: [currentItem objectForKey:@"item_comments"]];
		NSLog(@"set cell label");
		//check img cache
		//NSLog(@"key: %@",[self.itemImageBuffers objectForKey:[currentItem objectForKey:@"item_image_url"]]);
		if ([self.itemImageBuffers objectForKey:[currentItem objectForKey:@"item_image_url"]]) {
			NSLog(@"gettin from cache");
			cell.imageView.image = [UIImage imageWithData:[self.itemImageBuffers objectForKey:[currentItem objectForKey:@"item_image_url"]]];
		}else {
			NSURL *url = [NSURL URLWithString:[currentItem objectForKey:@"item_image_url"]];
			NSData *img = [[NSData alloc] initWithContentsOfURL:url];
			cell.imageView.image = [UIImage imageWithData:img]; 
			//add to cache
			NSLog(@"afsasa");
			[self.itemImageBuffers setObject:img forKey:[currentItem objectForKey:@"item_image_url"]];
			//[url release];
			//[img release];

		}
		//[currentItem release];
	}

	
	return cell;
	
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
		[self.myAppDelegate wigiLoginWithFbId:[result objectForKey:@"id"]];
		
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
