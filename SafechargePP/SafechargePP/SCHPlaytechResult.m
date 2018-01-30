//
//  SCHPlaytechResult.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "SCHPlaytechResult.h"
#import "UrlRequestParser.h"

@interface SCHPlaytechResult()


@property (nonatomic,strong) NSString *resultHolder; //dummy string
@end

@implementation SCHPlaytechResult

-(instancetype) initWithSuccessfullResult:(NSDictionary*) details {
    self = [super init];
    if ( self ){
        self.transactionSuccessful = true;
        self.details = details.copy;
    }
    return self;
}

-(instancetype) initWithRejectedResult:(NSDictionary*) details {
    self = [super init];
    if ( self ) {
        self.transactionSuccessful = false;
        self.details = details.copy;
    }
    return self;
}

-(instancetype) initFromURL:(NSURL*) redirectURL {
    self = [super init];
    if ( self ) {
        if ([self parseResult:redirectURL] ) {
            return self;
        } else {
            return nil;
        }
    }
    
    return self;
}

-(BOOL) parseResult:(NSURL*) url {
    NSDictionary<NSString*,NSString*> * params = [URLRequestParser queryParametersFromURL:url];
    
    self->_PPPStatus = params[@"ppp_status"];
    self->_GWStatus = params[@"gwStatus"];
    
    if (_PPPStatus == nil && self->_GWStatus == nil )
        return NO;
    
    if ( _PPPStatus ) {
        NSString *status = params[@"Status"];
        if ( status && [status isEqualToString:@"APPROVED"]) {
            self.transactionSuccessful = true;
        } else if (status && [status isEqualToString:@"PENDING"]){
            self.transactionPending = true;
            self.transactionSuccessful = true;
        } else {
            self.transactionSuccessful = false;
        }
    } else if ( self->_GWStatus ) {
        if ( [self->_GWStatus isEqualToString:@"APPROVED"] ) {
            self.transactionSuccessful = true;
        } else if ( [self->_GWStatus isEqualToString:@"PENDING"]) {
            self.transactionPending = true;
            self.transactionSuccessful = true;
        }
        else {
            self.transactionSuccessful = false;
        }
    }
    
    self.details = params.copy;
    
    return YES;
    
}


@end
