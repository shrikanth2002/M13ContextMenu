//
//  TableViewController.m
//  M13ContextMenu
//
//  Created by Brandon McQuilkin on 7/4/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "TableViewController.h"
#import "M13ContextMenu.h"
#import "M13ContextMenuItemIOS7.h"

@interface TableViewController () <M13ContextMenuDelegate>

@end

@implementation TableViewController
{
    M13ContextMenu *menu;
    UILongPressGestureRecognizer *longPress;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Fix tab bar
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"TableIconSelected"];
    
    //Create the items
    M13ContextMenuItemIOS7 *bookmarkItem = [[M13ContextMenuItemIOS7 alloc] initWithUnselectedIcon:[UIImage imageNamed:@"BookmarkIcon"] selectedIcon:[UIImage imageNamed:@"BookmarkIconSelected"]];
    M13ContextMenuItemIOS7 *uploadItem = [[M13ContextMenuItemIOS7 alloc] initWithUnselectedIcon:[UIImage imageNamed:@"UploadIcon"] selectedIcon:[UIImage imageNamed:@"UploadIconSelected"]];
    M13ContextMenuItemIOS7 *trashIcon = [[M13ContextMenuItemIOS7 alloc] initWithUnselectedIcon:[UIImage imageNamed:@"TrashIcon"] selectedIcon:[UIImage imageNamed:@"TrashIconSelected"]];
    //Create the menu
    menu = [[M13ContextMenu alloc] initWithMenuItems:@[bookmarkItem, uploadItem, trashIcon]];
    menu.delegate = self;
    
    //Create the gesture recognizer
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:menu action:@selector(showMenuUponActivationOfGetsure:)];
    [self.tableView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    
    return cell;
}

- (BOOL)shouldShowContextMenu:(M13ContextMenu *)contextMenu atPoint:(CGPoint)point
{
    //If there is a cell, then the menu should activate.
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    return cell != nil;
}

- (void)contextMenu:(M13ContextMenu *)contextMenu atPoint:(CGPoint)point didSelectItemAtIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSMutableString *string = [@"You selected the " mutableCopy];
    if (index == 0) {
        [string appendString:@"Bookmark Action."];
    } else if (index == 1) {
        [string appendString:@"Upload Action."];
    } else {
        [string appendString:@"Trash Action."];
    }
    
    [string appendFormat:@" For cell at index: %li.", (long)indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Action Selected" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
