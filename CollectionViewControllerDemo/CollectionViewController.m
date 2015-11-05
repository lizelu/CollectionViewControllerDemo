//
//  CollectionViewController.m
//  CollectionViewControllerDemo
//
//  Created by Mr.LuDashi on 15/9/6.
//  Copyright (c) 2015年 ZeluLi. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface CollectionViewController ()
@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) CGFloat padding;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"CollectionViewCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置Cell多选
    self.collectionView.allowsMultipleSelection = YES;
    
    _padding = 10;
    
    _cellWidth = (SCREEN_WIDTH - 4 * _padding) / 3;
    
    //注册Section的Footer和Header
    [self registerHeaderAndFooterView];
}


/**
 * 注册Header和FooterView
 * 便于在UICollectionViewDataSource中使用
 */
- (void) registerHeaderAndFooterView {
    //注册headerView
    //获取含有UICollectionReusableView的Nib文件。
    UINib *headerNib = [UINib nibWithNibName: @"CollectionHeaderReusableView"
                                      bundle: [NSBundle mainBundle]];
    
    //注册重用View
    [self.collectionView registerNib: headerNib
          forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                 withReuseIdentifier: @"CollectionHeaderReusableView"];
    
    
    //注册FooterView
    UINib *footerNib = [UINib nibWithNibName: @"CollectionFooterReusableView"
                                      bundle:[ NSBundle mainBundle]];
    
    [self.collectionView registerNib: footerNib
          forSupplementaryViewOfKind: UICollectionElementKindSectionFooter
                 withReuseIdentifier: @"CollectionFooterReusableView"];

}





#pragma mark <UICollectionViewDataSource>

/**
 * 返回Section的个数
 */
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 5;
}

/**
 * 返回每个Section中Cell的个数
 */
- (NSInteger)collectionView: (UICollectionView *)collectionView
     numberOfItemsInSection: (NSInteger)section {

    return 30;
}

/**
 * 返回Cell种类
 */
- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView
                  cellForItemAtIndexPath: (NSIndexPath *)indexPath {
    
    //通过Cell重用标示符来获取Cell
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: reuseIdentifier
                                                                         forIndexPath: indexPath];
    NSLog(@"%d, %d, %@", cell.highlighted, cell.selected, indexPath);
    
    [self changeSelectStateWithCell:cell];
    
    return cell;
}

/**
 * 设置Setion的Header和Footer(Supplementary View)
 */
- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView
           viewForSupplementaryElementOfKind: (NSString *)kind
                                 atIndexPath: (NSIndexPath *)indexPath{
    
    //设置SectionHeader
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderReusableView" forIndexPath:indexPath];
        
        return view;
    }
    
    //设置SectionFooter
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionFooterReusableView" forIndexPath:indexPath];
    return view;
    
}






#pragma mark <UICollectionViewDelegateFlowLayout>
/**
 * 改变Cell的尺寸
 */
- (CGSize)collectionView: (UICollectionView *)collectionView
                  layout: (UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath: (NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CGFloat heightOfCell = arc4random() % 100 + 30;
        
        return CGSizeMake(heightOfCell, _cellWidth);
    }
    
    return CGSizeMake(60, 60);
}

/**
 * Section的上下左右边距--UIEdgeInsetsMake(上, 左, 下, 右);逆时针
 */
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView
                        layout: (UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex: (NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


/**
 * Section中每个Cell的上下边距
 */
- (CGFloat)collectionView: (UICollectionView *)collectionView
                   layout: (UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex: (NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 20.0f;
}

/**
 * Section中每个Cell的左右边距
 */
- (CGFloat)collectionView: (UICollectionView *)collectionView
                   layout: (UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex: (NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 20.0f;
}

/**
 * headerView的大小
 */
- (CGSize)collectionView: (UICollectionView *)collectionView
                  layout: (UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection: (NSInteger)section{
    return CGSizeMake(200, 50);
}

/**
 * footerView的大小
 */
- (CGSize)collectionView: (UICollectionView *)collectionView
                  layout: (UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection: (NSInteger)section{
    return CGSizeMake(200, 50);
}


#pragma mark <UICollectionViewDelegate>

/**
 * Cell是否可以高亮
 */
- (BOOL)collectionView: (UICollectionView *)collectionView
shouldHighlightItemAtIndexPath: (NSIndexPath *)indexPath{
    
    return YES;
    
}


/**
 * 如果Cell可以高亮，Cell变为高亮后调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
didHighlightItemAtIndexPath: (NSIndexPath *)indexPath{
    
    [self changeHighlightCellWithIndexPath:indexPath];
}


/**
 * 如果Cell可以高亮，Cell从高亮变为非高亮调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
didUnhighlightItemAtIndexPath: (NSIndexPath *)indexPath{
    
    [self changeHighlightCellWithIndexPath:indexPath];

}


/**
 * 根据高亮状态修改背景图片
 */
- (void) changeHighlightCellWithIndexPath: (NSIndexPath *) indexPath{
    //获取当前变化的Cell
    CollectionViewCell *currentHighlightCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    currentHighlightCell.highlightImage.highlighted = currentHighlightCell.highlighted;
    
    if (currentHighlightCell.highlighted == YES){
        
        //NSLog(@"第%ld个Section上第%ld个Cell变为高亮",indexPath.section ,indexPath.row);
        return;
    }
    
    if (currentHighlightCell.highlighted == NO){
        
        //NSLog(@"第%ld个Section上第%ld个Cell变为非高亮",indexPath.section ,indexPath.row);
    }

}

/**
 * Cell是否可以选中
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


/**
 * Cell多选时是否支持取消功能
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/**
 * Cell选中调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *currentSelecteCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self changeSelectStateWithCell:currentSelecteCell];
}

/**
 * Cell取消选中调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前变化的Cell
    CollectionViewCell *currentSelecteCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self changeSelectStateWithCell:currentSelecteCell];
}


/**
 * Cell根据Cell选中状态来改变Cell上Button按钮的状态
 */
- (void) changeSelectStateWithCell: (CollectionViewCell *) currentSelecteCell{
 
    
    currentSelecteCell.selectButton.selected = currentSelecteCell.selected;
    
    if (currentSelecteCell.selected == YES){
        //NSLog(@"第%ld个Section上第%ld个Cell被选中了",indexPath.section ,indexPath.row);
        return;
    }
    
    if (currentSelecteCell.selected == NO){
        //NSLog(@"第%ld个Section上第%ld个Cell取消选中",indexPath.section ,indexPath.row);
    }

}

/**
 * Cell将要出现的时候调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
       willDisplayCell: (UICollectionViewCell *)cell
    forItemAtIndexPath: (NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
//    NSLog(@"第%ld个Section上第%ld个Cell将要出现",indexPath.section ,indexPath.row);
}

/**
 * Cell出现后调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
  didEndDisplayingCell: (UICollectionViewCell *)cell
    forItemAtIndexPath: (NSIndexPath *)indexPath{
//    NSLog(@"第%ld个Section上第%ld个Cell已经出现",indexPath.section ,indexPath.row);
}


/**
 * headerView或者footerView将要出现的时候调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
willDisplaySupplementaryView: (UICollectionReusableView *)view
        forElementKind: (NSString *)elementKind
           atIndexPath: (NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    
//    NSLog(@"第%ld个Section上第%ld个扩展View将要出现",indexPath.section ,indexPath.row);
    
}

/**
 * headerView或者footerView出现后调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
didEndDisplayingSupplementaryView: (UICollectionReusableView *)view
      forElementOfKind: (NSString *)elementKind
           atIndexPath: (NSIndexPath *)indexPath{
    
//    NSLog(@"第%ld个Section上第%ld个扩展View已经出现",indexPath.section ,indexPath.row);
    
}


/**
 * 长按是否出现编辑菜单（Cut Copy Paste）
 */
- (BOOL)collectionView: (UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath: (NSIndexPath *)indexPath{
    //第二个Section中的Cell可编辑
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (BOOL)collectionView: (UICollectionView *)collectionView
      canPerformAction: (SEL)action
    forItemAtIndexPath: (NSIndexPath *)indexPath
            withSender: (id)sender{
    
    NSString *selName = NSStringFromSelector(action);
    
    NSLog(@"%@", selName);
    
    
    //菜单中只会出现copy
    if([selName isEqualToString:@"copy:"]){
        return YES;
    }
    
    return NO;
}

- (void)collectionView: (UICollectionView *)collectionView
         performAction: (SEL)action
    forItemAtIndexPath: (NSIndexPath *)indexPath
            withSender: (id)sender{
    //可以执行一些拷贝粘贴等操作
    //详细的东西请看 UIPasteboard
    
    //点击Copy要执行的方法
    NSString *selName = NSStringFromSelector(action);
    
    NSLog(@"%@", selName);

}

//自定布局切换
/*
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout{
    return;
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
