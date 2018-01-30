//
//  SCHPlaytechPaymentViewController.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SCHPlaytechPaymentProtocol;

@interface SCHPlaytechPaymentViewController : UIViewController

-(id) initWithRequest:(NSURLRequest*) request;

@property (nonatomic,weak) id<SCHPlaytechPaymentProtocol> delegate;

@end
