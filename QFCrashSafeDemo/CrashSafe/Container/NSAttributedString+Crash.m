//
//  NSAttributedString+Crash.m
//  QFCrashSafeDemo
//
//  Created by APP on 25/05/2019.
//

#import "NSAttributedString+Crash.h"
#import "QF_CrashReport.h"


@implementation NSAttributedString (Crash)


- (instancetype)qf_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self qf_initWithString:@""];
    } else return [self qf_initWithString:aString];
}

- (instancetype)qf_initWithAttributedString:(NSAttributedString *)attrStr {
    
    if (!attrStr) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithAttributedString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self qf_initWithAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    } else return [self qf_initWithAttributedString:attrStr];
}

- (instancetype)qf_initWithString:(NSString *)aString attributes:(NSDictionary<NSString *,id> *)attrs {
    
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:attributes:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self qf_initWithString:@"" attributes:attrs];
    }else return [self qf_initWithString:aString attributes:attrs];
}

@end


#pragma mark -- 可变富文本
@implementation NSMutableAttributedString (Crash)

- (instancetype)qf_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self qf_initWithString:@""];
    } else return [self qf_initWithString:aString];
}

- (instancetype)qf_initWithString:(NSString *)aString attributes:(NSDictionary<NSString *,id> *)attrs {
    
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:attributes:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self qf_initWithString:@"" attributes:attrs];
    }else return [self qf_initWithString:aString attributes:attrs];
    
}

@end
