//
//  SHPeoplePickerDelegate.h
//  SHContactManager
//
//  Created by lalala on 2017/3/31.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
@interface SHPeoplePickerDelegate : NSObject <ABPeoplePickerNavigationControllerDelegate,ABNewPersonViewControllerDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate>

@property(nonatomic,copy) NSString * phoneNum;
@property(nonatomic,weak) UIViewController * controller;

@end
