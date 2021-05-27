//
//  QF_CrashSafe.h
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//

/*
 crash防护（QF_CrashSafe）
 简介：防止常见的bug导致crash，并收集crash原因和堆栈信息；收集导致crash的错误信息和堆栈信息。
 使用规则：
 1、在 -application:didFinishLaunchingWithOptions: 方法中使用QF_CrashSafe.h的注册方法；
 2、在 QF_CrashReport.h文件中提供了crash信息上报接口，还可以根据userInfo附件额外信息；
 3、如果需要将crash信息上传服务器，可以通过-receivedReport:方法或者+crashMessagesHistory方法去获取。
 备注：建议仅在release模式下开启，debug模式下使用该框架容易让开发人员忽略问题。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CrashSafeOption) {
    CrashSafeOptionUnrecognizedSelector = 0,//找不到对应方法
    CrashSafeOptionKVC, //kvc
    CrashSafeOptionKVO, //kvo
    CrashSafeOptionNotification, // 通知
    CrashSafeOptionArray,  //数组
    CrashSafeOptionDictionary, //字典
    CrashSafeOptionString,  //字符串
    CrashSafeOptionContainer, // 数组，字典，字符串
    CrashSafeOptionCatchCrash, // 收集崩溃信息
    CrashSafeOptionAll, // 全类型
}; // Crash防护的相关选项

@interface QF_CrashSafe : NSObject

+ (instancetype)shareCrashSafe;

- (void)registerCrashSafe:(CrashSafeOption)option;

@end

NS_ASSUME_NONNULL_END
