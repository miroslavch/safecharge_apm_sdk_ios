//
//  UrlRequestParser.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/29/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestParser : NSObject

+(NSDictionary<NSString*,NSString*> *) queryParametersFromURL:(NSURL *)url;
+(NSURL*) escapeBaseURL:(NSURL*) url;

@end
