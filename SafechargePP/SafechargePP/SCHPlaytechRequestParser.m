//
//  SCHPlaytechRequestParser.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 18.01.18.
//  Copyright © 2018 SafeCharge. All rights reserved.
//

#import "SCHPlaytechRequestParser.h"
#import "SCHPlaytechRequestBuilder.h"

@implementation SCHPlaytechRequestParser
#define VariableName(arg) (@""#arg)

+(SCHPlaytechRequestBuilder*) parseFromURL:(NSURL*) url {
    SCHPlaytechRequestBuilder *builder = [[SCHPlaytechRequestBuilder alloc] init];
    [SCHPlaytechRequestParser processURL:url withBuilder:builder];
    return builder;
}

+(NSDictionary*) urlToDictionary:(NSURL*) url {
    NSMutableDictionary *queryStringDictionary = [NSMutableDictionary dictionary];
    NSArray *urlComponents = [url.query componentsSeparatedByString:@"&"];
    
    for (NSString *keyValiePair in urlComponents)
    {
        NSArray *pairComponents = [keyValiePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        
        if (key == nil)
            continue;
        
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        
        [queryStringDictionary setObject:value forKey:key];
    }
    
    return queryStringDictionary;
}

+(void) processURL:(NSURL*) url
       withBuilder:(SCHPlaytechRequestBuilder*) builder {
    //NSDictionary *dictToParse = [SCHPlaytechRequestParser urlToDictionary:url];
    //[builder serializeFromDictionary:dictToParse];
    //[builder setBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url.host,url.relativePath]]];
    
}
@end
