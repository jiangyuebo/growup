//
//  CZRadioSelectView.m
//  Growup
//
//  Created by Jerry on 2017/6/3.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZRadioSelectView.h"
#import "globalHeader.h"

@interface CZRadioSelectView()

@property (strong,nonatomic) NSMutableDictionary *itemsDic;

@property (strong,nonatomic) NSMutableArray *allButtonsArray;

@property (strong,nonatomic) NSArray *itemsDicKeys;

//列
@property (nonatomic) NSUInteger col;
//行
@property (nonatomic) NSUInteger margin;

@end

@implementation CZRadioSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化控件
        self.col = 1;
        self.margin = 10;
        
        self.allButtonsArray = [[NSMutableArray alloc] init];
        NSLog(@"初始化控件");
    }
    
    return self;
}

- (void)setSelectItemDic:(NSMutableDictionary *) itemsDic{
    self.itemsDic = itemsDic;
    
    self.itemsDicKeys = [self.itemsDic allKeys];
    
    for (int i = 0; i < [self.itemsDicKeys count]; i++) {
        int page = i / self.col;
        int index = i % self.col;
        
        UIButton *BtnSearch = [[UIButton alloc] initWithFrame:CGRectMake(self.margin + index * (SCREENWIDTH - (self.col + 1) * self.margin) / self.col + self.margin * index,40 * page + 40,(SCREENWIDTH - (self.col + 1) * self.margin) / self.col,30)];
        
        BtnSearch.layer.cornerRadius = 5;
        BtnSearch.layer.masksToBounds = YES;
        BtnSearch.layer.shadowOffset =  CGSizeMake(1, 1);
        BtnSearch.layer.shadowOpacity = 0.8;
        BtnSearch.layer.shadowColor =  [UIColor blackColor].CGColor;
        BtnSearch.backgroundColor = [UIColor lightGrayColor];
        BtnSearch.tag = i;
        [BtnSearch setTitle:self.itemsDicKeys[i] forState:UIControlStateNormal];
        [BtnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [BtnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [BtnSearch addTarget:self action:@selector(SelectBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.allButtonsArray addObject:BtnSearch];
        [self addSubview:BtnSearch];
    }
}

- (void)setDefautSelect:(NSMutableDictionary *) selectItemsDic{
    for (int i = 0; i  < [self.allButtonsArray count]; i++) {
        UIButton *itemButton = self.allButtonsArray[i];
        NSString *text = itemButton.titleLabel.text;
        
        //判断是否需要默认选择
        if ([selectItemsDic objectForKey:text]) {
            itemButton.backgroundColor = [UIColor orangeColor];
            itemButton.selected = YES;
        }
        
    }
}

- (void)SelectBtnSearch:(UIButton *) button{
    for (int i = 0; i < [self.allButtonsArray count]; i++) {
        UIButton *itemButton = self.allButtonsArray[i];
        itemButton.backgroundColor = [UIColor lightGrayColor];
        itemButton.selected = NO;
    }
    
    button.selected = YES;
    button.backgroundColor = [UIColor orangeColor];
    
    //设置选中的项
    self.selectedValue = [self.itemsDic objectForKey:[self.itemsDicKeys objectAtIndex:button.tag]];
    NSLog(@" self.selectedValue = %@",self.selectedValue);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
