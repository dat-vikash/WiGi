//
//  WiGiRestClient.h
//  WiGi
//
//  Created by Vikash Dat on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSURLConnection.h"
@class WiGiAppDelegate;

@interface WiGiRestClient : NSObject {
	NSURL *_restful_webservice_url;
	WiGiAppDelegate* myAppDelegate;
}
@property (nonatomic, retain) WiGiAppDelegate *myAppDelegate;
@property (nonatomic, retain) NSURL *wigiRestUrl;

-(void) getWigiAuthorizationForFbId: (NSString *) fb_id withAccessToken: (NSString *) access_token exprDate: (NSString *) expr_date;
-(void) submitNewWigiItem: (UIImage*) item forUserWithId:(NSString*) wigi_id forUserWithFbId: (NSString *) fb_id withWigiAccessToken: (NSString *) access_token withComment: (NSString*) comment withTag: (NSString*) tag;
-(void) getWigiItemsForUserWithId: (NSString*) wigi_id withWigiAccessToken: (NSString *) access_token;
@end
