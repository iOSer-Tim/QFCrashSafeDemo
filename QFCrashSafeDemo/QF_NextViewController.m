//
//  QF_NextViewController.m
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//

#import "QF_NextViewController.h"
#import <objc/message.h>
#import "QF_CrashReport.h"

@interface QF_NextViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSNumber *number;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation QF_NextViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"NSArray ---crash",
                       @"NSMutableArray ---crash",
                       @"NSString ---crash",
                       @"NSMutableString ---crash",
                       @"NSAttributedString ---crash",
                       @"NSMutableAttributedString ---crash",
                       @"NSDictionary ---crash",
                       @"NSMutableDictionary ---crash",
                       @"KVO ---crash",
                       @"KVC ---crash"];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"内存地址 %p", self);
    
    [self.view addSubview:self.tableView];
    
    ((void (*)(id,SEL))objc_msgSend)(self,@selector(addRightBtn));
    
    //NSArray *arr = [QF_CrashReport crashMessagesHistory];
    //NSLog(@"%@",arr);
    
    //[QF_CrashReport clean];
    NSLog(@"%@",NSHomeDirectory());
    
    
}

-(void)addRightBtn{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"void crash" forState:0];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(0, 0, 100, 44);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}



#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.dataArray[indexPath.section];
    return cell;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.section;
    switch (index) {
        case 0:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testArray));
            break;
        case 1:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testMutArray));
            break;
        case 2:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testString));
            break;
        case 3:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testMutString));
            break;
        case 4:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testAttributedString));
            break;
        case 5:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testMutAttributedString));
            break;
        case 6:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testDic));
            break;
        case 7:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testMutDic));
            break;
        case 8:
            ((void (*)(id,SEL))objc_msgSend)(self,@selector(testKVO));
            break;
        case 9:
            //((void (*)(id,SEL))objc_msgSend)(self,@selector(testKVC));
            ((void (*)(id,SEL,id))objc_msgSend)(self,@selector(funtionSel:),@"testKVC");
            break;
            
        default:
            break;
    }
}

-(void)funtionSel:(NSString *)action{
    
    ((void (*)(id,SEL))objc_msgSend)(self,NSSelectorFromString(action));
}


//=================================================================
//                       NSArray_Test
//=================================================================
#pragma mark - NSArray_Test
-(void)testArray{
    
    //添加nil
    NSObject *obj = nil;
    NSArray *ar = @[@0,@2,obj,@6];
    NSLog(@"%@",ar);

    //数组越界
    NSArray *ar1 = @[@0,@8,@1,@3];
    NSLog(@"%@",ar1[6]);

    //操作空数组赋值
    NSArray *ar2 = @[];
    id obj0 = ar2[1];

    NSObject *obj1 = [[NSObject alloc] init];
    [obj1 setValue:@"infi" forKey:@"bbb"];
    
    [obj1 valueForKey:@"key"];
    

}

//=================================================================
//                       NSMutableArray_Test
//=================================================================
#pragma mark - NSMutableArray_Test
-(void)testMutArray{
    
    NSMutableArray *mArr = [NSMutableArray array];
    [mArr addObject:nil];
    [mArr insertObject:@"tim" atIndex:1];
    [mArr insertObject:@"fly" atIndex:0];
    [mArr insertObject:@"timor" atIndex:2];
    [mArr removeObject:nil];
    [mArr removeObject:@"aa"];
    [mArr removeObjectAtIndex:0];
    [mArr addObject:@"cc"];
    [mArr removeObjectAtIndex:2];
    

    [mArr replaceObjectAtIndex:2 withObject:nil];
    [mArr addObject:@"a"];
    [mArr replaceObjectAtIndex:2 withObject:@"b"];
    [mArr replaceObjectAtIndex:-1 withObject:@"b"];

    [mArr exchangeObjectAtIndex:2 withObjectAtIndex:3];
    [mArr addObject:@"xxx"];
    [mArr exchangeObjectAtIndex:2 withObjectAtIndex:3];
    [mArr exchangeObjectAtIndex:0 withObjectAtIndex:3];
}

//=================================================================
//                       NSString_Test
//=================================================================
#pragma mark - NSString_Test
-(void)testString{
    

    NSString *nilStr = nil;
    NSString *str = [[NSString alloc] initWithString:nilStr];
    str = [NSString stringWithString:nilStr];
    str = @"0123";
    [str stringByAppendingString:nilStr];
    NSLog(@"%c", [str characterAtIndex:4]);
    NSLog(@"%@", [str substringFromIndex:5]);
    NSLog(@"%@", [str substringToIndex:5]);
    NSLog(@"%@", [str substringWithRange:NSMakeRange(2, 4)]);
}

//=================================================================
//                       NSMutableString_Test
//=================================================================
#pragma mark - NSMutableString_Test
-(void)testMutString{
    
    NSString *insertString = nil;
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:insertString];
    mStr = [NSMutableString stringWithString:insertString];
    [mStr appendString:insertString];
    [mStr stringByAppendingString:insertString];
    [mStr insertString:insertString atIndex:0];
    [mStr insertString:@"s" atIndex:1];
    [mStr appendString:@"0123"];
    [mStr deleteCharactersInRange:NSMakeRange(4, 0)];
    [mStr deleteCharactersInRange:NSMakeRange(4, 1)];
    [mStr deleteCharactersInRange:NSMakeRange(3, 2)];
    
    
}

//=================================================================
//                      NSAttributedString_Test
//=================================================================
#pragma mark - NSAttributedString_Test
- (void)testAttributedString{
    NSString *str = nil;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str];
    NSLog(@"%@",attributeStr);
    
    
    //
    NSAttributedString *nilAttributedStr = nil;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithAttributedString:nilAttributedStr];
    NSLog(@"%@",attributedStr);
    
    
    //
    NSDictionary *attributes = @{
                           NSForegroundColorAttributeName : [UIColor redColor]
                           };
    NSString *nilStr = nil;
    NSAttributedString *attributedStr1 = [[NSAttributedString alloc] initWithString:nilStr attributes:attributes];
    NSLog(@"%@",attributedStr1);
}


//=================================================================
//                   NSMutableAttributedString_Test
//=================================================================
#pragma mark - NSMutableAttributedString_Test

- (void)testMutAttributedString {
    
    NSString *nilStr = nil;
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:nilStr];
    NSLog(@"%@",attrStrM);
    
    
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor redColor]
                                 };
    NSString *nilStr1 = nil;
    NSMutableAttributedString *attrStrM1 = [[NSMutableAttributedString alloc] initWithString:nilStr1 attributes:attributes];
    NSLog(@"%@",attrStrM1);

}

//=================================================================
//                       NSDictionary_Test
//=================================================================
#pragma mark - NSDictionary_Test
-(void)testDic{
    
    NSString *key = @"key2";
    NSString *value = nil;
    NSDictionary *dict = @{@"key1": @"v1", key: value, @"key3": @"v3"};
    NSLog(@"%@", dict);
    
    NSString *key1 = nil;
    NSDictionary *dict1 = @{key1: @"v1", @"key2": @"v2"};
    NSLog(@"%@", dict1);
}

//=================================================================
//                       NSMutableDictionary_Test
//=================================================================
#pragma mark - NSMutableDictionary_Test
-(void)testMutDic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:nil forKey:@"a"];
    [dic setValue:@"a" forKey:nil];
    [dic setValue:@"b" forKeyPath:@"b.b"];
    [dic setValuesForKeysWithDictionary:@{@"bbbbbbb": @"C", @"d": @"d"}];
    [dic setObject:nil forKeyedSubscript:@"a"]; //obj可以为nil,key不能为nil
    [dic setObject:nil forKeyedSubscript:nil];
    [dic removeObjectForKey:nil];
    [dic removeObjectForKey:@"不存在的key"]; //可以移除不存的key,但不能为nil
}

//=================================================================
//                       KVO_Test
//=================================================================
#pragma mark - KVO_Test
-(void)testKVO{
    
    //重复添加，重复移除，
    [self addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
    self.number = @1;
    [self removeObserver:self forKeyPath:@"number"];
    [self removeObserver:self forKeyPath:@"number"];
    [self removeObserver:self forKeyPath:@"number" context:nil];
    self.number = @2;
}

//=================================================================
//                       KVC_Test
//=================================================================
#pragma mark - KVC_Test
-(void)testKVC{
    
    NSObject *obj = [NSObject new];
    [obj setValue:@"tom" forKey:@"name"];
    [obj setValue:@"tom" forKeyPath:@"brother.name"];
    [obj valueForKey:@"name"];
    [obj valueForKeyPath:@"name"];
    [obj setValue:@"tom" forKeyPath:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%s %@ %@", __FUNCTION__, keyPath, change);
}


- (void)dealloc {
    NSLog(@"dealloc---%s", __FUNCTION__);
}

@end
