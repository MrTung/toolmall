//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#import "UIFont+Fit.h"

@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        isLoading = NO;
        
//        CGFloat midY = frame.size.height - PULL_AREA_HEIGTH/2;

//        /* Config Status Updated Label */(0.0f, midY - TMScreenH *10/568, self.frame.size.width, TMScreenH *20/568)
        /*
		UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *20/320, midY + TMScreenH *10/568, self.frame.size.width - TMScreenW *20/320, TMScreenH *20/568)];
        label.text = @"释放即可刷新";
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontWithSize:10.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        */
        CGFloat screenHeight = frame.size.height;
        CGFloat logoHeight = (kWidth * 224/750);
        CGFloat arrowSize = (TMScreenW *16/320);
        CGFloat whiteLayerHeight = (logoHeight + arrowSize + TMScreenH *12/568);
        
        /*白底*/
//        CALayer *whiteLayer = [[CALayer alloc] init];
//        whiteLayer.frame = CGRectMake(0, screenHeight - whiteLayerHeight, kWidth, whiteLayerHeight);
////        whiteLayer.backgroundColor = [UIColor whiteColor];
//        [[self layer] addSublayer:whiteLayer];
//        _whiteLayer = whiteLayer;
        
        /*配置土猫logo*/
        CALayer * lay = [[CALayer alloc]init];
        lay.frame = CGRectMake(0, screenHeight - logoHeight - arrowSize - TMScreenH *12/568, kWidth, logoHeight);
//        lay.contentsGravity = kCAGravityTop;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//            
//			layer.contentsScale = [[UIScreen mainScreen] scale];
//            lay.contentsScale = [[UIScreen mainScreen] scale];
//		}
#endif
        
        
        [[self layer] addSublayer:lay];
        _logoImage = lay;
  
        /* Config Arrow Image */
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake((kWidth-arrowSize)/2, screenHeight-arrowSize-TMScreenH *8/568, arrowSize, arrowSize);
        //		layer.contentsGravity = kCAGravityTop;
        
        [[self layer] addSublayer:layer];
		_arrowImage=layer;
        
        
        /* Config activity indicator */
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
        view.frame = layer.frame;
        [self addSubview:view];
        _activityView = view;
        
        [self setState:EGOOPullNormal];
        
        /* Configure the default colors and arrow image */
        [self setBackgroundColor:nil textColor:nil arrowImage:nil logoImage:nil];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

#define aMinute 60
#define anHour 3600
#define aDay 86400



- (void)setState:(EGOPullState)aState{
	
	switch (aState) {
		case EGOOPullPulling:
			
            _statusLabel.text = NSLocalizedStringFromTable(@"释放即可刷新...",@"PullTableViewLan", @"Release to refresh status");
            _statusLabel.hidden = YES;
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DIdentity;
//            _logoImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case EGOOPullNormal:
			
			if (_state == EGOOPullPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
;
//                _logoImage.transform  = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            _statusLabel.text = NSLocalizedStringFromTable(@"下拉即可刷新...",@"PullTableViewLan", @"Pull down to refresh status");
            _statusLabel.hidden = YES;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//            显示箭头
			_arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
;
//            土猫logo
            _logoImage.hidden = NO;
//            _logoImage.transform  = CATransform3DIdentity;
			[CATransaction commit];
		
//			[self refreshLastUpdatedDate];
            
			break;
//           刷新中
		case EGOOPullLoading:
			
            _statusLabel.text = NSLocalizedStringFromTable(@"正在努力刷新...",@"PullTableViewLan", @"Loading Status");
            _statusLabel.hidden = YES;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            _logoImage.hidden = NO;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage logoImage:(UIImage *)logoImage
{
    self.backgroundColor = backgroundColor? backgroundColor : DEFAULT_BACKGROUND_COLOR;
    
    if(textColor) {

        _statusLabel.textColor = textColor;
    } else {

        _statusLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    _statusLabel.shadowColor = [_statusLabel.textColor colorWithAlphaComponent:0.1f];
    
    _arrowImage.contents = (id)(arrowImage? arrowImage.CGImage : DEFAULT_ARROW_IMAGE.CGImage);

    _logoImage.contents = (id)(logoImage? logoImage.CGImage : LOGO_IMAGE.CGImage);
//    _whiteLayer.contents = (id)[UIImage imageNamed:@"tab_bg.png"].CGImage;
    
}


#pragma mark -
#pragma mark ScrollView Methods


- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
    
	if (_state == EGOOPullLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, PULL_AREA_HEIGTH);
        UIEdgeInsets currentInsets = scrollView.contentInset;
        currentInsets.top = offset;
        scrollView.contentInset = currentInsets;
		
	} else if (scrollView.isDragging) {
		if (_state == EGOOPullPulling && scrollView.contentOffset.y > -PULL_TRIGGER_HEIGHT && scrollView.contentOffset.y < 0.0f && !isLoading) {
			[self setState:EGOOPullNormal];
		} else if (_state == EGOOPullNormal && scrollView.contentOffset.y < -PULL_TRIGGER_HEIGHT && !isLoading) {
			[self setState:EGOOPullPulling];
            
		}
		
		if (scrollView.contentInset.top != 0) {
            UIEdgeInsets currentInsets = scrollView.contentInset;
            currentInsets.top = 0;
            scrollView.contentInset = currentInsets;
		}
		
	}
	
}

- (void)startAnimatingWithScrollView:(UIScrollView *) scrollView {
    isLoading = YES;
    
    [self setState:EGOOPullLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.top = PULL_AREA_HEIGTH;
    scrollView.contentInset = currentInsets;
    [UIView commitAnimations];
    if(scrollView.contentOffset.y == 0){
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -PULL_TRIGGER_HEIGHT) animated:YES];
    }    
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	
	if (scrollView.contentOffset.y <= - PULL_TRIGGER_HEIGHT && !isLoading) {
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        [self startAnimatingWithScrollView:scrollView];
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
    isLoading = NO;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.top = 0;
    scrollView.contentInset = currentInsets;
	[UIView commitAnimations];
	
	[self setState:EGOOPullNormal];
    
}

- (void)egoRefreshScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [self refreshLastUpdatedDate];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;

	[_statusLabel release];
	[_arrowImage release];
    [_logoImage release];

    [super dealloc];
}


@end
