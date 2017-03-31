//
//  ViewController.m
//  SHContactManager
//
//  Created by lalala on 2017/3/31.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "ViewController.h"
#import "SHContactManager.h"


@interface ViewController ()<UIActionSheetDelegate>
@property(nonatomic,strong) UIButton * phoneBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
-(void)configUI{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.frame = CGRectMake(100, 100, 100, 100);
        [_phoneBtn setTitle:@"通讯录" forState:UIControlStateNormal];
        _phoneBtn.backgroundColor = [UIColor purpleColor];
        [_phoneBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_phoneBtn];
    }
}
-(void)onClick{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"通讯录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建新的联系人",@"添加到现有的联系人", nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[SHContactManager sharedInstance] createNewContactWithPhoneNum:self.phoneBtn.titleLabel.text controller:self];
    } else if (buttonIndex == 1){
        [[SHContactManager sharedInstance] addToExistingContactsWithPhoneNum:self.phoneBtn.titleLabel.text controller:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
