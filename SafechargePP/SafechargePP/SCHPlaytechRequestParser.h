//
//  SCHPlaytechRequestParser.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 18.01.18.
//  Copyright © 2018 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCHPlaytechRequestBuilder;

@interface SCHPlaytechRequestParser : NSObject

+(SCHPlaytechRequestBuilder*) parseFromURL:(NSURL*) url;

@end
