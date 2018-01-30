//
//  SCHPlaytechPaymentProtocol.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#ifndef SCHPlaytechPaymentProtocol_h
#define SCHPlaytechPaymentProtocol_h

@class SCHPlaytechPaymentViewController;
@class SCHPlaytechResult;

@protocol SCHPlaytechPaymentProtocol <NSObject>

- (void)paymentPageController:(SCHPlaytechPaymentViewController *)paymentPageController
          didFinishWithResult:(SCHPlaytechResult *)result;

- (void)paymentPageController:(SCHPlaytechPaymentViewController *)paymentPageController
didFailLoadPaymentPageWithError:(NSError *)error;

@end


#endif /* SCHPlaytechPaymentProtocol_h */
