#import <UIKit/UIKit.h>


@interface MoreAppCell : UITableViewCell


-(void)setAppData:(NSDictionary *)app AtIndex:(NSInteger)index;

@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *descLabel;
@property (nonatomic, retain) UIImageView *commendView;
@property (nonatomic, retain) UILabel *commendLabel;
@property (nonatomic, retain) UIButton *priceButton;

@end
