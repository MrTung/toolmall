//
//  ProdInfoImage.m
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "ProdInfoImage.h"

@interface ProdInfoImage ()

@end

@implementation ProdInfoImage
@synthesize image;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = _frame;
    self.image.frame = _frame;
    self.image.placeholderImage = [UIImage imageNamed:@"index_defImage"];
    self.image.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
