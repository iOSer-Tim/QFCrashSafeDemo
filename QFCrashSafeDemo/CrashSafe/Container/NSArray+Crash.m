//
//  NSArray+Crash.m
//  QFCrashSafeDemo
//
//  Created by APP on 25/05/2019.
//

#import "NSArray+Crash.h"
#import "QF_CrashReport.h"

@implementation NSArray (Crash)

/*
 NSArray真正对应的类：__NSArray0、__NSSingleObjectArrayI、__NSArrayI
 对于超过一个字面量初始化的时候取值走的不是objectAtIndex: 而是objectAtIndexedSubscript:
 */

// 空数组：__NSArray0；objectAtIndex:
- (id)qf_objectWithArray0AtIndex:(NSUInteger)index {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds for empty NSArray", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index];
    [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    return nil;
}
// 单元素数组：__NSSingleObjectArrayI；objectAtIndex:
- (id)qf_objectWithSingleObjectArrayIAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self qf_objectWithSingleObjectArrayIAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index, self.count - 1];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 多元素数组：__NSArrayI；objectAtIndex:
- (id)qf_objectWithArrayIAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self qf_objectWithArrayIAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index, self.count - 1];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 单元素数组：__NSSingleObjectArrayI；objectAtIndexedSubscript:
- (id)qf_objectWithSingleObjectArrayIAtIndexedSubscript:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self qf_objectWithSingleObjectArrayIAtIndexedSubscript:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndexedSubscript:)), index, self.count - 1];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 多元素数组：__NSArrayI；objectAtIndexedSubscript:
- (id)qf_objectWithArrayIAtIndexedSubscript:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self qf_objectWithArrayIAtIndexedSubscript:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndexedSubscript:)), index, self.count - 1];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}
// 使用“@[]”创建数组时，系统会执行-[__NSPlaceholderArray initWithObjects:count:]
- (instancetype)qf_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    for (NSUInteger i = 0; i < cnt; i ++) {
        id tmpObject = objects[i];
        if (tmpObject == nil) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: attempt to insert nil object from objects[%lu]", self.class, NSStringFromSelector(@selector(initWithObjects:count:)), (unsigned long)i];
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
            continue;
        }
        newObjects[index] = tmpObject;
        index ++;
    }
    return [self qf_initWithObjects:newObjects count:index];
}


@end


#pragma mark -- NSMutableArray  可变数组

@implementation NSMutableArray (Crash)

/*
 NSMutableArray的实际执行者是__NSArrayM类
 addObject:也会执行insertObject:atIndex:方法；
 */
- (void)qf_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject) {
        if (NSLocationInRange(index, NSMakeRange(0, self.count + 1))) {
            [self qf_insertObject:anObject atIndex:index];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds", self.class, NSStringFromSelector(@selector(insertObject:atIndex:)), index];
            if (self.count == 0) {
                crashMessages = [crashMessages stringByAppendingString:@" for empty array"];
            } else {
                crashMessages = [crashMessages stringByAppendingFormat:@" [0 .. %lu]", self.count];
            }
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil", self.class, NSStringFromSelector(@selector(insertObject:atIndex:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}
/*
 iOS10后removeObjectAtIndex:也会执行removeObjectsInRange:
 */
- (void)qf_removeObjectsInRange:(NSRange)range {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: rannge {%lu, %lu} extends beyond bounds for empty array", self.class, NSStringFromSelector(@selector(removeObjectsInRange:)), range.location, range.length];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        NSRange bounds = NSMakeRange(0, self.count);
        if (NSLocationInRange(range.location, bounds) && NSLocationInRange(range.location + range.length - 1, bounds)) {
            [self qf_removeObjectsInRange:range];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: rannge {%lu, %lu} extends beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(removeObjectsInRange:)), range.location, range.length, self.count - 1];
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    }
}

- (void)qf_removeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu extends beyond bounds for empty array", self.class, NSStringFromSelector(@selector(removeObjectAtIndex:)), index];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        if (index < self.count) {
            [self qf_removeObjectAtIndex:index];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu extends beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(removeObjectAtIndex:)), index, self.count - 1];
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    }
}

- (void)qf_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (anObject) {
        if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
            [self qf_replaceObjectAtIndex:index withObject:anObject];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds", self.class, NSStringFromSelector(@selector(replaceObjectAtIndex:withObject:)), index];
            if (self.count == 0) {
                crashMessages = [crashMessages stringByAppendingString:@" for empty array"];
            } else {
                crashMessages = [crashMessages stringByAppendingFormat:@" [0 .. %lu]", self.count];
            }
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil", self.class, NSStringFromSelector(@selector(replaceObjectAtIndex:withObject:))];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}

- (void)qf_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds for empty array", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx1];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        if (!NSLocationInRange(idx1, NSMakeRange(0, self.count))) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx1, self.count - 1];
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        } else if (!NSLocationInRange(idx2, NSMakeRange(0, self.count))) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx2, self.count - 1];
            [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
        } else {
            [self qf_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        }
    }
}

- (id)qf_objectAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self qf_objectAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index, self.count - 1];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}

- (id)qf_objectAtIndexedSubscript:(NSUInteger)idx {
    if (NSLocationInRange(idx, NSMakeRange(0, self.count))) {
        return [self qf_objectAtIndexedSubscript:idx];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndexedSubscript:)), idx, self.count - 1];
        [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}

@end
