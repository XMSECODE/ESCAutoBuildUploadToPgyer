//
//  ESCAppTableViewAppBuildUpdateDescriptionCellView.h
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/4/20.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESCConfigurationModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *ESCAppTableViewAppBuildUpdateDescriptionCellViewId = @"ESCAppTableViewAppBuildUpdateDescriptionCellViewId";

@interface ESCAppTableViewAppBuildUpdateDescriptionCellView : NSTableCellView

@property(nonatomic,strong)ESCConfigurationModel* model;


@end

NS_ASSUME_NONNULL_END
