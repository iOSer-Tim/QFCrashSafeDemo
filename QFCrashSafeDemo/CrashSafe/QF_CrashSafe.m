//
//  QF_CrashSafe.m
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//

#import "QF_CrashSafe.h"
#import <objc/runtime.h>
#import "QF_TryCrash.h"
#import "QF_CrashReport.h"

@implementation QF_CrashSafe

+(instancetype)shareCrashSafe{
    static QF_CrashSafe *crashSafe = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashSafe = [[QF_CrashSafe alloc] init];
    });
    return crashSafe;
}

- (void)registerCrashSafe:(CrashSafeOption)option {
    if (option & CrashSafeOptionAll || option & CrashSafeOptionUnrecognizedSelector) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [QF_CrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(forwardingTargetForSelector:)
                                   swizzleSEL:NSSelectorFromString(@"qf_forwardingTargetForSelector:")];
        });
    }
    if (option & CrashSafeOptionAll || option & CrashSafeOptionKVC) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [QF_CrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(setValue:forKey:)
                                   swizzleSEL:NSSelectorFromString(@"qf_setValue:forKey:")];
            [QF_CrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(setValue:forUndefinedKey:)
                                   swizzleSEL:NSSelectorFromString(@"qf_setValue:forUndefinedKey:")];
            [QF_CrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(valueForUndefinedKey:)
                                   swizzleSEL:NSSelectorFromString(@"qf_valueForUndefinedKey:")];
        });
    }
    if (option & CrashSafeOptionAll || option & CrashSafeOptionKVO) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [QF_CrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(addObserver:forKeyPath:options:context:)
                                   swizzleSEL:NSSelectorFromString(@"qf_addObserver:forKeyPath:options:context:")];
            [QF_CrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(removeObserver:forKeyPath:)
                                   swizzleSEL:NSSelectorFromString(@"qf_removeObserver:forKeyPath:")];
        });
    }

    if (option & CrashSafeOptionAll || option & CrashSafeOptionContainer || option & CrashSafeOptionArray) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSPlaceholderArray")
                                  originalSEL:@selector(initWithObjects:count:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithObjects:count:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSSingleObjectArrayI")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_objectWithSingleObjectArrayIAtIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayI")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_objectWithArrayIAtIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArray0")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_objectWithArray0AtIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSSingleObjectArrayI")
                                  originalSEL:@selector(objectAtIndexedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"qf_objectWithSingleObjectArrayIAtIndexedSubscript:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayI")
                                  originalSEL:@selector(objectAtIndexedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"qf_objectWithArrayIAtIndexedSubscript:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(insertObject:atIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_insertObject:atIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(removeObjectsInRange:)
                                   swizzleSEL:NSSelectorFromString(@"qf_removeObjectsInRange:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(removeObjectAtIndex:)                                   swizzleSEL:NSSelectorFromString(@"qf_removeObjectAtIndex:")];

            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(replaceObjectAtIndex:withObject:)
                                   swizzleSEL:NSSelectorFromString(@"qf_replaceObjectAtIndex:withObject:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(exchangeObjectAtIndex:withObjectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_exchangeObjectAtIndex:withObjectAtIndex:")];
        });
    }
    if (option & CrashSafeOptionAll || option & CrashSafeOptionContainer || option & CrashSafeOptionDictionary) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(setObject:forKey:)
                                   swizzleSEL:NSSelectorFromString(@"qf_setObject:forKey:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(setObject:forKeyedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"qf_setObject:forKeyedSubscript:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(removeObjectForKey:)
                                   swizzleSEL:NSSelectorFromString(@"qf_removeObjectForKey:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSPlaceholderDictionary")
                                  originalSEL:@selector(initWithObjects:forKeys:count:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithObjects:forKeys:count:")];
        });
    }
    
    if (option & CrashSafeOptionAll || option & CrashSafeOptionContainer || option & CrashSafeOptionString) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"NSPlaceholderString")
                                  originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(stringByAppendingString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_stringByAppendingString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(characterAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_characterAtIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringToIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_substringToIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringFromIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_substringFromIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringWithRange:)
                                   swizzleSEL:NSSelectorFromString(@"qf_substringWithRange:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"NSPlaceholderMutableString")
                                  originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(appendString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_appendString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(stringByAppendingString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_stringByAppendingString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(insertString:atIndex:)
                                   swizzleSEL:NSSelectorFromString(@"qf_insertString:atIndex:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(deleteCharactersInRange:)
                                   swizzleSEL:NSSelectorFromString(@"qf_deleteCharactersInRange:")];
            //富文本
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"NSConcreteAttributedString")
                                  originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"NSConcreteAttributedString")
                                  originalSEL:@selector(initWithAttributedString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithAttributedString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"NSConcreteAttributedString")
                                   originalSEL:@selector(initWithString:attributes:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithString:attributes:")];
            
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"NSConcreteMutableAttributedString")
                                   originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithString:")];
            [QF_CrashSwizzling swizzlingMethod:NSClassFromString(@"NSConcreteMutableAttributedString")
                                   originalSEL:@selector(initWithString:attributes:)
                                   swizzleSEL:NSSelectorFromString(@"qf_initWithString:attributes:")];
        });
    }
    
    if (option & CrashSafeOptionAll || option & CrashSafeOptionCatchCrash) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [QF_TryCrash registerHandler];
        });
    }
    
}

@end
