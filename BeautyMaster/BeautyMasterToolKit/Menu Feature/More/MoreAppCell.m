#import "MoreAppCell.h"
#import "UIImageView+WebCache.h"

@implementation MoreAppCell

@synthesize iconView,nameLabel,descLabel,commendView,commendLabel,priceButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIndentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIndentifier]) {
        
        iconView = [[UIImageView alloc] init];
        iconView.frame = CGRectMake(10,6.5, 57, 57);
        iconView.layer.cornerRadius = 12.0f;
        iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:iconView];
        //图标
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 8.0f, self.contentView.frame.size.width - 125, 15.0f)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:nameLabel];
        //名称
				    
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 30.0f, self.contentView.frame.size.width - 125, 36)];
        descLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = [UIFont systemFontOfSize:12];
        descLabel.numberOfLines = 2;
        descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descLabel.textColor = [UIColor lightGrayColor];
        descLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:descLabel];
        //简介
        
        
        commendView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 40, 8, 30, 14)];
        commendView.backgroundColor = [UIColor redColor];
        commendView.layer.cornerRadius = 2.0f;
        commendView.layer.masksToBounds = YES;
        [self.contentView addSubview:commendView];
        
        commendLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width -40, 8, 30, 14)];
        commendLabel.backgroundColor = [UIColor clearColor];
        commendLabel.font = [UIFont systemFontOfSize:10];
        commendLabel.textColor = [UIColor whiteColor];
        commendLabel.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        commendLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:commendLabel];
        //是否推荐
        
        
        priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        priceButton.frame = CGRectMake ((self.contentView.frame.size.width - 40) , 30.0f, 30.0f, 16.0f);
        priceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin  +UIViewAutoresizingFlexibleBottomMargin;
        priceButton.backgroundColor = [UIColor colorWithRed:0.92 green:0.19 blue:0.52 alpha:1];
        priceButton.layer.cornerRadius = 2.0f;
        priceButton.layer.masksToBounds = YES;
        [priceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        priceButton.titleLabel.font = [UIFont systemFontOfSize:10];
        priceButton.userInteractionEnabled = NO;
        [self.contentView addSubview:priceButton];
        
        
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setAppData:(NSDictionary *)app AtIndex:(NSInteger)index
{
    [iconView sd_setImageWithURL:[NSURL URLWithString:[app objectForKey:@"app_icon"]] placeholderImage:[UIImage imageNamed:@"app_placeholder_icon.png"]];
    
    CGSize labelSize = [[app objectForKey:@"app_name"] sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                                  constrainedToSize:CGSizeMake(300, MAXFLOAT)
                                                      lineBreakMode:NSLineBreakByCharWrapping];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        float xx = 0;
        if (labelSize.width  >= self.contentView.frame.size.width - 125) {
            xx = self.contentView.frame.size.width - 125;
        }else{
            xx = labelSize.width;
        }
        
        nameLabel.frame = CGRectMake(80.0f, 8.0f, xx, 15.0f);
        nameLabel.text = [app objectForKey:@"app_name"];//app名称
        descLabel.text = [app objectForKey:@"app_desc"];//app简介
        
        if ([[app objectForKey:@"app_commend"] integerValue] == 1) {
            commendView.backgroundColor = [UIColor redColor];
            commendLabel.text = @"热门";//推荐app
            commendView.frame = CGRectMake(xx + 80.0 + 10, 8, 30, 14);
            commendLabel.frame = CGRectMake(xx + 80.0 + 10, 8, 30, 14);
        }else{
            commendView.backgroundColor = [UIColor clearColor];
            commendLabel.text = @"";
            
        }
        
    }else{
        
        nameLabel.frame = CGRectMake(80.0f, 8.0f, labelSize.width, 15.0f);
        nameLabel.text = [app objectForKey:@"app_name"];//app名称
        descLabel.text = [app objectForKey:@"app_desc"];//app简介
        
        if ([[app objectForKey:@"app_commend"] integerValue] == 1) {
            commendView.backgroundColor = [UIColor redColor];
            commendLabel.text = @"热门";//推荐app
            commendView.frame = CGRectMake(labelSize.width + 80.0 + 10, 8, 30, 14);
            commendLabel.frame = CGRectMake(labelSize.width + 80.0 + 10, 8, 30, 14);
        }else{
            commendView.backgroundColor = [UIColor clearColor];
            commendLabel.text = @"";
            
        }
    }
    
    
    if ([[app objectForKey:@"app_price"] integerValue] == 0) {
        [priceButton setTitle:@"免费" forState:UIControlStateNormal];
    }else{
        [priceButton setTitle:[NSString stringWithFormat:@"￥%ld",(long)[[app objectForKey:@"app_price"] integerValue]] forState:UIControlStateNormal];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
