//
//  AppDelegate.h
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ContactRepository;
@class ContactViewModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (readonly, strong) NSPersistentContainer *persistentContainer;
- (void)saveContext;

@property (nonatomic, strong) ContactRepository *contactRepository;
@property (nonatomic, strong) ContactViewModel *contactViewModel;

- (ContactViewModel *)getContactViewModel;
@end

