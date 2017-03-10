//
//  ProdImageScrollImage.m
//  eshop
//
//  Created by mc on 15-11-12.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "ProdImageScrollImage.h"

@interface ProdImageScrollImage ()

@end

@implementation ProdImageScrollImage

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
    // Do any additional setup after loading the view from its nib.
    //UIPinchGestureRecognizer *pinchGesterReconginzer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    //[self.view addGestureRecognizer:pinchGesterReconginzer];
    //origFrame = self.image.frame;
    //largeFrame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.size.width * 2, origFrame.size.height * 2);
    //1添加 UIScrollView
    //设置 UIScrollView的位置与屏幕大小相同
    self.view.frame = CGRectMake(0, 0, TMScreenW, TMScreenH);
    _scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TMScreenW, TMScreenH)];
//    _scrollview.showsVerticalScrollIndicator = NO;
//    _scrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollview];

     //(2)使用构造方法
    
    _imageview = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].applicationFrame.size.width - 20, [UIScreen mainScreen].applicationFrame.size.height - 20)];
    _imageview.placeholderImage = [UIImage imageNamed:@"index_defImage"];
    _imageview.contentMode = UIViewContentModeScaleAspectFit;

    //_imageview=[[UIImageView alloc]initWithImage:image];
     //调用initWithImage:方法，它创建出来的imageview的宽高和图片的宽高一样
     [_scrollview addSubview:_imageview];

     //设置UIScrollView的滚动范围和图片的真实尺寸一致
     _scrollview.contentSize=[UIScreen mainScreen].applicationFrame.size;


     //设置实现缩放
     //设置代理scrollview的代理对象
     _scrollview.delegate=self;
     //设置最大伸缩比例
     _scrollview.maximumZoomScale=2.0;
     //设置最小伸缩比例
     _scrollview.minimumZoomScale=1;
}


- (void)setImagePath:(NSString*)imagePath{
    _imageview.imageURL = [NSURL URLWithString:imagePath];
    
//    NSLog(@"%@", NSHomeDirectory());
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageview;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
