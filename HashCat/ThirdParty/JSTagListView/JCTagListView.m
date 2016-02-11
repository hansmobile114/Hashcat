//
//  JCTagListView.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagListView.h"
#import "JCTagCell.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "Global.h"

@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation JCTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
    [self.collectionView flashScrollIndicators];
}

- (void)setup
{
    _seletedTags = [NSMutableArray array];
    
    self.tags = [NSMutableArray array];
    
    JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    NSString* strTitle = [NSString stringWithFormat:@"#%@", ((GameCategoryEntity *)self.tags[indexPath.item]).m_strName];
    CGRect frame = [strTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:MAIN_FONT_NAME size:20.f]} context:nil];
    
    return CGSizeMake(frame.size.width + 24.0f, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSString* strTitle = [NSString stringWithFormat:@"#%@", ((GameCategoryEntity *)self.tags[indexPath.item]).m_strName];

    cell.title = strTitle;
    
    if (![_seletedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = [UIColor clearColor];
        [cell setTextColor:MAIN_COLOR];
        
        NSString* strTitle = [NSString stringWithFormat:@"#%@", ((GameCategoryEntity *)self.tags[indexPath.item]).m_strName];
        cell.title = strTitle;
        
    }
    else {
        cell.backgroundColor = MAIN_COLOR;
        [cell setTextColor:[UIColor whiteColor]];
        
        NSString* strTitle = [NSString stringWithFormat:@"#%@ x ", ((GameCategoryEntity *)self.tags[indexPath.item]).m_strName];
        cell.title = strTitle;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canRemoveTags) {
        JCTagCell *cell = (JCTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ([_seletedTags containsObject:self.tags[indexPath.item]]) {
            cell.backgroundColor = [UIColor clearColor];
            [cell setTextColor:MAIN_COLOR];
            
            NSString* strTitle = [NSString stringWithFormat:@"#%@", ((GameCategoryEntity *)self.tags[indexPath.item]).m_strName];
            cell.title = strTitle;
            
            [_seletedTags removeObject:self.tags[indexPath.item]];
        }
        else {
            if (_seletedTags.count >= 2)
            {
                [self.delegate limitSelectCell:self];
                
                return;
            }
            
            cell.backgroundColor = MAIN_COLOR;
            [cell setTextColor:[UIColor whiteColor]];
            
            NSString* strTitle = [NSString stringWithFormat:@"#%@ x ", ((GameCategoryEntity *)self.tags[indexPath.item]).m_strName];
            cell.title = strTitle;
            
            [_seletedTags addObject:self.tags[indexPath.item]];
        }
    }
}

@end
