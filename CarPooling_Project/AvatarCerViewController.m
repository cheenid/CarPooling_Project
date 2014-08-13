//
//  AvatarCerViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-31.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "AvatarCerViewController.h"
#import "CPHttpRequest.h"
#import "YZProgressHUD.h"
#import "YZQiniuUploader.h"

@interface AvatarCerViewController ()
<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView *avatarImageView;
@end

@implementation AvatarCerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"头像认证";
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
    UILabel *photosImagelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, KScreenWidth, 20)];
    photosImagelabel.textAlignment = NSTextAlignmentCenter;
    photosImagelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    photosImagelabel.text = @"生活照";
    [self.view addSubview:photosImagelabel];
}

- (UIImageView*)avatarImageView
{
    if (_avatarImageView == nil)
    {
        CGRect frame = CGRectMake(10, 25, KScreenWidth-20, 300);
        _avatarImageView = [[UIImageView alloc]initWithFrame:frame];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.layer.cornerRadius = 8.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor colorWithRed:0.524 green:0.533 blue:0.508 alpha:1.0].CGColor;
        _avatarImageView.layer.borderWidth = 2.0;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
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
    UITapGestureRecognizer *frontImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarImageDidTap)];
    frontImageTapGesture.numberOfTapsRequired = 1;
    [self.avatarImageView addGestureRecognizer:frontImageTapGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInfoLabel];
    [self.view addSubview:self.avatarImageView];
    [self initRightBarButtonItem];
    [self initTapGestureRecognizer];
    [self updateContentView];
}

#pragma mark -
#pragma mark updateContentView

- (void)updateContentView
{
    PersonalData *personalData =  (PersonalData*)[[YZDataBaseMgr sharedManager]fetchPersonalData];
    if (personalData.headPhoto)
    {
        NSString *baseURLStr = @"http://scar.qiniudn.com/";
        NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLStr,personalData.headPhoto];
        NSURL *url = [NSURL URLWithString:urlString];
        [_avatarImageView setImageWithURL:url];
    }
}


#pragma mark -
#pragma mark 上传头像

- (void)clickToUpload
{
    if (_avatarImageView.image == nil)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择头像"];
        return;
    }
    
    // 七牛上传
    QiniuPutPolicy *token = [[QiniuPutPolicy alloc]init];
    token.scope = KQiniuScope;
    YZQiniuUploader *qiniuUploader = [[YZQiniuUploader alloc]initWithToken:token];
    
    //生活照图片
    NSData *avatarImageData = UIImagePNGRepresentation(_avatarImageView.image);
    YZQiniuFile *qiniuFile1 = [[YZQiniuFile alloc]initWithFileData:avatarImageData];
    
    [qiniuUploader addFile:qiniuFile1];
    
    [[YZProgressHUD progressHUD]showProgressOnView:self.view labelText:@"1/1" detailText:@"正在上传图片"];
    
    WEAKSELF;
    [qiniuUploader execuploadTask:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *ret) {
        
        DEBUG_METHOD(@"index:%ld ret:%@",(long)index,ret);
        [weakSelf uploadAvatarImageData:ret[@"key"]];
        
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

- (void)uploadAvatarImageData:(NSString*)imageKey
{
    [[YZProgressHUD progressHUD]changeHUDWithText:@"请稍后" detailText:@"头像认证中"];
    [[CPHttpRequest sharedInstance]requestVertifyPhoto:imageKey success:^(id responseObject) {
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
             [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"信息上传失败"];
        }
    } failture:^(NSError *error) {
         [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"上传失败"];
    }];
}

#pragma mark -
#pragma mark UITapGuestureRecognizer

- (void)avatarImageDidTap
{
    [self showImagePickerActionSheet];
}

#pragma mark -
#pragma mark 图像选取

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
    self.avatarImageView.image = image;
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
