//
//  RequestBuilderHelper.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "RequestBuilderHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "SCHLogging.h"

@implementation RequestBuilderHelper

+(void) assignValueIfNotNil:(NSObject *__strong*) tarObj
                       what:(NSObject*) iobj {
    if (iobj != nil) {
        *tarObj = iobj.mutableCopy;
    }
}

+(void) writeURL:(NSURL *)URLValue
          forKey:(NSString *)key
     targetArray:(NSMutableArray *)targetArray {
    if (URLValue) {
        [targetArray addObject:[NSString stringWithFormat:@"%@=%@", key, URLValue.absoluteString]];
    }
}

+(void) writeString:(NSString *)stringValue
             forKey:(NSString *)key
        targetArray:(NSMutableArray *) targetArray{
    if (stringValue) {
        [targetArray addObject:[NSString stringWithFormat:@"%@=%@", key, stringValue]];
    }
}


+(void) writeNumberAsDouble:(NSNumber*) value
                     forKey:(NSString *)key
                targetArray:(NSMutableArray *) targetArray {
    if (value) {
        [targetArray addObject:[NSString stringWithFormat:@"%@=%.02f",key,value.doubleValue]];
    }
}

+(void) writeNumberAsBoolean:(NSNumber*) value
                      forKey:(NSString*) key
                 targetArray:(NSMutableArray*) targetArray {
    if( value ) {
        [targetArray addObject:[NSString stringWithFormat:@"%@=%d",key,(value.boolValue)?1:0]];
    }
}

+(void) writeNumberAsInteger:(NSNumber*) value
                      forKey:(NSString*) key
                 targetArray:(NSMutableArray*) targetArray {
    if( value ) {
        [targetArray addObject:[NSString stringWithFormat:@"%@=%i",key,value.intValue]];
    }
}



+(void) writeNumberAsLongLong:(NSNumber*) value
                       forKey:(NSString*) key
                  targetArray:(NSMutableArray*) targetArray {
    if( value ) {
        [targetArray addObject:[NSString stringWithFormat:@"%@=%lld",key,value.longLongValue]];
    }
}


+(NSString*) generateTimestampFromNow {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dateFormatter.dateFormat = @"yyyy-MM-dd.HH:mm:ss";
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString*) MD5FromString:(NSString *)string {
    const int md5Length = 16;
    unsigned char result[md5Length];
    const char *str = [string UTF8String];
    
    if( str == nil ) {
        SCHLog(@"String can't be converted to utf8");
        SCHAssert(false);
        return nil;
    }
    
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *md5 = [NSMutableString stringWithCapacity:md5Length * 2];
    for (int i = 0; i < md5Length; i++)
        [md5 appendFormat:@"%02x", result[i]];
    return md5;
}

+(NSString*) SHA256FromString:(NSString *)string {
    NSData *dataIn = [string dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(dataIn.bytes, (CC_LONG)dataIn.length,  macOut.mutableBytes);
    return [[NSString alloc] initWithData:macOut encoding:NSASCIIStringEncoding];
}



@end
