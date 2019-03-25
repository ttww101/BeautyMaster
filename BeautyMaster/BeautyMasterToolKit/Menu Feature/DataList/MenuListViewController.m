#import "MenuListViewController.h"
#import "InfoDetailViewController.h"

@interface MenuListViewController ()
{
    NSString *name;
    NSString *url;
    NSMutableArray *resultArray;
    NSInteger page;
}
@end

@implementation MenuListViewController


-(id)initWithURL:(NSString *)__url AndName:(NSString *)__name {
    self = [super init];
    if (self) {
        //左侧按钮
        name = __name;
        url = __url;
        self.navigationItem.title = name;
    }
    return self;
}


-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if(self!=[self.navigationController.viewControllers objectAtIndex:0]){
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        }else{
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
        }
    
    // iOS9
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.922 alpha:1];
    
    
    resultArray = [[NSMutableArray alloc] initWithCapacity:20];
    page = 1;
    
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = 64;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    __weak typeof(self) weakSelf = self;
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView triggerPullToRefresh];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    self.tableView.showsInfiniteScrolling = NO;
    
    self.tableView.pullToRefreshView.arrowColor = [UIColor grayColor];
    self.tableView.pullToRefreshView.textColor = [UIColor grayColor];
    self.tableView.pullToRefreshView.activityIndicatorViewColor = [UIColor grayColor];
    self.tableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新数据" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"松开开始加载" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"加载中" forState:SVPullToRefreshStateLoading];
    
    self.tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    

}

-(void)refresh {
    page = 1;
    [resultArray removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
}


-(void)loadMore {
    page ++;
    [self loadData];
}


- (void)loadData{
        
    NSString *urlString = [NSString stringWithFormat:@"%@",url,(long)page,MAX_PAGE_COUNT];
    
    __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    __weak ASIHTTPRequest *request = requests;
    [request setCompletionBlock:^{
        
        NSData *responseData = [request responseData];
        NSDictionary *wdic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        
//        if ([[wdic objectForKey:@"resultCount"] integerValue]>0) {
        id value = [wdic objectForKey:@"list"];
        value = [[value firstObject] objectForKey:@"list"];
        [resultArray addObjectsFromArray:value];
//        }
        [self.tableView reloadData];
        self.tableView.showsInfiniteScrolling = ([wdic objectForKey:@"totalpage"] == [wdic objectForKey:@"nowpage"]) ? NO : YES;
        if (page==1) {
            [self.tableView.pullToRefreshView stopAnimating];
        }else{
            [self.tableView.infiniteScrollingView stopAnimating];
        }
    }];
    [request setFailedBlock:^{
        if (page==1) {
            [self.tableView.pullToRefreshView stopAnimating];
        }else{
            [self.tableView.infiniteScrollingView stopAnimating];
        }
    }];
    [request startAsynchronous];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        cell.textLabel.textColor = [UIColor colorWithRed:55.0/255 green:55.0/255 blue:55.0/255 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 16 :18];
        
    }
    
    
    NSDictionary *info = [resultArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [info objectForKey:@"title"];//标题
    
    if (([info objectForKey:@"thumb"]!=nil && ![[info objectForKey:@"thumb"] isEqualToString:@""])) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder-news.png"]];
        cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        float sw=70/cell.imageView.image.size.width;
        float sh=53/cell.imageView.image.size.height;
        cell.imageView.transform=CGAffineTransformMakeScale(sw,sh);
        
    }else{
        cell.imageView.image = nil;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InfoDetailViewController *cc = [[InfoDetailViewController alloc] initWithIndex:[[resultArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
    [self.navigationController pushViewController:cc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
