//
//  SCHValidatable.m
//  SafechargePP
//
//  Created by Miroslav Chernev on 1/30/17.
//  Copyright © 2017 SafeCharge. All rights reserved.
//

#import "SCHValidatable.h"

@implementation SCHValidatable

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

//////////////////////////////////////////////////////////////////////////
//validatePropertyIfSet
//returns true if there is no validator added
//////////////////////////////////////////////////////////////////////////
-(BOOL) validatePropertyIfSet:(id) prop withMinValue:(NSNumber*) minValue
                 withMaxValue:(NSNumber*) maxValue {
    
    if ( prop != nil ) {

        SEL validatorSelector = @selector(validateProperty:withMinValue:withMaxValue:);

        BOOL isValidatorAdded = [self respondsToSelector:validatorSelector];
        if ( isValidatorAdded ) {
            
            typedef BOOL (*ValidatorType)(id, SEL, id, NSNumber*, NSNumber*);
            ValidatorType validatorToCall = (ValidatorType)([self methodForSelector:validatorSelector]);
            
            return validatorToCall(self,validatorSelector,prop,minValue,maxValue);
        } else {
            return true; //return true if no validator is found
        }
    } else {
        return true;
    }
}

//////////////////////////////////////////////////////////////////////////
//validatePropertyRequired
//returns false if prop is nil, otherwise calls validatePropertyIfSet
//////////////////////////////////////////////////////////////////////////
-(BOOL) validatePropertyRequired:(id) prop withMinValue:(NSNumber*) minValue
                    withMaxValue:(NSNumber*) maxValue {
    if ( prop == nil ) {
        return false;
    }
    
    return [self validatePropertyIfSet:prop withMinValue:minValue withMaxValue:maxValue];
}

///////////////////////////////////////////////////////////////////////////
//private
///////////////////////////////////////////////////////////////////////////

-(BOOL) validateProperty:(id) prop withMinValue:(NSNumber*) minValue
            withMaxValue:(NSNumber*) maxValue {
    
    if ( [prop isKindOfClass:[NSString class] ] ){
        BOOL maxLength = (((NSString*) prop).length > maxValue.unsignedLongValue);
        return (maxLength == FALSE);
        
    } else if ( [prop isKindOfClass:[NSURL class] ] ) {
        
        BOOL maxLength = (((NSURL*) prop).absoluteString.length > 2048 );
        return (maxLength == FALSE); // nsurl is non nill if it's valid
        
    } else if ( [prop isKindOfClass:[NSNumber class] ] ) {
        
        BOOL lessThanMin = ([((NSNumber*) prop) compare:minValue] == NSOrderedAscending);
        BOOL largeThanMax = ([((NSNumber*) prop) compare:maxValue] == NSOrderedDescending);
        
        return (lessThanMin == FALSE) && (largeThanMax == FALSE);

    }
    

    return false;
}

#pragma clang diagnostic pops

@end
