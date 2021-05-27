//
//  ViewController.m
//  QFCrashSafeDemo
//
//  Created by APP on 24/05/2019.
//

#import "ViewController.h"
#import <objc/message.h>

#import "QF_NextViewController.h"


@interface ViewController ()

@property(nonatomic,strong)UIButton *nextBtn;


@end


@implementation ViewController



-(UIButton *)nextBtn{
    if (!_nextBtn) {
       _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitle:@"Crash List" forState:0];
        _nextBtn.frame = CGRectMake(100, 200, 150, 100);
        [_nextBtn setTitleColor:[UIColor redColor] forState:0];
        [_nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *arr = @[@1,@2,@3,@6];
    NSArray *arr1 = @[@1,@5,@9,@6,@7];
    
    NSMutableArray *arr3 = [NSMutableArray array];
    [arr3 addObjectsFromArray:arr];
    [arr3 addObjectsFromArray:arr1];
    
    //方法一
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSNumber *number in arr3) {
        [dict setObject:number forKey:number];
    }
    NSLog(@"%@",[dict allKeys]);
    NSArray *dictArr = [dict allKeys];
    
    //方法二
    NSSet *set = [NSSet setWithArray:arr3];
    NSLog(@"%@",[set allObjects]);
//    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSLog(@"%@",obj);
//    }];
    
    //排序
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
    NSArray *sortSetArray = [set sortedArrayUsingDescriptors:sortDesc];
    NSLog(@"set去重并排序：%@",sortSetArray);
    
    NSArray *sortSetArray1 = [dictArr sortedArrayUsingDescriptors:sortDesc];
    NSLog(@"--dic去重并排序：%@",sortSetArray1);
}


-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nextBtn];
}

-(void)btnClick:(UIButton *)sender{
   
    //((void (*)(id,SEL))objc_msgSend)(self,@selector(test1));
    ((void (*)(id,SEL,id))objc_msgSend)(self,@selector(test2:),sender);
    
    //[self test2:sender];
}

-(void)test1{
    NSLog(@"111");
}

-(void)test2:(id)arg{
    NSLog(@"222--%@",arg);
    
    QF_NextViewController *vc = [QF_NextViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
