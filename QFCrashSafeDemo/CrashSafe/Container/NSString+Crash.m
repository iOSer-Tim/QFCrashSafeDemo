//
//  NSString+Crash.m
//  QFCrashSafeDemo
//
//  Created by APP on 25/05/2019.
//

#import "NSString+Crash.h"
#import "QF_CrashReport.h"

@implementation NSString (Crash)

// NSPlaceholderString的同名类方法也会执行该方法
- (instancetype)qf_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self qf_initWithString:@""];
    } else return [self qf_initWithString:aString];
}

- (NSString *)qf_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(stringByAppendingString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    } else return [self qf_stringByAppendingString:aString];
}

- (unichar)qf_characterAtIndex:(NSUInteger)index {
    if (index < self.length) {
        return [self qf_characterAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(characterAtIndex:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return 0;
    }
}

- (NSString *)qf_substringFromIndex:(NSUInteger)from {
    if (from <= self.length) {
        return [self qf_substringFromIndex:from];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Index %lu out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringFromIndex:)), from, self.length];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return @"";
    }
}

- (NSString *)qf_substringToIndex:(NSUInteger)to {
    if (to <= self.length) {
        return [self qf_substringToIndex:to];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Index %lu out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringToIndex:)), to, self.length];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    }
}

- (NSString *)qf_substringWithRange:(NSRange)range {
    if (range.location < self.length && range.location + range.length <= self.length) {
        return [self qf_substringWithRange:range];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range {%lu, %lu} out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringWithRange:)), range.location, range.length, self.length];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        NSRange intersectionRange = NSIntersectionRange(range, NSMakeRange(0, self.length));
        return [self qf_substringWithRange:intersectionRange];
    }
}


@end

#pragma mark -- NSMutableString 可变字符串

@implementation NSMutableString (Crash)

// NSPlaceholderMutableString的同名类方法也会执行该方法
- (instancetype)qf_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self qf_initWithString:@""];
    } else return [self qf_initWithString:aString];
}

- (void)qf_appendString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(appendString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else [self qf_appendString:aString];
}

- (NSString *)qf_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(stringByAppendingString:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    } else return [self qf_stringByAppendingString:aString];
}

- (void)qf_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(insertString:atIndex:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else if (loc > self.length) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(insertString:atIndex:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else
    [self qf_insertString:aString atIndex:loc];
}

- (void)qf_deleteCharactersInRange:(NSRange)range {
    if (range.location < self.length && range.location + range.length <= self.length) {
        [self qf_deleteCharactersInRange:range];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(deleteCharactersInRange:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        NSRange intersectionRange = NSIntersectionRange(range, NSMakeRange(0, self.length));
        [self qf_deleteCharactersInRange:intersectionRange];
    }
}


@end
