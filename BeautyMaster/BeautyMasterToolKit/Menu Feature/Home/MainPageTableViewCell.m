#import "MainPageTableViewCell.h"

@implementation MainPageTableViewCell

@synthesize iconView,nameLabel,cateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIndentifier {  
	if (self = [super initWithStyle:style reuseIdentifier:reuseIndentifier]) {		
		
		iconView = [[UIImageView alloc] init];
		iconView.frame = CGRectMake(10,14, 70, 53);
		//iconView.layer.cornerRadius = 10.0f;
		//iconView.layer.masksToBounds = YES;
		[self.contentView addSubview:iconView];
        
        
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 8, self.contentView.frame.size.width - 100, 42)];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.textAlignment = NSTextAlignmentLeft;
		nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
		nameLabel.numberOfLines = 2;
        nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        nameLabel.textColor = [UIColor colorWithWhite:0.1 alpha:0.9];
        nameLabel.shadowColor = [UIColor clearColor];
		nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 16 :18];
		[self.contentView addSubview:nameLabel];
		
            		
        cateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 55, 100, 17)];
		cateLabel.backgroundColor = [UIColor clearColor];
		cateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 12 :14];
		cateLabel.textColor = [UIColor grayColor];
        cateLabel.shadowColor = [UIColor clearColor];
		cateLabel.textAlignment = NSTextAlignmentLeft;
		cateLabel.lineBreakMode = NSLineBreakByWordWrapping;
		cateLabel.numberOfLines = 1;
		[self.contentView addSubview:cateLabel];
        
	}
	
	return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

-(void)setData:(NSDictionary *)info AtIndex:(NSInteger)index
{

    if ([info objectForKey:@"thumb"] != nil && ![[info objectForKey:@"thumb"] isEqualToString:@""]) {
        [iconView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder-news"]];
        iconView.frame = CGRectMake(10,14, 70, 53);
        nameLabel.frame = CGRectMake(90.0f, 8, self.contentView.frame.size.width - 100, 42);
        cateLabel.frame = CGRectMake(90.0f, 55, 100, 17);
    }else{
        iconView.frame = CGRectMake(0,0, 0, 0);
        nameLabel.frame = CGRectMake(10.0f, 8, self.contentView.frame.size.width - 20, 44);
        cateLabel.frame = CGRectMake(10.0f, 55, 100, 17);
    }
    
	nameLabel.text = [info objectForKey:@"title"];
	cateLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"subcatename"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
