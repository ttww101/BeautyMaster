#import "LeftMenuViewController.h"
#import "MainPageViewController.h"
#import "MenuListViewController.h"
#import "MoreInfoViewController.h"
#import "BkMarViewController.h"

@interface LeftMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *resultArray;

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    self.resultArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20,60, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight + UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleBottomMargin;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollEnabled = YES;
        tableView;
    });
    [self.view addSubview:self.tableView];
    self.tableView.scrollsToTop = NO;
    
    // iOS9
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    if (self.resultArray.count == 0) {
        [self loadData];
    }

}


- (void)buildCate {
    UIButton *reloadDataBtn = [[UIButton alloc] initWithFrame:CGRectMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?20:50,120,200,100)];
    reloadDataBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin + UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleBottomMargin;
    [reloadDataBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
    [reloadDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reloadDataBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?20:28];
    reloadDataBtn.backgroundColor = [UIColor clearColor];
    reloadDataBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [reloadDataBtn addTarget:self action:@selector(reloadButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:reloadDataBtn];
}

-(void)reloadButtonPressed:(id)sender{
    UIButton *b = (UIButton *)sender;
    [b removeFromSuperview];
    
    [self loadData];
}


- (void)loadData{
    NSString *urlString = [LEFT_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    __weak ASIHTTPRequest *request = requests;
    [request setCompletionBlock:^{
        NSData *responseData = [request responseData];
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [self.resultArray addObjectsFromArray:[dataDic objectForKey:@"category"]];
        
        [self.tableView reloadData];
        
        float oneheight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 50 :70;
        self.tableView.frame = CGRectMake(20, (self.view.frame.size.height - [self.resultArray count]* oneheight)/2.0 , self.view.frame.size.width, [self.resultArray count]* oneheight);
        
        if ([self.resultArray count]* oneheight > self.view.frame.size.height) {
            self.tableView.frame = CGRectMake(20, 20 , self.view.frame.size.width, self.view.frame.size.height - 20);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if(error) {
            NSLog(@"左侧栏加载失败:%@", [error localizedDescription]);
        }
        [self buildCate];
    }];
    [request startAsynchronous];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 50 : 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 18 :18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){

            UIImageView *segline = [[UIImageView alloc] initWithFrame:CGRectMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?40 :60, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?44:59, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?120:140, 1)];
            segline.image = [UIImage imageNamed:@"line"];
            segline.alpha = 0.6;
            [cell.contentView addSubview:segline];
            
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?160:190,(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 20 :30, 6, 10)];
            arrow.image = [UIImage imageNamed:@"arrow_details"];
            [cell.contentView addSubview:arrow];
        }
    }
    
    
    NSDictionary *data = [self.resultArray objectAtIndex:indexPath.row];
    
    if ([[data objectForKey:@"title"] length] <= 6) {
        cell.textLabel.text = [data objectForKey:@"title"];
    } else {
        cell.textLabel.text = [[data objectForKey:@"title"] substringToIndex:6];
    }
    
    return cell;
}


#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *selectViewController;
    
    if ([[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"index"]) {
        //首頁
        selectViewController = [[MainPageViewController alloc] init];
        
    } else if ([[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"list"]) {
        //資料頁
        selectViewController = [[MenuListViewController alloc] initWithURL:[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"apiurl"] AndName:[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [self.sideMenuViewController hideMenuViewController];
    } else if ([[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"fav"]) {
        //收藏
        selectViewController = [[BkMarViewController alloc] init];
        [self.sideMenuViewController hideMenuViewController];
    } else if ([[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"more"]) {
        //更多
        selectViewController = [[MoreInfoViewController alloc] init];
        [self.sideMenuViewController hideMenuViewController];
    } else if ([[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"url"]) {
        //?
        selectViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:[[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"apiurl"]]];
    } else {
        NSLog(@"empty select");
    }
    
    if (selectViewController != nil) {
        [self.sideMenuViewController setContentViewController:[[MLNavigationController alloc] initWithRootViewController:selectViewController] animated:YES];
    }
    [self.sideMenuViewController hideMenuViewController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

@end
