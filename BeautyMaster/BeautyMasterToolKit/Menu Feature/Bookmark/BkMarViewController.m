#import "BkMarViewController.h"
#import "InfoDetailViewController.h"

@interface BkMarViewController ()
{
    NSMutableArray *resultArray;
}
@end

@implementation BkMarViewController

- (id)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = NSLocalizedString(@"我的收藏",nil);
    }
    return self;
}

#pragma mark -
#pragma mark buttonAction methods
- (void)backAction{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [resultArray removeAllObjects];
    
    NSMutableDictionary *favs = [[NSMutableDictionary alloc] initWithCapacity:10];
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]) {
        [favs setDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]];
    }
    
    
    for (NSString *key in favs) {
        [resultArray addObject:@[key,favs[key]]];
    }
    
    
    [self.tableView reloadData];
    
    if (resultArray.count == 0) {
        self.navigationItem.title = @"暂无收藏";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    // iOS9
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    if(self!=[self.navigationController.viewControllers objectAtIndex:0]){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    }

    
    resultArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = 64;
        insets.bottom = self.tabBarController.tabBar.bounds.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"编辑",nil)
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(Edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

-(void)Edit:(id)sender {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self.tableView reloadData];
    
    if (self.tableView.editing)
    {
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"完成",nil)];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"编辑",nil)];
    }
}

#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        cell.textLabel.textColor = [UIColor colorWithRed:55.0/255 green:55.0/255 blue:55.0/255 alpha:1.0];
        cell.textLabel.shadowColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        
    }
    
    cell.textLabel.text = [[resultArray objectAtIndex:indexPath.row] objectAtIndex:1];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InfoDetailViewController *cc = [[InfoDetailViewController alloc] initWithIndex:[[resultArray objectAtIndex:indexPath.row] objectAtIndex:0]];
    [self.navigationController pushViewController:cc animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableDictionary *favs = [[NSMutableDictionary alloc] initWithCapacity:10];
        if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]) {
            [favs setDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]];
        }
        [favs removeObjectForKey:[[resultArray objectAtIndex:indexPath.row] objectAtIndex:0]];
        
        [[NSUserDefaults standardUserDefaults] setObject:favs forKey:@"bookmark"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [resultArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (resultArray.count == 0) {
            self.navigationItem.title = @"暂无收藏";
        }

    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
