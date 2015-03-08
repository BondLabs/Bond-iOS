//
//  TryCatchSwift.h
//  Bond
//
//  Created by Bryce Dougherty on 2/22/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//
#import <Foundation/Foundation.h>

void tryCatchFinally(void(^tryBlock)(), void(^catchBlock)(NSException *e), void(^finallyBlock)());

