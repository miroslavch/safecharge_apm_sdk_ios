//
//  SCHPlaytechConstants.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 5/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#ifndef SCHPlaytechConstants_h
#define SCHPlaytechConstants_h

static NSString * const PT_SCHPaymentPagePath = @"/ppp/purchase.do";
static NSString * const PT_SCHBlankPagePath = @"/blank.html";
static NSString * const PT_SCHReviewPagePath = @"/ppp/review.do";


static NSString * const PT_SCHAPMResponsePagePath = @"/ppp/apmgwresponse.do";
static NSString * const PT_SCHPPPAdapterResponsePagePath = @"/ppp/pppadapter.do";
static NSString * const PT_SCHCloseWindowURL = @"schppclose://window";
static NSString * const PT_SCHNewWindowURLSuffix = @"//newwindow";

static NSString * const PT_SCHApplePayCaptureURL = @"http://apple.pay.capture.me.invaliddomain/";
static NSString * const PT_SCHApplePaySuccessURL = @"http://apple.pay.capture.me.invaliddomain/success";
static NSString * const PT_SCHApplePayFailureURL = @"http://apple.pay.capture.me.invaliddomain/failure";

static NSString * const PT_SCHSetPopupClosedJS = @"_popupWindow.closed = true; window.unblockUI();";

static NSString * const PT_SCHOpenState = @"sdk";

static NSString * const PT_SCHOverrideWindowOpenJS =
@"var _popupWindow;"
""
"if (!window.openIsOverriden)"
"{"
"    var _open = window.open;"
""
"    window.open = function(url, name, properties)"
"    {"
"        _open(url + '//newwindow', name, properties);"
""
"        _popupWindow = {"
"            closed : false,"
"            focus : function() { },"
"            close : function() { }"
"        };"
""
"        return _popupWindow;"
"    };"
""
"    window.openIsOverriden = true;"
"}";

static NSString * const PT_SCHOverrideWindowOpenJSForWK =
@"var _popupWindow;"
""
"if (!window.openIsOverriden)"
"{"
"    var _open = window.open;"
""
"    window.open = function(url, name, properties)"
"    {"
"        _open(url, name, properties);"
""
"        _popupWindow = {"
"            closed : false,"
"            focus : function() { },"
"            close : function() { }"
"        };"
""
"        return _popupWindow;"
"    };"
""
"    window.openIsOverriden = true;"
"}";

static NSString * const PT_SCHOverrideWindowCloseJS =
@"if (!window.closeIsOverriden)"
"{"
"   window.close = function()"
"   {"
"       window.location.assign('schppclose://window');"
"   };"
""
"   window.closeIsOverriden = true;"
"}";

static NSString *PT_SCHOverrideTransactionFunction = @"var transactionFunction = false; \
var callbackFunc = function(data) { \
window.webkit.messageHandlers.APPLTransactionEvent.postMessage( {'data':data}); \
}; \
this.pubsub.subscribe('safecharge.transaction.complete',callbackFunc); \
transactionFunction = true;";

static NSString *PT_SCHOverwrittenEvent = @"APPLTransactionEvent";


#endif /* SCHPlaytechConstants_h */
