//
//  SCHPlaytechRequestBuilder.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/29/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "SCHPlaytechRequestBuilder.h"
#import "RequestBuilderHelper.h"
#import "SCHLogging.h"
#import "UrlRequestParser.h"
#import <UIKit/UIKit.h>
#import "SCHPlaytechRequestParser.h"
#import "SCHPlaytechPaymentViewController.h"
#import "SCHPlaytechConstants.h"

@implementation SCHPlaytechRequestBuilder

-(id) init {
    self = [super init];
    if ( self ) {
        self.customFields = [[NSMutableDictionary alloc] init];
        self.openState = PT_SCHOpenState;
    }
    return self;
}


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
                       realmode:(NSNumber *) realmode

{
    self = [super init];
    if(self) {
        self.baseURL = baseURL;
        self.merchant_id = merchant_id;
        self.merchant_site_id = merchant_site_id;
        self.theme_id = theme_id;
        self.language = language;
        self.currency = currency;
        self.username = username;
        self.casinoname = casinoname;
        self.temporaryToken = temporaryToken;
        self.clienttype = clienttype;
        self.clientplatform = clientplatform;
        self.clientversion = clientversion;
        self.realmode = realmode;
        self.openState = PT_SCHOpenState;
        
    }
    return self;
}

- (instancetype) initFromURL:(NSURL*) requestURL {
    self = [super init];
    if ( self ) {
        NSDictionary<NSString*,NSString*> *params = [URLRequestParser queryParametersFromURL:requestURL];
        if ( params ) {
            self.baseURL = [URLRequestParser escapeBaseURL:requestURL];
            [self assignFromDictionary:params];
            self.openState = PT_SCHOpenState;
        } else {
            SCHLog(@"empty url params list");
        }
    }
    return self;
}

-(void) assignFromDictionary:(NSDictionary<NSString*,NSString*>*) input {
    if ( [input objectForKey:@"merchant_id"] ) {
        self.merchant_id = [NSNumber numberWithLongLong:
                            [input objectForKey:@"merchant_id"].longLongValue];
    }
    
    if ( [input objectForKey:@"merchant_site_id"] ) {
        
        self.merchant_site_id = [NSNumber numberWithLongLong:
                                 [input objectForKey:@"merchant_site_id"].longLongValue];
        
    } if ( [input objectForKey:@"theme_id"] ) {
        self.theme_id = [NSNumber numberWithLongLong:
                         [input objectForKey:@"theme_id"].longLongValue];
        
    } if ( [input objectForKey:@"language"] ) {
        self.language = [input objectForKey:@"language"].copy;
        
    } if ( [input objectForKey:@"currency"] ) {
        self.currency = [input objectForKey:@"currency"].copy;
        
    } if ( [input objectForKey:@"username"] ) {
        self.username = [input objectForKey:@"username"].copy;
        
    } if ( [input objectForKey:@"casinoname"] ) {
        self.casinoname = [input objectForKey:@"casinoname"].copy;
        
    } if ( [input objectForKey:@"temporaryToken"] ) {
        self.temporaryToken = [input objectForKey:@"temporaryToken"].copy;
        
    } if ( [input objectForKey:@"clienttype"] ) {
        self.clienttype = [input objectForKey:@"clienttype"].copy;
        
    } if ( [input objectForKey:@"clientplatform"] ) {
        self.clientplatform = [input objectForKey:@"clientplatform"].copy;
        
    } if ( [input objectForKey:@"clientversion"] ) {
        self.clientversion = [input objectForKey:@"clientversion"].copy;
        
    } if ( [input objectForKey:@"realmode"] ) {
        self.realmode = [NSNumber numberWithBool:
                         [input objectForKey:@"realmode"].boolValue];
        
    } if ( [input objectForKey:@"country"] ) {
        self.country = [input objectForKey:@"country"].copy;
        
    } if ( [input objectForKey:@"redirectresponse"] ) {
         self.redirectresponse = [input objectForKey:@"redirectresponse"].copy;
        
    } if ( [input objectForKey:@"orderoptions"] ) {
         self.orderoptions = [input objectForKey:@"orderoptions"].copy;
        
    } if ( [input objectForKey:@"quickdeposit"] ) {
        self.quickdeposit = [NSNumber numberWithBool:
                             [input objectForKey:@"quickdeposit"].boolValue];
        
    } if ( [input objectForKey:@"playercode"] ) {
         self.playercode = [input objectForKey:@"playercode"].copy;
        
    } if ( [input objectForKey:@"requesttype"] ) {
        self.requesttype = [input objectForKey:@"requesttype"].copy;
        
    } if ( [input objectForKey:@"playermessages"] ) {
        self.playermessages = [input objectForKey:@"playermessages"].copy;
        
    } if ( [input objectForKey:@"gsmessages"] ) {
        self.gsmessages = [NSNumber numberWithBool:
                           [input objectForKey:@"gsmessages"].boolValue];
    }
    
    //parse the custom fields
    const int maxCustomFields = 15;
    for ( unsigned  long i = 1; i<=maxCustomFields ; ++i ) {
        NSString *fieldName = [NSString stringWithFormat:@"customField%ld",i];
        if ( [ input objectForKey:fieldName] ) {
            [self.customFields setObject:[input objectForKey:fieldName] forKey:fieldName];
        }
    }
}

-(BOOL) validateMandatory {
    
    if ( self.baseURL == nil ||
        ([self.baseURL.scheme isEqualToString:@"http"] || [self.baseURL.scheme isEqualToString:@"https"] ) == false ) {
        SCHLog(@"baseURL is not valid URL");
        return false;
    }
    
    if ( self.merchant_id == nil || self.merchant_id.longLongValue < 0 || self.merchant_id.longLongValue > LONG_LONG_MAX ) {
        SCHLog(@"merchant_id is not valid");
        return false;
    }
    
    if ( self.merchant_site_id == nil || self.merchant_site_id.longLongValue < 0 || self.merchant_site_id.longLongValue > LONG_LONG_MAX ) {
        SCHLog(@"merchant_site_id is not valid");
        return false;
    }
    
    if ( self.language == nil || self.language.length == 0 || self.language.length > 2 ) {
        SCHLog(@"language is not valid");
        return false;
    }
    
    if ( self.currency == nil || self.currency.length == 0 || self.currency.length > 3 ) {
        SCHLog(@"currency is not valid");
        return false;
    }
    
    if ( self.username == nil || self.username.length == 0 || self.username.length > 255 ) {
        SCHLog(@"username is not valid");
        return false;
    }
    
    if ( self.casinoname == nil || self.casinoname.length == 0 || self.casinoname.length > 255 ) {
        SCHLog(@"casinoname is not valid");
        return false;
    }
    
    if ( self.temporaryToken == nil || self.temporaryToken.length == 0 || self.temporaryToken.length > 255 ) {
        SCHLog(@"temporaryToken is not valid");
        return false;
    }
    
    if ( self.clienttype == nil || self.clienttype.length == 0 || self.clienttype.length > 255 ) {
        SCHLog(@"clienttype is not valid");
        return false;
    }

    if ( self.clientplatform == nil || self.clientplatform.length == 0 || self.clientplatform.length > 255 ) {
        SCHLog(@"clientplatform is not valid");
        return false;
    }
    
    if ( self.clientversion == nil || self.clientversion.length == 0 || self.clientversion.length > 255 ) {
        SCHLog(@"clientversion is not valid");
        return false;
    }
    
    if ( self.realmode == nil ) {
        SCHLog(@"realmode is not valid");
        return false;
    }
    
    return true;
}

-(BOOL) validateNonMandatory {
    
    if ( self.theme_id != nil && ( self.theme_id.intValue < 0 || self.theme_id.intValue > INT_MAX ) ) {
        SCHLog(@"theme_id is not valid");
        return false;
    }
    
    if ( self.country != nil && ( self.country.length == 0 || self.country.length > 2 ) ) {
        SCHLog(@"country is not valid");
        return false;
    }
    
    if ( self.redirectresponse != nil ) {
        if ( self.redirectresponse.length == 0 || self.redirectresponse.length > 2048 ) {
            SCHLog(@"redirectresponse is not valid");
            return false;
        }
        
        if ( [NSJSONSerialization isValidJSONObject:self.redirectresponse] == false ) {
            SCHLog(@"redirectresponse is not valid JSON");
            return false;
        }
    }
    
    if ( self.orderoptions != nil &&
        ([self.orderoptions isEqualToString:@"orderByPlayerHistory"] == false &&
         [self.orderoptions isEqualToString:@"orderByCountryPopularity"] == false &&
         [self.orderoptions isEqualToString:@"orderByCasinoConfiguration"] == false &&
         [self.orderoptions isEqualToString:@"all"] == false)) {
            SCHLog(@"orderoptions is not valid");
            return false;
    }
    
    if ( self.playercode != nil && ( self.playercode.length == 0 || self.playercode.length > 255) ) {
        SCHLog(@"playercode is not valid");
    }
    
    if ( self.requesttype != nil &&
        ([self.requesttype isEqualToString:@"deposit"] == false &&
         [self.requesttype isEqualToString:@"withdrawal"] == false ) ) {
            SCHLog(@"requesttype is not valid");
            return false;
        }
    
    if ( self.playermessages != nil && (self.playermessages.length == 0 || self.playermessages.length > 512 ) ) {
        SCHLog(@"playermessages is not valid");
        return false;
    }
    
    if ( self.customFields != nil ) {
        
        __block BOOL anyInvalid = false;
        
        [self.customFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if ( obj.length == 0 || obj.length > 64 ) {
                SCHLog(@"customField(%@) is not valid", key);
                *stop = true;
                anyInvalid = true;
                return;
            }
        }];
        
        if ( anyInvalid ){
            return false;
        }
        
    }

    return true;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// generate NSURLRequest
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSURLRequest*) constructURLRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self constructURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    if( request == nil ) {
        SCHLog(@"bad request created");
        return nil;
    }
    
    [request setHTTPMethod:@"GET"];
    return request;
}


-(NSURL*) constructURL {
    
    if ([self validateMandatory] == FALSE || [self validateNonMandatory] == FALSE) {
        SCHLog(@"invalid request data provided");
        return nil;
    }
    
    
    NSString *fullURL = [[NSString stringWithFormat:@"%@?%@",self.baseURL.absoluteString,
                          [self deserializeToURLParams]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:fullURL];
}

-(NSString*) deserializeToURLParams {
    
    NSMutableArray<NSString*> *resultArray = [[NSMutableArray alloc] init];
    [resultArray addObjectsFromArray:[self deserializeToParts]];
    return [resultArray componentsJoinedByString:@"&"];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// deserialization
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSMutableArray<NSString*>*) deserializeToParts {
    NSMutableArray<NSString*> *resultArray = [[NSMutableArray alloc] initWithCapacity:50];
    
    [RequestBuilderHelper writeNumberAsLongLong:self.merchant_id        forKey:@"merchant_id"       targetArray:resultArray];
    [RequestBuilderHelper writeNumberAsLongLong:self.merchant_site_id   forKey:@"merchant_site_id"  targetArray:resultArray];
    [RequestBuilderHelper writeNumberAsInteger:self.theme_id            forKey:@"theme_id"          targetArray:resultArray];
    [RequestBuilderHelper writeString:self.language                     forKey:@"language"          targetArray:resultArray];
    [RequestBuilderHelper writeString:self.currency                     forKey:@"currency"          targetArray:resultArray];
    [RequestBuilderHelper writeString:self.username                     forKey:@"username"          targetArray:resultArray];
    [RequestBuilderHelper writeString:self.casinoname                   forKey:@"casinoname"        targetArray:resultArray];
    [RequestBuilderHelper writeString:self.temporaryToken               forKey:@"temporaryToken"    targetArray:resultArray];
    [RequestBuilderHelper writeString:self.clienttype                   forKey:@"clienttype"        targetArray:resultArray];
    [RequestBuilderHelper writeString:self.clientplatform               forKey:@"clientplatform"    targetArray:resultArray];
    [RequestBuilderHelper writeString:self.clientversion                forKey:@"clientversion"     targetArray:resultArray];
    [RequestBuilderHelper writeNumberAsBoolean:self.realmode            forKey:@"realmode"          targetArray:resultArray];
    
    [RequestBuilderHelper writeString:self.country                      forKey:@"country"           targetArray:resultArray];
    [RequestBuilderHelper writeString:self.redirectresponse             forKey:@"redirectresponse"  targetArray:resultArray];
    [RequestBuilderHelper writeString:self.orderoptions                 forKey:@"orderoptions"      targetArray:resultArray];
    [RequestBuilderHelper writeNumberAsBoolean:self.quickdeposit        forKey:@"quickdeposit"      targetArray:resultArray];
    [RequestBuilderHelper writeString:self.playercode                   forKey:@"playercode"        targetArray:resultArray];
    [RequestBuilderHelper writeString:self.requesttype                  forKey:@"requesttype"       targetArray:resultArray];
    [RequestBuilderHelper writeString:self.playermessages               forKey:@"playermessages"    targetArray:resultArray];
    
    [RequestBuilderHelper writeNumberAsBoolean:self.gsmessages          forKey:@"gsmessages"        targetArray:resultArray];
    [RequestBuilderHelper writeString:self.openState                   forKey:@"openState"       targetArray:resultArray];
    
    if ( self.customFields != nil ) {
        [self.customFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [RequestBuilderHelper writeString:obj               forKey:key    targetArray:resultArray];
        }];
    }
    return resultArray;
}

@end
