//
//  NSObject+UnrecognizedSelector.m
//  QFCrashSafeDemo
//
//  Created by APP on 25/05/2019.
//

#import "NSObject+UnrecognizedSelector.h"
#import "QF_CrashReport.h"
#import <objc/runtime.h>

@implementation QF_ForwardingTarget

int smartFunctionForForwardingTarget(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethodForForwardingTarget(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunctionForForwardingTarget, funcTypeEncoding);
}

+ (instancetype)defaultForwardingTarget {
    static QF_ForwardingTarget *target = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        target = [[QF_ForwardingTarget alloc] init];
    });
    return target;
}

- (BOOL)addInstanceMethod:(SEL)instanceSEL {
    return __addMethodForForwardingTarget([QF_ForwardingTarget class], instanceSEL);
}

+ (BOOL)addClassMethod:(SEL)classSEL {
    Class metaClass = objc_getMetaClass(class_getName([QF_ForwardingTarget class]));
    return __addMethodForForwardingTarget(metaClass, classSEL);
}

@end

@implementation NSObject (UnrecognizedSelector)

- (id)qf_forwardingTargetForSelector:(SEL)aSelector {
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    if ([self respondsToSelector:aSelector] || signatrue) {
        return self;
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: unrecognized selector sent to instance (%@)",self.class, NSStringFromSelector(aSelector), self];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        [QF_ForwardingTarget.defaultForwardingTarget addInstanceMethod:aSelector];
        return QF_ForwardingTarget.defaultForwardingTarget;
    }
}

@end


