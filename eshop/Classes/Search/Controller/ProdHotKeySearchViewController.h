//
//  ProdHotKeySearchViewController.h
//  eshop
//
//  Created by mc on 16/3/8.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchService.h"
#import "HotSearchKeyListResponse.h"
#import "UIDevice+Extensions.h"
#import "HistoryCollectionViewCell.h"
#import "ProdList.h"
#import "Pagination.h"

@protocol ProdHotKeySearchDelegate <NSObject>

- (void)changeTheTextOfTextFiled:(NSString *)string;

@end

@interface ProdHotKeySearchViewController : UIBaseController<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITextField * searchText;
@property (nonatomic) Boolean fetchSearchHistory;

@property (nonatomic, strong) NSMutableArray * hotArray; //热门搜索词
//@property (nonatomic, strong) NSMutableArray * historyMutableArray; // 历史搜索
@property (nonatomic, strong) NSMutableArray * historyArray; // 排重历史搜索

@property (nonatomic, strong) id <ProdHotKeySearchDelegate> hotKeyDelegate;
//申明一个block
@property (nonatomic, copy) void (^keywordSearch)(NSString *);

@end
