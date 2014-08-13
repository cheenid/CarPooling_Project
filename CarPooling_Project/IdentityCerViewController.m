//
//  IdentityAuthViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-31.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "IdentityCerViewController.h"
#import "CPHttpRequest.h"
#import "YZProgressHUD.h"
#import "YZQiniuUploader.h"

typedef NS_ENUM(NSInteger, PhotoPickerType)
{
    PhotoPickerFrontImage,
    PhotoPickerBackImage,
};

@interface IdentityCerViewController ()
<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) PhotoPickerType pickerType;
@property (nonatomic, strong) NSString *frontImageKey;
@property (nonatomic, strong) NSString *backImageKey;
@end

@implementation IdentityCerViewController

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"身份认证";
    }
    return self;
}

#pragma mark -
#pragma mark loadView

- (void)loadView
{
    [super loadView];
    UIView *contentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)initInfoLabel
{
    UILabel *frontImagelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, KScreenWidth, 20)];
    frontImagelabel.textAlignment = NSTextAlignmentCenter;
    frontImagelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    frontImagelabel.text = @"身份证正面照";
    [self.view addSubview:frontImagelabel];
    
    UILabel *backImagelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, KScreenWidth, 20)];
    backImagelabel.textAlignment = NSTextAlignmentCenter;
    backImagelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    backImagelabel.text = @"身份证反面照";
    [self.view addSubview:backImagelabel];
    
}

- (UIImageView*)frontImageView
{
    if (_frontImageView == nil)
    {
        CGRect frame = CGRectMake(10, 25, KScreenWidth-20, 180);
        _frontImageView = [[UIImageView alloc]initWithFrame:frame];
        _frontImageView.contentMode = UIViewContentModeScaleAspectFit;
        _frontImageView.layer.cornerRadius = 8.0;
        _frontImageView.layer.masksToBounds = YES;
        _frontImageView.layer.borderColor = [UIColor colorWithRed:0.524 green:0.533 blue:0.508 alpha:1.0].CGColor;
        _frontImageView.layer.borderWidth = 2.0;
        _frontImageView.userInteractionEnabled = YES;
    }
    return _frontImageView;
}

- (UIImageView*)backImageView
{
    if (_backImageView == nil)
    {
        CGRect frame = CGRectMake(10, 225, KScreenWidth- 20, 180);
        _backImageView = [[UIImageView alloc]initWithFrame:frame];
        _backImageView.contentMode = UIViewContentModeScaleAspectFit;
        _backImageView.layer.cornerRadius = 8.0;
        _backImageView.layer.masksToBounds = YES;
        _backImageView.layer.borderColor = [UIColor colorWithRed:0.524 green:0.533 blue:0.508 alpha:1.0].CGColor;
        _backImageView.layer.borderWidth = 2.0;
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (void)initTapGestureRecognizer
{
    UITapGestureRecognizer *frontImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(frontImageDidTap)];
    frontImageTapGesture.numberOfTapsRequired = 1;
    [self.frontImageView addGestureRecognizer:frontImageTapGesture];
    
    UITapGestureRecognizer *backImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backImageDidTap)];
    backImageTapGesture.numberOfTapsRequired = 1;
    [self.backImageView addGestureRecognizer:backImageTapGesture];
}

- (void)initRightBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 80, 34)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:@"上传" forState:UIControlStateNormal];
    [button setTitle:@"上传" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToUpload) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRightBarButtonItem];
    [self initInfoLabel];
    [self.view addSubview:self.frontImageView];
    [self.view addSubview:self.backImageView];
    [self initTapGestureRecognizer];
    [self updateContentView];
}

- (void)updateContentView
{
    PersonalData *personalData =  (PersonalData*)[[YZDataBaseMgr sharedManager]fetchPersonalData];
    if (personalData.frontPhoto)
    {
        NSString *baseURLStr = @"http://scar.qiniudn.com/";
        NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLStr,personalData.frontPhoto];
        NSURL *url = [NSURL URLWithString:urlString];
        [_frontImageView setImageWithURL:url];
    }
    
    if (personalData.backPhoto)
    {
        NSString *baseURLStr = @"http://scar.qiniudn.com/";
        NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLStr,personalData.backPhoto];
        NSURL *url = [NSURL URLWithString:urlString];
        [_backImageView setImageWithURL:url];
    }

}

#pragma mark -
#pragma mark UIControl Action

- (void)clickToUpload
{
    
    if (_frontImageView.image == nil)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择身份证正面照"];
        return;
    }
    if (_backImageView.image == nil)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择身份证反面照"];
        return;
    }
    
    // 七牛上传
    QiniuPutPolicy *token = [[QiniuPutPolicy alloc]init];
    token.scope = KQiniuScope;
    YZQiniuUploader *qiniuUploader = [[YZQiniuUploader alloc]initWithToken:token];
    
    //身份证正面照
    NSData *frontImageData = UIImagePNGRepresentation(_frontImageView.image);
    YZQiniuFile *qiniuFile1 = [[YZQiniuFile alloc]initWithFileData:frontImageData];
    
    // 身份证反面照片
    NSData *backImageData = UIImagePNGRepresentation(_backImageView.image);
    YZQiniuFile *qiniuFile2 = [[YZQiniuFile alloc]initWithFileData:backImageData];
    
    [qiniuUploader addFile:qiniuFile1];
    [qiniuUploader addFile:qiniuFile2];
    
    [[YZProgressHUD progressHUD]showProgressOnView:self.view labelText:@"1/2" detailText:@"正在上传图片"];
    WEAKSELF;
    [qiniuUploader execuploadTask:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *ret) {
        DEBUG_METHOD(@"index:%ld ret:%@",(long)index,ret);
        STRONGSELF;
        NSString *key = ret[@"key"];
        if (index == 0)
        {
            strongSelf.frontImageKey = key;
        }
        else
        {
            strongSelf.backImageKey = key;
            [weakSelf uploadIdentityCardData:strongSelf.frontImageKey backImageKey:strongSelf.backImageKey];
        }
        
    } oneFileUploadFailture:^(AFHTTPRequestOperation *operation, NSInteger index, NSError *error)
     {
         DEBUG_METHOD(@"index:%ld responseObject:%@",(long)index,operation.responseObject);
         [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"更新信息失败"];
         
     } oneFileProgress:^(NSInteger index, double percent)
     {
         DEBUG_METHOD(@"index:%ld percent:%lf",(long)index,percent);
         NSString *labeltext = [NSString stringWithFormat:@"%d/2",index+1];
         [[YZProgressHUD progressHUD]updateProgress:percent labelText:labeltext detailText:@"正在上传图片"];
         
     } uploadAllFilesComplete:^{
         DEBUG_METHOD(@"all complete");
     }];
    
    [qiniuUploader startUpload];

}

- (void)uploadIdentityCardData:(NSString*)frontKey backImageKey:(NSString*)backKey
{
    [[YZProgressHUD progressHUD]changeHUDWithText:@"请稍后" detailText:@"正在进行身份认证"];
    [[CPHttpRequest sharedInstance]requestVerifyIdentity:frontKey backPhoto:backKey success:^(id responseObject) {
        NSInteger statusCode = [responseObject[@"statusCode"]integerValue];
        if (statusCode == 1)
        {
            [[YZProgressHUD progressHUD]hideWithSuccess:nil detailText:@"成功上传信息"];
        }
        else
        {
            [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"信息上传失败"];
        }
    } failture:^(NSError *error) {
        [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"信息上传失败"];
    }];
}

#pragma mark -
#pragma mark UITapGestureRecognizer

- (void)frontImageDidTap
{
    _pickerType = PhotoPickerFrontImage;
    [self showImagePickerActionSheet];
}

- (void)backImageDidTap
{
    _pickerType = PhotoPickerBackImage;
    [self showImagePickerActionSheet];
}

- (void)showImagePickerActionSheet
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"上传照片"
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"从相册选取", nil];
        actionSheet.tag = 11110;
        [actionSheet showInView:self.navigationController.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"上传照片"
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"从相册选取",@"从相机选取", nil];
        actionSheet.tag = 11111;
        [actionSheet showInView:self.navigationController.view];
    }
}



- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType = sourceType;
    pickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if ([self.navigationController respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
        [self.navigationController presentViewController:pickerController animated:YES completion:^{}];
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
        [self.navigationController presentModalViewController:pickerController animated:YES];
#endif
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 11110)
    {
        if (buttonIndex == 0)
        {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
    
    if (actionSheet.tag == 11111)
    {
        if (buttonIndex == 0)
        {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if (buttonIndex == 1)
        {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
    }
    
    if (actionSheet.tag == 11112)
    {
        if (buttonIndex == 0)
        {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
    
    if (actionSheet.tag == 11113)
    {
        if (buttonIndex == 0)
        {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if (buttonIndex == 1)
        {
            [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
        [picker dismissModalViewControllerAnimated:YES];
#endif
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_pickerType == PhotoPickerFrontImage)
    {
        self.frontImageView.image = image;
    }
    else
    {
        self.backImageView.image = image;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
        [picker dismissModalViewControllerAnimated:YES];
#endif
    }
}


@end
