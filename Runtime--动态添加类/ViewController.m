//
//  ViewController.m
//  Runtime--动态添加类
//
//  Created by 张晓龙 on 2020/7/28.
//  Copyright © 2020 张晓龙. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建
    Class Car = objc_allocateClassPair([NSObject class], "Car", 0);
    //添加成员变量
    class_addIvar(Car, "name", sizeof(NSString *), log2(sizeof(NSString *)), "@");
    //注册
    objc_registerClassPair(Car);
    

    test_class_addProperty(Car, "info");

    
    id c = [Car alloc];
    [c setValue:@"Audi" forKey:@"name"];
    NSLog(@"%@", [c valueForKey:@"name"]);
    
    [c setValue:@"haha" forKey:@"info"];
    NSLog(@"%@", [c valueForKey:@"info"]);
    
    
}

void test_class_addProperty(Class targetClass , const char *propertyName){
    // 添加属性
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
    objc_property_attribute_t ownership1 = { "C", "" }; // C = copy
    objc_property_attribute_t ownership2 = { "N", "" }; //N = nonatomic
    objc_property_attribute_t ivar  = { "V", [NSString stringWithFormat:@"_%@",[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]].UTF8String };  //variable name
    objc_property_attribute_t attrs[] = {type, ownership1, ownership2, ivar};

    class_addProperty(targetClass, propertyName, attrs, 4);
    
    // 添加setter  +  getter 方法
    class_addMethod(targetClass, @selector(setInfo:), (IMP)testSetter, "v@:@");
    class_addMethod(targetClass, @selector(info), (IMP)testInfo, "@@:");
}

void testSetter(NSString *value){
    printf("%s\n",__func__);
    
}

NSString *testInfo(){
    printf("%s\n",__func__);
    return @"info";
}


@end
