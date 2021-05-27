
# 前言
  一个无侵入的 iOS crash 防护框架，基于 Swizzle Method 的 Crash 防护。能有效的防止代码潜在的crash，自动在app运行时实时捕获导致app崩溃的破环因子，使app避免崩溃，照样可以继续正常运行。
  主要参考了[AvoidCrash](https://github.com/chenfanfang/AvoidCrash)框架编写而成。

# 功能
- unrecognized selector crash
- KVO、KVC crash
- Container crash（数组越界，插nil，字典objc、key为nil等）
- NSString crash（字符串截取越界等） 
- NSAttributedString

  
# 使用方法

导入#import "QF_CrashSafe.h"

```
 
/**
 
 @param CrashSafeOption 启动防护类型
 */
- (void)registerCrashSafe:(CrashSafeOption)option;

/*
 crash防护（QF_CrashSafe）
 简介：防止常见的bug导致crash，并收集crash原因和堆栈信息；收集导致crash的错误信息和堆栈信息。
 使用规则：
 1、在 -application:didFinishLaunchingWithOptions: 方法中使用QF_CrashSafe.h的注册方法；
 2、在 QF_CrashReport.h文件中提供了crash信息上报接口，还可以根据userInfo附件额外信息；
 3、如果需要将crash信息上传服务器，可以通过-receivedReport:方法或者+crashMessagesHistory方法去获取。
 */

```


# 版本适配   
系统支持 iOS 10.0 ~ iOS 14.2


# 注意事项

 ** 建议实际开发的时候关闭该组件，以便及时发现crash bug，需要上架或者演示的时候开启crash防护组件。 **
 *  该组件中使用了@try@catch捕捉crash会占用极少量内存，不过正常情况下不影响性能。
 *  目前尚未测试其他第三方框架共同使用时是否存在冲突的情况，如bugly、友盟等。
 *  如果您发现了问题希望能issue，大家一起来解决问题 ^_^
 *  最后，如果你觉得这个框架对你有帮助就给个star吧 ^_^


