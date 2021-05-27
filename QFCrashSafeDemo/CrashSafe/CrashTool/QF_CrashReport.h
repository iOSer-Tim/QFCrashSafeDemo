//
//  QF_CrashReport.h
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//  收集日志，上报日志

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QF_CrashReport : NSObject

+ (instancetype)shareCrashReport;
// 崩溃日志上报
- (void)reportCrashMessage:(NSString *)crashMessage;
// 收到崩溃日志时的回调
- (void)receivedReport:(void(^)(NSString *crashMessage))handle;
// 崩溃用户手机信息采集
@property (nonatomic, strong, readonly) NSMutableDictionary *userInfo;
// 回调信息
@property (nonatomic, copy) void (^handle) (NSString *);

@end

@interface QF_CrashReport (FileManager)
// 获取本地的崩溃日志
+ (NSArray <NSString *>*)crashMessagesHistory;
// 清除本地的崩溃日志
+ (void)clean;

@end

@interface NSObject (CrashStack)

// 获取当前的堆栈信息
+ (NSArray <NSString *>*)qf_callStackSymbols;

@end

NS_ASSUME_NONNULL_END
