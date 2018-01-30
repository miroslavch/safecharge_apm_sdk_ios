//
//  SCHPaymentData.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/26/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHPaymentData : NSObject
{
@public
    NSString *event;
    NSString *status;
    BOOL updatedOnce;
}


-(id)   initFromPayload:(NSDictionary*) payload;
-(BOOL) isReady;
-(void) updateWithPayload:(NSDictionary*) payload;


@end
