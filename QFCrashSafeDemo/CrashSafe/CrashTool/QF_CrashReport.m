//
//  QF_CrashReport.m
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//

#import "QF_CrashReport.h"
#include <execinfo.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define dLog(format, ...) NSLog((@"*** CrashInfo: " format), ##__VA_ARGS__);
#else
#define dLog(...)
#endif

#pragma mark --- CrashStack  堆栈信息
@implementation NSObject (CrashStack)

+ (NSArray <NSString *>*)qf_callStackSymbols {
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i ++) {
        NSString *stackString = [NSString stringWithUTF8String:strs[i]];
        [backtrace addObject:stackString];
    }
    free(strs);
    return backtrace;
}


@end

#pragma mark -----  QF_CrashReport 文件管理
@implementation QF_CrashReport (FileManager)

+ (NSString *)directoryPath {
    NSArray <NSString *>*directoryPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [directoryPaths.firstObject stringByAppendingString:@"/CrashMessages"];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];
    if (!isExist) {
        NSError *error;
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isSuccess) {
            dLog(@"creat Directory Failed. errorInfo:%@",error);
        }
    }
    return directoryPath;
}

// 获取文件夹下文件列表
+ (NSArray <NSString *>*)getFileListInFolderWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        dLog(@"getFileListInFolderWithPathFailed, errorInfo:%@",error);
    }
    return fileList;
}

+ (NSArray <NSString *>*)crashMessagesHistory {
    NSArray <NSString *>*fileNames = [QF_CrashReport getFileListInFolderWithPath:[QF_CrashReport directoryPath]];
    
    NSMutableArray <NSString *>*crashMessages = [NSMutableArray array];
    for (NSString *fileName in fileNames) {
        NSString *crashMessage = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [QF_CrashReport directoryPath], fileName] encoding:NSUTF8StringEncoding error:nil];
        [crashMessages addObject:[NSString stringWithFormat:@"%@ %@", fileName, crashMessage]];
    }
    return crashMessages;
}

+ (void)clean {
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *directoryPath = [QF_CrashReport directoryPath];
    if ([fileManage fileExistsAtPath:directoryPath]) [fileManage removeItemAtPath:directoryPath error:nil];
}

- (void)writeCrashMessage:(NSString *)crashMessage toDirectoryPath:(NSString *)directoryPath {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSZ";
    NSString *filePath = [directoryPath stringByAppendingFormat:@"/%@", [dateFormatter stringFromDate:[NSDate date]]];
    [crashMessage writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end

#pragma mark ---- QF_CrashReport
@implementation QF_CrashReport
{
    __strong NSMutableDictionary *_userInfo;
}

+ (instancetype)shareCrashReport {
    static QF_CrashReport *crashReport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashReport = [[QF_CrashReport alloc] init];
    });
    return crashReport;
}

- (void)reportCrashMessage:(NSString *)crashMessage {
    if (![crashMessage containsString:@"First throw call stack"]) {
        crashMessage = [crashMessage stringByAppendingFormat:@"\n*** First throw call stack:\n%@",[NSObject qf_callStackSymbols]];
    }
    crashMessage = [crashMessage stringByAppendingFormat:@"\n*** UserInfo:\n%@", self.userInfo];
    
    dLog(@"%@", crashMessage);
    
    if (_handle) _handle(crashMessage);
    // 收集Crash信息
    [self writeCrashMessage:crashMessage toDirectoryPath:[QF_CrashReport directoryPath]];
}

- (void)receivedReport:(void (^)(NSString * _Nonnull))handle {
    _handle = handle;
}

- (NSMutableDictionary *)userInfo {
    if (!_userInfo) {
        _userInfo = [NSMutableDictionary dictionary];
        UIDevice *device = [UIDevice currentDevice];
        _userInfo[@"device_name"] = device.name;
        _userInfo[@"device_model"] = device.model;
        _userInfo[@"device_localizedModel"] = device.localizedModel;
        _userInfo[@"device_system"] = [device.systemName stringByAppendingFormat:@" %@", device.systemVersion];
        _userInfo[@"device_UUID"] = device.identifierForVendor;
    }
    return _userInfo;
}


@end
