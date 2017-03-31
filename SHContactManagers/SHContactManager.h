//
//  SHContactManager.h
//  SHContactManager
//
//  Created by lalala on 2017/3/31.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SHPerson, SHSectionPerson;

@interface SHContactManager : NSObject

+(instancetype)sharedInstance;
//通讯录变更回调(已经分组的通讯录)
@property(nonatomic,copy) void(^contactsChangehanlder) (BOOL succeed, NSArray <SHPerson *> * newContacts);
//通讯录的变更回调(未分组的通讯录)
@property(nonatomic,copy) void(^sectionContactsHanlder) (BOOL succeed, NSArray <SHSectionPerson *> *newSectionContacts,NSArray <NSString *>* keys);
/**
 选择联系人
 
 @param controller 控制器
 @param completcion 回调
 */
- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *name, NSString *phone))completcion;

/**
 创建新联系人
 
 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;

/**
 添加到现有联系人
 
 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;

/**
 获取联系人列表（未分组的通讯录）
 
 @param completcion 回调
 */
- (void)accessContactsComplection:(void (^)(BOOL succeed, NSArray <SHPerson *> *contacts))completcion;

/**
 获取联系人列表（已分组的通讯录）
 
 @param completcion 回调
 */
- (void)accessSectionContactsComplection:(void (^)(BOOL succeed, NSArray <SHSectionPerson *> *contacts, NSArray <NSString *> *keys))completcion;
@end
