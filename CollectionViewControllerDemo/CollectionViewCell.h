//
//  CollectionViewCell.h
//  CollectionViewControllerDemo
//
//  Created by Mr.LuDashi on 15/9/14.
//  Copyright (c) 2015年 ZeluLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *highlightImage;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@end
