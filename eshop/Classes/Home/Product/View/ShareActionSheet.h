
#import <UIKit/UIKit.h>

@protocol CustomActionSheetDelegate <NSObject>
@optional
-(void)choseAtIndex:(int)index;

@end

@interface ShareActionSheet : UIView
{
    UIButton * cancelButton;
    UIView * coverView;
}
@property(nonatomic,strong)UILabel * shareLabel;
@property(nonatomic,strong)NSArray * buttons;
@property(nonatomic,strong)UIImageView * backgroundImageView;
@property(nonatomic,weak)id<CustomActionSheetDelegate> delegate;
-(id)initWithButtons:(NSArray *)buttons;
-(void)showInView:(UIView *)view;
-(void)dissmiss;
@end


@interface CustomActionSheetButton : UIView
@property(nonatomic,strong)UIButton * imgButton;
@property(nonatomic,strong)UILabel * titleLabel;
+(CustomActionSheetButton *)buttonWithImage:(UIImage *)image title:(NSString *)title;
@end
