//
//  WiGiRestClient.m
//  WiGi
//
//  Created by Vikash Dat on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiGiRestClient.h"

//SET WIGI RESTFUL WEBSERVICES BASE URL
static NSString* wigiBaseURL = @"http://ec2-50-17-86-253.compute-1.amazonaws.com:8888/";


@implementation WiGiRestClient
@synthesize wigiRestUrl = _restful_webservice_url;


-(NSDictionary*) getWigiAuthorizationForFbId: (NSString *) fb_id withAccessToken: (NSString *) access_token 
								 exprDate: (NSString *) expr_date {
	//RESTful post to wigi login service
	//parameters are facebook_id,  facebook access_token, and expiration date. This will return a JSON 
	//response containing a wigi access token to allow user data manipulation
	NSLog(@"in rest client");
	//initialize wigi url path to authorization
	NSURL *wigiURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@login",wigiBaseURL]];
	//setup wigi request for authorization
	NSMutableURLRequest *wigiRequest = [[NSMutableURLRequest alloc] initWithURL:wigiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
															timeoutInterval:10];
	[wigiRequest setHTTPMethod:@"POST"];
	[wigiRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	//setup POST agruments
	//TODO: EXPR_DATE
	NSString *postData = [[NSString alloc] initWithString: [NSString stringWithFormat:@"wigi_accessToken=%@&wigi_expr_token=1&wigi_fb_id=%@", access_token, fb_id]];
	NSString *len = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d", [postData length]]];
	[wigiRequest setValue:len forHTTPHeaderField:@"Content-Length"];
	[wigiRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
	NSHTTPURLResponse *wigiResponse = [[[NSHTTPURLResponse alloc] init] autorelease];
	NSError *wigiError = [[[NSError alloc] init] autorelease];
	
	NSData * responseData = [[NSData alloc] initWithData: [NSURLConnection sendSynchronousRequest:wigiRequest returningResponse:&wigiResponse error:&wigiError]];
	NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"WIGI RESPONSE: %@", responseString);

	//release objects
	[wigiURL release];
	[wigiRequest release];
	[postData release];
	[len release];
	[responseData release];
		
	return [[[NSDictionary alloc] initWithDictionary: [responseString JSONValue] ] autorelease];
}

-(void) submitNewWigiItem: (id) item forUserWithId: (NSString*) wigi_id WithFbId: (NSString *) fb_id withWigiAccessToken: (NSString *) access_token{
	NSLog(@"in submitNewWigiItem");
	//setup url
//	NSURL *wigiItemURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/items",wigiBaseURL,fb_id
}

@end
