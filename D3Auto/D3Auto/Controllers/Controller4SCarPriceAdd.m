//
//  Controller4SCarInfo.m
//  D3Auto
//
//  Created by zhongfang on 15/11/12.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "Controller4SCarPriceAdd.h"

#import "Utils.h"
#import "Net4S.h"
#import "Config.h"
#import "NetUser.h"
#import "DataCenter.h"
#import "MyNetLoading.h"
#import "RDVTabBarController.h"
#import "MyAlertNotice.h"
#import "ModelUserInfo.h"


@interface Controller4SCarPriceAdd () <UITextFieldDelegate, UIPickerViewDelegate ,UIPickerViewDataSource>
{
    int                 _textFieldH;
    
    NSDictionary*       _attrDic;
    
    ModelUserInfo*      _userInfo;
    
    UITextField*        _attrField;
    UITextField*        _priceField;
    UITextField*        _promotionField;
    
    UIButton*           _pickerMaskBtn;
    UIPickerView*       _attrPicker;
    
    NSMutableArray*     _brandArray;
    NSMutableArray*     _carArray;
    NSMutableArray*     _attrArray;
    
    MyNetLoading*       _netLoading;
}
@end


@implementation Controller4SCarPriceAdd

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
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_KEY_USER_INFO];
    _userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    _attrDic = [[NSDictionary alloc] init];
    
    _brandArray = [[NSMutableArray alloc] init];
    _carArray = [[NSMutableArray alloc] init];
    _attrArray = [[NSMutableArray alloc] init];
}

-(void)initUI
{
    self.title = @"车辆报价";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //CGRect frame = self.view.frame;
    float viewH = self.view.frame.size.height - 64;
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, viewH);
    self.view.frame = frame;
    
    // 4S店配置价格
    CGPoint relationP = CGPointMake(0, 0);
    int height = 40;
    NSString* districtWds = @"     配置选择:";
    float districtWdsW = [Utils widthForString:districtWds fontSize:14] + 10;
    UILabel* districtWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, districtWdsW, height)];
    districtWdsLabel.backgroundColor = [UIColor clearColor];
    districtWdsLabel.textColor = [UIColor grayColor];
    districtWdsLabel.font = [UIFont systemFontOfSize:14];
    districtWdsLabel.text = districtWds;
    
    _attrField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frame.size.width, height)];
    [_attrField setBorderStyle:UITextBorderStyleNone];
    [_attrField setBackgroundColor:[UIColor whiteColor]];
    _attrField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _attrField.textColor = [UIColor blackColor];
    _attrField.delegate = self;
    _attrField.font = [UIFont systemFontOfSize:14];
    _attrField.clearsOnBeginEditing = NO;
    _attrField.leftViewMode = UITextFieldViewModeAlways;
    _attrField.leftView = districtWdsLabel;
    [self.view addSubview:_attrField];
    
    relationP.y = relationP.y + height - 0.5;
    height = 0.5;
    UIView* seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frame.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // 促销信息
    relationP.y = relationP.y + height;
    height = 40;
    NSString* promotionWds = @"     促销信息:";
    float promotionWdsW = [Utils widthForString:promotionWds fontSize:14] + 10;
    UILabel* promotionWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, promotionWdsW, height)];
    promotionWdsLabel.backgroundColor = [UIColor clearColor];
    promotionWdsLabel.textColor = [UIColor grayColor];
    promotionWdsLabel.font = [UIFont systemFontOfSize:14];
    promotionWdsLabel.text = promotionWds;
    
    _promotionField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frame.size.width, height)];
    [_promotionField setBorderStyle:UITextBorderStyleNone];
    [_promotionField setBackgroundColor:[UIColor whiteColor]];
    _promotionField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _promotionField.textColor = [UIColor blackColor];
    _promotionField.delegate = self;
    _promotionField.font = [UIFont systemFontOfSize:14];
    _promotionField.clearsOnBeginEditing = NO;
    _promotionField.leftViewMode = UITextFieldViewModeAlways;
    _promotionField.leftView = promotionWdsLabel;
    [self.view addSubview:_promotionField];
    
    relationP.y = relationP.y + height - 0.5;
    height = 0.5;
    seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frame.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // 价格信息
    relationP.y = relationP.y + height;
    height = 40;
    
    NSString* detailWds = @"  价格(万元):";
    float detailWdsW = [Utils widthForString:detailWds fontSize:14] + 10;
    UILabel* detailWdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, detailWdsW, height)];
    detailWdsLabel.backgroundColor = [UIColor clearColor];
    detailWdsLabel.textColor = [UIColor grayColor];
    detailWdsLabel.font = [UIFont systemFontOfSize:14];
    detailWdsLabel.text = detailWds;
    
    _priceField = [[UITextField alloc] initWithFrame:CGRectMake(0, relationP.y, frame.size.width, height)];
    [_priceField setBorderStyle:UITextBorderStyleNone];
    [_priceField setBackgroundColor:[UIColor whiteColor]];
    _priceField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _priceField.textColor = [UIColor blackColor];
    _priceField.delegate = self;
    _priceField.font = [UIFont systemFontOfSize:14];
    _priceField.clearsOnBeginEditing = NO;
    _priceField.leftViewMode = UITextFieldViewModeAlways;
    _priceField.leftView = detailWdsLabel;
    [self.view addSubview:_priceField];
    
    relationP.y = relationP.y + height - 0.5;
    height = 0.5;
    seperatorlINE = [[UIView alloc] initWithFrame:CGRectMake(0, relationP.y, frame.size.width, height)];
    [seperatorlINE setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorlINE];
    
    // 提交按钮
    UILabel* saveAddrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    [saveAddrLabel setCenter:CGPointMake(frame.size.width/2, frame.size.height-saveAddrLabel.frame.size.height/2)];
    saveAddrLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:83.0/255 blue:80.0/255 alpha:1.0];
    saveAddrLabel.text = @"保存";
    saveAddrLabel.textColor = [UIColor whiteColor];
    saveAddrLabel.userInteractionEnabled = YES;
    [saveAddrLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:saveAddrLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onConfirmClicked:)];
    [saveAddrLabel addGestureRecognizer:tap];
    
    // 筛选时的背景遮罩
    _pickerMaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_pickerMaskBtn setBackgroundColor:[UIColor blackColor]];
    [_pickerMaskBtn setAlpha:0.3f];
    [_pickerMaskBtn setHidden:YES];
    [_pickerMaskBtn addTarget:self action:@selector(onPickerMaskBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickerMaskBtn];
    
    // 城市筛选器
    _attrPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, frame.size.height-64-180, frame.size.width, 180)];
    _attrPicker.tag = 0;
    [_attrPicker setHidden:YES];
    _attrPicker.delegate = self;
    _attrPicker.dataSource = self;
    _attrPicker.showsSelectionIndicator = YES;
    [self.view addSubview:_attrPicker];
    _attrPicker.backgroundColor = [UIColor whiteColor];
    
    // loading
    _netLoading = [[MyNetLoading alloc] init];
    [_netLoading setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:_netLoading];
}

-(void)updateUI:(NSDictionary*)addrDic
{
    NSString* addrWds = [NSString stringWithFormat:@"%@ %@ %@ %@",[addrDic objectForKey:@"country_name"],[addrDic objectForKey:@"province_name"],[addrDic objectForKey:@"city_name"],[addrDic objectForKey:@"district_name"]];
    [_attrField setText:addrWds];
    [_priceField setText:[addrDic objectForKey:@"address"]];
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
    if ( textField == _attrField )
    {
        [_attrField resignFirstResponder];
        [_priceField resignFirstResponder];
        [_promotionField resignFirstResponder];
        
        // 点击地址的情况调用 UIPickerView
        [_attrPicker setHidden:NO];
        [_pickerMaskBtn setHidden:NO];
        
        [self requestComponent0Info:1];
        
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
        return [_brandArray count];
    }
    else if (component == 1) {
        return [_carArray count];
    }
    else {
        return [_attrArray count];
    }
}
//设置当前行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"titleForRow");
    if(component == 0 && row < [_brandArray count]) {
        return [[_brandArray objectAtIndex:row] valueForKey:@"cate_name"];
    }
    else if (component == 1 && row < [_carArray count]) {
        return [[_carArray objectAtIndex:row] valueForKey:@"car_name"];
    }
    else if (component == 3 && row < [_attrArray count]) {
        return [[_attrArray objectAtIndex:row] valueForKey:@"attr_name"];
    }
    return nil;
    
}
//选择的行数
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelectRow");
    if (component == 0 && row < [_brandArray count])
    {
        NSDictionary* provinceDic = [_brandArray objectAtIndex:row];
        [self requestComponent1Info:[provinceDic objectForKey:@"cate_id"]];
    }
    else if (component == 1 && row < [_carArray count])
    {
        NSDictionary* cityDic = [_carArray objectAtIndex:row];
        [self requestComponent2Info:[cityDic objectForKey:@"car_id"]];
    }
    else if (component == 2 && row < [_attrArray count])
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
        titleLabel.text = [[_brandArray objectAtIndex:row] valueForKey:@"cate_name"];
    }
    else if (component == 1) {
        titleLabel.text = [[_carArray objectAtIndex:row] valueForKey:@"car_name"];
    }
    else {
        titleLabel.text = [[_attrArray objectAtIndex:row] valueForKey:@"attr_name"];
    }
    return titleLabel;
    
}
// 显示选择结果
- (void)UpdateDistrictTextField
{
    NSLog(@"UpdateDistrictTextField");
    NSInteger cityRow0 = [_attrPicker selectedRowInComponent:0];
    NSInteger cityRow1 = [_attrPicker selectedRowInComponent:1];
    NSInteger cityRow2 = [_attrPicker selectedRowInComponent:2];
    
    NSString* provinceWds = @"";
    NSString* cityWds = @"";
    NSString* district = @"";
    
    if ( 0 <= cityRow0 && cityRow0 < [_brandArray count] )
        provinceWds = [[_brandArray objectAtIndex:cityRow0] valueForKey:@"cate_name"];
    
    if ( 0 <= cityRow1 && cityRow1 < [_carArray count] )
        cityWds = [[_carArray objectAtIndex:cityRow1] valueForKey:@"car_name"];
    
    if ( 0 <= cityRow2 && cityRow2 < [_attrArray count] )
        district = [[_attrArray objectAtIndex:cityRow2] valueForKey:@"attr_name"];
    
    
    NSString* addrWds = [NSString stringWithFormat:@"%@ %@ %@",provinceWds,cityWds,district];
    [_attrField setText:addrWds];
}

#pragma mark - clicked event
-(void)onConfirmClicked:(UITapGestureRecognizer*)sender
{
    NSString* str = _attrField.text;
    if ( [str compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"配置信息不能为空" timer:2.0f];
        return;
    }
    
    str = _priceField.text;
    if ( [str compare:@""] == NSOrderedSame )
    {
        [MyAlertNotice showMessage:@"价格不能为空" timer:2.0f];
        return;
    }
    
    // 请求数据结构填充
    NSMutableDictionary* addPriceDic = [[NSMutableDictionary alloc] init];
    [addPriceDic setValue:_userInfo.shopID forKey:@"shop_id"];
    [addPriceDic setValue:_priceField.text forKey:@"car_attr_price"];
    [addPriceDic setValue:_promotionField.text forKey:@"promotion_info"];
    
    // 地址
    NSInteger brandIndex = [_attrPicker selectedRowInComponent:0];
    NSInteger carIndex = [_attrPicker selectedRowInComponent:1];
    NSInteger attrIndex = [_attrPicker selectedRowInComponent:2];
    if ( 0 <= brandIndex && brandIndex < [_brandArray count] )
    {
        [addPriceDic setValue:[[_brandArray objectAtIndex:brandIndex] valueForKey:@"cate_id"] forKey:@"brand_cate_id"];
        [addPriceDic setValue:[[_brandArray objectAtIndex:brandIndex] valueForKey:@"cate_name"] forKey:@"brand_cate_name"];
    }
    if ( 0 <= carIndex && carIndex < [_carArray count] )
    {
        [addPriceDic setValue:[[_carArray objectAtIndex:carIndex] valueForKey:@"car_id"] forKey:@"car_id"];
        [addPriceDic setValue:[[_carArray objectAtIndex:carIndex] valueForKey:@"car_name"] forKey:@"car_name"];
    }
    if ( 0 <= attrIndex && attrIndex < [_attrArray count] )
    {
        [addPriceDic setValue:[[_attrArray objectAtIndex:attrIndex] valueForKey:@"attr_id"] forKey:@"car_attr_id"];
        [addPriceDic setValue:[[_attrArray objectAtIndex:attrIndex] valueForKey:@"attr_name"] forKey:@"car_attr_name"];
    }

    [self requestAdd4SPrice:addPriceDic];
}

-(void)onPickerMaskBtnClicked:(UIButton*)sender
{
    [_attrPicker setHidden:YES];
    [_pickerMaskBtn setHidden:YES];
}

#pragma mark - network

-(void)userInfoEditResult:(NSDictionary*)resultDic
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestAdd4SPrice:(NSMutableDictionary*)priceDic
{
    [_netLoading startAnimating];
    [[Net4S sharedInstance] reqAddCarPrice:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [MyAlertNotice showMessage:@"操作成功！" timer:2.0f];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
        }
    } fail:^(NSError *error) { [_netLoading stopAnimating]; } dic:priceDic];
}

-(void)requestComponent0Info:(int)parentID
{
    [_netLoading startAnimating];
    
    [[Net4S sharedInstance] req4SBrandList:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_netLoading stopAnimating];
            [_brandArray removeAllObjects];
            NSMutableArray* bArray = [[NSMutableArray alloc] initWithArray:success[@"data"]];
            for ( int i = 0; i < [bArray count]; i++ )
            {
                NSDictionary* dic = bArray[i];
                if ( [[dic valueForKey:@"parent_id"] intValue] == 0 )
                {
                    // 移除parentid＝0的分类 此级别分类时字母
                    [bArray removeObjectAtIndex:i];
                    continue;
                }
            }
            
            [_brandArray addObjectsFromArray:bArray];
            [self requestComponent1Info:[[_brandArray objectAtIndex:0] valueForKey:@"cate_id"]];
            
            [_attrPicker reloadComponent:0];
            [self UpdateDistrictTextField];
        }
    } fail:^(NSError *error) { [_netLoading stopAnimating]; } andRetLevel:2];
}

-(void)requestComponent1Info:(NSString*)brandID
{
    [_netLoading startAnimating];
    
    [[Net4S sharedInstance] reqCarListWithoutBrand:^(id success) {
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            NSArray* array = success[@"data"];
            
            if ( [array count] <= 0)
                return;
            
            [_netLoading stopAnimating];
            [_carArray removeAllObjects];
            [_carArray addObjectsFromArray:array];
            [_attrPicker reloadComponent:1];
            [self UpdateDistrictTextField];
            
            [self requestComponent2Info:[[_carArray objectAtIndex:0] valueForKey:@"car_id"]];
        }
    } fail:^(NSError *error) { [_netLoading stopAnimating]; } brandID:brandID];
}

-(void)requestComponent2Info:(NSString*)carID
{
    [_netLoading startAnimating];
    
    [[Net4S sharedInstance] req4SCarDetail:^(id success) {
        
        [_netLoading stopAnimating];
        
        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
        {
            [_attrArray removeAllObjects];
            NSArray* array = success[@"data"][@"attribute"];
            for ( int i = 0; i < [array count]; i++ )
            {
                NSDictionary* dic = [array objectAtIndex:i];
                if ( [[dic valueForKey:@"parent_id"] integerValue] == 0 )
                    continue;
                [_attrArray addObject:[array objectAtIndex:i]];
            }
            
            [_attrPicker reloadComponent:2];
            [self UpdateDistrictTextField];
        }
        
    } fail:^(NSError *error) {
        
        [_netLoading stopAnimating];
        
    } andCateID:carID];
}

@end
