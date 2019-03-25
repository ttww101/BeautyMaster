#import "InfoDetailViewController.h"

#import "PhotoViewer.h"
#import "MBProgressHUD.h"
#import "KLCPopup.h"
#import "TalkingData.h"
#import <GoogleMobileAds/GADInterstitial.h>


typedef NS_ENUM(NSInteger, FontSizeChangeType) {
    FontSizeChangeTypeIncrease,
    FontSizeChangeTypeDecrease,
    FontSizeChangeTypeNone
};


@interface InfoDetailViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate, GADInterstitialDelegate> {
    NSString *index;
    UIWebView *webView;
    NSUInteger _currentFontSize;
    UIActivityIndicatorView *activityView;
    KLCPopup *popupAd;
    NSString *gotoUrl;
    
    GADInterstitial *_interstitial;
}


- (void)dismissButtonPressed:(id)sender;
- (void)gotoAdView:(id)sender;

@end

@implementation InfoDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // talking data 页面进入统计
    [TalkingData trackPageBegin:@"Etrance_Detail_Page_Framework_1"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // talking data 页面退出统计
    [TalkingData trackPageEnd:@"Exit_Detail_Page_Framework_1"];
}


- (void)dismissButtonPressed:(id)sender {
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
}

-(void) uploadIDFAData:(NSString*)gotoUrl {
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *_gotoUrl = [gotoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *_client_id = [appDelegate.clientIDFAInfo objectForKey:@"1"];
    
    NSString *rawData = [NSString stringWithFormat:@"%@%@G%@G%@G%@", STAT_INFO_URL, @"2", _client_id, appDelegate.idfa, _gotoUrl];
    
    __block ASIHTTPRequest *requests = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[rawData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    __weak ASIHTTPRequest *request = requests;
    [request setCompletionBlock:^{
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if (error) {
            NSLog(@"上传统计数据错误:%@", [error localizedDescription]);
        }
    }];
    [request startAsynchronous];
}


- (void)gotoAdView:(id)sender {
    [popupAd dismissPresentingPopup];
    
    // 统计数据
    [TalkingData trackEvent:@"Popup_AD_Touch" label:gotoUrl];
    [self uploadIDFAData:gotoUrl];
    
    if([gotoUrl hasPrefix:@"https://ituns"]){
        // 跳转到itunes
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[gotoUrl stringByReplacingOccurrencesOfString:@"https" withString:@"itms-apps"]]];
    }else{
        // 跳转到网页
        TOWebViewController *dd = [[TOWebViewController alloc] initWithURLString:gotoUrl];
        [self.navigationController pushViewController:dd animated:YES];
    }
}


- (id)initWithIndex:(NSString *)__index {
    self = [super init];
    if (self) {
        index = __index;
        
        self.navigationItem.title = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] stringByAppendingString:@" - 详情"];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
        
    }
    return self;
}

-(void)backAction {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadRequest) object:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ftsz"] == nil)
    {
        _currentFontSize = 100;
    }
    else
    {
        _currentFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"ftsz"];
    }
    

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f,0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight + UIViewAutoresizingFlexibleWidth;
	[webView setUserInteractionEnabled:YES];
	[webView setBackgroundColor:[UIColor clearColor]];
	[webView setDelegate:self];
	[webView setOpaque:NO];
    webView.dataDetectorTypes=0;

    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@?p=%@",SHOW_URL,index]];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    
    
    for (UIView* subView in [webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
    
    //双指调整字体
    UIPinchGestureRecognizer *pin;
    pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(fontSizePinch:)];
    [pin setDelegate:self];
    [webView addGestureRecognizer:pin];
    
    UITapGestureRecognizer *imageTapDetector = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [imageTapDetector setNumberOfTapsRequired:1];
    [imageTapDetector setDelegate:self];
    [imageTapDetector setDelaysTouchesBegan:YES];
    [webView addGestureRecognizer:imageTapDetector];
    
    //计数器
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:@"count"] + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"count"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.view addSubview:webView];
    
    //google广告
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appDelegate.googleAdSwitch)
    {
        if (_interstitial) {
            _interstitial.delegate = nil;
            _interstitial = nil;
        }
        //interstitial
        _interstitial = [[GADInterstitial alloc] initWithAdUnitID:kAdMobInterstitialKey];
        _interstitial.delegate = self;
        
        int i = arc4random() % 3;
        
        if (i == 0) {
            GADRequest *request = [GADRequest request];
            [_interstitial loadRequest:request];
        }

    }
    
    [self performSelector:@selector(loadRequest) withObject:nil afterDelay:15.f];
}

- (void)loadRequest
{
    if (_interstitial) {
        _interstitial.delegate = nil;
        _interstitial = nil;
    }
    //interstitial
    _interstitial = [[GADInterstitial alloc] initWithAdUnitID:kAdMobInterstitialKey];
    _interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [_interstitial loadRequest:request];
}

- (void)setADPopup:(NSData *) rawJSONData{
    // 解析pop广告栏数据
    NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:rawJSONData options:NSJSONReadingMutableLeaves error:nil];
    
    if([[ret objectForKey:@"list"] count] <= 0) {
        return;
    }
    
    gotoUrl = [[[ret objectForKey:@"list"] objectAtIndex:0] objectForKey:@"ad_url"];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.layer.cornerRadius = 12.0;
    UITapGestureRecognizer *clickEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAdView:)];
    [contentView addGestureRecognizer:clickEvent];
    
    NSURL *imageUrl = [NSURL URLWithString:[[[ret objectForKey:@"list"] objectAtIndex:0] objectForKey:@"img_url"]];
    UIImage *tmpImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:tmpImg];
    imageView.frame = CGRectMake(15, 35, kDeviceWidth - 30, KDeviceHeight - 45);

    UIButton* dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    UIImage *closeIconImg = [UIImage imageNamed:@"close_icon.png"];
    UIImageView *closeIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 30, 30)];
    closeIconImgView.image = closeIconImg;
    
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissButton setTitleColor:[[dismissButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    dismissButton.layer.cornerRadius = 6.0;
    [dismissButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton addSubview:closeIconImgView];
    [dismissButton setFrame:CGRectMake(0, 0, 200, 200)];
    [dismissButton setContentMode:UIViewContentModeCenter];
    
    [contentView addSubview:imageView];
    [contentView addSubview:dismissButton];
    
    popupAd = [KLCPopup popupWithContentView:contentView];
    [popupAd show];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)tapDetected:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        CGPoint touchPoint = [tap locationInView:self.view];
        NSString *imageURL = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y]];
        static NSSet *imageFormats;
        if (!imageFormats.count) {
            imageFormats = [NSSet setWithObjects:@"jpg",@"jpeg",@"bmp",@"png",nil];
        }
        if ([imageFormats containsObject:imageURL.pathExtension]) {
            PhotoViewer *photoview = [[PhotoViewer alloc]init];
            [photoview.view setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
            [self presentViewController:photoview animated:YES completion:nil];
            photoview.imgUrl = imageURL;
            [photoview fadeIn];
        }
    }
}


- (void)fontSizePinch:(id)sender {
    UIPinchGestureRecognizer *pinch = sender;
    if (pinch.state == UIGestureRecognizerStateRecognized)
    {
        [self changeFontSize:(pinch.scale > 1)?FontSizeChangeTypeIncrease:FontSizeChangeTypeDecrease];
    }
}


- (void)changeFontSize:(FontSizeChangeType)changeType {
    if (changeType == FontSizeChangeTypeIncrease && _currentFontSize == 160) return;
    if (changeType == FontSizeChangeTypeDecrease && _currentFontSize == 50) return;
    if (changeType != FontSizeChangeTypeNone)
    {
        _currentFontSize = (changeType == FontSizeChangeTypeIncrease) ? _currentFontSize + 5 : _currentFontSize - 5;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentFontSize forKey:@"ftsz"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%lu%%'",
                          (unsigned long)_currentFontSize];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    webView.frame = CGRectMake(0.0f,0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [webView reload];
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)theRequest navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *url = theRequest.URL.absoluteString;
        if ([url hasPrefix:@"https://itunes.apple.com/"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else if ([url hasPrefix:@"bookmark://"]) {
            [self addBookmark:[url substringFromIndex:11]];
        }else if ([url hasPrefix:@"deletebookmark://"]) {
            [self deleteBookmark:[url substringFromIndex:17]];
        }else if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]){
            TOWebViewController *cc = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            [self.navigationController pushViewController:cc animated:YES];
        }
        return NO;
    }
    return YES;
}


-(void)deleteBookmark:(NSString *)__bookmarkid {
    NSMutableDictionary *favs = [[NSMutableDictionary alloc] initWithCapacity:10];
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]) {
        [favs setDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]];
    }
    [favs removeObjectForKey:__bookmarkid];
    
    [[NSUserDefaults standardUserDefaults] setObject:favs forKey:@"bookmark"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('bookmark').innerHTML = '收藏';document.getElementById('bookmark').href = 'bookmark://%@';",__bookmarkid]];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"取消收藏成功!";
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
    
}


-(void)addBookmark:(NSString *)__bookmarkid {
    NSMutableDictionary *favs = [[NSMutableDictionary alloc] initWithCapacity:10];
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]) {
        [favs setDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]];
    }
    
    if ([favs objectForKey:__bookmarkid]) {
        return ;
    }else{
        NSString *newstitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [favs setObject:newstitle forKey:__bookmarkid];
        
        [[NSUserDefaults standardUserDefaults] setObject:favs forKey:@"bookmark"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('bookmark').innerHTML = '已收藏';document.getElementById('bookmark').href = 'deletebookmark://%@';",__bookmarkid]];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"收藏成功!";
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    // Set custom view mode
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
    
}


-(void)checkBookmark:(NSString *)__bookmarkid {
    NSMutableDictionary *favs = [[NSMutableDictionary alloc] initWithCapacity:10];
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]) {
        [favs setDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bookmark"]];
    }
    
    if ([favs objectForKey:__bookmarkid]) {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('bookmark').innerHTML = '已收藏';document.getElementById('bookmark').href = 'deletebookmark://%@';",__bookmarkid]];
    }else{
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('bookmark').innerHTML = '收藏';document.getElementById('bookmark').href = 'bookmark://%@';",__bookmarkid]];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)awebView {
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(0, 0, 24, 24);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [activityView startAnimating];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if(appDelegate.isFirstStart){
        [self setADPopup:appDelegate.popupRawJSON];
        appDelegate.isFirstStart = NO;
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)awebView {
    
    [activityView stopAnimating];
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%lu%%'",(unsigned long)_currentFontSize];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [awebView stringByEvaluatingJavaScriptFromString:@"{\
     var b = document.getElementsByTagName('a'); \
     for (var j=0; j<b.length; j++) \
     b[j].target = '_self';\
     }"];
    
    [self checkBookmark:[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('newsid').value"]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleBordered target:self action:@selector(share)];
    
}


-(void)share {
    NSString *newsTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *newsUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setValue:[NSString stringWithFormat:@"%@\n%@",newsTitle,newsUrl] forPasteboardType:@"public.utf8-plain-text"];
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"亲，内容已复制到粘贴板，你可以随意分享到QQ，微信，微博...(打开对应的App输入框长按即可粘贴)"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil //@"分享到QQ"
                                  otherButtonTitles:/*@"分享到微信或微信朋友圈",
                                  @"分享到QQ空间",
                                  @"分享到微博",*/
                                  nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    return ;
}

- (void)backAction:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)backIndexAction:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    return YES;
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [_interstitial presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    
}

@end
