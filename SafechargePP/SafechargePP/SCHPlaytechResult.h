//
//  SCHPlaytechResult.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHPlaytechResult : NSObject

-(id) initWithSuccessfullResult:(NSDictionary*) details;
-(id) initWithRejectedResult:(NSDictionary*) details;

//keeps support for old redirect URL from the PPP
-(instancetype) initFromURL:(NSURL*) redirectURL;

@property (nonatomic,strong) NSString                   *PPPStatus;
@property (nonatomic,strong) NSString                   *GWStatus;
@property (nonatomic,strong) NSDictionary<NSString*,id> *details;

//transaction result - i.e approved, ( rejected, declined -> result in false )
@property (nonatomic,assign) BOOL                       transactionSuccessful;
@property (nonatomic,assign) BOOL                       transactionPending;


@end
