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

-(void) submitNewWigiItem: (UIImage*) item forUserWithId: (NSString*) wigi_id WithFbId: (NSString *) fb_id withWigiAccessToken: (NSString *) access_token  withComment: (NSString*) comment withTag: (NSString*) tag;
{
	//setup url
	NSURL *wigiURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@/items",wigiBaseURL,wigi_id]];
	
	NSLog(@"in submitNewWigiItem");
	// create the connection
	NSMutableURLRequest *wigiRequest = [NSMutableURLRequest requestWithURL:wigiURL
															   cachePolicy:NSURLRequestUseProtocolCachePolicy
														   timeoutInterval:30.0];
	
	// change type to POST (default is GET)
	[wigiRequest setHTTPMethod:@"POST"];
	
	// just some random text that will never occur in the body
	NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
	
	// header value
	NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
								stringBoundary];
	
	// set header
	[wigiRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
	
	//add body
	NSMutableData *postBody = [NSMutableData data];
	NSLog(@"body made");
	//wigi access token	
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"wigi_access_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[access_token dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	//facebook id	
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"wigi_facebook_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[fb_id dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	//tag
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"wigi_item_tag\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[tag dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	//comment
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"wigi_item_comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[comment dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	//image
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"wigi_item_image\"; filename=\"item.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

	// get the image data from main bundle directly into NSData object
	NSData *imgData = UIImageJPEGRepresentation(item, 1.0);
	// add it to body
	[postBody appendData:imgData];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		NSLog(@"message added");
	// final boundary
	[postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

	// add body to post
	[wigiRequest setHTTPBody:postBody];
	
	NSLog(@"body set");
	// pointers to some necessary objects
	NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
	NSError* error = [[NSError alloc] init] ;
	
	// synchronous filling of data from HTTP POST response
	NSData *responseData = [NSURLConnection sendSynchronousRequest:wigiRequest returningResponse:&response error:&error];
NSLog(@"just sent request");
	
	if (error)
	{
		//NSLog(@"EROROROROROROR: %@", error);
	}
	NSLog(@"just 3");

	// convert data into string
	NSString *responseString = [[[NSString alloc] initWithBytes:[responseData bytes]
														 length:[responseData length]
													   encoding:NSUTF8StringEncoding] autorelease];
		NSLog(@"done");
	// see if we get a welcome result
	NSLog(@"%@", responseString);
	/*
	//garbage collection
	[imgData release];
	[wigiURL release];
	[wigiRequest release];
	[stringBoundary release];
	[headerBoundary release];
	*/
}

@end
