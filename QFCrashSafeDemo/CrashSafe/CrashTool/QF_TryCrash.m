//
//  QF_CatchCrash.m
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//

#import "QF_TryCrash.h"
#import <objc/runtime.h>
#import "QF_CrashReport.h"

static NSUncaughtExceptionHandler *qf_previousUncaughtExceptionHandler;
typedef void (*SignalHandler)(int signo, siginfo_t *info, void *context);
static SignalHandler qf_previousSignalHandler = NULL;

@implementation QF_TryCrash

+ (void)registerHandler {
    InstallSignalHandler();
    InstallUncaughtExceptionHandler();
}



/*
 SIGABRT--程序中止命令中止信号
 SIGALRM--程序超时信号
 SIGFPE--程序浮点异常信号
 SIGILL--程序非法指令信号
 SIGHUP--程序终端中止信号
 SIGINT--程序键盘中断信号
 SIGKILL--程序结束接收中止信号
 SIGTERM--程序kill中止信号
 SIGSTOP--程序键盘中止信号
 SIGSEGV--程序无效内存中止信号
 SIGBUS--程序内存字节未对齐中止信号
 SIGPIPE--程序Socket发送失败中止信号
 */
static void InstallSignalHandler(void) {
    struct sigaction old_action;
    sigaction(SIGABRT, NULL, &old_action);
    if (old_action.sa_flags & SA_SIGINFO) {
        qf_previousSignalHandler = old_action.sa_sigaction;
    }
    
    SignalRegister(SIGABRT);
//    SignalRegister(SIGHUP);
//    SignalRegister(SIGINT);
//    SignalRegister(SIGQUIT);
//    SignalRegister(SIGILL);
//    SignalRegister(SIGSEGV);
//    SignalRegister(SIGFPE);
//    SignalRegister(SIGBUS);
//    SignalRegister(SIGPIPE);
    // .......

}

static void SignalRegister(int signal) {
    struct sigaction action;
    action.sa_sigaction = qfSignalHandler;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal, &action, 0);
}

static void qfSignalHandler(int signal, siginfo_t* info, void* context) {
    NSString *crashMessage = [NSString stringWithFormat:@"*** crash *** signal: %d, info: %@", signal, info];
    [QF_CrashReport.shareCrashReport reportCrashMessage:crashMessage];

    // 处理前者注册的 handler
    if (qf_previousSignalHandler) {
        qf_previousSignalHandler(signal, info, context);
    }
}

static void qfHandleException(NSException *exception) {
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    [QF_CrashReport.shareCrashReport reportCrashMessage:[NSString stringWithFormat:@"*** crash *** %@ \n*** First throw call stack:\n%@", reason, [exception callStackSymbols]]];
    
    //  处理前者注册的 handler
    if (qf_previousUncaughtExceptionHandler) {
        qf_previousUncaughtExceptionHandler(exception);
    }
}

static void InstallUncaughtExceptionHandler(void) {
    qf_previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&qfHandleException);
}

@end

#pragma mark --- 方法交换
@implementation QF_CrashSwizzling

/**
 *  对象方法的交换
 *
 *  @param anClass    哪个类
 *  @param originalSEL 方法1(原本的方法)
 *  @param swizzleSEL 方法2(要替换成的方法)
 */
+ (void)swizzlingMethod:(Class)anClass originalSEL:(SEL)originalSEL swizzleSEL:(SEL)swizzleSEL {

    Method originalMethod = class_getInstanceMethod(anClass, originalSEL);
    Method swizzleMethod = class_getInstanceMethod(anClass, swizzleSEL);
    
    
    BOOL didAddMethod = class_addMethod(anClass, originalSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        //  当originalMethod为nil时，这里的class_replaceMethod将不做替换，所以swizzleSel方法里的实现还是自己原来的实现
        class_replaceMethod(anClass, swizzleSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

@end
