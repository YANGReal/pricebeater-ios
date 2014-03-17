//
//  ShareView.m
//  PBScanner
//
//  Created by YANGReal on 14-3-8.
//  Copyright (c) 2014年 Huo Ju. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()
@property (weak , nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)iconBtnClicked:(UIButton *)sender;
- (IBAction)cancelBtnClicked:(id)sender;
@end


@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.cancelBtn setupBorder:COLOR_DEFAULT_GRAY cornerRadius:5.0];
    [self setupBorder:CLEAR_COLOR cornerRadius:5.0];
}

- (IBAction)iconBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shareView:didSelectAtIndex:)])
    {
        [self.delegate shareView:self didSelectAtIndex:sender.tag];
    }
}

- (IBAction)cancelBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.y = self.superview.height+10;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
