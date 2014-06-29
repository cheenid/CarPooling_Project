//
//  DrivelicenceViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-31.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "DrivelicenceViewController.h"
#import "YZProgressHUD.h"
#import "CPHttpRequest.h"
#import "YZQiniuUploader.h"

@interface DrivelicenceViewController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView *driveLicenceImageView;
@end

@implementation DrivelicenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"驾驶证认证";
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
    frontImagelabel.text = @"驾驶证照片";
    [self.view addSubview:frontImagelabel];
}

- (UIImageView*)driveLicenceImageView
{
    if (_driveLicenceImageView == nil)
    {
        CGRect frame = CGRectMake(10, 25, KScreenWidth-20, 180);
        _driveLicenceImageView = [[UIImageView alloc]initWithFrame:frame];
        _driveLicenceImageView.contentMode = UIViewContentModeScaleAspectFit;
        _driveLicenceImageView.layer.cornerRadius = 8.0;
        _driveLicenceImageView.layer.masksToBounds = YES;
        _driveLicenceImageView.layer.borderColor = [UIColor colorWithRed:0.524 green:0.533 blue:0.508 alpha:1.0].CGColor;
        _driveLicenceImageView.layer.borderWidth = 2.0;
        _driveLicenceImageView.userInteractionEnabled = YES;
    }
    return _driveLicenceImageView;
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

- (void)initTapGestureRecognizer
{
    UITapGestureRecognizer *frontImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(driveLicenceImageDidTap)];
    frontImageTapGesture.numberOfTapsRequired = 1;
    [self.driveLicenceImageView addGestureRecognizer:frontImageTapGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInfoLabel];
    [self.view addSubview:self.driveLicenceImageView];
    [self initRightBarButtonItem];
    [self initTapGestureRecognizer];
    [self updateContentView];
}

#pragma mark -
#pragma mark updateContentView

- (void)updateContentView
{
    NSString *mobileNo = [[YZKeyChainManager defaultManager]keychainValueForKey:KMobileNO];
    PersonalData *personalData =  [[YZDataBaseMgr sharedManager]personalDataSortByAccountID:mobileNo];
    if (personalData.driverLicencesPhoto)
    {
        NSString *baseURLStr = @"http://scar.qiniudn.com/";
        NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLStr,personalData.driverLicencesPhoto];
        NSURL *url = [NSURL URLWithString:urlString];
        [self.driveLicenceImageView setImageWithURL:url];
    }
}

#pragma mark -
#pragma mark 上传照片

- (void)clickToUpload
{
    if (self.driveLicenceImageView.image == nil)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择驾驶证照片"];
        return;
    }
    
    // 七牛上传
    QiniuPutPolicy *token = [[QiniuPutPolicy alloc]init];
    token.scope = KQiniuScope;
    YZQiniuUploader *qiniuUploader = [[YZQiniuUploader alloc]initWithToken:token];
    
    //生活照图片
    NSData *avatarImageData = UIImagePNGRepresentation(_driveLicenceImageView.image);
    YZQiniuFile *qiniuFile1 = [[YZQiniuFile alloc]initWithFileData:avatarImageData];
    
    [qiniuUploader addFile:qiniuFile1];
    
    [[YZProgressHUD progressHUD]showProgressOnView:self.view labelText:@"1/1" detailText:@"正在上传图片"];
    
    WEAKSELF;
    [qiniuUploader execuploadTask:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *ret) {
        
        DEBUG_METHOD(@"index:%ld ret:%@",(long)index,ret);
        NSString *key = ret[@"key"];
        [weakSelf uploadDriveLicenceImageData:key];
        
    } oneFileUploadFailture:^(AFHTTPRequestOperation *operation, NSInteger index, NSError *error){
        
        DEBUG_METHOD(@"index:%ld responseObject:%@",(long)index,operation.responseObject);
        [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"更新信息失败"];
        
    } oneFileProgress:^(NSInteger index, double percent){
        
        DEBUG_METHOD(@"index:%ld percent:%lf",(long)index,percent);
        NSString *labeltext = [NSString stringWithFormat:@"%d/1",index+1];
        [[YZProgressHUD progressHUD]updateProgress:percent labelText:labeltext detailText:@"正在上传图片"];
        
    } uploadAllFilesComplete:^{
        
        DEBUG_METHOD(@"all complete");
        
    }];
    
    [qiniuUploader startUpload];
    
}

- (void)uploadDriveLicenceImageData:(NSString*)imageKey
{
    [[YZProgressHUD progressHUD]changeHUDWithText:@"请稍后" detailText:@"驾驶证认证中"];
    [[CPHttpRequest sharedInstance]requestUploadDriverlicenseVerify:imageKey success:^(id responseObject) {
        NSInteger statusCode = [responseObject[@"statusCode"]integerValue];
        if (statusCode == 1)
        {
            [[YZProgressHUD progressHUD]hideWithSuccess:nil detailText:@"上传成功"];
        }
        else if (statusCode == 2)
        {
            // 重新登录
            [[YZProgressHUD progressHUD]hide];
        }
        else
        {
            [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"上传失败"];
        }
        
    } failture:^(NSError *error) {
        [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"上传失败"];
    }];
}

#pragma mark -
#pragma mark UITapGestureRecognizer

- (void)driveLicenceImageDidTap
{
    [self showImagePickerActionSheet];
}


#pragma mark -
#pragma mark imagePicker

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
    self.driveLicenceImageView.image = image;
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
