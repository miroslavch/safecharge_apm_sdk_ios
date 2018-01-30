//
//  RequestBuilderHelper.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestBuilderHelper : NSObject
+(void) assignValueIfNotNil:(NSObject *__strong*) tarObj
                       what:(NSObject*) iobj;

+(void) writeURL:(NSURL *)URLValue
          forKey:(NSString *)key
     targetArray:(NSMutableArray *)targetArray ;

+(void) writeString:(NSString *)stringValue
             forKey:(NSString *)key
        targetArray:(NSMutableArray *) targetArray ;


+(void) writeNumberAsDouble:(NSNumber*) value
                     forKey:(NSString *)key
                targetArray:(NSMutableArray *) targetArray ;

+(void) writeNumberAsBoolean:(NSNumber*) value
                      forKey:(NSString*) key
                 targetArray:(NSMutableArray*) targetArray ;

+(void) writeNumberAsInteger:(NSNumber*) value
                      forKey:(NSString*) key
                 targetArray:(NSMutableArray*) targetArray ;



+(void) writeNumberAsLongLong:(NSNumber*) value
                       forKey:(NSString*) key
                  targetArray:(NSMutableArray*) targetArray ;


+(NSString*) generateTimestampFromNow;

@end
