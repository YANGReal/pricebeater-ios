//
//  GoodsCell.h
//  PBScanner
//
//  Created by YANGReal on 14-3-5.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCell : UITableViewCell
@property (strong , nonatomic) NSDictionary *data;

+(CGFloat)cellHeightWithData:(NSDictionary *)data;

@end
