//
//  WiGiMainViewController.h
//  WiGi
//
//  Created by Vikash Dat on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
@class WiGiAppDelegate;


@interface WiGiMainViewController : UIViewController<FBRequestDelegate,UITableViewDelegate, UITableViewDataSource> {

	//setup UI
	IBOutlet UILabel *_headerLabel;
	IBOutlet UILabel *_userNameLabel;
	IBOutlet UIImageView *_facebookPicture;
	UITableView *wigiLists;
	
	WiGiAppDelegate *myAppDelegate;
	NSArray *itemsList;
	NSMutableDictionary *itemImageBuffers;

}
@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UIImageView *facebookPicture;
@property (nonatomic, retain) WiGiAppDelegate *myAppDelegate;
@property (nonatomic, retain) IBOutlet UITableView *wigiLists;
@property (nonatomic, retain) NSArray *itemsList;
@property (nonatomic, retain) NSMutableDictionary *itemImageBuffers;
-(void) refreshView;
-(void) retrieveFacebookInfoForUser;
-(void) reloadWigiList: (NSNotification*) notification;
-(void) facebookLoginComplete;
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger) section;
-(UITableViewCell *) tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath;

@end
