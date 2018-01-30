//
//  SCHPaymentData.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/26/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "SCHPaymentData.h"

@implementation SCHPaymentData

-(id) initFromPayload:(NSDictionary*) payload {
    self = [super init];
    if(self){
        [self updateWithPayload:payload];
    }
    
    return self;
}

-(BOOL) isReady {
    return self->updatedOnce;
}

-(void) updateWithPayload:(NSDictionary*) payload {
    self->event = [payload objectForKey:@"event"];
    self->status = [payload objectForKey:@"status"];
    
    self->updatedOnce = TRUE;
}

@end
