//
//  SHPerson.m
//  SHContactManager
//
//  Created by lalala on 2017/3/31.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHPerson.h"

@implementation SHPerson
-(instancetype)initWithCnContact:(CNContact *)contact{
    if (self == [super init]) {
        self.contactType = contact.contactType == CNContactTypePerson ? SHContactTypePerson : SHContactTypeOrigination;
        self.fullName = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        self.familyName = contact.familyName;
        self.givenName = contact.givenName;
        self.nameSuffix = contact.nameSuffix;
        self.namePrefix = contact.namePrefix;
        self.nickName = contact.nickname;
        self.middleName = contact.middleName;
        
        if ([contact isKeyAvailable:CNContactOrganizationNameKey]) {
            self.organizationName = contact.organizationName;
        }
        if ([contact isKeyAvailable:CNContactDepartmentNameKey]) {
            self.departmentName = contact.departmentName;
        }
        if ([contact isKeyAvailable:CNContactJobTitleKey]) {
            self.jobTitle = contact.jobTitle;
        }
        if ([contact isKeyAvailable:CNContactNoteKey]) {
            self.note = contact.note;
        }
        if ([contact isKeyAvailable:CNContactPhoneticFamilyNameKey]) {
            self.phoneticFamilyName = contact.phoneticFamilyName;
        }
        if ([contact isKeyAvailable:CNContactPhoneticGivenNameKey]) {
            self.phoneticGivenName = contact.phoneticGivenName;
        }
        if ([contact isKeyAvailable:CNContactPhoneticMiddleNameKey]) {
            self.phoneticMiddleName = contact.phoneticMiddleName;
        }
        if ([contact isKeyAvailable:CNContactImageDataKey]) {
            self.imageData = contact.imageData;
            self.image = [UIImage imageWithData:contact.imageData];
        }
        if ([contact isKeyAvailable:CNContactThumbnailImageDataKey]) {
            self.thumbnailImageData = contact.thumbnailImageData;
            self.thumbnailImage = [UIImage imageWithData:contact.thumbnailImageData];
        }
        if ([contact isKeyAvailable:CNContactPhoneNumbersKey]) {
             //电话号码
            NSMutableArray * phones = [NSMutableArray array];
            for (CNLabeledValue * labeledValue in contact.phoneNumbers) {
                SHPhone * phoneModel = [[SHPhone alloc]initWithLabeledValue:labeledValue];
                [phones addObject:phoneModel];
            }
            self.phones = phones;
        }
        if ([contact isKeyAvailable:CNContactEmailAddressesKey]) {
             //电子邮件
            NSMutableArray * emails = [NSMutableArray array];
            for (CNLabeledValue * labeledValue in contact.emailAddresses) {
                SHEmail * emailModel = [[SHEmail alloc]initWithLabeledValue:labeledValue];
                [emails addObject:emailModel];
            }
            self.emails = emails;
        }
        if ([contact isKeyAvailable:CNContactPostalAddressesKey]) {
             //地址
            NSMutableArray * addresses = [NSMutableArray array];
            for (CNLabeledValue * labeledValue in contact.postalAddresses) {
                SHAddress * addressModel = [[SHAddress alloc]initWithLabeledValue:labeledValue];
                [addresses addObject:addressModel];
            }
            self.addresses = addresses;
        }
        //生日
        SHBirthday * birthday = [[SHBirthday alloc]initWithCnContact:contact];
        self.birthday = birthday;
        
        if ([contact isKeyAvailable:CNContactInstantMessageAddressesKey]) {
             //即时通讯
            NSMutableArray * messages = [NSMutableArray array];
            for (CNLabeledValue * labeledVallue in contact.instantMessageAddresses) {
                SHMessage * messageModel = [[SHMessage alloc]initWithLabeledValue:labeledVallue];
                [messages addObject:messageModel];
            }
            self.messages = messages;
        }
        if ([contact isKeyAvailable:CNContactSocialProfilesKey]) {
             //社交
            NSMutableArray * socials = [NSMutableArray array];
            for (CNLabeledValue * labeledValue in contact.socialProfiles) {
                SHSocialProfile * socialModel = [[SHSocialProfile alloc]initWithLabeledValue:labeledValue];
                [socials addObject:socialModel];
            }
            self.socials = socials;
        }
        if ([contact isKeyAvailable:CNContactRelationsKey]) {
             //关联人
            NSMutableArray * relations = [NSMutableArray array];
            for (CNLabeledValue * labeledValue in contact.contactRelations) {
                SHContactRelation * relationModel = [[SHContactRelation alloc]initWithLabeledValue:labeledValue];
                [relations addObject:relationModel];
            }
            self.relations = relations;
        }
        if ([contact isKeyAvailable:CNContactUrlAddressesKey]) {
             //URL
            NSMutableArray * urlAddresses = [NSMutableArray array];
            for (CNLabeledValue * lableledValue in contact.urlAddresses) {
                SHUrlAddress * urlAddressesModel = [[SHUrlAddress alloc]initWithLabeledValue:lableledValue];
                [urlAddresses addObject:urlAddressesModel];
            }
            self.urls = urlAddresses;
        }
    }
    return self;
}
-(instancetype)initWithRecord:(ABRecordRef)record{
    if (self == [super init]) {
        CFNumberRef type = ABRecordCopyValue(record, kABPersonKindProperty);
        self.contactType = type == kABPersonKindPerson ? SHContactTypePerson : SHContactTypeOrigination;
        CFRelease(type);
        NSString * fullName = CFBridgingRelease(ABRecordCopyCompositeName(record));
        NSString * firstName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        NSString * lastName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNameProperty));
        NSString * namePrefix = CFBridgingRelease(ABRecordCopyValue(record, kABPersonPrefixProperty));
        NSString * nameSuffix = CFBridgingRelease(ABRecordCopyValue(record, kABPersonSuffixProperty));
        NSString * middleName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonMiddleNameProperty));
        NSString * origaizationName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonOrganizationProperty));
        NSString * departmentName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonDepartmentProperty));
        NSString * jobTitle = CFBridgingRelease(ABRecordCopyValue(record, kABPersonJobTitleProperty));
        NSString * note = CFBridgingRelease(ABRecordCopyValue(record, kABPersonNoteProperty));
        NSString * phoneticFamilyName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty));
        NSString * phoneticGivenName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty));
        NSString * phoneticMiddleName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty));
        NSData * imageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatOriginalSize));
        NSData * thumbnailImageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail));
        
        self.fullName = fullName;
        self.familyName = firstName;
        self.givenName = lastName;
        self.namePrefix = namePrefix;
        self.nameSuffix = nameSuffix;
        self.middleName = middleName;
        self.organizationName = origaizationName;
        self.departmentName = departmentName;
        self.jobTitle = jobTitle;
        self.note = note;
        self.phoneticFamilyName = phoneticFamilyName;
        self.phoneticGivenName = phoneticGivenName;
        self.phoneticMiddleName = phoneticMiddleName;
        self.imageData = imageData;
        self.image = [UIImage imageWithData:imageData];
        self.thumbnailImageData = thumbnailImageData;
        self.thumbnailImage = [UIImage imageWithData:thumbnailImageData];
        
        //电话
        ABMultiValueRef multiPhones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(multiPhones);
        NSMutableArray * phones = [NSMutableArray array];
        for (CFIndex i = 0; i < phoneCount; i++) {
            SHPhone * phoneModel = [[SHPhone alloc]initWithMultiValue:multiPhones index:i];
            [phones addObject:phoneModel];
        }
        CFRelease(multiPhones);
        self.phones = phones;
        
        //电子邮件
        ABMultiValueRef multiEmails = ABRecordCopyValue(record, kABPersonEmailProperty);
        CFIndex emailCount = ABMultiValueGetCount(multiEmails);
        NSMutableArray * emails = [NSMutableArray array];
        for (CFIndex i = 0; i < emailCount; i++) {
            SHEmail * emailModel = [[SHEmail alloc]initWithMultiValue:multiEmails index:i];
            [emails addObject:emailModel];
        }
        CFRelease(multiEmails);
        self.emails = emails;
        
        //地址
        ABMultiValueRef multiAddress = ABRecordCopyValue(record, kABPersonAddressProperty);
        CFIndex addressCount = ABMultiValueGetCount(multiAddress);
        NSMutableArray * addresses = [NSMutableArray array];
        for (CFIndex i = 0; i < addressCount; i ++) {
            SHAddress * addressModel = [[SHAddress alloc]initWithMultiValue:multiAddress index:i];
            [addresses addObject:addressModel];
        }
        CFRelease(multiAddress);
        self.addresses = addresses;
        
        //生日
        SHBirthday * birthday = [[SHBirthday alloc]initWithRecord:record];
        self.birthday = birthday;
        
        //即时通讯
        ABMultiValueRef multiMessages = ABRecordCopyValue(record, kABPersonInstantMessageProperty);
        CFIndex messagesCount = ABMultiValueGetCount(multiMessages);
        NSMutableArray * messages = [NSMutableArray array];
        for (CFIndex i = 0; i < messagesCount; i++) {
            SHMessage * messageModel = [[SHMessage alloc]initWithMultiValue:multiMessages index:i];
            [messages addObject:messageModel];
        }
        CFRelease(multiMessages);
        self.messages = messages;
        
        //社交
        ABMultiValueRef multiSocials = ABRecordCopyValue(record, kABPersonSocialProfileProperty);
        CFIndex socialsCount = ABMultiValueGetCount(multiSocials);
        NSMutableArray * socials = [NSMutableArray array];
        for (CFIndex i = 0; i < socialsCount; i++) {
            SHSocialProfile * socialsModel = [[SHSocialProfile alloc]initWithMultiValue:multiSocials index:i];
            [socials addObject:socialsModel];
        }
        CFRelease(multiSocials);
        self.socials = socials;
        
        //关联人
        ABMultiValueRef multiRelations = ABRecordCopyValue(record, kABPersonRelatedNamesProperty);
        CFIndex relationCount = ABMultiValueGetCount(multiRelations);
        NSMutableArray * relations = [NSMutableArray array];
        for (CFIndex i = 0; i < relationCount; i++) {
            SHContactRelation * relationModel = [[SHContactRelation alloc]initWithMultiValue:multiRelations index:i];
            [relations addObject:relationModel];
        }
        CFRelease(multiRelations);
        self.relations = relations;
        
        //URL
        ABMultiValueRef multiUrls = ABRecordCopyValue(record, kABPersonURLProperty);
        CFIndex urlCount = ABMultiValueGetCount(multiUrls);
        NSMutableArray * urls = [NSMutableArray array];
        for (CFIndex i = 0 ; i < urlCount; i++) {
            SHUrlAddress * urlModel = [[SHUrlAddress alloc]initWithMultiValue:multiUrls index:i];
            [urls addObject:urlModel];
        }
        CFRelease(multiUrls);
        self.urls = urls;
    }
    return self;
}
@end

@implementation SHPhone

-(instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue{
    if (self == [super init]) {
        CNPhoneNumber * phoneValue = labeledValue.value;
        NSString * phoneNumber = phoneValue.stringValue;
        self.phone = [self _filterSpecialString:phoneNumber];
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
    }
    return self;
}
- (NSString *)_filterSpecialString:(NSString *)string
{
    if (string == nil)
    {
        return @"";
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}
-(instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index{
    if (self == [super init]) {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        self.label = CFBridgingRelease(ABAddressBookCopyLocalizedLabel(label));
        NSString * phoneNumber = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(multiValue, index));
        self.phone = [self _filterSpecialString:phoneNumber];
        CFRelease(label);
    }
    return self;
}

@end

@implementation SHEmail

- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
        self.email = labeledValue.value;
    }
    return self;
}

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        CFRelease(label);
        self.label = CFBridgingRelease(localLabel);
        NSString *emial = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
        self.email = emial;
    }
    return self;
}

@end

@implementation SHAddress

- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNPostalAddress *addressValue = labeledValue.value;
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
        self.street = addressValue.street;
        self.state = addressValue.state;
        self.city = addressValue.city;
        self.postalCode = addressValue.postalCode;
        self.country = addressValue.country;
        self.ISOCountryCode = addressValue.ISOCountryCode;
        
        self.formatterAddress = [CNPostalAddressFormatter stringFromPostalAddress:addressValue style:CNPostalAddressFormatterStyleMailingAddress];
    }
    return self;
}

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        CFRelease(label);
        self.label = CFBridgingRelease(localLabel);
        
        NSDictionary *dict = CFBridgingRelease((ABMultiValueCopyValueAtIndex(multiValue, index)));
        self.country = [dict valueForKey:(__bridge NSString *)kABPersonAddressCountryKey];
        self.city = [dict valueForKey:(__bridge NSString *)kABPersonAddressCityKey];
        self.state = [dict valueForKey:(__bridge NSString *)kABPersonAddressStateKey];
        self.street = [dict valueForKey:(__bridge NSString *)kABPersonAddressStreetKey];
        self.postalCode = [dict valueForKey:(__bridge NSString *)kABPersonAddressZIPKey];
        self.ISOCountryCode = [dict valueForKey:(__bridge NSString *)kABPersonAddressCountryCodeKey];
    }
    return self;
}

@end

@implementation SHBirthday

- (instancetype)initWithCnContact:(CNContact *)contact
{
    self = [super init];
    if (self)
    {
        if ([contact isKeyAvailable:CNContactBirthdayKey])
        {
            self.brithdayData = contact.birthday.date;
        }
        
        if ([contact isKeyAvailable:CNContactNonGregorianBirthdayKey])
        {
            self.calendarIdentifier = contact.nonGregorianBirthday.calendar.calendarIdentifier;
            self.era = contact.nonGregorianBirthday.era;
            self.day = contact.nonGregorianBirthday.day;
            self.month = contact.nonGregorianBirthday.month;
            self.year = contact.nonGregorianBirthday.year;
        }
    }
    return self;
}

- (instancetype)initWithRecord:(ABRecordRef)record
{
    self = [super init];
    if (self)
    {
        self.brithdayData = CFBridgingRelease(ABRecordCopyValue(record, kABPersonBirthdayProperty));
        
        NSDictionary *dict = CFBridgingRelease((ABRecordCopyValue(record, kABPersonAlternateBirthdayProperty)));
        self.calendarIdentifier = [dict valueForKey:@"calendarIdentifier"];
        self.era = [(NSNumber *)[dict valueForKey:@"era"] integerValue];
        self.year = [(NSNumber *)[dict valueForKey:@"year"] integerValue];
        self.month = [(NSNumber *)[dict valueForKey:@"month"] integerValue];
        self.day = [(NSNumber *)[dict valueForKey:@"day"] integerValue];
    }
    return self;
}

@end

@implementation SHMessage

- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNInstantMessageAddress *messageValue = labeledValue.value;
        self.service = messageValue.service;
        self.userName = messageValue.username;
    }
    return self;
}

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        NSDictionary *dict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
        self.service = [dict valueForKey:@"service"];
        self.userName = [dict valueForKey:@"username"];
    }
    return self;
}

@end

@implementation SHSocialProfile

- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNSocialProfile *socialValue = labeledValue.value;
        self.service = socialValue.service;
        self.userName = socialValue.username;
        self.urlString = socialValue.urlString;
    }
    return self;
}

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        NSDictionary *dict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
        self.service = [dict valueForKey:@"service"];
        self.userName = [dict valueForKey:@"username"];
        self.urlString = [dict valueForKey:@"url"];
    }
    return self;
}

@end

@implementation SHUrlAddress

- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
        self.urlString = labeledValue.value;
    }
    return self;
}

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        CFRelease(label);
        self.label = CFBridgingRelease(localLabel);
        self.urlString = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
    }
    return self;
}

@end

@implementation SHContactRelation

- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNContactRelation *relationValue = labeledValue.value;
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];;
        self.name = relationValue.name;
    }
    return self;
}

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        CFRelease(label);
        self.label = CFBridgingRelease(localLabel);
        self.name = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
    }
    return self;
}

@end

@implementation SHSectionPerson


@end

