//
//  PhotoViewer.m
//  NetDemo
//
//  Created by 海锋 周 on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewer.h"

@interface PhotoViewer()
-(void) BtnClicked:(id)sender;
-(void)handlePan:(UIPanGestureRecognizer *)recognizer;
-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo;
@end

@implementation PhotoViewer
@synthesize imgUrl,imageView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        roation = 0;
        scale = 1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadPad{
    
    //BOOL HENG = (self.interfaceOrientation != UIInterfaceOrientationPortrait && self.interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)  ? YES :  NO;
    
    UIView *aa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2048, 2048)];
    aa.backgroundColor =  [UIColor blackColor];
    [self.view addSubview:aa];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder-news"]];
    
    [imageView setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin + UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleBottomMargin];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setFrame:CGRectMake((self.view.frame.size.width-200)/2,(self.view.frame.size.height-200)/2,200,100)];
    [self.view addSubview:imageView];
    
    
    UIView *toolView = [[UIView alloc] init];
    toolView.frame = CGRectMake(10, self.view.frame.size.height - 150, self.view.frame.size.width - 20, 100);
    toolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin;
    toolView.backgroundColor = [UIColor clearColor];
    
    float xx = (toolView.frame.size.width - 4*50)/5.0;
    NSArray *array = [NSArray arrayWithObjects:@"rotate_left",@"rotate_right",@"zoom_in",@"zoom_out",nil];
    for (int i=0; i<[array count]; i++)
    {
        UIImage *normal = [UIImage imageNamed:[array objectAtIndex:i]];
        UIImage *active = [[UIImage imageNamed:@"imageviewer_toolbar_background.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((50 + xx)*i+xx,25,50,50)];
        [btn setImage:normal forState:UIControlStateNormal];
        [btn setBackgroundImage:active forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [btn setBackgroundColor:[UIColor clearColor]];
        [toolView addSubview:btn];
    }
    
    [self.view addSubview:toolView];
    
    
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(40,50,50,50)];
    [backbtn setImageEdgeInsets:UIEdgeInsetsMake(0,2,0,0)];
    [backbtn setTitleEdgeInsets:UIEdgeInsetsMake(2,-2,0,0)];
    [backbtn setImage:[UIImage imageNamed:@"imageviewer_return.png"] forState:UIControlStateNormal];
    //[backbtn setTitle:@"返回" forState:UIControlStateNormal];
    [backbtn setBackgroundImage:[[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [backbtn setTag:4];
    [backbtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [savebtn setFrame:CGRectMake(self.view.frame.size.width-90,50,40,40)];
    [savebtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleBottomMargin ];
    [savebtn setImageEdgeInsets:UIEdgeInsetsMake(0,2,0,0)];
    [savebtn setTitleEdgeInsets:UIEdgeInsetsMake(2,-2,0,0)];
    [savebtn setImage:[UIImage imageNamed:@"imageviewer_save.png"] forState:UIControlStateNormal];
    //[savebtn setTitle:@"保存" forState:UIControlStateNormal];
    [savebtn setBackgroundImage:[[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [savebtn setTag:5];
    [savebtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savebtn];
    
    [imageView setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRcognize setMinimumNumberOfTouches:1];
    panRcognize.delegate=self;
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    
    UIPinchGestureRecognizer *pinchRcognize=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [pinchRcognize setEnabled:YES];
    [pinchRcognize delaysTouchesEnded];
    [pinchRcognize cancelsTouchesInView];
    
    UIRotationGestureRecognizer *rotationRecognize=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotationRecognize setEnabled:YES];
    [rotationRecognize delaysTouchesEnded];
    [rotationRecognize cancelsTouchesInView];
    rotationRecognize.delegate=self;
    pinchRcognize.delegate=self;
    
    [imageView addGestureRecognizer:rotationRecognize];
    [imageView addGestureRecognizer:panRcognize];
    [imageView addGestureRecognizer:pinchRcognize];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIView *aa = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        aa.backgroundColor =  [UIColor blackColor];
        [self.view addSubview:aa];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder-news"]];
        
        [imageView setFrame:CGRectMake((self.view.frame.size.width-200)/2,(self.view.frame.size.height-200)/2,200,200)];
        [self.view addSubview:imageView];
        
        NSArray *array = [NSArray arrayWithObjects:@"rotate_left",@"rotate_right",@"zoom_in",@"zoom_out",nil];
        for (int i=0; i<[array count]; i++)
        {
            UIImage *normal = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[array objectAtIndex:i]]];
            UIImage *active = [[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(60+55*i,self.view.frame.size.height-80,40,40)];
            [btn setImage:normal forState:UIControlStateNormal];
            [btn setBackgroundImage:active forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i];
            [self.view addSubview:btn];
            //[normal release];
            //[active release];
        }
        
        UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setFrame:CGRectMake(20,20,40,40)];
        [backbtn setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
        [backbtn setTitleEdgeInsets:UIEdgeInsetsMake(2,-2,0,0)];
        [backbtn setImage:[UIImage imageNamed:@"imageviewer_return.png"] forState:UIControlStateNormal];
        //[backbtn setTitle:@"返回" forState:UIControlStateNormal];
        [backbtn setBackgroundImage:[[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [backbtn setTag:4];
        [backbtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backbtn];
        
        UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [savebtn setFrame:CGRectMake(self.view.frame.size.width - 50,26,28,28)];
        [savebtn setImageEdgeInsets:UIEdgeInsetsMake(0,2,0,0)];
        [savebtn setTitleEdgeInsets:UIEdgeInsetsMake(2,-2,0,0)];
        [savebtn setImage:[UIImage imageNamed:@"imageviewer_save.png"] forState:UIControlStateNormal];
        //[savebtn setTitle:@"保存" forState:UIControlStateNormal];
        [savebtn setBackgroundImage:[[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [savebtn setTag:5];
        [savebtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:savebtn];
        
        [imageView setUserInteractionEnabled:YES];
        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [panRcognize setMinimumNumberOfTouches:1];
        panRcognize.delegate=self;
        [panRcognize setEnabled:YES];
        [panRcognize delaysTouchesEnded];
        [panRcognize cancelsTouchesInView];
        
        UIPinchGestureRecognizer *pinchRcognize=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [pinchRcognize setEnabled:YES];
        [pinchRcognize delaysTouchesEnded];
        [pinchRcognize cancelsTouchesInView];
        
        UIRotationGestureRecognizer *rotationRecognize=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        [rotationRecognize setEnabled:YES];
        [rotationRecognize delaysTouchesEnded];
        [rotationRecognize cancelsTouchesInView];
        rotationRecognize.delegate=self;
        pinchRcognize.delegate=self;
        
        [imageView addGestureRecognizer:rotationRecognize];
        [imageView addGestureRecognizer:panRcognize];
        [imageView addGestureRecognizer:pinchRcognize];
        
    }else{
        
        [self loadPad];
    }
    
}

-(void) BtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:  //向左
        {
            [UIView animateWithDuration:0.5f animations:^{
                roation -=M_PI_2;
                imageView.transform = CGAffineTransformMakeRotation(roation);
            }];
        }
            break;
        case 1:  //向右
        {
            
            [UIView animateWithDuration:0.5f animations:^{
                roation +=M_PI_2;
                imageView.transform = CGAffineTransformMakeRotation(roation);
            }];
        }
            break;
        case 2:  //放大
        {
            [UIView animateWithDuration:0.5f animations:^{
                scale*=1.5;
                imageView.transform = CGAffineTransformMakeScale(scale,scale);
            }];
        }
            break;
        case 3:  //缩小
        {
            [UIView animateWithDuration:0.5f animations:^{
                scale/=1.5;
                imageView.transform = CGAffineTransformMakeScale(scale,scale);
            }];
        }
            break;
        case 4://返回
        {
            [self fadeOut];
        }
            break;
        case 5://保存.
        {
            
            //调用方法保存到相册的代码
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        }
            break;
        default:
            break;
    }
    
}

//实现类中实现
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"成功提示";
        message = [NSString stringWithFormat:@"成功保存到相冊"];
        
        
    } else {
        title = @"失败提示";
        message = [NSString stringWithFormat:@"请到【设置】→【隐私】→【照片】打开访问相册的权限"];
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    //[alert release];
}




/*
 *  移动图片处理的函数
 *  @recognizer 移动手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}
/*
 * handPinch 缩放的函数
 * @recognizer UIPinchGestureRecognizer 手势识别器
 */
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    recognizer.scale = 1;
    
}

/*
 * handleRotate 旋转的函数
 * recognizer UIRotationGestureRecognizer 手势识别器
 */
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(void) fadeIn
{
    CGRect rect = self.view.frame;
    self.view.center = CGPointMake(rect.size.width/2,  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?720: 450);
    [UIView animateWithDuration:0.5f animations:^{
        self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        //NSLog(@"%f, %f",rect.size.width/2 , rect.size.height/2);
    } completion:^(BOOL finished) {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat w = 1.0f;
            CGFloat h = 1.0f;
            if (image.size.width>600) {
                w = image.size.width/600;
            }
            if (image.size.height>600) {
                h = image.size.height/600;
            }
            CGFloat scole = w>h ? w:h;
            
            CGRect rect = CGRectMake(0, 0,image.size.width/scole,image.size.height/scole);
            [imageView setFrame:rect];
            CGRect bounds = self.view.bounds;
            imageView.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
            
            
        }];
        
    }];
}

-(void) fadeOut
{
    CGRect rect = self.view.frame;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.center = CGPointMake(rect.size.width/2,(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?720: rect.size.height/2);
    } completion:^(BOOL finished) {
        [imageView sd_cancelCurrentImageLoad];
        //[imageView release];
        //[imgUrl release];
        imageView = nil;
        imgUrl = nil;
        //[self.view removeFromSuperview];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self fadeIn];
    
    //[self loadPad];
}


@end
