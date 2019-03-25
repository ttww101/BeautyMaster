//
//  MoreViewController.m
//  iCaipu
//
//  Created by 商攀峰 on 14-9-10.
//  Copyright (c) 2014年 www.ipadown.com. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "FileSize.h"
#import "MoreAppCell.h"

#import "BkMarViewController.h"
#import "MBProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <StoreKit/StoreKit.h>

@interface MoreInfoViewController ()<MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>
{
    NSArray *resultArray;
    NSMutableArray *appArray;
}
@end

@implementation MoreInfoViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.title = @"更多";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];

    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // iOS9
    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
    self.tableView.backgroundView = nil;
    
    appArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    
    resultArray = [[NSArray alloc] initWithObjects:
                   [NSArray arrayWithObjects:
                    [NSArray arrayWithObjects:@"我的收藏",@"plugin_icon_star",nil],
                    nil],
                   [NSArray arrayWithObjects:
                    [NSArray arrayWithObjects:@"清空缓存",@"plugin_icon_setting",nil],
                    nil],
                   [NSArray arrayWithObjects:
                    //[NSArray arrayWithObjects:@"关于我们",@"plugin_icon_info",nil],
//                    [NSArray arrayWithObjects:@"意见建议反馈",@"plugin_icon_message",nil],
                    [NSArray arrayWithObjects:@"为我们打分",@"plugin_icon_rated",nil],
                    nil],
                   
                   nil];
    
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    
    UILabel *tt = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.tableView.frame.size.width, 20)];
    tt.autoresizingMask = UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleBottomMargin + UIViewAutoresizingFlexibleLeftMargin +UIViewAutoresizingFlexibleRightMargin;
    tt.text = [NSString stringWithFormat:@"Build Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    tt.textAlignment = NSTextAlignmentCenter;
    tt.font = [UIFont systemFontOfSize:12.0f];
    tt.textColor = [UIColor lightGrayColor];
    tt.backgroundColor = [UIColor clearColor];
    [footer addSubview:tt];
    self.tableView.tableFooterView = footer;
    
    
    if (appArray.count == 0) {
        [self loadData];
    }
    
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return appArray.count<2?3:4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return  section == 3 ? appArray.count : [[resultArray objectAtIndex:section] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[NSArray arrayWithObjects:@"个人收藏",@"系统设置",@"建议反馈",@"应用推荐", nil] objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 3) {
        static NSString *CellIdentifier = @"TableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSArray *data = [[resultArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = [data objectAtIndex:0];
        cell.imageView.image = [UIImage imageNamed:[data objectAtIndex:1]];
        float sw = 30/cell.imageView.image.size.width;
        float sh = 30/cell.imageView.image.size.height;
        cell.imageView.transform=CGAffineTransformMakeScale(sw,sh);

        
        if (indexPath.section==1 && indexPath.row==0) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cacheDirectory = [paths objectAtIndex:0];
            cell.detailTextLabel.text = [FileSize stringFolderSizeAtPath:cacheDirectory];
        }else{
            cell.detailTextLabel.text = nil;
        }
        
        return cell;
        
    }else if (indexPath.section == 3){
        static NSString *MyIdentifier = @"AppCell";
        MoreAppCell *cell = (MoreAppCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier]; // changed this
        if (cell == nil) {
            cell = [[MoreAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier]; // changed this
            cell.accessoryType = UITableViewCellAccessoryNone;
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *app = [appArray objectAtIndex:indexPath.row];
        [cell setAppData:app AtIndex:(indexPath.row+1)];
        
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3 && appArray.count==0) {
        return 40;
    }
    return 0;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section==3 && appArray.count==0) {
//        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,40)];
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityView.frame = CGRectMake((self.tableView.frame.size.width-40)/2, 0, 40, 40);
//        [cell addSubview:activityView];
//        [activityView startAnimating];
//        return cell;
//    }
//    return nil;
//}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	return (indexPath.section == 3) ? 70 :50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            BkMarViewController *bk = [[BkMarViewController alloc] init];
            [self.navigationController pushViewController:bk animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
#if NS_BLOCKS_AVAILABLE
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud];
            hud.labelText = @"清理缓存";
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.minShowTime = 2;
            [hud showAnimated:YES whileExecutingBlock:^{
                NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                //NSLog(@"files :%d",[files count]);
                for (NSString *p in files) {
                    NSError *error;
                    NSString *path = [cachPath stringByAppendingPathComponent:p];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    }
                }
                hud.mode = MBProgressHUDModeText;
                //hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.labelText = @"清理完成";
            } completionBlock:^{
                [hud removeFromSuperview];
                [self.tableView reloadData];
            }];
#endif
        }
    }else if (indexPath.section==2){
        if (indexPath.row == 10){
            NSString *urlString = [NSString stringWithFormat:@"http://iapi.ipadown.com/api/i/aboutus.php?channel=app4life&version=%@&appname=%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            TOWebViewController *url = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
            url.hidesBottomBarWhenPushed = YES;
            [[self navigationController] pushViewController:url animated:YES];
        }
//        else if (indexPath.row == 0){
//            @try{
//                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
//                if (!mail) {
//                    
//                    NSLog(@"设备还没有添加邮件账户");
//                }else{
//                    mail.mailComposeDelegate = self;
//                    mail.navigationBar.tintColor = [UIColor clearColor];
//                    if ([MFMailComposeViewController canSendMail]) {
//                        [mail setToRecipients:[NSArray arrayWithObjects:ADMIN_EMAIL,nil]];
//                        [mail setSubject:[NSString stringWithFormat:@"%@ 意见反馈",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]]];
//                        [mail setMessageBody:@"" isHTML:YES];
//                        [self presentViewController:mail animated:YES completion:^{
//                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//                        }];
//                    }
//                }
//            }
//            @catch (NSException *exception){
//                NSLog(@"%s\n%@", __FUNCTION__, exception);
//            }
//        }
        else if (indexPath.row == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d?mt=8", APP_ID]]];
        }
    }else if (indexPath.section == 2){
        NSLog([[appArray objectAtIndex:indexPath.row] objectForKey:@"app_id"]);
        [self openAppWithId:[[appArray objectAtIndex:indexPath.row] objectForKey:@"app_id"]];
    }
}


- (void)openAppWithId:(NSString *)_appId {
    
    Class storeVC = NSClassFromString(@"SKStoreProductViewController");
    if (storeVC != nil) {
        SKStoreProductViewController *_SKSVC = [[SKStoreProductViewController alloc] init];
        _SKSVC.delegate = self;
        [_SKSVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId}
                          completionBlock:^(BOOL result, NSError *error) {
                              if (result) {
                                  [self presentViewController:_SKSVC animated:YES completion:nil];
                              }
                              else{
                                  NSLog(@"error:%@",error);
                              }
                          }];
    }
    else{
        //低于iOS6没有这个类
        NSString *_idStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",_appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_idStr]];
    }
}
#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
}


#pragma mark -
#pragma mark MessagesUI delegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮件发送失败,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(void)loadData{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app4life.mobi/applist.php?format=json&from=%@&version=%@&device=%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"iPhone":@"iPad")]];
    //NSLog(@"%@",url);
    
    __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = requests;
    [request setCompletionBlock:^{
        NSData *responseData = [request responseData];
        appArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"%@",appArray);
        [self.tableView reloadData];
        
    }];
    [request setFailedBlock:^{
        //NSError *error = [request error];
    }];
    [request startAsynchronous];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }
    
    return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.tableView reloadData];
    
}

@end
