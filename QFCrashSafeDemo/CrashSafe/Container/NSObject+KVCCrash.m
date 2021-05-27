//
//  NSObject+KVCCrash.m
//  QFCrashSafeDemo
//
//  Created by APP on 25/05/2019.
//

#import "NSObject+KVCCrash.h"
#import "QF_CrashReport.h"

@implementation NSObject (KVCCrash)

/*
 setValue:forKeyPath:方法 和 setValuesForKeysWithDictionary:方法最后都会执行setValue:forKey:方法
 */
- (void)qf_setValue:(id)value forKey:(NSString *)key {
    if (key) {
        [self qf_setValue:value forKey:key];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setValue:forKey:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}
// 对未定义的属性赋值都会执行setValue:forUndefinedKey:
- (void)qf_setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: this class does not find this key (%@)", self.class, NSStringFromSelector(@selector(setValue:forUndefinedKey:)), key];
    [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
}
// 对未定义的属性取值都会执行valueForUndefinedKey:
- (id)qf_valueForUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: this class does not find this key (%@)", self.class, NSStringFromSelector(@selector(valueForUndefinedKey:)), key];
    [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    return nil;
}


@end
