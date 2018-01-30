//
//  SCHLogging.h
//  SafechargePP
//
//  Created by Bozhidar Dimitrov on 3/24/15.
//  Copyright (c) 2015-2016 SafeCharge. All rights reserved.
//


#pragma once


#ifdef DEBUG
    #define SCHLog(str, ...) NSLog(str, ##__VA_ARGS__)
    #define SCHAssert   assert
#else
    #define SCHLog(str, ...)
    #define SCHAssert
#endif
