//
//  NSObject+DeallocLog.h
//  DeallocLogDemo
//
//  Created by unakayou on 8/14/19.
//  Copyright © 2019 unakayou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DeallocLog)
@property (nonatomic, assign) BOOL deallocLog;
@end

NS_ASSUME_NONNULL_END
