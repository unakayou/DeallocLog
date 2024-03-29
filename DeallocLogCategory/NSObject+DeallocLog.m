//
//  NSObject+DeallocLog.m
//  DeallocLogDemo
//
//  Created by unakayou on 8/14/19.
//  Copyright © 2019 unakayou. All rights reserved.
//

#import "NSObject+DeallocLog.h"
#import <objc/runtime.h>

@interface DeallocObject : NSObject
@property (nonatomic, assign) Class className;
@property (nonatomic, assign) BOOL  deallocLog;
@end

@interface NSObject()
@property (nonatomic, strong) DeallocObject * deallocObject;
@end

@implementation NSObject (DeallocLog)
@dynamic deallocLog;

#if DEBUG
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class], @selector(init), @selector(swizzled_init));
    });
}
#endif

- (instancetype)swizzled_init {
    if(self.deallocObject == nil) {
        self.deallocObject = [DeallocObject alloc];
        self.deallocObject.className = self.class;
    }
    return [self swizzled_init];
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)deallocLog {
    return self.deallocObject.deallocLog;
}

- (void)setDeallocLog:(BOOL)deallocLog {
    self.deallocObject.deallocLog = deallocLog;
}

static char __logDeallocSentryKey__;
- (DeallocObject *)deallocObject {
    return objc_getAssociatedObject( self, &__logDeallocSentryKey__ );
}

- (void)setDeallocObject:(DeallocObject *)deallocObject {
    objc_setAssociatedObject(self, &__logDeallocSentryKey__, deallocObject, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation DeallocObject
- (void)dealloc {
    if (self.deallocLog) {
        NSLog(@"[%@ %@]",NSStringFromClass(self.className),NSStringFromSelector(_cmd));
    }
}
@end
