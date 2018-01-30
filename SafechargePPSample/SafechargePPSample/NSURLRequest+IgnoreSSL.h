//
//  NSURLRequest+IgnoreSSL.h
//  SafechargePPSample
//
//  Created by Bozhidar Dimitrov on 4/14/15.
//  Copyright (c) 2015 SafeCharge. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end
