//
//  ControllerFill4SInfo.m
//  D3Auto
//
//  Created by zhongfang on 15/11/9.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerFill4SInfo.h"

#import "Utils.h"
#import "NetUser.h"
#import "DataCenter.h"
#import "MyNetLoading.h"
#import "RDVTabBarController.h"
#import "MyAlertNotice.h"

@interface ControllerFill4SInfo () <UITextFieldDelegate, UIPickerViewDelegate ,UIPickerViewDataSource>
{
    int                 _textFieldH;
    
    NSDictionary*       _addrDic;
    
    UITextField*        _nameField;
    UITextField*        _mobileField;
    UITextField*        _telField;
    UITextField*        _emailField;
    UITextField*        _districtField;
    UITextField*        _detailField;
    
    UILabel*            _longitudeLabel;
    UILabel*            _latitudeLabel;
    
    UIButton*           _pickerMaskBtn;
    UIPickerView*       _cityPicker;
    
    NSMutableArray*     _provinceArray;
    NSMutableArray*     _cityArray;
    NSMutableArray*     _districtArray;
    
    MyNetLoading*       _netLoading;
}
@end

@implementation ControllerFill4SInfo

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
    _textFieldH = 40;
    
    _addrDic = [[NSDictionary alloc] init];
    
    _provinceArray = [[NSMutableArray alloc] init];
    _cityArray = [[NSMutableArray alloc] init];
    _districtArray = [[NSMutableArray alloc] init];
}

-(void)initUI
{
    self.title = @"4S店信息";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect frameR = self.view.frame;
    
    // 4S店信息
    CGPoint relationP = CGPointMake(0, 0);
    int height = 40;
    
    NSString* nameWds = @"  店铺名称:";
    float nameWdsW = [Utils widthForString:nameWds fontSize:14] + 10;
    UILabel* nameWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameWdsW, height)];
    nameWdsLabel.backgroundColor = [UIColor clearColor];
    nameWdsLabel.textColor = [UIColor grayColor];
    nameWdsLabel.font = [UIFont systemFontOfSize:14];
    nameWdsLabel.text = nameWds;
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_nameField setBorderStyle:UITextBorderStyleNone];
    [_nameField setBackgroundColor:[UIColor whiteColor]];
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.textColor = [UIColor blackColor];
    _nameField.delegate = self;
    _nameField.font = [UIFont systemFontOfSize:14];
    _nameField.clearsOnBeginEditing = NO;
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    _nameField.leftView = nameWdsLabel;
    [self.view addSubview:_nameField];
    
    relationP.y = relationP.y + height;
    height = 0.5;
    UIView* seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // 联系方式
    relationP.y = relationP.y + height;
    height = 40;
    
    NSString* mobileWds = @"  手机号码:";
    float mobileWdsW = [Utils widthForString:mobileWds fontSize:14] + 10;
    UILabel* mobileWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mobileWdsW, height)];
    mobileWdsLabel.backgroundColor = [UIColor clearColor];
    mobileWdsLabel.textColor = [UIColor grayColor];
    mobileWdsLabel.font = [UIFont systemFontOfSize:14];
    mobileWdsLabel.text = mobileWds;
    
    _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_mobileField setBorderStyle:UITextBorderStyleNone];
    [_mobileField setBackgroundColor:[UIColor whiteColor]];
    _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileField.textColor = [UIColor blackColor];
    _mobileField.delegate = self;
    _mobileField.font = [UIFont systemFontOfSize:14];
    _mobileField.clearsOnBeginEditing = NO;
    _mobileField.leftViewMode = UITextFieldViewModeAlways;
    _mobileField.leftView = mobileWdsLabel;
    [self.view addSubview:_mobileField];
    
    // 联系方式
    relationP.y = relationP.y + height;
    height = 40;
    
    NSString* telWds = @"  座机号码:";
    float telWdsW = [Utils widthForString:telWds fontSize:14] + 10;
    UILabel* telWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, telWdsW, height)];
    telWdsLabel.backgroundColor = [UIColor clearColor];
    telWdsLabel.textColor = [UIColor grayColor];
    telWdsLabel.font = [UIFont systemFontOfSize:14];
    telWdsLabel.text = telWds;
    
    _telField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_telField setBorderStyle:UITextBorderStyleNone];
    [_telField setBackgroundColor:[UIColor whiteColor]];
    _telField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telField.keyboardType = UIKeyboardTypeNumberPad;
    _telField.textColor = [UIColor blackColor];
    _telField.delegate = self;
    _telField.font = [UIFont systemFontOfSize:14];
    _telField.clearsOnBeginEditing = NO;
    _telField.leftViewMode = UITextFieldViewModeAlways;
    _telField.leftView = telWdsLabel;
    [self.view addSubview:_telField];
    
    relationP.y = relationP.y + height - 0.5;
    height = 0.5;
    seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // EMAIL
    relationP.y = relationP.y + height;
    height = 40;
    
    NSString* emailWds = @"  电子邮箱:";
    float emailWdsW = [Utils widthForString:emailWds fontSize:14] + 10;
    UILabel* emailWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, emailWdsW, height)];
    emailWdsLabel.backgroundColor = [UIColor clearColor];
    emailWdsLabel.textColor = [UIColor grayColor];
    emailWdsLabel.font = [UIFont systemFontOfSize:14];
    emailWdsLabel.text = emailWds;
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_emailField setBorderStyle:UITextBorderStyleNone];
    [_emailField setBackgroundColor:[UIColor whiteColor]];
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailField.textColor = [UIColor blackColor];
    _emailField.delegate = self;
    _emailField.font = [UIFont systemFontOfSize:14];
    _emailField.clearsOnBeginEditing = NO;
    _emailField.leftViewMode = UITextFieldViewModeAlways;
    _emailField.leftView = emailWdsLabel;
    [self.view addSubview:_emailField];
    
    relationP.y = relationP.y + height - 0.5;
    height = 0.5;
    seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // 所在地区
    relationP.y = relationP.y + height;
    height = 40;
    
    NSString* districtWds = @"  所在地区:";
    float districtWdsW = [Utils widthForString:districtWds fontSize:14] + 10;
    UILabel* districtWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, districtWdsW, height)];
    districtWdsLabel.backgroundColor = [UIColor clearColor];
    districtWdsLabel.textColor = [UIColor grayColor];
    districtWdsLabel.font = [UIFont systemFontOfSize:14];
    districtWdsLabel.text = districtWds;
    
    _districtField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_districtField setBorderStyle:UITextBorderStyleNone];
    [_districtField setBackgroundColor:[UIColor whiteColor]];
    _districtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _districtField.textColor = [UIColor blackColor];
    _districtField.delegate = self;
    _districtField.font = [UIFont systemFontOfSize:14];
    _districtField.clearsOnBeginEditing = NO;
    _districtField.leftViewMode = UITextFieldViewModeAlways;
    _districtField.leftView = districtWdsLabel;
    [self.view addSubview:_districtField];
    
    relationP.y = relationP.y + height - 0.5;
    height = 0.5;
    seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // 详细地址
    relationP.y = relationP.y + height;
    height = 40;
    
    NSString* detailWds = @"  详细地址:";
    float detailWdsW = [Utils widthForString:detailWds fontSize:14] + 10;
    UILabel* detailWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, detailWdsW, height)];
    detailWdsLabel.backgroundColor = [UIColor clearColor];
    detailWdsLabel.textColor = [UIColor grayColor];
    detailWdsLabel.font = [UIFont systemFontOfSize:14];
    detailWdsLabel.text = detailWds;
    
    _detailField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [_detailField setBorderStyle:UITextBorderStyleNone];
    [_detailField setBackgroundColor:[UIColor whiteColor]];
    _detailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _detailField.textColor = [UIColor blackColor];
    _detailField.delegate = self;
    _detailField.font = [UIFont systemFontOfSize:14];
    _detailField.clearsOnBeginEditing = NO;
    _detailField.leftViewMode = UITextFieldViewModeAlways;
    _detailField.leftView = detailWdsLabel;
    [self.view addSubview:_detailField];
    
    // 经纬度label
    relationP.y = relationP.y + height + 10;
    height = 40;
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    double longitude = [userDefault doubleForKey:DEF_KEY_LONGITUDE];
    double latitude = [userDefault doubleForKey:DEF_KEY_LATITUDE];
    NSString* longtitudeStr = [NSString stringWithFormat:@"经度：%lf",longitude];
    NSString* latitudeStr = [NSString stringWithFormat:@"纬度：%lf",latitude];
    
    _longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width/2, height)];
    [_longitudeLabel setBackgroundColor:[UIColor whiteColor]];
    [_longitudeLabel setText:longtitudeStr];
    [_longitudeLabel setTextColor:[UIColor grayColor]];
    [_longitudeLabel setTextAlignment:NSTextAlignmentCenter];
    [_longitudeLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_longitudeLabel];
    
    _latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameR.size.width/2, relationP.y, frameR.size.width/2, height)];
    [_latitudeLabel setBackgroundColor:[UIColor whiteColor]];
    [_latitudeLabel setText:latitudeStr];
    [_latitudeLabel setTextColor:[UIColor grayColor]];
    [_latitudeLabel setTextAlignment:NSTextAlignmentCenter];
    [_latitudeLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_latitudeLabel];
    
    relationP.y = relationP.y + height - 0.5;
    height = 0.5;
    seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frameR.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // 提交按钮
    UILabel* saveAddrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameR.size.width-60, 40)];
    [saveAddrLabel setCenter:CGPointMake(frameR.size.width/2, frameR.size.height-64-60/2)];
    saveAddrLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:83.0/255 blue:80.0/255 alpha:1.0];
    saveAddrLabel.text = @"保存";
    saveAddrLabel.textColor = [UIColor whiteColor];
    saveAddrLabel.userInteractionEnabled = YES;
    [saveAddrLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:saveAddrLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onConfirmClicked:)];
    [saveAddrLabel addGestureRecognizer:tap];
    
    // 筛选时的背景遮罩
    _pickerMaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frameR.size.width, frameR.size.height)];
    [_pickerMaskBtn setBackgroundColor:[UIColor blackColor]];
    [_pickerMaskBtn setAlpha:0.3f];
    [_pickerMaskBtn setHidden:YES];
    [_pickerMaskBtn addTarget:self action:@selector(onPickerMaskBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickerMaskBtn];
    
    // 城市筛选器
    _cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, frameR.size.height-64-180, frameR.size.width, 180)];
    _cityPicker.tag = 0;
    [_cityPicker setHidden:YES];
    _cityPicker.delegate = self;
    _cityPicker.dataSource = self;
    _cityPicker.showsSelectionIndicator = YES;
    [self.view addSubview:_cityPicker];
    _cityPicker.backgroundColor = [UIColor whiteColor];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}

-(void)updateUI:(NSDictionary*)addrDic
{
    [_nameField setText:[addrDic objectForKey:@"consignee"]];
    [_mobileField setText:[addrDic objectForKey:@"mobile"]];
    [_telField setText:[addrDic objectForKey:@"tel"]];
    [_emailField setText:[addrDic objectForKey:@"email"]];
    NSString* addrWds = [NSString stringWithFormat:@"%@ %@ %@ %@",[addrDic objectForKey:@"country_name"],[addrDic objectForKey:@"province_name"],[addrDic objectForKey:@"city_name"],[addrDic objectForKey:@"district_name"]];
    [_districtField setText:addrWds];
    [_detailField setText:[addrDic objectForKey:@"address"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 返回一个BOOL值，指定是否循序文本字段开始编辑
    if ( textField == _districtField )
    {
        [_nameField resignFirstResponder];
        [_mobileField resignFirstResponder];
        [_telField resignFirstResponder];
        [_emailField resignFirstResponder];
        [_districtField resignFirstResponder];
        [_detailField resignFirstResponder];
        
        // 点击地址的情况调用 UIPickerView
        [_cityPicker setHidden:NO];
        [_pickerMaskBtn setHidden:NO];
        
        [self requestComponent0RegionInfo:1];
        [self requestComponent1RegionInfo:2];
        [self requestComponent2RegionInfo:52];
        
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 开始编辑时触发，文本字段将成为first responder
    //[self animateTextField: textField up: YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[self animateTextField: textField up: NO];
    [textField resignFirstResponder];
    return  YES;
}
// 键盘弹出时移动frame
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    int offsetY = self.view.frame.origin.y;
    if ( up && offsetY < 0 && offsetY == movement )
        return;
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}


#pragma mark - UIPackerView delegate
//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"numberOfRowsInComponent");
    if (component == 0) {
        return [_provinceArray count];
    }
    else if (component == 1) {
        return [_cityArray count];
    }
    else {
        return [_districtArray count];
    }
}
//设置当前行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"titleForRow");
    if(component == 0 && row < [_provinceArray count]) {
        return [[_provinceArray objectAtIndex:row] valueForKey:@"name"];
    }
    else if (component == 1 && row < [_cityArray count]) {
        return [[_cityArray objectAtIndex:row] valueForKey:@"name"];
    }
    else if (component == 3 && row < [_districtArray count]) {
        return [[_districtArray objectAtIndex:row] valueForKey:@"name"];
    }
    return nil;
    
}
//选择的行数
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelectRow");
    if (component == 0 && row < [_provinceArray count])
    {
        NSDictionary* provinceDic = [_provinceArray objectAtIndex:row];
        int provinceID = [[provinceDic objectForKey:@"id"] intValue];
        [self requestComponent1RegionInfo:provinceID];
    }
    else if (component == 1 && row < [_cityArray count])
    {
        NSDictionary* cityDic = [_cityArray objectAtIndex:row];
        int cityID = [[cityDic objectForKey:@"id"] intValue];
        [self requestComponent2RegionInfo:cityID];
    }
    else if (component == 2 && row < [_districtArray count])
    {
        [self UpdateDistrictTextField];
    }
}
//每行显示的文字样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSLog(@"viewForRow");
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (component == 0) {
        titleLabel.text = [[_provinceArray objectAtIndex:row] valueForKey:@"name"];
    }
    else if (component == 1) {
        titleLabel.text = [[_cityArray objectAtIndex:row] valueForKey:@"name"];
    }
    else {
        titleLabel.text = [[_districtArray objectAtIndex:row] valueForKey:@"name"];
    }
    return titleLabel;
    
}
// 显示选择结果
- (void)UpdateDistrictTextField
{
    NSLog(@"UpdateDistrictTextField");
    NSInteger cityRow0 = [_cityPicker selectedRowInComponent:0];
    NSInteger cityRow1 = [_cityPicker selectedRowInComponent:1];
    NSInteger cityRow2 = [_cityPicker selectedRowInComponent:2];
    
    NSString* provinceWds = @"";
    NSString* cityWds = @"";
    NSString* district = @"";
    
    if ( 0 <= cityRow0 && cityRow0 < [_provinceArray count] )
        provinceWds = [[_provinceArray objectAtIndex:cityRow0] valueForKey:@"name"];
    
    if ( 0 <= cityRow1 && cityRow1 < [_cityArray count] )
        cityWds = [[_cityArray objectAtIndex:cityRow1] valueForKey:@"name"];
    
    if ( 0 <= cityRow2 && cityRow2 < [_districtArray count] )
        district = [[_districtArray objectAtIndex:cityRow2] valueForKey:@"name"];
    
    
    NSString* addrWds = [NSString stringWithFormat:@"中国 %@ %@ %@",provinceWds,cityWds,district];
    [_districtField setText:addrWds];
}

#pragma mark - clicked event
-(void)onConfirmClicked:(UITapGestureRecognizer*)sender
{
    NSString* str = _nameField.text;
    if ( [str compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"4S店信息不能为空" timer:2.0f];
        return;
    }
    
    str = _mobileField.text;
    if ( [str compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"手机号码信息不能为空" timer:2.0f];
        return;
    }
    
    str = _emailField.text;
    if ( [str compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"电子邮箱信息不能为空" timer:2.0f];
        return;
    }
    
    str = _districtField.text;
    if ( [str compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"所在区域信息不能为空" timer:2.0f];
        return;
    }
    
    str = _detailField.text;
    if ( [str compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"详细地址信息不能为空" timer:2.0f];
        return;
    }
    
    NSMutableDictionary* addAddrDic = [[NSMutableDictionary alloc] init];
    if ( _addrDic == nil )
    {
    }
    else
    {
        //[addAddrDic setValuesForKeysWithDictionary:_addrDic];
    }
    
    [addAddrDic setValue:_nameField.text forKey:@"shop_name"];
    [addAddrDic setValue:_mobileField.text forKey:@"shop_mobile"];
    [addAddrDic setValue:_telField.text forKey:@"shop_tel"];
    [addAddrDic setValue:_emailField.text forKey:@"shop_email"];
    [addAddrDic setValue:_detailField.text forKey:@"address"];
    [addAddrDic setValue:@"1" forKey:@"country"];
    
    // 地址
    NSInteger cityRow0 = [_cityPicker selectedRowInComponent:0];
    NSInteger cityRow1 = [_cityPicker selectedRowInComponent:1];
    NSInteger cityRow2 = [_cityPicker selectedRowInComponent:2];
    if ( 0 <= cityRow0 && cityRow0 < [_provinceArray count] )
    {
        [addAddrDic setValue:[[_provinceArray objectAtIndex:cityRow0] valueForKey:@"id"] forKey:@"province"];
    }
    if ( 0 <= cityRow1 && cityRow1 < [_cityArray count] )
    {
        [addAddrDic setValue:[[_cityArray objectAtIndex:cityRow1] valueForKey:@"id"] forKey:@"city"];
    }
    if ( 0 <= cityRow2 && cityRow2 < [_districtArray count] )
    {
        [addAddrDic setValue:[[_districtArray objectAtIndex:cityRow2] valueForKey:@"id"] forKey:@"district"];
    }
    
    //if ( _addrDic == nil )
    {
        [self requestAdd4SUser:addAddrDic];
    }
    //else
    {
        //[self requestUpdateAddress:[[_addrDic objectForKey:@"id"] intValue] addrDic:addAddrDic];
    }
    
}

-(void)onPickerMaskBtnClicked:(UIButton*)sender
{
    [_cityPicker setHidden:YES];
    [_pickerMaskBtn setHidden:YES];
}

#pragma mark - network

-(void)userInfoEditResult:(NSDictionary*)resultDic
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestAdd4SUser:(NSMutableDictionary*)addrDic
{
    // session
    NSString* sessionID = [[NSUserDefaults standardUserDefaults] stringForKey:DEF_KEY_SESSION_ID];
    NSString* userID = [[NSUserDefaults standardUserDefaults] stringForKey:DEF_KEY_USER_ID];
    if ( sessionID == nil || userID == nil )
        return;
    NSMutableDictionary* sessionDic = [[NSMutableDictionary alloc] init];
    [sessionDic setValue:sessionID forKey:@"sid"];
    [sessionDic setValue:userID forKey:@"uid"];
    [addrDic setObject:sessionDic forKey:@"session"];
    
    // 经纬度
    double longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:DEF_KEY_LONGITUDE];
    double latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:DEF_KEY_LATITUDE];
    if ( longitude == 0 || latitude == 0 )
    {
        [MyAlertNotice showMessage:@"定位信息不存在，请重新定位！" timer:2.0f];
        return;
    }
    [addrDic setValue:[NSString stringWithFormat:@"%lf",longitude] forKey:@"longitude"];
    [addrDic setValue:[NSString stringWithFormat:@"%lf",latitude] forKey:@"latitude"];
    
    [_netLoading startAnimating];
    NetUser * net = [NetUser sharedInstance];
    
    [net reqAdd4SUser:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [MyAlertNotice showMessage:@"操作成功，请等待管理员审核！" timer:2.0f];

            [self.navigationController popViewControllerAnimated:YES];
        }
        else if( success[@"status"] && [[success[@"status"] valueForKey:@"error_code"] intValue] == 100 )
        {
            [MyAlertNotice showMessage:@"您的账号已过期，请尝试重新登陆！" timer:4.0f];
            [[DataCenter sharedInstance] cleanLoginInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) { [_netLoading stopAnimating]; } dic:addrDic];
}

-(void)requestUpdateAddress:(int)addrID addrDic:(NSDictionary*)addrDic
{
    [_netLoading startAnimating];
    
    /*NetworkModel * net = [NetworkModel sharedNetworkModel];
    
    [net request_AddrUpdate_Datasuc:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [MyAlert showMessage:@"操作成功" timer:2.0f];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MyAlert showMessage:@"操作失败" timer:2.0f];
        }
        
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        [MyAlert showMessage:@"操作失败" timer:2.0f];
        
    } addrID:addrID addrDic:addrDic];*/
}

-(void)requestComponent0RegionInfo:(int)parentID
{
    [_netLoading startAnimating];
    
    NetUser * net = [NetUser sharedInstance];
    
    [net reqRegion:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_provinceArray removeAllObjects];
            [_provinceArray addObjectsFromArray:success[@"data"][@"regions"]];
            [_cityPicker reloadComponent:0];
            [self UpdateDistrictTextField];
        }
        
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } parentID:parentID];
}

-(void)requestComponent1RegionInfo:(int)parentID
{
    [_netLoading startAnimating];
    
    NetUser * net = [NetUser sharedInstance];
    
    [net reqRegion:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_cityArray removeAllObjects];
            [_cityArray addObjectsFromArray:success[@"data"][@"regions"]];
            [_cityPicker reloadComponent:1];
            [self UpdateDistrictTextField];
        }
        
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } parentID:parentID];
}

-(void)requestComponent2RegionInfo:(int)parentID
{
    [_netLoading startAnimating];
    
    NetUser * net = [NetUser sharedInstance];
    
    [net reqRegion:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_districtArray removeAllObjects];
            [_districtArray addObjectsFromArray:success[@"data"][@"regions"]];
            [_cityPicker reloadComponent:2];
            [self UpdateDistrictTextField];
        }
        
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } parentID:parentID];
}

@end
