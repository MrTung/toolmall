//
//  ProdImageScroll.m
//  eshop
//
//  Created by mc on 15-11-12.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "ProdImageScroll.h"

@interface ProdImageScroll ()

@property (weak, nonatomic) IBOutlet UILabel *currentPageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cutLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumPagesLabel;

@end

@implementation ProdImageScroll

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // @"商品图片"
    NSString *prodImageScroll_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodImageScroll_navItem_title"];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = prodImageScroll_navItem_title;

    // Do any additional setup after loading the view from its nib.
    images = [[NSMutableArray alloc] initWithCapacity:10];
    for (AppProductImage *prodImage in self.prodImages){
        [images addObject:prodImage.large];
    }
    kNumberOfPages =images.count;
    NSMutableArray* controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0 ; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    self.scrollView.pagingEnabled = YES;
    self.view.frame = CGRectMake(0, 0, TMScreenW, TMScreenH);
    self.scrollView.frame = CGRectMake(0, 0, TMScreenW, TMScreenH);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*kNumberOfPages,
                                             self.scrollView.frame.size.height);
    //  self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.hidden = YES;
    self.pageControl.frame = CGRectMake((TMScreenW-TMScreenW *300/320)/2.0, TMScreenH - TMScreenH *35/568, TMScreenW *300/320,  TMScreenH *20/568);

    self.pageControl.numberOfPages = kNumberOfPages;
    self.pageControl.currentPage = 0;
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [super addNavBackButton];
    [self configurePageLabel];
}

- (void)configurePageLabel {

    self.currentPageLabel.frame = CGRectMake(TMScreenW *274/320,  TMScreenH *520/568, TMScreenW *10/320,  TMScreenH *15/568);
//        self.currentPageLabel.backgroundColor = [UIColor cyanColor];
    self.currentPageLabel.textAlignment = NSTextAlignmentRight;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%d", 1];
    self.currentPageLabel.textColor = redColorSelf;
    
    self.cutLabel.frame = CGRectMake(TMScreenW *285/320,  TMScreenH *520.5/568.0, TMScreenW *5/320,  TMScreenH *13/568);
//    self.cutLabel.backgroundColor = [UIColor cyanColor];
    self.cutLabel.text = @"/";
    self.cutLabel.textAlignment = NSTextAlignmentCenter;
    
    self.sumPagesLabel.frame = CGRectMake(TMScreenW *290/320,  TMScreenH *520/568, TMScreenW *10/320,  TMScreenH *15/568);
//    self.sumPagesLabel.backgroundColor = [UIColor cyanColor];
    self.sumPagesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)kNumberOfPages];
    self.sumPagesLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) changePage:(id)sender{
    int page = self.pageControl.currentPage;
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width*page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}


-(void) loadScrollViewWithPage:(int)page{
    if (page < 0) {
        return;
    }else if(page >= kNumberOfPages) {
        //do some thing,like jump to other screen
        return;
    }
    
    ProdImageScrollImage * controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull*)controller == [NSNull null]) {
        controller = [[ProdImageScrollImage alloc] init];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
        [controller setImagePath:[images objectAtIndex:page ]];
        
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //page表示当前滚动哪一页的标识
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
    
    self.pageControl.currentPage = page;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%d", page+1];
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
    
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

@end
