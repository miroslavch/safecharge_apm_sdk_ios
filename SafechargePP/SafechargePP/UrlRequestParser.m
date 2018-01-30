
//
//  UrlRequestParser.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/29/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "UrlRequestParser.h"

@implementation URLRequestParser


+(NSDictionary<NSString*,NSString*> *) queryParametersFromURL:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableDictionary<NSString *, NSString *> *queryParams = [NSMutableDictionary<NSString *, NSString *> new];
    for (NSURLQueryItem *queryItem in [urlComponents queryItems]) {
        if (queryItem.value == nil) {
            continue;
        }
        [queryParams setObject:queryItem.value forKey:queryItem.name];
    }
    return queryParams;
}

+(NSURL*) escapeBaseURL:(NSURL*) url {
    
    NSRange foundQueryDelimiter = [url.absoluteString rangeOfString:@"?"];
    NSString *leftPart = [url.absoluteString substringToIndex:foundQueryDelimiter.location];
    
    return [[NSURL alloc] initWithString:leftPart];
}



@end
