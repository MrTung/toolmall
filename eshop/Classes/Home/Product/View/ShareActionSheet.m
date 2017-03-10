
#import "ShareActionSheet.h"
#import "AppDelegate.h"

#define intervalWithButtonsX 0
#define intervalWithButtonsY 10
#define buttonCountPerRow 4
#define headerHeight 40
#define bottomHeight 20
#define cancelButtonHeight 26

@implementation ShareActionSheet
@synthesize buttons;
@synthesize backgroundImageView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (id)initWithButtons:(NSArray *)buttonArray
{
    self = [super init];
    self.buttons = buttonArray;
    if (self) {
        // Initialization code
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        coverView.backgroundColor = [UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:0.6f];
        [coverView addGestureRecognizer:tap];
//        coverView.backgroundColor = [UIColor cyanColor];
        coverView.hidden = YES;
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"sharebg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:110]];
        self.backgroundImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundImageView];

        for (int i = 0; i < [self.buttons count]; i++) {
            CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
            button.imgButton.tag = i;
            [button.imgButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: button];
        }
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"share_close"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        // @"分享"
        NSString *shareActionSheet_shareLabel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"shareActionSheet_shareLabel_title"];
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.text = shareActionSheet_shareLabel_title;
        _shareLabel.textAlignment = NSTextAlignmentCenter;
        _shareLabel.textColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
        _shareLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_shareLabel];
        
    }
    return self;
}


-(void)dealloc
{
    self.buttons = nil;
    self.backgroundImageView = nil;
   
}

-(void)setPositionInView:(UIView *)view
{
    if([self.buttons count] == 0)
    {
        return;
    }
    float buttonWidth = ((CustomActionSheetButton *)[self.buttons objectAtIndex:0]).frame.size.width;
    float buttonHeight = ((CustomActionSheetButton *)[self.buttons objectAtIndex:0]).frame.size.height;
    
    self.frame = CGRectMake(0.0f, view.frame.size.height, view.frame.size.width,bottomHeight + headerHeight + (buttonHeight + intervalWithButtonsY)*(([self.buttons count]-1)/buttonCountPerRow + 1));

    self.backgroundImageView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    float beginX = (self.frame.size.width - (intervalWithButtonsX * (buttonCountPerRow - 1) + buttonWidth * buttonCountPerRow))/2;
    
    _shareLabel.frame = CGRectMake(cancelButtonHeight+10, 10, self.frame.size.width-(cancelButtonHeight+10)*2, cancelButtonHeight);
    
    cancelButton.frame = CGRectMake(self.frame.size.width-cancelButtonHeight-10,
                                  10,cancelButtonHeight, cancelButtonHeight);
    
    if ([self.buttons count] > buttonCountPerRow) {
        for (int i = 0; i < [self.buttons count]; i++) {
            CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
            button.frame = CGRectMake(beginX + i%buttonCountPerRow*(buttonWidth + intervalWithButtonsX),
                                      headerHeight + i/buttonCountPerRow*(buttonHeight + intervalWithButtonsY) +10,     buttonWidth, buttonHeight);
        }
    }
    else
    {
        float intervalX = (self.frame.size.width - beginX*2 - buttonWidth*[self.buttons count])/([self.buttons count] - 1);
        for (int i = 0; i < [self.buttons count]; i++) {
            CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
            button.frame = CGRectMake(beginX + i%buttonCountPerRow*(buttonWidth + intervalX),
                                      headerHeight + i/buttonCountPerRow*(buttonHeight + intervalWithButtonsY), buttonWidth, buttonHeight);
        }
    }

}


-(void)showInView:(UIView *)view
{
    [self setPositionInView:view];
    [view addSubview:coverView];
    [view addSubview:self];
    [UIView beginAnimations:@"ShowCustomActionSheet" context:nil];
    self.frame = CGRectMake(0.0f, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    coverView.hidden = NO;
    [UIView commitAnimations];
}
-(void)dissmiss
{
    [UIView beginAnimations:@"DismissCustomActionSheet" context:nil];
    self.frame = CGRectMake(0.0f, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(sheetDidDismissed)];
    coverView.hidden = YES;
    [UIView commitAnimations];
}

-(void)sheetDidDismissed
{
    [coverView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)buttonAction:(UIButton *)button
{
//    NSLog(@"index:%ld",(long)button.tag);
    if([delegate respondsToSelector:@selector(choseAtIndex:)])
    {
        [delegate choseAtIndex:button.tag];
    }
    [self dissmiss];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


@implementation CustomActionSheetButton
@synthesize imgButton;
@synthesize titleLabel;
-(id)init
{
    if(self)
    {
        
        self = nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomActionSheetButton" owner:self options:nil] objectAtIndex:0];
    for (id obj in self.subviews) {
        if([obj isKindOfClass:[UIButton class]])
        {
            self.imgButton = obj;
        }
        else if([obj isKindOfClass:[UILabel class]])
        {
            self.titleLabel = obj;
        }
    }
    return self;
}

+(CustomActionSheetButton *)buttonWithImage:(UIImage *)image title:(NSString *)title
{
    CustomActionSheetButton * button = [[CustomActionSheetButton alloc] init] ;
    [button.imgButton setBackgroundImage:image forState:UIControlStateNormal];
    button.titleLabel.text = title;
    return button;
}

-(void)dealloc
{
    self.titleLabel = nil;
    self.imgButton = nil;
}
@end
