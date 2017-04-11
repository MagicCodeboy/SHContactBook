//
//  SortAddressBookViewController.m
//  Demo
//
//  Created by LeeJay on 2017/3/27.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "SortAddressBookViewController.h"
#import "SHPerson.h"
#import "SHContactManager.h"
#import "ContactTableViewCell.h"

@interface SortAddressBookViewController ()

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation SortAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SHContactManager sharedInstance] accessSectionContactsComplection:^(BOOL succeed, NSArray<SHSectionPerson *> *contacts, NSArray<NSString *> *keys) {
        
        self.dataSource = contacts;
        self.keys = keys;
        [self.tableView reloadData];
        
        for (SHSectionPerson *sectionModel in contacts)
        {
            NSLog(@"---------------------***%@***------------------------------------",sectionModel.key);
            
            for (SHPerson *person in sectionModel.persons)
            {
                NSLog(@"名字列表：fullName = %@, firstName = %@, lastName = %@", person.fullName, person.familyName, person.givenName);
                
                for (SHPhone *model in person.phones)
                {
                    NSLog(@"号码：phone = %@, label = %@", model.phone,model.label);
                }
                
                for (SHEmail *model in person.emails)
                {
                    NSLog(@"电子邮件：email = %@, label = %@", model.email, model.label);
                }
                
                for (SHAddress *model in person.addresses)
                {
                    NSLog(@"地址：address = %@, label = %@", model.city, model.label);
                }
                for (SHMessage *model in person.messages)
                {
                    NSLog(@"即时通讯：service = %@, userName = %@", model.service, model.userName);
                }
                
                NSLog(@"生日：brithdayDate = %@",person.birthday.brithdayData);
                
                for (SHSocialProfile *model in person.socials)
                {
                    NSLog(@"社交：service = %@, username = %@, urlString = %@", model.service, model.userName, model.urlString);
                }
                
                for (SHContactRelation *model in person.relations)
                {
                    NSLog(@"关联人：label = %@, name = %@", model.label, model.name);
                }
                
                for (SHUrlAddress *model in person.urls)
                {
                    NSLog(@"URL：label = %@, urlString = %@", model.label,model.urlString);
                }

            }
        }
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SHSectionPerson *sectionModel = self.dataSource[section];
    return sectionModel.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell"];
    
    SHSectionPerson *sectionModel = self.dataSource[indexPath.section];
    SHPerson *personModel = sectionModel.persons[indexPath.row];
    
    cell.model = personModel;
    
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SHSectionPerson *sectionModel = self.dataSource[section];
    return sectionModel.key;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
