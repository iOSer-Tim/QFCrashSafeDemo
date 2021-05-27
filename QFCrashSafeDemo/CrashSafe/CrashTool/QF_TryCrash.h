//
//  QF_CatchCrash.h
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface QF_TryCrash : NSObject

+ (void)registerHandler;

@end



@interface QF_CrashSwizzling : NSObject

+ (void)swizzlingMethod:(Class)clazz originalSEL:(SEL)originalSEL swizzleSEL:(SEL)swizzleSEL;

@end

NS_ASSUME_NONNULL_END
