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
	NSLog(@"in submitNewWigiItem");
	//setup url
	NSURL *wigiURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@/items",wigiBaseURL,wigi_id]];
	//setup request for add item
	NSMutableURLRequest *wigiRequest = [[NSMutableURLRequest alloc] initWithURL:wigiURL cachePolicy:NSURLRequestReloadIgnoringCacheData
																timeoutInterval:10];
	[wigiRequest setHTTPMethod:@"POST"];
	
	//define post boundary
	NSString *boundary = [[NSString alloc] initWithString: [[NSProcessInfo processInfo] globallyUniqueString]];
	NSString *boundaryString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary]];
	[wigiRequest addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
	
	//define boundary seperator
	NSString *boundarySeparator = [[NSString alloc] initWithString: [NSString stringWithFormat:@"--%@\r\n",boundary]];
	
	//add body
	NSMutableData *postBody = [NSMutableData data];
	
	//add params
	//wigi access token
	[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]]; 
	NSLog(@"postbody set");
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"wigi_access_token"] dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"123post");
	[postBody appendData:[[NSString stringWithFormat:@"%@\r\n", access_token] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//facebook id
	[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]]; 
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"wigi_facebook_id"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%@\r\n", fb_id] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//image
	[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]]; 
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"wigi_item_image",@"item.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[NSData dataWithData:UIImageJPEGRepresentation(item, 1.0)]];
	
	//tag
	[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]]; 
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"wigi_item_tag"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%@\r\n", tag] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//comment
	[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]]; 
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"wigi_item_comment"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%@\r\n", comment] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//end post data
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[wigiRequest setHTTPBody:postBody];
	//setup the connection
	NSHTTPURLResponse *wigiResponse = [[[NSHTTPURLResponse alloc] init] autorelease];
	NSError *wigiError = [[[NSError alloc] init] autorelease];
	NSData * responseData = [[NSData alloc] initWithData: [NSURLConnection sendSynchronousRequest:wigiRequest returningResponse:&wigiResponse error:&wigiError]];
	
	NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"WIGI RESPONSE: %@", responseString);
	
}

@end
