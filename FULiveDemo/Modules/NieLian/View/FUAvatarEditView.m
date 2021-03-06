//
//  FUAvatarEditView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarEditView.h"
#import "FUColorCollectionView.h"
#import "FUAvatarContentColletionView.h"
#import "FUAvatarBottomColletionView.h"
#import "FUAvatarPresenter.h"
#import "FUAvatarCustomView.h"
#import "FUManager.h"
#import "FUAvatarModel.h"


@interface FUAvatarEditView()<FUAvatarBottomColletionViewDelegate,FUAvatarContentColletionViewDelegate,FUColorCollectionViewDelegate>

@property (strong, nonatomic) FUColorCollectionView *colorCollectionView;

@property (strong, nonatomic) FUAvatarContentColletionView *avatarContentColletionView;

@property (strong, nonatomic) FUAvatarBottomColletionView *avatarBottomColletionView;

@end
@implementation FUAvatarEditView



- (id)initWithFrame:(CGRect)frame withData:(NSArray<FUAvatarModel *> *)dataArray{
    self = [super initWithFrame:frame];
    if (self){
        self.dataArray = dataArray;
        _avatarCustomView = [[FUAvatarCustomView alloc] initWithFrame:CGRectMake(0, 123,[UIScreen mainScreen].bounds.size.width, 194)];
        _avatarCustomView.avatarModel = self.dataArray[0] ;
        _avatarCustomView.backgroundColor = [UIColor whiteColor];
        _avatarCustomView.hidden = YES;
        [self addSubview:_avatarCustomView];
        
        _colorCollectionView = [[FUColorCollectionView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 60)];
        _colorCollectionView.avatarModel = self.dataArray[0];
        _colorCollectionView.backgroundColor = [UIColor whiteColor];
        _colorCollectionView.delegate = self;
        [self addSubview:_colorCollectionView];
        
        _avatarContentColletionView = [[FUAvatarContentColletionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_colorCollectionView.frame),[UIScreen mainScreen].bounds.size.width, 208)];
        _avatarContentColletionView.delegate = self;
        _avatarContentColletionView.avatarModel = self.dataArray[0];
        _avatarContentColletionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_avatarContentColletionView];
        
        _avatarBottomColletionView = [[FUAvatarBottomColletionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_avatarContentColletionView.frame),[UIScreen mainScreen].bounds.size.width, 49)];
        _avatarBottomColletionView.delegate = self;
        _avatarBottomColletionView.backgroundColor = [UIColor whiteColor];
        _avatarBottomColletionView.dataArray = self.dataArray;
        [self addSubview:_avatarBottomColletionView];
    }
    
    return self;
}

#pragma  mark -  set

-(void)setIsCustomState:(BOOL)isCustomState{
    _isCustomState = isCustomState;
    if (_isCustomState) {
        _avatarBottomColletionView.hidden = YES;
        _colorCollectionView.hidden = YES;
        _avatarContentColletionView.hidden = YES;
        _avatarCustomView.hidden = NO;
        
        int bottomIndex = (int)_avatarBottomColletionView.selIndex;
        /* 默认的值 */
        FUAvatarModel *modle =  self.dataArray[bottomIndex];
        _avatarCustomView.avatarModel = modle;
    }else{
        _avatarBottomColletionView.hidden = NO;
        _colorCollectionView.hidden = NO;
        _avatarContentColletionView.hidden = NO;
        _avatarCustomView.hidden = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(avatarEditViewDidCustom:)]) {
        [self.delegate avatarEditViewDidCustom:_isCustomState];
    }
    
}
#pragma  mark -  FUColorCollectionViewDelegate
    
-(void)colorCollectionViewDidSelectedIndex:(NSInteger)index{
    if (_avatarBottomColletionView.selIndex == 0) {//选中的发型
        FUAvatarColor *colorModel = self.colorCollectionView.avatarModel.colors[index];
    
        [[FUManager shareManager] setAvatarHairColorParam:self.colorCollectionView.avatarModel.colorsParam colorWithRed:colorModel.r green:colorModel.g blue:colorModel.b intensity:(int)colorModel.intensity];
    }else{
        FUAvatarColor *colorModel = self.colorCollectionView.avatarModel.colors[index];
        
        [[FUManager shareManager] setAvatarItemParam:self.colorCollectionView.avatarModel.colorsParam colorWithRed:colorModel.r green:colorModel.g blue:colorModel.b];
    }
}

    

#pragma  mark -  FUAvatarBottomColletionViewDelegate
-(void)avatarBottomColletionDidSelectedIndex:(NSInteger)index{
    _colorCollectionView.avatarModel = self.dataArray[index];
    _avatarContentColletionView.avatarModel = self.dataArray[index];
    
    /* update UI */
    if (index == 4 || (index == 0 && _avatarContentColletionView.avatarModel.bundleSelIndex == 0 )) {//鼻子没有颜色 + 光头
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame =  _avatarContentColletionView.frame;
            _avatarContentColletionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame =  _avatarContentColletionView.frame;
            _avatarContentColletionView.frame = CGRectMake(0, _colorCollectionView.frame.size.height, frame.size.width, frame.size.height);
        }];

    }

}


#pragma  mark -  FUAvatarContentColletionViewDelegate

- (void)avatarContentColletionViewDidSelectedIndex:(NSInteger)index{
    int bottomIndex = (int)_avatarBottomColletionView.selIndex;
    
    /* update UI */
    if ((bottomIndex == 0 && index == 0) || bottomIndex == 4) {//鼻子没有颜色 + 光头
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame =  _avatarContentColletionView.frame;
            _avatarContentColletionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame =  _avatarContentColletionView.frame;
            _avatarContentColletionView.frame = CGRectMake(0, _colorCollectionView.frame.size.height, frame.size.width, frame.size.height);
        }];
        
    }
    
    FUAvatarModel *modle =  self.dataArray[bottomIndex];
    
    /* bind美发道具 */
    if (bottomIndex == 0) {
        [[FUManager shareManager] avatarBindHairItem:modle.bundles[index].bundleName];
        
        /* 重设置颜色 */
        int colorIndex = (int)_colorCollectionView.selIndex;
        FUAvatarColor *colorModel = self.colorCollectionView.avatarModel.colors[colorIndex];
        [[FUManager shareManager] setAvatarHairColorParam:self.colorCollectionView.avatarModel.colorsParam colorWithRed:colorModel.r green:colorModel.g blue:colorModel.b intensity:(int)colorModel.intensity];

        return;
    }
    
    if (index == 0) {//自定义
        if (modle.haveCustom) {
            self.isCustomState = YES;
        }
        /* 参数设置类型 */
        for (FUAvatarParam *model0 in modle.bundles[index].params) {
            if (model0.value < 0) {
                [[FUManager shareManager] setAvatarParam:model0.paramS value:fabsf(model0.value)];
                [[FUManager shareManager] setAvatarParam:model0.paramB value:0];
            }else{
                [[FUManager shareManager] setAvatarParam:model0.paramS value:0];
                [[FUManager shareManager] setAvatarParam:model0.paramB value:fabsf(model0.value)];
            }
        }
    }else if (modle.bundles[index].params.count > 0) {//参数设置类型
            for (FUAvatarParam *model0 in modle.bundles[index].params) {
                if (model0.value < 0) {
                    [[FUManager shareManager] setAvatarParam:model0.paramS value:fabsf(model0.value)];
                    [[FUManager shareManager] setAvatarParam:model0.paramB value:0];
                }else{
                    [[FUManager shareManager] setAvatarParam:model0.paramS value:0];
                    [[FUManager shareManager] setAvatarParam:model0.paramB value:fabsf(model0.value)];
                }
            }
            
            /* 产品要求将自定义设置为0 */
            for (FUAvatarParam *param in modle.bundles[0].params) {
                param.value = 0;
            }
     }
    

    if(bottomIndex != 4){//鼻子不需要设置颜色
        /* 重设置颜色 */
        int colorIndex = (int)_colorCollectionView.selIndex;
        FUAvatarColor *colorModel = self.colorCollectionView.avatarModel.colors[colorIndex];
        [[FUManager shareManager] setAvatarItemParam:self.colorCollectionView.avatarModel.colorsParam colorWithRed:colorModel.r green:colorModel.g blue:colorModel.b];
    }

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"1111");
}

@end
