//
//  MineViewController_iph.m
//  YunYiGou
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 yunfeng. All rights reserved.
//

#import "ControllerUserInfoEdit.h"

#import "NetUser.h"
#import "MyNetLoading.h"
#import "MyAlertNotice.h"
#import "RDVTabBarController.h"
#import "ControllerRegister.h"


@interface ControllerUserInfoEdit ()  <UIScrollViewDelegate,UITextFieldDelegate>
{
    ENUM_EDIT_MODE              _editMode;
    NSString*                   _account;
    
    UIScrollView*               _scrollView;
    
    UITextField*                _oldValueField;             // 默认修改
    
    UISegmentedControl*         _sexSegment;                // 性别修改
    
    UITextField*                _newPswdField;              // 密码修改
    UITextField*                _pswdConfirmField;
    
    UILabel*                    _confirmBtnLabel;
    
    MyNetLoading*               _netLoading;
}
@end

@implementation ControllerUserInfoEdit


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initData];
        [self initUI];
    }
    return self;
}

-(void)initData
{
    _editMode = ENUM_EDIT_MODE_START;
    _account = @"";
}

-(void)initUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
 
    CGRect frameR = self.view.frame;
    
    // content
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frameR.size.width, frameR.size.height)];
    [_scrollView setBackgroundColor:[UIColor colorWithRed:238.0/255 green:243.0/255 blue:246.0/255 alpha:1]];
    [self.view addSubview:_scrollView];
    [_scrollView setDelegate:self];
    
    // ------ 默认修改
    CGPoint relationP = CGPointMake(0, 0);
    int height = 40;
    UILabel* oldValueWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, relationP.y, 100, height)];
    oldValueWdsLabel.backgroundColor = [UIColor clearColor];
    oldValueWdsLabel.textColor = [UIColor grayColor];
    _oldValueField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_oldValueField setBorderStyle:UITextBorderStyleNone];
    [_oldValueField setBackgroundColor:[UIColor whiteColor]];
    _oldValueField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldValueField.keyboardType = UIKeyboardTypeAlphabet;
    _oldValueField.autocapitalizationType =  UITextAutocapitalizationTypeNone;
    _oldValueField.font = [UIFont systemFontOfSize:15];
    _oldValueField.textColor = [UIColor lightGrayColor];
    _oldValueField.delegate = self;
    _oldValueField.clearsOnBeginEditing = YES;
    _oldValueField.leftViewMode = UITextFieldViewModeAlways;
    _oldValueField.leftView = oldValueWdsLabel;
    [_scrollView addSubview:_oldValueField];
    
    // ------ 性别修改
    NSArray* segmentArray = [NSArray arrayWithObjects:@"男", @"女", nil];
    _sexSegment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    [_sexSegment setFrame:CGRectMake(40, 10, frameR.size.width-2*40, 50)];
    [_sexSegment setHidden:YES];
    [_scrollView addSubview:_sexSegment];
    
    // ------ 密码修改
    relationP.y = relationP.y + height + 20;
    height = 40;
    
    UILabel* newPswdWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, relationP.y, 100, height)];
    newPswdWdsLabel.backgroundColor = [UIColor clearColor];
    newPswdWdsLabel.textColor = [UIColor grayColor];
    newPswdWdsLabel.text = @"     新密码:";

    _newPswdField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_newPswdField setBorderStyle:UITextBorderStyleNone];
    [_newPswdField setBackgroundColor:[UIColor whiteColor]];
    _newPswdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newPswdField.keyboardType = UIKeyboardTypeAlphabet;
    _newPswdField.autocapitalizationType =  UITextAutocapitalizationTypeNone;
    _newPswdField.text = @"请输入新密码";
    _newPswdField.font = [UIFont systemFontOfSize:15];
    _newPswdField.textColor = [UIColor lightGrayColor];
    _newPswdField.delegate = self;
    _newPswdField.clearsOnBeginEditing = YES;
    _newPswdField.leftViewMode = UITextFieldViewModeAlways;
    _newPswdField.leftView = newPswdWdsLabel;
    _newPswdField.hidden = YES;
    [_scrollView addSubview:_newPswdField];
    
    // 分割线
    relationP.y = relationP.y + height + 0.5;
    height = 0.5;
    
    float startX = newPswdWdsLabel.frame.size.width;
    UIView* seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(startX, relationP.y, frameR.size.width-startX, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [_scrollView addSubview:seperatorlINE];
    
    // 密码
    relationP.y = relationP.y + height;
    height = 40;
    
    UILabel* pswdConfirmWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, relationP.y, 100, height)];
    pswdConfirmWdsLabel.backgroundColor = [UIColor clearColor];
    pswdConfirmWdsLabel.textColor = [UIColor grayColor];
    pswdConfirmWdsLabel.text = @"   重复确认:";
    
    _pswdConfirmField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_pswdConfirmField setBorderStyle:UITextBorderStyleNone];
    [_pswdConfirmField setBackgroundColor:[UIColor whiteColor]];
    _pswdConfirmField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pswdConfirmField.text = @"请再次输入新密码";
    _pswdConfirmField.font = [UIFont systemFontOfSize:15];
    _pswdConfirmField.textColor = [UIColor lightGrayColor];
    _pswdConfirmField.delegate = self;
    _pswdConfirmField.clearsOnBeginEditing = YES;
    _pswdConfirmField.leftViewMode = UITextFieldViewModeAlways;
    _pswdConfirmField.leftView = pswdConfirmWdsLabel;
    _pswdConfirmField.hidden = YES;
    [_scrollView addSubview:_pswdConfirmField];
    
    // 确认按钮
    relationP.y = relationP.y + height + 30;
    height = 30;

    _confirmBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, relationP.y-100, frameR.size.width-40, height)];
    [_confirmBtnLabel.layer setBackgroundColor:[UIColor colorWithRed:241.0/255 green:83.0/255 blue:80.0/255 alpha:1.0].CGColor];
    [_confirmBtnLabel.layer setCornerRadius:3];
    _confirmBtnLabel.text = @"提交修改";
    _confirmBtnLabel.textColor = [UIColor whiteColor];
    _confirmBtnLabel.userInteractionEnabled = YES;
    [_confirmBtnLabel setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_confirmBtnLabel];
    
    UITapGestureRecognizer *loginReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestEditUserInfo)];
    [_confirmBtnLabel addGestureRecognizer:loginReco];
    
    int iTotalH = relationP.y + height + 15;
    iTotalH += 60;
    [_scrollView setContentSize:CGSizeMake(frameR.size.width, iTotalH)];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"资料修改";
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - edit mode
- (void)setEditMode:(ENUM_EDIT_MODE)editMode account:(NSString* _Nonnull)account oldInfo:(NSString* _Nonnull)oldInfo
{
    _editMode = editMode;
    _account = account;
    
    switch (editMode)
    {
        case ENUM_EDIT_MODE_SEX:
        {
            if ( [oldInfo compare:@"1"] == NSOrderedSame )
                [_sexSegment setSelectedSegmentIndex:0];
            else
                [_sexSegment setSelectedSegmentIndex:1];
            
            _oldValueField.hidden = YES;
            _sexSegment.hidden = NO;
        }
            break;
        case ENUM_EDIT_MODE_BIRTHDAY:
        {
            UILabel *leftLabel = (UILabel*)_oldValueField.leftView;
            [leftLabel setText:@"       生日:"];
            
            _oldValueField.text = oldInfo;
        }
            break;
        case ENUM_EDIT_MODE_EMAIL:
        {
            UILabel *leftLabel = (UILabel*)_oldValueField.leftView;
            [leftLabel setText:@"   邮箱地址:"];
            
            _oldValueField.text = oldInfo;
        }
            break;
        case ENUM_EDIT_MODE_PASSWORD:
        {
            UILabel *leftLabel = (UILabel*)_oldValueField.leftView;
            [leftLabel setText:@"     原密码:"];
            
            _newPswdField.hidden = NO;
            _pswdConfirmField.hidden = NO;
            
            CGRect btnR = _confirmBtnLabel.frame;
            btnR.origin.y += 100;
            [_confirmBtnLabel setFrame:btnR];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UITextFiled
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( textField == _newPswdField )
        _newPswdField.secureTextEntry = true;
    if ( textField == _pswdConfirmField )
        textField.secureTextEntry = true;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark - network
-(void)requestEditUserInfo
{
    NSString* email = nil;
    NSString* sex = nil;
    NSString* birthday = nil;
    NSString* qq = nil;
    NSString* mobile = nil;
    NSString* oldPaswd = nil;
    NSString* newPaswd = nil;
    
    switch (_editMode)
    {
        case ENUM_EDIT_MODE_SEX:
        {
            NSInteger selIndex = _sexSegment.selectedSegmentIndex;
            if ( selIndex == 0 )
            {
                sex = @"1";
            }
            else if ( selIndex == 1 )
            {
                sex = @"0";
            }
        }
            break;
        case ENUM_EDIT_MODE_BIRTHDAY:
        {
            if ( [_oldValueField.text compare:@""] == NSOrderedSame )
            {
                [MyAlertNotice showMessage:@"生日不能为空" timer:2.0f];
                return;
            }
            birthday = _oldValueField.text;
        }
            break;
        case ENUM_EDIT_MODE_EMAIL:
        {
            if ( [_oldValueField.text compare:@""] == NSOrderedSame )
            {
                [MyAlertNotice showMessage:@"邮箱不能为空" timer:2.0f];
                return;
            }
            email = _oldValueField.text;
        }
            break;
        case ENUM_EDIT_MODE_PASSWORD:
        {
            if ( [_oldValueField.text compare:@""] == NSOrderedSame )
            {
                [MyAlertNotice showMessage:@"原密码不能为空" timer:2.0f];
                return;
            }
            if ( [_newPswdField.text compare:@""] == NSOrderedSame )
            {
                [MyAlertNotice showMessage:@"新密码不能为空" timer:2.0f];
                return;
            }
            if ( [_pswdConfirmField.text compare:@""] == NSOrderedSame )
            {
                [MyAlertNotice showMessage:@"确认密码不能为空" timer:2.0f];
                return;
            }
            if ( [_pswdConfirmField.text compare:_newPswdField.text] != NSOrderedSame )
            {
                [MyAlertNotice showMessage:@"两次输入密码不一致" timer:2.0f];
                return;
            }
            oldPaswd = _oldValueField.text;
            newPaswd = _newPswdField.text;
        }
            break;
        default:
            break;
    }
    
    [_netLoading startAnimating];
    [[NetUser sharedInstance] reqEditUserInfo:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } account:_account email:email sex:sex birthday:birthday qq:qq mobile:mobile oldPaswd:oldPaswd newPaswd:newPaswd];
}


@end
