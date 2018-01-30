//
//  SCHJsFunction.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/25/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "SCHJsFunction.h"
#import <WebKit/WebKit.h>
#import "SCHLogging.h"

@implementation SCHJsFunction

-(void) executeFunction:(NSString*) source inWebView:(WKWebView*) webview {
    if(webview == nil ) {
        return;
    }
    
    if(_delegate == nil){
        SCHLog(@"no listener on function call");
    }
    
    [webview evaluateJavaScript:source completionHandler:^(id _Nullable callResult, NSError * _Nullable error) {
        if(error) {
            [_delegate onFunctionCallError:self withError:error];
        } else {
            [_delegate onFunctionCallSuccessfull:self withResult:callResult caller:source];
        }
    }];
    
}

-(void) executeFunctionWithBlock:(NSString *)source
                       inWebView:(WKWebView *)webview
                withCompletition:(void (^ _Nullable)(BOOL executed,id result)) completition {
    
    if(webview == nil ) {
        return;
    }
    
    if(_delegate == nil){
        SCHLog(@"no listener on function call");
    }

    [webview evaluateJavaScript:source completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        if(error) {
            completition(FALSE,nil);
        } else {
            completition(TRUE,res);
        }
    }];
}

@end
