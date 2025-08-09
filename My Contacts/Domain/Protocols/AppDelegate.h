//
//  AppDelegate.h
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (readonly, strong) NSPersistentContainer *persistentContainer;
- (void)saveContext;
@end

