//
//  ViewController.m
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

#import "ViewController.h"
#import "My_Contacts-Swift.h"
#import "AppDelegate.h"
@import SwiftUI;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>

@property (strong, nonatomic) ContactViewModel *viewModel;
@property (nonatomic, strong) NSArray<ContactsDataEntity *> *contacts;
@property (nonatomic, strong) NSArray<ContactsDataEntity *> *filteredContacts;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.viewModel = [ContactViewModel shared];
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    self.viewModel = [appDelegate getContactViewModel];
    
    [self setupNavigationItems];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];

    self.contacts = [self.viewModel getContacts];
    self.filteredContacts = self.contacts;
    
    // Configurar SearchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = @"Buscar contacto";
    
    // Agregar barra de búsqueda a la barra de navegación
    self.navigationItem.searchController = self.searchController;
    self.definesPresentationContext = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleContactsUpdate) name:@"contactsDidUpdate"
                                               object:nil];
    
}

-(void)handleContactsUpdate {
    self.contacts = [self.viewModel getContacts];
    self.filteredContacts = self.contacts;
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
    return self.filteredContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    NSArray *contacts = self.filteredContacts;
    ContactsDataEntity *contact = contacts[indexPath.row];
    
    [self configureCell:cell withContact:contact];
    
    return cell;
}

// Custom Contact cell
- (void)configureCell:(UITableViewCell *)cell withContact:(ContactsDataEntity *)contact {
    UIImageView *customImageView = [cell.contentView viewWithTag:999];
    if (!customImageView) {
        customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        customImageView.tag = 999;
        customImageView.contentMode = UIViewContentModeScaleAspectFill;
        customImageView.clipsToBounds = YES;
        customImageView.layer.cornerRadius = 30;
        [cell.contentView addSubview:customImageView];
    }

    cell.imageView.hidden = YES;

    UILabel *nameLabel = [cell.contentView viewWithTag:1000];
    if (!nameLabel) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, cell.contentView.frame.size.width - 105, 60)];
        nameLabel.tag = 1000;
        nameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        nameLabel.numberOfLines = 1;
        [cell.contentView addSubview:nameLabel];
    } else {
        nameLabel.frame = CGRectMake(90, 10, cell.contentView.frame.size.width - 105, 60);
    }
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    nameLabel.text = fullName;
    
    UIImage *placeholder = [UIImage systemImageNamed:@"person.crop.circle.fill"];

    [KFHelper setImage:customImageView urlString:contact.imageUrl placeholder:placeholder];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// swipe to delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ContactsDataEntity *contactToDelete = self.filteredContacts[indexPath.row];
        
        [self.viewModel deleteContact:contactToDelete];
        self.contacts = [self.viewModel getContacts];
        
        [self updateFilteredContacts];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

// Show contact detail view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsDataEntity *contact = self.filteredContacts[indexPath.row];

    ContactDetailViewWrapper *wrapper = [[ContactDetailViewWrapper alloc] initWithContact:contact];
    UIViewController *detailVC = [wrapper makeViewController];
    detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:detailVC animated:YES completion:nil];
}

// Update search
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self updateFilteredContacts];
    
    [self.tableView reloadData];
}

- (void)updateFilteredContacts {
    NSString *searchText = self.searchController.searchBar.text;
    
    if (searchText == nil || searchText.length == 0) {
        self.filteredContacts = self.contacts;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(ContactsDataEntity *evaluatedObject, NSDictionary *bindings) {
            NSString *searchLower = [searchText lowercaseString];
            
            BOOL matchesFirstName = [[evaluatedObject.firstName lowercaseString] containsString:searchLower];
            BOOL matchesLastName = [[evaluatedObject.lastName lowercaseString] containsString:searchLower];
            BOOL matchesPhone = [[evaluatedObject.phoneNumber lowercaseString] containsString:searchLower];
            
            return matchesFirstName || matchesLastName || matchesPhone;
        }];
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    }
}

@end
