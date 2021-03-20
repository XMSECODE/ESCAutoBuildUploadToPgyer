//
//  ESCAppBundleIdAndProfileConfigViewController.m
//  iOSAutoBuildAndUpload
//
//  Created by xiangmingsheng on 2021/3/20.
//  Copyright © 2021 XMSECODE. All rights reserved.
//

#import "ESCAppBundleIdAndProfileConfigViewController.h"
#import "ESCTextCellView.h"

@interface ESCAppBundleIdAndProfileConfigViewController ()<NSTableViewDataSource,NSTableViewDelegate>

@property (weak, nonatomic) IBOutlet NSTableView *tableView;

@property (nonatomic, strong)NSArray<ESCBundleIdModel *>* modelArray;

@property (nonatomic, strong)ESCBundleIdModel* currentModel;

@end

@implementation ESCAppBundleIdAndProfileConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (self.configurationModel.bundleIdModelArray == nil) {
        ESCBundleIdModel *model2 = [[ESCBundleIdModel alloc] init];
        model2.bundleId = self.configurationModel.bundleID;
        model2.profileName = self.configurationModel.provisioningProfileName;
        self.modelArray = [NSArray arrayWithObject:model2];
    }else {
        NSMutableArray *temArray = [NSMutableArray array];
        for (int i = 0; i < self.configurationModel.bundleIdModelArray.count; i++) {
            ESCBundleIdModel *model = self.configurationModel.bundleIdModelArray[i];
            ESCBundleIdModel *model2 = [[ESCBundleIdModel alloc] init];
            model2.bundleId = model.bundleId;
            model2.profileName = model.profileName;
            [temArray addObject:model2];
        }
        self.modelArray = [temArray copy];
    }
}

- (IBAction)didClicCommitButton:(NSButton *)sender {
    self.configurationModel.bundleIdModelArray = self.modelArray;
    [self dismissController:nil];
}

- (IBAction)didClicAddButton:(NSButton *)sender {
    ESCBundleIdModel *newModel = [[ESCBundleIdModel alloc] init];
    NSMutableArray *temArray = [self.modelArray mutableCopy];
    [temArray addObject:newModel];
    self.modelArray = temArray;
    [self.tableView reloadData];
}

- (IBAction)didClicDeleteButton:(NSButton *)sender {
    NSMutableArray *temArray = [self.modelArray mutableCopy];
    [temArray removeObject:self.currentModel];
    self.modelArray = temArray;
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDelegate, NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.modelArray.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row NS_AVAILABLE_MAC(10_7) {
    ESCTextCellView *cell = [tableView makeViewWithIdentifier:@"ESCTextCellViewId" owner:nil];
    ESCBundleIdModel *model = [self.modelArray objectAtIndex:row];
    cell.model = model;
    if ([tableColumn.identifier isEqualToString:@"bundleid"]) {
        cell.type = 0;
    }else {
        cell.type = 1;
    }
    return cell;
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    self.currentModel = [self.modelArray objectAtIndex:row];
    return YES;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20;
}

@end
