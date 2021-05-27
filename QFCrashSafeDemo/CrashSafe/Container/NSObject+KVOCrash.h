//
//  NSObject+KVOCrash.h
//  QFCrashSafeDemo
//
//  Created by APP on 25/05/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObserverRemover : NSObject

@end

@interface ObserverContainer : NSObject

@end

@interface NSObject (KVOCrash)

- (void)qf_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
