//
//  NSDictionary+Carsh.m
//  QFCrashSafeDemo
//
//  Created by APP on 25/05/2019.
//

#import "NSDictionary+Crash.h"
#import "QF_CrashReport.h"

@implementation NSDictionary (Crash)

/**
 使用“@{}”创建字典时，系统会执行-[__NSPlaceholderDictionary initWithObjects:forKeys:count:]
 */
- (instancetype)qf_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: attempt to insert nil object from objects[%d]", self.class, NSStringFromSelector(@selector(initWithObjects:forKeys:count:)), i];
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
            continue;
        }
        newObjects[index] = tmpItem;
        newkeys[index] = tmpKey;
        index++;
    }
    
    return [self qf_initWithObjects:newObjects forKeys:newkeys count:index];
}


@end


#pragma mark -- NSMutableDictionary 可变字典

@implementation NSMutableDictionary (Crash)

/*
 NSMutableDictionary实际对应的是__NSDictionaryM类
 setValue:forKey:也会执行setObject:forKey:
 */
- (void)qf_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setObject:forKey:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    if (!anObject) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil (key: %@)", self.class, NSStringFromSelector(@selector(setObject:forKey:)), aKey];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    [self qf_setObject:anObject forKey:aKey];
}

- (void)qf_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    // obj可以为nil
    if (!key) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setObject:forKeyedSubscript:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    [self qf_setObject:obj forKeyedSubscript:key];
}

- (void)qf_removeObjectForKey:(id)aKey {
    if (aKey) {
        [self qf_removeObjectForKey:aKey];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(removeObjectForKey:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}


@end

