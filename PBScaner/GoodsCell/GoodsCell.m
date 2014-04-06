//
//  GoodsCell.m
//  PBScanner
//
//  Created by YANGReal on 14-3-5.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "GoodsCell.h"

@interface GoodsCell ()
@property (weak ,nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak , nonatomic) IBOutlet AttributedLabel *descLabel;
@property (weak , nonatomic) IBOutlet UILabel *priceLabel;
@property (weak , nonatomic) IBOutlet UILabel *fromLabel;
@property (weak , nonatomic) IBOutlet UIView *line;
@end

@implementation GoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
        //[self _initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.contentView addSubview:self.line];
    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImgView.clipsToBounds = YES;
    self.descLabel.numberOfLines = 0;
    //self.descLabel.backgroundColor = [UIColor redColor];
    self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.line.width = [AppUtil getDeviceWidth]+30;
    self.line.backgroundColor =[UIColor lightGrayColor];
    self.line.height = 1.0;
}

- (void)_initViews
{
    
//    self.goodsImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.goodsImgView.clipsToBounds = YES;
//    [self.contentView addSubview:self.goodsImgView];
//    
//    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.descLabel.font = [UIFont fontWithName:@"Avenir Next" size:13];
//    self.descLabel.textColor = COLOR_DEFAULT_YELLOW;
//    self.descLabel.numberOfLines = 0;
//    self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.contentView addSubview:self.descLabel];
//    
//    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.priceLabel.font = [UIFont fontWithName:@"Avenir Next" size:13];
//    self.priceLabel.textColor = COLOR_DEFAULT_YELLOW;
//    self.priceLabel.numberOfLines = 0;
//    self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.contentView addSubview:self.priceLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString *imgURL = [self.data stringAttribute:@"img"];
    NSURL *url = [NSURL URLWithString:imgURL];
    [self.goodsImgView setImageWithURL:url placeholderImage:[UIImage imageFromMainBundleFile:@"logo.png"]];
    //self.descLabel.text = [self.data stringAttribute:@"skuname"];
    NSString *price = [self.data stringAttribute:@"price"];
    self.priceLabel.text = [NSString stringWithFormat:@"$ %@",price];
    NSString *skuName = [[self.data stringAttribute:@"skuname"] stringByRemovingPercentEncoding];
    [self highlightedTagsWithSkuName:skuName];
}




- (void)highlightedTagsWithSkuName:(NSString *)skuName
{
    NSArray *targets = [skuName componentsMatchedByRegex:@">.[^<>]+<"];//找到到<span>...</span>之间的内容
    NSArray *spans = [skuName componentsMatchedByRegex:@"<[^>]*>"];//找到<span标签>
    for (NSString *span in spans)
    {
        skuName = [skuName stringByReplacingOccurrencesOfString:span withString:@""];//将<span>去掉
    }
    CGFloat fontSize = 18;
    if ([AppUtil isiPhone])
    {
        fontSize = 13;
    }
    
    self.descLabel.text = skuName;
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:fontSize];
    [self.descLabel setFont:font fromIndex:0 length:skuName.length];
    for (NSString *target in targets)
    {
        NSString *str1 = [target stringByReplacingOccurrencesOfString:@">" withString:@""];//去掉右尖括号
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"<" withString:@""];//去掉做左括号
        NSRange range = [skuName rangeOfString:str2];
        [self.descLabel setColor:COLOR_DEFAULT_YELLOW fromIndex:range.location length:range.length];
    }

    if (self.height>84)
    {
        CGSize labelSize = [AppUtil getLabelSizeWithText:skuName font:fontSize width:self.descLabel.width];
        self.descLabel.height = labelSize.height;
        self.descLabel.center = CGPointMake(self.descLabel.center.x, self.height/2.0);
        self.fromLabel.y = self.descLabel.y+self.descLabel.height + 10;
        self.priceLabel.y = self.fromLabel.y;
    }
    else
    {
        CGSize labelSize = [AppUtil getLabelSizeWithText:skuName font:fontSize width:self.descLabel.width];
        self.descLabel.height = labelSize.height;
        self.descLabel.center = CGPointMake(self.descLabel.center.x, self.height/2.0);

    }
   
    self.line.y = self.height-1;
}


+ (CGFloat)cellHeightWithData:(NSDictionary *)data
{
    NSString *skuName = [data stringAttribute:@"skuname"];
    NSArray *spans = [skuName componentsMatchedByRegex:@"<[^>]*>"];//找到<span标签>
    for (NSString *span in spans)
    {
        skuName = [skuName stringByReplacingOccurrencesOfString:span withString:@""];//将<span>去掉
    }
    CGSize size;
    if ([AppUtil isiPhone])
    {
        size = [AppUtil getLabelSizeWithText:skuName font:13 width:209];
        
        CGFloat height = size.height;
        height += 45;
        
        if (height<83)
        {
            return 83;
        }
        return height;
    }
    else
    {
        // size = [AppUtil getLabelSizeWithText:skuName font:18 width:575];
        return 82;
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
