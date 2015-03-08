//
//  TryCatchSwift.m
//  Bond
//
//  Created by Bryce Dougherty on 2/22/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

#import "TryCatchSwift.h"




void tryCatchFinally(void(^tryBlock)(), void(^catchBlock)(NSException *e), void(^finallyBlock)()) {
	@try {
		tryBlock();
	}
	@catch (NSException *exception) {
		catchBlock(exception);
	}
	@finally {
		finallyBlock();
	}
}
