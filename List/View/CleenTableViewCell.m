//
//  CleenTableViewCell.m
//  CleenProjectDemo
//
//  Created by saifing on 2018/2/26.
//  Copyright © 2018年 BKZ. All rights reserved.
//

#import "CleenTableViewCell.h"
#import "XWScanImage.h"

@implementation CleenTableViewCell{
    
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIImageView *leftImageView;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.sd_layout.
        leftSpaceToView(self, 0).
        rightSpaceToView(self, 0).
        topSpaceToView(self, 0).
        bottomSpaceToView(self, 0);

        titleLabel = [UILabel new];
        titleLabel.text = @"Finally, each row of the table should look roughly like the following image. It does not need to be exact, but should have a title at the top in blue, the description underneath it in black";
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blueColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        titleLabel.sd_layout.
        topSpaceToView(self.contentView, 10).
        leftSpaceToView(self.contentView, 10).
        rightSpaceToView(self.contentView, 35).
        autoHeightRatio(0);
        
        leftImageView = [UIImageView new];
        leftImageView.layer.cornerRadius = 2;
        leftImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:leftImageView];
        leftImageView.sd_layout.
        topSpaceToView(titleLabel, 10).
        rightSpaceToView(self.contentView, 35).
        heightIs(80).
        widthIs(80);
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
        [leftImageView addGestureRecognizer:tapGestureRecognizer1];
        [leftImageView setUserInteractionEnabled:YES];

        contentLabel = [UILabel new];
        contentLabel.text = @"Use Git to manage the source code. Clear Git history is required.  Your completed project should be uploaded to your github account, and we will simply pull from your submission. Don’t send us a zip file";
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:contentLabel];
        contentLabel.sd_layout.
        topSpaceToView(titleLabel, 10).
        leftSpaceToView(self.contentView, 10).
        rightSpaceToView(leftImageView, 10).
        autoHeightRatio(0);
    }
    
    return self;
}

#pragma mark - 浏览大图点击事件
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

- (void)setRowModel:(RowModel *)rowModel{
    
    titleLabel.text = rowModel.title;
    contentLabel.text = rowModel.myDescription;
    
    UIView *tempView = nil;
    
    if (!rowModel.title) {
        
        contentLabel.sd_layout.
        topSpaceToView(self.contentView, 10).
        leftSpaceToView(self.contentView, 10).
        rightSpaceToView(leftImageView, 10);
    }else
        tempView = titleLabel;
    
    if (rowModel.myDescription)
        tempView = contentLabel;
        
        
    if (rowModel.imageHref) {
        
        leftImageView.hidden = NO;
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:rowModel.imageHref] placeholderImage:[UIImage imageNamed:@"placeHolder@2x"]];
        
        
        if (rowModel.myDescription){
            
            leftImageView.hidden = NO;
            
            contentLabel.sd_layout.
            topSpaceToView(titleLabel, 10).
            leftSpaceToView(self.contentView, 10).
            rightSpaceToView(leftImageView, 10);
            
            if ([self contentHeight:rowModel.myDescription] < 80) {
                
                tempView = leftImageView;
            }
        }else
            tempView = leftImageView;

        
    }else{
        
        leftImageView.hidden = YES;
        
        contentLabel.sd_layout.
        topSpaceToView(titleLabel, 10).
        leftSpaceToView(self.contentView, 10).
        rightSpaceToView(self.contentView, 35);
    }
    
    if (tempView) {
        [self setupAutoHeightWithBottomView:tempView bottomMargin:17];
    }
}

//计算描述正文的文字高度,比较是否高于图片高度.如果大于则cell的高度以Contentlabel为最后参考
- (CGFloat)contentHeight:(NSString*)contentStr{
    
    CGFloat textHeightFloat = 0;
    
    textHeightFloat = [contentStr boundingRectWithSize:CGSizeMake(KmainW -45, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    return textHeightFloat;
}

@end
