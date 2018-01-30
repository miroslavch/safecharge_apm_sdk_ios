//
//  SCHPlaytechRequestBuilder.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/29/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCHPlaytechPaymentViewController;

@interface SCHPlaytechRequestBuilder : NSObject

//mandatory
@property (nonatomic, strong)           NSURL*                         baseURL;
@property (nonatomic, strong)           NSNumber*                      merchant_id;
@property (nonatomic, strong)           NSNumber*                      merchant_site_id;
@property (nonatomic, strong)           NSNumber*                      theme_id;
@property (nonatomic, strong)           NSString*                      language;
@property (nonatomic, strong)           NSString*                      currency;
@property (nonatomic, strong)           NSString*                      username;
@property (nonatomic, strong)           NSString*                      casinoname;
@property (nonatomic, strong)           NSString*                      temporaryToken;
@property (nonatomic, strong)           NSString*                      clienttype;
@property (nonatomic, strong)           NSString*                      clientplatform;
@property (nonatomic, strong)           NSString*                      clientversion;
@property (nonatomic, strong)           NSNumber*                      realmode;

// non mandatory

@property (nonatomic, strong)           NSString*                      country;
@property (nonatomic, strong)           NSString*                      redirectresponse;
@property (nonatomic, strong)           NSString*                      orderoptions;
@property (nonatomic, strong)           NSNumber*                      quickdeposit;
@property (nonatomic, strong)           NSString*                      playercode;
@property (nonatomic, strong)           NSString*                      requesttype;

@property (nonatomic, strong)           NSString*                      playermessages;
@property (nonatomic, strong)           NSNumber*                      gsmessages;

@property (nonatomic, strong)           NSMutableDictionary<NSString*,NSString*>* customFields;

//sdk based
@property (nonatomic, strong)           NSString*                      openState;

- (instancetype)initWithBaseURL:(NSURL*) baseURL
                     merchantId:(NSNumber *) merchant_id
                 merchantSiteID:(NSNumber *) merchant_site_id
                        themeId:(NSNumber *) theme_id
                       language:(NSString *) language
                       currency:(NSString *) currency
                       username:(NSString *) username
                     casinoname:(NSString *) casinoname
                 temporaryToken:(NSString *) temporaryToken
                     clienttype:(NSString *) clienttype
                 clientplatform:(NSString *) clientplatform
                  clientversion:(NSString *) clientversion
                       realmode:(NSNumber *) realmode;

- (instancetype) initFromURL:(NSURL*) requestURL;
-(NSURLRequest*) constructURLRequest;

@end
