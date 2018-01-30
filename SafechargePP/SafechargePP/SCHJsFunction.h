//
//  SCHJsFunction.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/25/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>

//fwd
@class WKWebView;
@class SCHJsFunction;

@protocol SCHJsFunctionDelegate <NSObject>

-(void) onFunctionCallSuccessfull:(SCHJsFunction * _Nonnull) caller
                      withResult:(id _Nullable) result
                          caller:(NSString* _Nullable) callerName;

-(void) onFunctionCallError:(SCHJsFunction * _Nonnull) caller
                  withError:(NSError* _Nullable) error;

@end

@interface SCHJsFunction : NSObject

@property (nonatomic,weak,nullable) id<SCHJsFunctionDelegate> delegate;

-(void) executeFunction:(NSString* _Nullable) source inWebView:(WKWebView* _Nullable) webview;
-(void) executeFunctionWithBlock:(NSString * _Nullable)source
                       inWebView:(WKWebView * _Nullable)webview
                withCompletition:(void (^ _Nullable)(BOOL executed,id _Nullable result)) completition;

@end
