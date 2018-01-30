//
//  NSURLRequest+IgnoreSSL.m
//  SafechargePPSample
//
//  Created by Bozhidar Dimitrov on 4/14/15.
//  Copyright (c) 2015 SafeCharge. All rights reserved.
//


#import "NSURLRequest+IgnoreSSL.h"


@implementation NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
