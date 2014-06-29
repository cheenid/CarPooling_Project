//
//  MyInfoViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-31.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "MyInfoViewController.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "YZProgressHUD.h"
#import "YZQiniuUploader.h"
#import "CPHttpRequest.h"

#define ORIGINAL_MAX_WIDTH 640.0f

typedef void (^TouchBlock)();

@interface YZLineCellView : UIView
{
    UITapGestureRecognizer *tapGuestureRecognizer;
}
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL showCellLine;
@property (nonatomic, copy) TouchBlock block;
- (void)execTouchTask:(TouchBlock)block;
@end

@implementation YZLineCellView

- (void)dealloc
{
    [self removeGestureRecognizer:tapGuestureRecognizer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        tapGuestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellDidTaped)];
        tapGuestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGuestureRecognizer];
    }
    return self;
}

- (void)execTouchTask:(TouchBlock)block
{
    _block = block;
}

- (void)CellDidTaped
{
    if (_block)
    {
        _block();
    }
}

- (void)setShowCellLine:(BOOL)showCellLine
{
    if (_showCellLine != showCellLine)
    {
        _showCellLine = showCellLine;
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews
{
    if (self.textField)
    {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
        CGSize size = [self.text sizeWithFont:font];
        
        CGFloat originX = 20 + size.width;
        CGRect rect = self.textField.frame;
        rect.origin.x = originX;
        rect.size.width = self.frame.size.width - originX-10;
        rect.size.height = 24;
        rect.origin.y = self.frame.size.height*0.5 - 12;
        self.textField.frame = rect;
        [self addSubview:self.textField];
    }
}

- (void)drawRect:(CGRect)rect
{
    // 填充白色背景色
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    if (self.showCellLine)
    {
        // 画水平线
        CGContextMoveToPoint(context, 0.0f, round(CGRectGetMaxY(rect)) - 0.5f);
        CGContextAddLineToPoint(context, round(rect.size.width), round(CGRectGetMaxY(rect)) - 0.5f);
        
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (self.text)
    {
        [[UIColor blackColor]set];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
        CGSize size = [self.text sizeWithFont:font];
        CGRect frame = CGRectMake(10, rect.size.height*0.5 - 12, size.width, 24);
        [self.text drawInRect:frame withFont:font];
    }
}
@end


@interface YZCheckRadioView : UIView
@property (nonatomic, assign) BOOL gender;
@end

@implementation YZCheckRadioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _gender = YES;
        
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(radioViewDidTap:)];
        [self addGestureRecognizer:tapGuesture];
        tapGuesture = nil;
    }
    return self;
}

- (void)radioViewDidTap:(UITapGestureRecognizer*)tapGuesture
{
    CGPoint point = [tapGuesture locationInView:self];
    if (point.x <= self.frame.size.width *0.5)
    {
        _gender = YES;
    }
    else
    {
        _gender = NO;
    }
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"icon_typeUnselected"];
    UIImage *selectImage = [UIImage imageNamed:@"icon_typeSelected"];
    [[UIColor blackColor]set];
    NSString *manStr = @"男";
    NSString *womanStr = @"女";
    [manStr drawInRect:CGRectMake(35, rect.size.height*0.5-12, 24, 24)
              withFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [womanStr drawInRect:CGRectMake(83, rect.size.height*0.5-12, 24, 24)
                withFont:[UIFont fontWithName:@"Helvetica" size:16]];
    
    if (!_gender)
    {
        [image drawInRect:CGRectMake(10, (rect.size.height-19)*0.5, 19, 19)];
        [selectImage drawInRect:CGRectMake(60, (rect.size.height-19)*0.5, 19, 19)];
    }
    else
    {
        [selectImage drawInRect:CGRectMake(10, (rect.size.height-19)*0.5, 19, 19)];
        [image drawInRect:CGRectMake(60, (rect.size.height-19)*0.5, 19, 19)];
    }
}

@end

@interface MyInfoViewController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *upContentView;
@property (nonatomic, strong) UIView *downContentView;
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) YZLineCellView *userNamecellView;
@property (nonatomic, strong) YZLineCellView *userNickNameCellView;
@property (nonatomic, strong) YZLineCellView *birthDayCellView;
@property (nonatomic, strong) YZLineCellView *qqCellView;
@property (nonatomic, strong) YZLineCellView *genderCellView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) YZCheckRadioView *checkRadioView;
@end

@implementation MyInfoViewController

#pragma mark -
#pragma mark dealloc

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
        self.title = @"个人信息";
    }
    return self;
}

#pragma mark -
#pragma mark UIView

- (TPKeyboardAvoidingScrollView*)scrollView
{
    if (_scrollView == nil)
    {
        CGRect frame = self.view.bounds;
        _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView*)upContentView
{
    if (_upContentView == nil)
    {
        _upContentView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, KScreenWidth-20, 88)];
        _upContentView.backgroundColor = [UIColor whiteColor];
        _upContentView.layer.cornerRadius = 4.0;
        _upContentView.layer.masksToBounds = YES;
    }
    return _upContentView;
}

- (UIView*)downContentView
{
    if (_downContentView == nil)
    {
        _downContentView = [[UIView alloc]initWithFrame:CGRectMake(10, 130, KScreenWidth-20, 132)];
        _downContentView.backgroundColor = [UIColor whiteColor];
        _downContentView.layer.cornerRadius = 4.0;
        _downContentView.layer.masksToBounds = YES;
    }
    return _downContentView;
}

- (UIImageView*)avatarImageView
{
    if (_avatarImageView == nil)
    {
        CGRect frame = CGRectMake(10, 4, 80, 80);
        _avatarImageView = [[UIImageView alloc]initWithFrame:frame];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.layer.cornerRadius = 40.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor colorWithRed:0.524 green:0.533 blue:0.508 alpha:1.0].CGColor;
        _avatarImageView.layer.borderWidth = 2.0;
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (YZLineCellView*)userNamecellView
{
    if (_userNamecellView == nil)
    {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 210, 24)];
        textField.placeholder = @"用户姓名";
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont fontWithName:@"Helvetica" size:16];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _userNamecellView = [[YZLineCellView alloc]initWithFrame:CGRectMake(100, 0, KScreenWidth-120, 44)];
        _userNamecellView.showCellLine = YES;
        _userNamecellView.text = @"姓名：";
        _userNamecellView.textField = textField;
    }
    return _userNamecellView;
}

- (YZLineCellView*)userNickNameCellView
{
    if (_userNickNameCellView == nil)
    {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 210, 24)];
        textField.placeholder = @"用户昵称";
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont fontWithName:@"Helvetica" size:16];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _userNickNameCellView = [[YZLineCellView alloc]initWithFrame:CGRectMake(100, 44, KScreenWidth-120, 44)];
        _userNickNameCellView.showCellLine = NO;
        _userNickNameCellView.text = @"昵称：";
        _userNickNameCellView.textField = textField;
    }
    return _userNickNameCellView;
}

- (YZLineCellView*)qqCellView
{
    if (_qqCellView == nil)
    {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 210, 24)];
        textField.placeholder = @"QQ号码";
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor blackColor];
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.font = [UIFont fontWithName:@"Helvetica" size:16];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        _qqCellView = [[YZLineCellView alloc]initWithFrame:CGRectMake(0, 88, KScreenWidth-20, 44)];
        _qqCellView.showCellLine = NO;
        _qqCellView.textField = textField;
        _qqCellView.text = @"  QQ：";
    }
    return _qqCellView;
}

- (YZCheckRadioView*)checkRadioView
{
    if (_checkRadioView == nil)
    {
        _checkRadioView = [[YZCheckRadioView alloc]initWithFrame:CGRectMake(70, 0, 100, 44)];
    }
    return _checkRadioView;
}

- (YZLineCellView*)genderCellView
{
    if (_genderCellView == nil)
    {
        _genderCellView = [[YZLineCellView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-20, 44)];
        _genderCellView.showCellLine = YES;
        _genderCellView.textField = nil;
        _genderCellView.text = @"性别：";
        [_genderCellView addSubview:self.checkRadioView];
    }
    return _genderCellView;
}

- (YZLineCellView*)birthDayCellView
{
    if (_birthDayCellView == nil)
    {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 210, 24)];
        textField.placeholder = @"用户生日";
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor blackColor];
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.font = [UIFont fontWithName:@"Helvetica" size:16];
        textField.enabled = NO;
        
        _birthDayCellView = [[YZLineCellView alloc]initWithFrame:CGRectMake(0, 44, KScreenWidth-20, 44)];
        _birthDayCellView.showCellLine = YES;
        _birthDayCellView.textField = textField;
        _birthDayCellView.text = @"生日：";
    }
    return _birthDayCellView;
}


#pragma mark -
#pragma mark loadView

- (void)loadView
{
    [super loadView];
    UIView *contentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    contentView.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.961 alpha:1.0];
    self.view = contentView;
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
    UITapGestureRecognizer *avatarImageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarImageDidTap)];
    avatarImageTapGesture.numberOfTapsRequired = 1;
    [self.avatarImageView addGestureRecognizer:avatarImageTapGesture];
    
    UITapGestureRecognizer *endEditingTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditingDidTap)];
    endEditingTapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:endEditingTapGesture];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRightBarButtonItem];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.upContentView];
    [self.scrollView addSubview:self.downContentView];
    [self.upContentView addSubview:self.avatarImageView];
    [self.upContentView addSubview:self.userNamecellView];
    [self.upContentView addSubview:self.userNickNameCellView];
    [self.downContentView addSubview:self.genderCellView];
    [self.downContentView addSubview:self.birthDayCellView];
    [self.downContentView addSubview:self.qqCellView];
    [self initTapGestureRecognizer];
    
    // 选择生日
    WEAKSELF;
    [self.birthDayCellView execTouchTask:^{
        STRONGSELF;
        [strongSelf.view endEditing:YES];
        [weakSelf showDataPicker];
        
    }];
    
    [self updateContentView];
}

#pragma mark -
#pragma mark updateContentView

- (void)updateContentView
{
    NSString *mobileNo = [[YZKeyChainManager defaultManager]keychainValueForKey:KMobileNO];
    PersonalData *personalData =  [[YZDataBaseMgr sharedManager]personalDataSortByAccountID:mobileNo];
    _checkRadioView.gender = [personalData.gender boolValue];
    _userNamecellView.textField.text = personalData.realname;
    _userNickNameCellView.textField.text = personalData.nickname;
    
    
    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:[personalData.birthday longValue]];
    NSString *birthday = [self.dateFormatter stringFromDate:date];
    _birthDayCellView.textField.text = birthday;
    
    
    if (personalData.headPhoto)
    {
        NSString *baseURLStr = @"http://scar.qiniudn.com/";
        NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLStr,personalData.headPhoto];
        NSURL *url = [NSURL URLWithString:urlString];
        [_avatarImageView setImageWithURL:url];
    }
}

#pragma mark -
#pragma mark 日期选取

- (UIDatePicker*)datePicker
{
    if (_datePicker == nil)
    {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (NSDateFormatter*)dateFormatter
{
    if (_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (void)showDataPicker
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    actionSheet.userInteractionEnabled = YES;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    
    [actionSheet addSubview:self.datePicker];
    [actionSheet showInView:self.navigationController.view];
}

- (void)dateChanged:(id)sender
{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSString *dateString = [self.dateFormatter stringFromDate:control.date];
    [self.birthDayCellView.textField setText:dateString];
}


#pragma mark -
#pragma mark UIControl Action

- (void)clickToUpload
{
    [self.view endEditing:YES];
    if (_avatarImageView.image == nil)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择图像"];
        return;
    }
    
    if (_userNamecellView.textField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请输入用户名"];
        return;
    }
    
    if (_userNickNameCellView.textField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请输入用户昵称"];
        return;
    }
    
    if (_birthDayCellView.textField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择生日"];
        return;
    }
    
    if (_qqCellView.textField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请输入QQ号"];
        return;
    }
    
    [[YZProgressHUD progressHUD]showProgressOnView:self.navigationController.view labelText:@"1/1" detailText:@"正在上传图片"];
    
    // 七牛上传
    QiniuPutPolicy *token = [[QiniuPutPolicy alloc]init];
    token.scope = KQiniuScope;
    NSData *imageData = UIImagePNGRepresentation(_avatarImageView.image);
    YZQiniuFile *qiniuFile = [[YZQiniuFile alloc]initWithFileData:imageData withKey:nil mimeType:@"image/png"];
    YZQiniuUploader *qiniuUploader = [[YZQiniuUploader alloc]initWithToken:token];
    [qiniuUploader addFile:qiniuFile];
    
    WEAKSELF;
    [qiniuUploader execuploadTask:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *ret) {
        DEBUG_METHOD(@"index:%ld ret:%@",(long)index,ret);
        NSString *key = ret[@"key"];
        [weakSelf uploadPersonalData:key];
        
    } oneFileUploadFailture:^(AFHTTPRequestOperation *operation, NSInteger index, NSError *error)
    {
        DEBUG_METHOD(@"index:%ld responseObject:%@",(long)index,operation.responseObject);
        [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"更新信息失败"];
        
    } oneFileProgress:^(NSInteger index, double percent)
    {
        DEBUG_METHOD(@"index:%ld percent:%lf",(long)index,percent);
        [[YZProgressHUD progressHUD]updateProgress:percent labelText:@"1/1" detailText:@"正在上传图片"];
        
    } uploadAllFilesComplete:^{
        DEBUG_METHOD(@"all complete");
        
    }];
    
    [qiniuUploader startUpload];
}

- (void)uploadPersonalData:(NSString*)retkey
{
    [[YZProgressHUD progressHUD]changeHUDWithText:@"请稍后" detailText:@"正在上传个人信息"];
    NSTimeInterval timeStamp = [self.datePicker.date timeIntervalSince1970];
    NSString *birthday = [NSString stringWithFormat:@"%lf",timeStamp];
    // 上传用户信息到服务器
    [[CPHttpRequest sharedInstance]requestUploadMyInfo:_userNamecellView.textField.text
                                              nickname:_userNickNameCellView.textField.text
                                              birthday:birthday
                                                gender:_checkRadioView.gender
                                             headPhoto:retkey
                                                    qq:_qqCellView.textField.text
                                               success:^(id responseObject) {
                                                   
                                                   NSInteger statusCode = [responseObject[@"statusCode"]integerValue];
                                                   if (statusCode == 1)
                                                   {
                                                       [[YZProgressHUD progressHUD]hideWithSuccess:nil detailText:@"成功上传信息"];
                                                   }
                                                   else if (statusCode == 2)
                                                   {
                                                       // 自动登录
                                                       [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"信息上传失败"];
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
#pragma mark 手势

- (void)endEditingDidTap
{
    [self.view endEditing:YES];
}

- (void)avatarImageDidTap
{
    [self showImagePickerActionSheet];
}


#pragma mark -
#pragma mark ImagePicker

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
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatarImageView.image = [self imageByScalingToMaxSize:image];
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


#pragma mark -
#pragma mark image scale utility

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height)
    {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    }
    else
    {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
