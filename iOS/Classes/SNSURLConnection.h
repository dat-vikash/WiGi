//
//  SNSURLConnection.h
//  WiGi
//  
//  Created by Vikash Dat on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/* implements a stateful nsurlconnection. connection now have a distinugshing id.
 */

#import <Foundation/Foundation.h>


@interface SNSURLConnection : NSURLConnection {
	NSDictionary *_connectionInfo;

}

@property (nonatomic, retain) NSDictionary *connInfo;

@end
