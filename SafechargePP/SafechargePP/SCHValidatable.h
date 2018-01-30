//
//  SCHValidatable.h
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SCHValidatable : NSObject 

-(BOOL) validatePropertyIfSet:(id) prop
                 withMinValue:(NSNumber*) minValue
                 withMaxValue:(NSNumber*) maxValue;

-(BOOL) validatePropertyRequired:(id) prop
                    withMinValue:(NSNumber*) minValue
                    withMaxValue:(NSNumber*) maxValue;

@end
