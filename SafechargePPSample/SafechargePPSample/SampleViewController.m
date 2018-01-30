//
//  SampleViewController.m
//  SafechargePPSample
//
//  Created by Miroslav Chernev on 4/28/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "SampleViewController.h"
#import <SafechargePP/SafechargePP.h>

@interface SampleViewController () < SCHPlaytechPaymentProtocol >
@property (weak, nonatomic) IBOutlet UITextView *urlTextField;

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onOpenURL:(id)sender {
    
    if ( self.urlTextField.text.length  == 0 )
        return;
    
    NSString *urlToOpen = self.urlTextField.text;
    NSURL *url = [[NSURL alloc] initWithString:urlToOpen];
    
    if ( url != nil && [url scheme] != nil && [url host]  != nil) {
        
        //the initFromURL constructs SCHPlaytechRequestBuilder and fills the parameters
        SCHPlaytechRequestBuilder *request = [[SCHPlaytechRequestBuilder alloc] initFromURL:url];
        //you can use:
        // - (instancetype)initWithBaseURL:(NSURL*) baseURL
        //                      merchantId:(NSNumber *) merchant_id
        //                  merchantSiteID:(NSNumber *) merchant_site_id
        //                         themeId:(NSNumber *) theme_id
        //                        language:(NSString *) language
        //                        currency:(NSString *) currency
        //                        username:(NSString *) username
        //                      casinoname:(NSString *) casinoname
        //                  temporaryToken:(NSString *) temporaryToken
        //                      clienttype:(NSString *) clienttype
        //                  clientplatform:(NSString *) clientplatform
        //                   clientversion:(NSString *) clientversion
        //                        realmode:(NSNumber *) realmode
        
        // in order to construct request builder with the mandatory fields
        // and further set the rest of the parameters which are optional
        
        SCHPlaytechPaymentViewController *paymentVC = [[SCHPlaytechPaymentViewController alloc] initWithRequest:[request constructURLRequest]];
        paymentVC.delegate = self;
        [self.navigationController pushViewController:paymentVC animated:YES];
    } else {
        
        [self showURLError];
    }
}


-(void) showURLError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"                                                                             message:@"Unable to open the url, check the format"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)paymentPageController:(SCHPlaytechPaymentViewController *)paymentPageController
          didFinishWithResult:(SCHPlaytechResult *)result {
    NSLog(@"paymentPageController didFinishWithResult called");
    
    
    //based on the result - i.e transactionSuccessful field you can distinguish between the different types of result which can be obtained here.

    NSString *transactionStatus = (result.transactionSuccessful == TRUE ? @"APPROVED" : @"DECLINED");
    NSString *transactionProcess = (result.transactionPending == TRUE ? @"PENDING" : @"PROCESSED");
    
    NSString *messageToShow = ([transactionStatus stringByAppendingFormat:@"(%@)",transactionProcess]);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"didFinishWithResult"                                                                             message:messageToShow
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)paymentPageController:(SCHPlaytechPaymentViewController *)paymentPageController
didFailLoadPaymentPageWithError:(NSError *)error {
    NSLog(@"paymentPageController didFailLoadPaymentPageWithError called");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"didFailLoadPaymentPageWithError"                                                                             message:error.description
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
