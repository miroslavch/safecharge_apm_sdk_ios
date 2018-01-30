//
//  SCHPlaytechPaymentViewController.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "SCHPlaytechPaymentViewController.h"
#import <WebKit/WebKit.h>
#import "SCHJsFunction.h"
#import "SCHPlaytechConstants.h"
#import "SCHLogging.h"
#import "SCHPlaytechPaymentProtocol.h"
#import "SCHPlaytechResult.h"

@interface SCHPlaytechPaymentViewController() <WKNavigationDelegate,WKUIDelegate,SCHJsFunctionDelegate,WKScriptMessageHandler>
{
    WKWebView *_webView;
    WKWebView *_APMWebView;
    
    SCHJsFunction   *apmCloseOverrideHandler;
    SCHJsFunction   *webviewSetPopupClosed;
    
    SCHJsFunction   *overrideWebviewClose;
    SCHJsFunction   *overrideWebviewPopup;
    
    SCHJsFunction   *overrideTransactionEvent;
    
    NSURLRequest    *remoteRequest;
}

@end

@implementation SCHPlaytechPaymentViewController


-(id) initWithRequest:(NSURLRequest*) request {
    self = [super init];
    if ( self ){
        self->remoteRequest = request;
    }
    
    return self;
}

-(void) loadView {
    [super loadView];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    
    [controller addScriptMessageHandler:self name:PT_SCHOverwrittenEvent];
    configuration.userContentController = controller;
    
    //standard close handler
    webviewSetPopupClosed = [[SCHJsFunction alloc] init];
    
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView setNavigationDelegate:self];
    [_webView setUIDelegate:self];
    self.view = _webView;
}

-(void) dealloc {
    
    
    if ( overrideTransactionEvent ) {
        [overrideTransactionEvent setDelegate:nil];
        overrideTransactionEvent = nil;
    }
    
    if ( overrideWebviewPopup == nil ) {
        [overrideWebviewPopup setDelegate:nil];
        overrideWebviewPopup = nil;
    }
    if ( overrideWebviewClose == nil ) {
        [overrideWebviewClose setDelegate:nil];
        overrideWebviewClose = nil;
    }
    
    if ( webviewSetPopupClosed ) {
        [webviewSetPopupClosed setDelegate:nil];
        webviewSetPopupClosed = nil;
    }
    if ( _APMWebView ) {
        [_APMWebView setNavigationDelegate:nil];
        [_APMWebView setUIDelegate:nil];
        [_APMWebView removeFromSuperview];
        _APMWebView = nil;
    }
    
    if ( _webView ){
        [_webView setNavigationDelegate:nil];
        [_webView setUIDelegate:nil];
        [_webView removeFromSuperview];
        _webView = nil;
    }

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRemote];
}

-(void) setRemoteRequest:(NSURLRequest*) request {
    self->remoteRequest = request;
}

-(void) loadRemote {
    if ( self->remoteRequest ) {
        [self->_webView loadRequest:self->remoteRequest];
    }
}

-(void) registerHandlers : (WKWebView *) webView{

    if ( overrideWebviewPopup == nil ) {
        overrideWebviewPopup = [[SCHJsFunction alloc] init];
        [overrideWebviewPopup setDelegate:self];
        [overrideWebviewPopup executeFunction:PT_SCHOverrideWindowOpenJSForWK inWebView:webView];
    }
    if ( overrideWebviewClose == nil ) {
        overrideWebviewClose = [[SCHJsFunction alloc] init];
        [overrideWebviewClose setDelegate:self];
        [overrideWebviewClose executeFunction:PT_SCHOverrideWindowCloseJS inWebView:webView];
    }
}

-(void) registerTransactionEventListener {
    
    if ( overrideTransactionEvent == nil ) {
        overrideTransactionEvent = [[SCHJsFunction alloc] init];
        [overrideTransactionEvent setDelegate:self];
        [overrideTransactionEvent executeFunction:PT_SCHOverrideTransactionFunction inWebView:self->_webView];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    SCHLog(@"dump events:%@",message.body);
    
    if ( [message.name isEqualToString:PT_SCHOverwrittenEvent]) {
        
        NSDictionary *evDict = message.body;
        NSDictionary<NSString*,id> *eventDataBody = [evDict objectForKey:@"data"];
        NSString *status = [self parseTransactionStatus:eventDataBody];
        
        if ( [status isEqualToString:@"APPROVED"] ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate paymentPageController:self didFinishWithResult: [ [SCHPlaytechResult alloc] initWithSuccessfullResult:[eventDataBody objectForKey:@"details"]]];
            });
        } else {
            
            if ( [status isEqualToString:@"CANCEL"] ) { //does nothing - skip firing event, happens when third party payment without registration is invoked
                
            } else {
                
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate paymentPageController:self didFinishWithResult: [[SCHPlaytechResult alloc] initWithRejectedResult:[eventDataBody objectForKey:@"details"]]];
                });
            }
        }
        
    }
}

-(NSString*) parseTransactionStatus:(NSDictionary<NSString*,id>*) eventDataBody {
    if ( eventDataBody == nil ){
        return false;
    }
    
    return [eventDataBody objectForKey:@"trxStatus"];
    
}


- (void)                    webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request   = navigationAction.request;
    WKNavigationActionPolicy decision = WKNavigationActionPolicyAllow;
    
    [self registerHandlers:_webView];
    
#ifdef DEBUG
    SCHLog(@"webview requesting : %@ ", request.URL.absoluteString);
#endif
    
    if (webView == _webView)
    {
        //preregister
        if ([request.URL.absoluteString rangeOfString:PT_SCHReviewPagePath].location != NSNotFound && _APMWebView == nil) {
            [self registerTransactionEventListener];
        }
        
        if ([request.URL.absoluteString rangeOfString:PT_SCHReviewPagePath].location != NSNotFound && _APMWebView != nil) {
            decision = WKNavigationActionPolicyAllow;
        }
        if ([request.URL.absoluteString rangeOfString:PT_SCHApplePaySuccessURL].location != NSNotFound)
        {
            decision = WKNavigationActionPolicyCancel;
        }
        else if ([request.URL.absoluteString rangeOfString:PT_SCHApplePayFailureURL].location != NSNotFound)
        {
            decision = WKNavigationActionPolicyCancel;
        }
        else if ([request.URL.absoluteString rangeOfString:PT_SCHApplePayCaptureURL].location != NSNotFound)
        {
            decision = WKNavigationActionPolicyCancel;
        }
        else if ([request.URL.absoluteString rangeOfString:PT_SCHPPPAdapterResponsePagePath].location != NSNotFound) {
            decision = WKNavigationActionPolicyAllow;
        }
        else
        {
            SCHPlaytechResult *result = [[SCHPlaytechResult alloc] initFromURL:request.URL];
            if ( result ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate paymentPageController:self didFinishWithResult:result];
                });
                
                decision = WKNavigationActionPolicyCancel;
            }
        }
    }
    else if (webView == _APMWebView )
    {
        if ( [request.URL.absoluteString isEqualToString:PT_SCHCloseWindowURL] ) {
            [self APMFlowDidFinish];
            decision = WKNavigationActionPolicyCancel;
        } else if ([request.URL.absoluteString rangeOfString:PT_SCHReviewPagePath].location != NSNotFound ) {
            [self registerTransactionEventListener];
        } else if ([request.URL.absoluteString rangeOfString:PT_SCHAPMResponsePagePath].location != NSNotFound ) {
            
            SCHPlaytechResult *result = [[SCHPlaytechResult alloc] initFromURL:request.URL];
            if ( result ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate paymentPageController:self didFinishWithResult:result];
                });
                decision = WKNavigationActionPolicyAllow;
            }
        }
    }
    
    decisionHandler(decision);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//JSFunction caller delegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) onFunctionCallSuccessfull:(SCHJsFunction * _Nonnull) caller
                       withResult:(id _Nullable) result
                           caller:(NSString* _Nullable) callerName {
    SCHLog(@"handler call ok:%@",callerName);
}

-(void) onFunctionCallError:(SCHJsFunction * _Nonnull) caller
                  withError:(NSError* _Nullable) error {
    SCHLog(@"handler call bad with error:%@",error.localizedDescription);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate paymentPageController:self didFailLoadPaymentPageWithError:error];
    });
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//WKUI delegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////
//navigation delegate
/////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    if (webView == _APMWebView && [webView.URL.absoluteString rangeOfString:PT_SCHAPMResponsePagePath].location != NSNotFound)
    {
        
        [self APMFlowDidFinish];
    }
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (webView == _APMWebView) {
        apmCloseOverrideHandler = [[SCHJsFunction alloc] init];
        [apmCloseOverrideHandler setDelegate:self];
        [apmCloseOverrideHandler executeFunction:PT_SCHOverrideWindowCloseJS inWebView:_APMWebView];
    }  else if (webView == _webView) {
        [_webView evaluateJavaScript:PT_SCHOverrideWindowOpenJSForWK completionHandler:nil];
    }
}



- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if ([webView.URL.absoluteString rangeOfString:PT_SCHReviewPagePath].location != NSNotFound && webView == _APMWebView) {
        [self APMFlowDidFinish];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate paymentPageController:self didFailLoadPaymentPageWithError:error];
    });
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSString *failingURL = error.userInfo[NSURLErrorFailingURLStringErrorKey];
    if ([failingURL rangeOfString:PT_SCHBlankPagePath].location == NSNotFound) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate paymentPageController:self didFailLoadPaymentPageWithError:error];
        });
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//APM Webview show/hide logic
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (WKWebView *)             webView:(WKWebView *)webView
     createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
                forNavigationAction:(WKNavigationAction *)navigationAction
                     windowFeatures:(WKWindowFeatures *)windowFeatures
{
    CGRect frame = CGRectMake(0.0f, 0.0f, _webView.bounds.size.width, _webView.bounds.size.height);
    _APMWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    [self.view addSubview:_APMWebView];
    _APMWebView.scrollView.contentInset = _webView.scrollView.contentInset;
    _APMWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _APMWebView.navigationDelegate = self;
    
    return _APMWebView;
}

- (void)APMFlowDidFinish
{
    [_APMWebView stopLoading];
    _APMWebView.navigationDelegate = nil;
    _APMWebView.UIDelegate = nil;
    [_APMWebView removeFromSuperview];
    _APMWebView = nil;
    
    
    [webviewSetPopupClosed executeFunction:PT_SCHSetPopupClosedJS inWebView:_webView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
// authentication challenge ignore
////////////////////////////////////////////////////////////////////////////////////////////////////////

//this can be removed in production
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
    id<NSURLAuthenticationChallengeSender> sender = [challenge sender];
    NSURLCredential *credential = challenge.proposedCredential;
    
    if ([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust] && credential)
    {
        SecTrustRef trust = [[challenge protectionSpace] serverTrust];
        credential = [NSURLCredential credentialForTrust:trust];
        
        [sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}


@end
