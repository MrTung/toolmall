//
//  YCXMenu.m
//  YCXMenuDemo_ObjC
//
//  Created by 牛萌 on 15/5/6.
//  Copyright (c) 2015年 NiuMeng. All rights reserved.
//

#import "YCXMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+Fit.h"
////
#define kTintColorAlpha [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8]   //!< 透明度
#define kAlpha 0.8  //!< 透明度
////

#define kArrowSize      TMScreenW *8/320   //!< 箭头尺寸
#define kCornerRadius   TMScreenW *5/320    //!< 圆角
#define kTintColor  [UIColor colorWithRed:0.267 green:0.303 blue:0.335 alpha:0.5]  //!< 主题颜色
#define kTitleFont  [UIFont systemFontWithSize:15.0]

typedef enum {
    
    YCXMenuViewArrowDirectionNone,
    YCXMenuViewArrowDirectionUp,
    YCXMenuViewArrowDirectionDown,
    YCXMenuViewArrowDirectionLeft,
    YCXMenuViewArrowDirectionRight,
    
} YCXMenuViewArrowDirection;


@interface YCXMenuView : UIView
/**
 *  @method
 *  @brief 隐藏Menu
 *
 *  @param animated 是否有动画
 */
- (void)dismissMenu:(BOOL)animated;

@end



@interface YCXMenuOverlay : UIView

@end

@interface YCXMenu ()

/// 重置属性
+ (void)reset;

@end

#pragma mark - YCXMenuOverlay

@implementation YCXMenuOverlay

#pragma mark System Methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[YCXMenuView class]] && [view respondsToSelector:@selector(dismissMenu:)]) {
            [view performSelector:@selector(dismissMenu:) withObject:@(YES)];
        }
    }
}
@end



#pragma mark - YCXMenuView
@implementation YCXMenuView {
    YCXMenuViewArrowDirection _arrowDirection;
    CGFloat _arrowPosition;
    UIView *_contentView;
    NSArray *_menuItems;
    YCXMenuSelectedItem _selectedItem;
}

#pragma mark System Methods
- (id)init {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.alpha = 0;
        
        if ([YCXMenu hasShadow]) {
            self.layer.shadowOpacity = 0.5;
            self.layer.shadowColor = [YCXMenu tintColor].CGColor;
            self.layer.shadowOffset = CGSizeMake(2, 2);
            self.layer.shadowRadius = 2;
        }
    }
    return self;
}


- (void)setupFrameInView:(UIView *)view fromRect:(CGRect)fromRect {
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;
    
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = TMScreenW *8/320;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = YCXMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf*2+ TMScreenW *20/320, // 箭头起始点<宽度-20>
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){0, kArrowSize, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = YCXMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = YCXMenuViewArrowDirectionLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){kArrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + kArrowSize,
            contentSize.height
        };
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = YCXMenuViewArrowDirectionRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + kArrowSize,
            contentSize.height
        };
        
    } else {
        
        _arrowDirection = YCXMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}

- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YCXMenuSelectedItem)selectedItem {
    _menuItems = menuItems;
    _selectedItem = selectedItem;
    _contentView = [self mkContentView];
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];
    
    YCXMenuOverlay *overlay = [[YCXMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
}

- (void)dismissMenu:(BOOL) animated {
    if (self.superview) {
        if (animated) {
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            [UIView animateWithDuration:0.2 animations:^(void) {
                self.alpha = 0;
                self.frame = toFrame;
            } completion:^(BOOL finished) {
                if ([self.superview isKindOfClass:[YCXMenuOverlay class]])
                    [self.superview removeFromSuperview];
                [self removeFromSuperview];
            }];
        }
        else {
            if ([self.superview isKindOfClass:[YCXMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}

- (void)performAction:(id)sender {
    [self dismissMenu:YES];
    UIButton *button = (UIButton *)sender;
    YCXMenuItem *menuItem = _menuItems[button.tag];
    [menuItem performAction];
    _selectedItem(button.tag, menuItem);
}

- (UIView *) mkContentView {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (!_menuItems.count)
        return nil;
    
#pragma mark = 修改Size
    
    const CGFloat kMinMenuItemHeight = TMScreenH *16/568;
    const CGFloat kMinMenuItemWidth = TMScreenW *32/320;
    const CGFloat kMarginX = TMScreenW *10/320;
    const CGFloat kMarginY = TMScreenH *5/568;
    
    UIFont *titleFont = [YCXMenu titleFont];
    
    CGFloat maxImageWidth = 0;
    CGFloat maxItemHeight = 0;
    CGFloat maxItemWidth = 0;
    
    for (YCXMenuItem *menuItem in _menuItems) {
        const CGSize imageSize = menuItem.image.size;
        if (imageSize.width > maxImageWidth)
            maxImageWidth = imageSize.width;
    }
    
    if (maxImageWidth) {
//        maxImageWidth += kMarginX;
    }
    
    for (YCXMenuItem *menuItem in _menuItems) {
        
        const CGSize titleSize = [menuItem.title sizeWithAttributes:@{NSFontAttributeName:menuItem.titleFont?menuItem.titleFont:titleFont}];
        //const CGSize titleSize = [menuItem.title sizeWithFont:titleFont];
        const CGSize imageSize = menuItem.image.size;
        
        const CGFloat itemHeight = MAX(titleSize.height, imageSize.height) + kMarginY*2;
        const CGFloat itemWidth = ((!menuItem.enabled && !menuItem.image) ? titleSize.width : maxImageWidth + titleSize.width) + kMarginX * 4;
        
        if (itemHeight > maxItemHeight)
            maxItemHeight = itemHeight;
        
        if (itemWidth > maxItemWidth)
            maxItemWidth = itemWidth;
    }
    
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);
    
    const CGFloat titleX = kMarginX*2 + maxImageWidth + kMarginX/2;
    const CGFloat titleWidth = maxItemWidth - titleX - kMarginX*2+ kMarginX/2;
    
//    UIImage *selectedImage = [YCXMenuView selectedImage:(CGSize){maxItemWidth, maxItemHeight + 2}];
    UIImage *gradientLine = [YCXMenuView gradientLine: (CGSize){maxItemWidth , 0.5}];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
//    contentView.backgroundColor = [UIColor cyanColor];
    contentView.opaque = NO;
    
    CGFloat itemY = kMarginY;
    NSUInteger itemNum = 0;
    
    for (YCXMenuItem *menuItem in _menuItems) {
        
        const CGRect itemFrame = (CGRect){0, itemY, maxItemWidth, maxItemHeight};
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
//        itemView.backgroundColor = [UIColor redColor];
        itemView.opaque = NO;
        
        [contentView addSubview:itemView];
        
        if (menuItem.enabled) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = itemNum;
            button.frame = itemView.bounds;
            button.enabled = menuItem.enabled;
//            button.backgroundColor = [UIColor blueColor];
            button.opaque = NO;
            button.autoresizingMask = UIViewAutoresizingNone;
            
            [button addTarget:self
                       action:@selector(performAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
//            [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
            
            [itemView addSubview:button];
        }
        
        if (menuItem.image) {
            
            const CGRect imageFrame = {kMarginX*1.5, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
//            imageView.backgroundColor = [UIColor orangeColor];
            imageView.image = menuItem.image;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }
        
        if (menuItem.title.length) {
            
            CGRect titleFrame;
            
            if (!menuItem.enabled && !menuItem.image) {
                
                titleFrame = (CGRect){
                    kMarginX * 2,
                    kMarginY,
                    maxItemWidth - kMarginX * 4,
                    maxItemHeight - kMarginY * 2
                };
                
            } else {
                
                titleFrame = (CGRect){
                    titleX,
                    kMarginY,
                    titleWidth,
                    maxItemHeight - kMarginY * 2
                };
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = menuItem.titleFont ? menuItem.titleFont : titleFont;
            titleLabel.textAlignment = menuItem.alignment;
//            titleLabel.textColor = menuItem.foreColor ? menuItem.foreColor : lightGrayColorSelf;
            titleLabel.textColor = [UIColor colorWithRed:198.0/255 green:200.0/255 blue:201.0/255 alpha:1.0];
//            titleLabel.backgroundColor = [UIColor orangeColor];
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:titleLabel];
        }
        
        
        if (itemNum < _menuItems.count - 1) {
            
            UIImageView *gradientView = [[UIImageView alloc] initWithImage:gradientLine];
            gradientView.frame = (CGRect){0, maxItemHeight + 0.0, gradientLine.size};
            gradientView.backgroundColor = lightGrayColorSelf;
            gradientView.contentMode = UIViewContentModeLeft;
            [itemView addSubview:gradientView];
            
            itemY += 0.5;
        }
        
        itemY += maxItemHeight;
        ++itemNum;
    }
    
    contentView.frame = (CGRect){0, 0, maxItemWidth, itemY + kMarginY};
    
    return contentView;
}

- (CGPoint)arrowPoint {
    CGPoint point;
    
    if (_arrowDirection == YCXMenuViewArrowDirectionUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == YCXMenuViewArrowDirectionDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == YCXMenuViewArrowDirectionLeft) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == YCXMenuViewArrowDirectionRight) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}

+ (UIImage *)selectedImage:(CGSize)size {
    const CGFloat locations[] = {0,1};
    const CGFloat components[] = {
        //0.216, 0.471, 0.871, 1,
        //0.059, 0.353, 0.839, 1,
        41 / 255.0 ,46 / 255.0 ,49 / 255.0, 1,
        41 / 255.0 ,46 / 255.0 ,49 / 255.0, 1,
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:2];
}

+ (UIImage *)gradientLine:(CGSize)size {
    const CGFloat locations[5] = {0,0.2,0.5,0.8,1};
    const CGFloat R = 0.44f, G = 0.44f, B = 0.44f;
    const CGFloat components[20] = {
        R,G,B,0.1,
        R,G,B,0.4,
        R,G,B,0.7,
        R,G,B,0.4,
        R,G,B,0.1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:5];
}

+ (UIImage *)gradientImageWithSize:(CGSize) size locations:(const CGFloat []) locations components:(const CGFloat []) components count:(NSUInteger)count {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
    CGGradientRelease(colorGradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawRect:(CGRect)rect {
    [self drawBackground:self.bounds inContext:UIGraphicsGetCurrentContext()];
    // 绘制完成后,初始静态变量值
    // 防止下次调用控件时沿用上一次设置的属性
    [YCXMenu reset];
}

- (void)drawBackground:(CGRect)frame inContext:(CGContextRef) context {
    CGFloat R0 = 0.0, G0 = 0.0, B0 = 0.0;
    CGFloat R1 = 0.0, G1 = 0.0, B1 = 0.0;
    
//    UIColor *tintColor = [YCXMenu tintColor];
//    if (tintColor) {
//        CGFloat a;
//        [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
//        [tintColor getRed:&R1 green:&G1 blue:&B1 alpha:&a];
//    }
    
    if ([YCXMenu backgrounColorEffect] == YCXMenuBackgrounColorEffectGradient) {
        R1-=0.2;
        G1-=0.2;
        B1-=0.2;
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    const CGFloat kEmbedFix = 0.f;
    
    if (_arrowDirection == YCXMenuViewArrowDirectionUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize- TMScreenW *2/320;
        const CGFloat arrowX1 = arrowXM + kArrowSize+ TMScreenW *2/320;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + kArrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        [kTintColorAlpha setFill];
        
        Y0 += kArrowSize;
        
    } else if (_arrowDirection == YCXMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [kTintColorAlpha setFill];
        
        Y1 -= kArrowSize;
        
    } else if (_arrowDirection == YCXMenuViewArrowDirectionLeft) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + kArrowSize + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [kTintColorAlpha setFill];
        
        X0 += kArrowSize;
        
    } else if (_arrowDirection == YCXMenuViewArrowDirectionRight) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [kTintColorAlpha setFill];
        
        X1 -= kArrowSize;
    }
    [kTintColorAlpha set];
    [arrowPath fill];
    
//    [arrowPath closePath];
//    [arrowPath stroke];
    // render body
//    X0-=10;
//    NSLog(@" X0, Y0, X1, Y1 - %f - %f - %f - %f", X0, Y0, X1, Y1);
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:kCornerRadius];
    
    const CGFloat locations[] = {0, 1};
    const CGFloat components[] = {
        R0, G0, B0, kAlpha,
        R1, G1, B1, kAlpha,
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    
    CGPoint start, end;
    
    if (_arrowDirection == YCXMenuViewArrowDirectionLeft ||
        _arrowDirection == YCXMenuViewArrowDirectionRight) {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X1, Y0};
        
    } else {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X0, Y1};
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}

@end


#pragma mark - YCXMenu
/// MenuView
static YCXMenu                      *gMenu;
/// 背景色
static UIColor                      *gTintColor;
/// 字体
static UIFont                       *gTitleFont;
/// 背景色效果
static YCXMenuBackgrounColorEffect   gBackgroundColorEffect = YCXMenuBackgrounColorEffectSolid;
/// 是否显示阴影
static BOOL                          gHasShadow = NO;

@implementation YCXMenu {
    YCXMenuView *_menuView;
    BOOL         _observing;
}

#pragma mark System Methods

+ (instancetype) sharedMenu {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gMenu = [[YCXMenu alloc] init];
    });
    return gMenu;
}

- (id) init {
    NSAssert(!gMenu, @"singleton object");
    self = [super init];
    if (self) {

    }
    return self;
}

- (void) dealloc {
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark Public Methods

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YCXMenuSelectedItem)selectedItem {
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems selected:selectedItem];
}

+ (void)dismissMenu {
    [[self sharedMenu] dismissMenu];
}

+ (void)reset {
    gTintColor = nil;
    gTitleFont = nil;
    gBackgroundColorEffect = YCXMenuBackgrounColorEffectSolid;
    gHasShadow = NO;
}

#pragma mark Private Methods

- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(YCXMenuSelectedItem)selectedItem {
    NSParameterAssert(view);
    NSParameterAssert(menuItems.count);
    
    if (_menuView) {
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        _observing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    
    // 创建MenuView
    _menuView = [[YCXMenuView alloc] init];
    [_menuView showMenuInView:view fromRect:rect menuItems:menuItems selected:selectedItem];
}

- (void)dismissMenu {
    
    if (_menuView) {
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (_observing) {
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

}

#pragma mark Notification
- (void)orientationWillChange:(NSNotification *)notification {
    [self dismissMenu];
}

#pragma mark setter/getter
+ (UIColor *)tintColor {
    return gTintColor?gTintColor:kTintColor;
}

+ (void)setTintColor:(UIColor *)tintColor {
    if (tintColor != gTintColor) {
        gTintColor = tintColor;
    }
}

+ (UIFont *) titleFont {
    return gTitleFont?gTitleFont:kTitleFont;
}

+ (void) setTitleFont: (UIFont *) titleFont {
    if (titleFont != gTitleFont) {
        gTitleFont = titleFont;
    }
}

+ (YCXMenuBackgrounColorEffect)backgrounColorEffect {
    return gBackgroundColorEffect;
}

+ (void)setBackgrounColorEffect:(YCXMenuBackgrounColorEffect)effect {
    gBackgroundColorEffect = effect;
}

+ (BOOL)hasShadow {
    return gHasShadow;
}

+ (void)setHasShadow:(BOOL)flag {
    gHasShadow = flag;
}

@end

