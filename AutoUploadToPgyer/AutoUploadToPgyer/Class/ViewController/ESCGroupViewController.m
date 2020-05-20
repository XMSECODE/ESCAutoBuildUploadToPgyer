//
//  ESCGroupViewController.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/4/22.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCGroupViewController.h"
#import "ESCConfigManager.h"
#import "ESCGroupTableGroupCellView.h"

@interface ESCGroupViewController () <NSTableViewDelegate, NSTableViewDataSource, ESCGroupTableGroupCellViewDelegate>

@property (weak, nonatomic) IBOutlet NSTableView *tableView;

@property(nonatomic,strong)ESCGroupModel* currentGroupModel;

@property(nonatomic,strong)NSArray<ESCGroupModel *>* showArray;

@end

@implementation ESCGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"ESCGroupTableGroupCellView" bundle:nil] forIdentifier:ESCGroupTableGroupCellViewId];
    
    self.currentGroupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    [self reloadData];
}

- (IBAction)didClicSaveButton:(NSButton *)sender {
    [[ESCConfigManager sharedConfigManager] saveUserData];
    [self dismissController:nil];
}

- (IBAction)didClicCancelButton:(NSButton *)sender {
    [self dismissController:nil];
}

- (IBAction)didClicAddGroupButton:(NSButton *)sender {
    //增加一个分组
    ESCGroupModel *groupModel = [[ESCGroupModel alloc] init];
    groupModel.name = @"新分组";
    [self.currentGroupModel addGroupModel:groupModel];
    [[ESCConfigManager sharedConfigManager] saveUserData];
    [self reloadData];
}

- (void)reloadData {
    self.showArray = [[ESCConfigManager sharedConfigManager].groupModel allShowGroupModelArray];
    [self.tableView reloadData];
}

- (IBAction)didClicDeleteGroupButton:(NSButton *)sender {
    //删除分组
    ESCGroupModel *topGroupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    ESCGroupModel *targetGroupModel = [topGroupModel getGroupInWhatGroupWithGroup:self.currentGroupModel];
    NSMutableArray *temArray = [targetGroupModel.groupModelArray mutableCopy];
    [temArray removeObject:self.currentGroupModel];
    targetGroupModel.groupModelArray = [temArray copy];
    [[ESCConfigManager sharedConfigManager] saveUserData];
    [self reloadData];
}

- (IBAction)didClicRenameButton:(NSButton *)sender {
    if ([self.currentGroupModel isEqual:[ESCConfigManager sharedConfigManager].groupModel] == NO) {
        self.currentGroupModel.isEdit = YES;
        [self reloadData];
    }
}

#pragma mark - NSTableViewDelegate, NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.showArray.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row NS_AVAILABLE_MAC(10_7) {
    ESCGroupTableGroupCellView *cell = [tableView makeViewWithIdentifier:ESCGroupTableGroupCellViewId owner:nil];
    cell.groupModel = [self.showArray objectAtIndex:row];
    cell.delegate = self;
    return cell;
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    self.currentGroupModel = [self.showArray objectAtIndex:row];
    return YES;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20;
}

#pragma mark - ESCGroupTableGroupCellViewDelegate
- (void)ESCGroupTableGroupCellViewDidClickShowButton:(ESCGroupTableGroupCellView *)cellView {
    [self reloadData];
}

@end
