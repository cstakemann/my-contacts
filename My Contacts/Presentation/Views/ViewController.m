//
//  ViewController.m
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

#import "ViewController.h"
//#import "Contact.h"
#import "My_Contacts-Swift.h"
@import SwiftUI;

@interface ViewController ()
//@property (strong, nonatomic) NSMutableArray<Contact *> *contacts;
@property (strong, nonatomic) ContactViewModel *viewModel;
@end

@implementation ViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [ContactViewModel shared];
    
    [self setupNavigationItems];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
    
    [self loadContacts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleContactsUpdate) name:@"contactsDidUpdate"
                                               object:nil];
    
}

- (void)loadContacts {
    // Aquí cargas de Core Data vía ViewModel
    // Pero como ViewModel está en Swift y usa @Published, deberías usar KVO o notificaciones
    // Para simplificar, recarga tabla cuando view aparecer
    
    [self.tableView reloadData];
}

-(void)handleContactsUpdate {
    NSArray *contacts = [self.viewModel getContacts];
    NSLog(@"Contacts count: %lu", (unsigned long)contacts.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigationItems {
    self.navigationItem.title = @"My Contacts";
    
    UIBarButtonItem *addButton = [
        [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
        target:self
        action:@selector(addContact)
    ];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)addContact {
    AddContactViewWrapper *wrapper = [[AddContactViewWrapper alloc] init];
    UIViewController *addContactView = [wrapper makeViewController];
    [self presentViewController:addContactView animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.viewModel getContacts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    NSArray *contacts = [self.viewModel getContacts];
    ContactsDataEntity *contact = contacts[indexPath.row];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    
    cell.textLabel.text = fullName;
    return cell;
}

// swipe to delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteContact:indexPath.row];

        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}


@end
