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

    self.cancelBtn.layer.cornerRadius = 9.0;
    self.cancelBtn.layer.borderWidth = 2.0;
    self.cancelBtn.layer.borderColor = COLOR_DEFAULT_GRAY.CGColor;
    self.cancelBtn.layer.masksToBounds = YES;

    
    [self setupBorder:CLEAR_COLOR cornerRadius:5.0];
}


/*点击视图上的图标按钮*/
- (IBAction)iconBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shareView:didSelectAtIndex:)])
    {
        [self.delegate shareView:self didSelectAtIndex:(int)sender.tag];
    }
    if (sender.tag == 100)
    {
        [self cancelBtnClicked:nil];
    }
}

- (void)cancelBtnClicked:(id)sender
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
