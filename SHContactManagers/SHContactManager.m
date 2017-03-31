//
//  SHContactManager.m
//  SHContactManager
//
//  Created by lalala on 2017/3/31.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHContactManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SHPerson.h"
#import "SHPeoplePickerDelegate.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface SHContactManager () <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, CNContactViewControllerDelegate, CNContactPickerDelegate>

@property (nonatomic, copy) void (^handler) (NSString *, NSString *);
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, strong) SHPeoplePickerDelegate *pickerDelegate;
@property (nonatomic) ABAddressBookRef addressBook;

@end

@implementation SHContactManager
void _addressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    [[SHContactManager sharedInstance] accessContactsComplection:^(BOOL succeed, NSArray *contacts) {
        if ([SHContactManager sharedInstance].contactsChangehanlder) {
            [SHContactManager sharedInstance].contactsChangehanlder(succeed, contacts);
        }
    }];
    [[SHContactManager sharedInstance] accessSectionContactsComplection:^(BOOL succeed, NSArray<SHSectionPerson *> *contacts, NSArray<NSString *> *keys) {
        if ([SHContactManager sharedInstance].sectionContactsHanlder) {
            [SHContactManager sharedInstance].sectionContactsHanlder(succeed, contacts, keys);
        }
    }];
}
- (SHPeoplePickerDelegate *)pickerDelegate {
    if (!_pickerDelegate)  {
        _pickerDelegate = [SHPeoplePickerDelegate new];
    }
    return _pickerDelegate;
}
- (NSArray *)keys {
    if (!_keys) {
        _keys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                  CNContactPhoneNumbersKey,
                  CNContactOrganizationNameKey,
                  CNContactDepartmentNameKey,
                  CNContactJobTitleKey,
                  CNContactNoteKey,
                  CNContactPhoneticGivenNameKey,
                  CNContactPhoneticFamilyNameKey,
                  CNContactPhoneticMiddleNameKey,
                  CNContactImageDataKey,
                  CNContactThumbnailImageDataKey,
                  CNContactEmailAddressesKey,
                  CNContactPostalAddressesKey,
                  CNContactBirthdayKey,
                  CNContactNonGregorianBirthdayKey,
                  CNContactInstantMessageAddressesKey,
                  CNContactSocialProfilesKey,
                  CNContactRelationsKey,
                  CNContactUrlAddressesKey];
    }
    return _keys;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        if (IOS9_OR_LATER) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_contactStoreDidChange)
                                                         name:CNContactStoreDidChangeNotification
                                                       object:nil];
        } else {
            self.addressBook = ABAddressBookCreate();
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, _addressBookChange, nil);
        }
    }
    return self;
}
+(instancetype)sharedInstance{
    static id shared_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_instance = [[self alloc]init];
    });
    return shared_instance;
}
#pragma mark - Public
-(void)selectContactAtController:(UIViewController *)controller complection:(void (^)(NSString *, NSString *))completcion{
    self.isAdd = NO;
    [self _presentFromController:controller];
    self.handler = ^(NSString *name, NSString * phone) {
        if (completcion) {
            completcion(name,phone);
        }
    };
}
-(void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller{
    if (IOS9_OR_LATER) {
        CNMutableContact * contact = [[CNMutableContact alloc]init];
        CNLabeledValue * labeledValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum]];
        contact.phoneNumbers = @[labeledValue];
        CNContactViewController * contactController = [CNContactViewController viewControllerForContact:contact];
        contactController.delegate = self;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:contactController];
        [controller presentViewController:nav animated:YES completion:nil];
    } else {
        ABNewPersonViewController * picker = [[ABNewPersonViewController alloc]init];
        ABRecordRef newPerson = ABPersonCreate();
        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        CFErrorRef error = NULL;
        ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phoneNum), kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue, &error);
        CFRelease(multiValue);
        picker.displayedPerson = newPerson;
        CFRelease(newPerson);
        picker.newPersonViewDelegate = self;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:picker];
        [controller presentViewController:nav animated:YES completion:nil];
    }
}
-(void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller{
    self.isAdd = YES;
    self.pickerDelegate.phoneNum = phoneNum;
    self.pickerDelegate.controller = controller;
    
    [self _presentFromController:controller];
}
-(void)accessContactsComplection:(void (^)(BOOL, NSArray<SHPerson *> *))completcion{
    [self _authorizationStatus:^(BOOL authorization) {
        if (authorization) {
            if (IOS9_OR_LATER) {
                [self _asynAccessContactStoreWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    if (completcion) {
                        completcion(YES,datas);
                    }
                }];
            } else {
                [self _asynAccessContactStoreWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    if (completcion) {
                        completcion(YES,datas);
                    }
                }];
            }
        } else {
            if (completcion) {
                completcion(NO,nil);
            }
        }
    }];
}
-(void)accessSectionContactsComplection:(void (^)(BOOL, NSArray<SHSectionPerson *> *, NSArray<NSString *> *))completcion{
    [self _authorizationStatus:^(BOOL authorization) {
        if (authorization) {
            if (IOS9_OR_LATER) {
                [self _asynAccessContactStoreWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    if (completcion) {
                        completcion(YES, datas, keys);
                    }
                }];
            } else {
                [self _asynAccessContactStoreWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    if (completcion)  {
                        completcion(YES, datas, keys);
                    }
                }];
            }
        } else {
             if (completcion) {
                 completcion(NO, nil, nil);
             }
        }
    }];
}
#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    NSString *name = CFBridgingRelease(ABRecordCopyCompositeName(person));
    
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    NSString *phone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multi, index));
    CFRelease(multi);
    if (self.handler) {
        self.handler(name, phone);
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ABNewPersonViewControllerDelegate
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNContact *contact = contactProperty.contact;
    NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    CNPhoneNumber *phoneValue= contactProperty.value;
    NSString *phoneNumber = phoneValue.stringValue;
    
    if (self.handler)
    {
        self.handler(name, phoneNumber);
    }
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Private
- (void)_asynAccessContactStoreWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *datas = [NSMutableArray array];
        CNContactStore *contactStore = [CNContactStore new];
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.keys];
        
        [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            SHPerson *person = [[SHPerson alloc] initWithCnContact:contact];
            
            [datas addObject:person];
            
        }];
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_sortNameWithDatas:(NSArray *)datas completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (SHPerson *person in datas)
    {
        NSString *firstLetter = [self _firstCharacterWithString:person.fullName];
        
        if (dict[firstLetter])
        {
            [dict[firstLetter] addObject:person];
        }
        else
        {
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:person, nil];
            [dict setValue:arr forKey:firstLetter];
        }
    }
    
    NSMutableArray *keys = [[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    if ([keys.firstObject isEqualToString:@"#"])
    {
        [keys addObject:keys.firstObject];
        [keys removeObjectAtIndex:0];
    }
    
    NSMutableArray *persons = [NSMutableArray array];
    
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SHSectionPerson *person = [SHSectionPerson new];
        person.key = key;
        person.persons = dict[key];
        
        [persons addObject:person];
    }];
    
    if (completcion)
    {
        completcion(persons, keys);
    }
}

- (NSString *)_firstCharacterWithString:(NSString *)string
{
    if (string.length == 0)
    {
        return @"#";
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    
    NSMutableString *pinyinString = [[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] mutableCopy];
    NSString *str = [string substringToIndex:1];
    
    // 多音字处理http://blog.csdn.net/qq_29307685/article/details/51532147
    if ([str compare:@"长"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([str compare:@"沈"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([str compare:@"厦"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([str compare:@"地"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"di"];
    }
    if ([str compare:@"重"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    
    NSString *upperStr = [[pinyinString substringToIndex:1] uppercaseString];
    
    NSString *regex = @"^[A-Z]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    NSString *firstCharacter = [predicate evaluateWithObject:upperStr] ? upperStr : @"#";
    
    return firstCharacter;
}

- (void)_authorizationAddressBook:(void (^) (BOOL succeed))completion
{
    if (IOS9_OR_LATER)
    {
        CNContactStore *store = [CNContactStore new];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (completion)
            {
                completion(granted);
            }
        }];
    }
    else
    {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            CFRelease(addressBook);
            if (completion)
            {
                completion(granted);
            }
        });
    }
}

- (void)_authorizationStatus:(void (^) (BOOL authorization))completion
{
    __block BOOL authorization;
    
    if (IOS9_OR_LATER)
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                authorization = succeed;
            }];
        }
        else if (status == CNAuthorizationStatusAuthorized)
        {
            authorization = YES;
        }
        else
        {
            authorization = NO;
        }
    }
    else
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                authorization = succeed;
            }];
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            authorization = YES;
        }
        else
        {
            authorization = NO;
        }
    }
    
    if (completion)
    {
        completion(authorization);
    }
}

- (void)_presentFromController:(UIViewController *)controller
{
    if (IOS9_OR_LATER)
    {
        CNContactPickerViewController *pc = [[CNContactPickerViewController alloc] init];
        
        if (self.isAdd)
        {
            pc.delegate = self.pickerDelegate;
        }
        else
        {
            pc.delegate = self;
        }
        
        pc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [controller presentViewController:pc animated:YES completion:nil];
    }
    else
    {
        ABPeoplePickerNavigationController *pvc = [[ABPeoplePickerNavigationController alloc] init];
        pvc.displayedProperties = @[@(kABPersonPhoneProperty)];
        
        if (self.isAdd)
        {
            pvc.peoplePickerDelegate = self.pickerDelegate;
        }
        else
        {
            pvc.peoplePickerDelegate = self;
        }
        
        [self _authorizationStatus:^(BOOL authorization) {
            
            if (authorization)
            {
                [controller presentViewController:pvc animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的通讯录暂未允许访问，请去设置->隐私里面授权!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
        }];
    }
}
- (void)_contactStoreDidChange
{
    [[SHContactManager sharedInstance] accessContactsComplection:^(BOOL succeed, NSArray *contacts) {
        if ([SHContactManager sharedInstance].contactsChangehanlder)
        {
            [SHContactManager sharedInstance].contactsChangehanlder(succeed, contacts);
        }
    }];
    
    [[SHContactManager sharedInstance] accessSectionContactsComplection:^(BOOL succeed, NSArray<SHSectionPerson *> *contacts, NSArray<NSString *> *keys) {
        if ([SHContactManager sharedInstance].sectionContactsHanlder)
        {
            [SHContactManager sharedInstance].sectionContactsHanlder(succeed, contacts, keys);
        }
    }];
}

- (void)dealloc
{
    if (IOS9_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
    }
    else
    {
        ABAddressBookUnregisterExternalChangeCallback(self.addressBook, _addressBookChange, nil);
        CFRelease(self.addressBook);
    }
}
@end
