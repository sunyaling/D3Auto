//
//  ControllerUploadPhoto.m
//  D3Auto
//
//  Created by apple on 15/11/28.
//  Copyright © 2015年 xinli. All rights reserved.
//

#import "ControllerUploadPhoto.h"

#import <Photos/Photos.h>

#import "Config.h"
#import "NetUser.h"
#import "MyAlertNotice.h"
#import "RDVTabBarController.h"
#import "MyCollectionViewCell.h"

@interface ControllerUploadPhoto () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView*       _collectionView;
    
    UIProgressView*         _progressUpload;
}

@property (nonatomic,strong) PHFetchResult* assetsFetchResults;

@property (strong) PHCachingImageManager *imageManager;

@end

@implementation ControllerUploadPhoto

- (instancetype)init
{
    if ( self = [super init] )
    {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData
{
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    
    UIBarButtonItem* confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(onClickedCommit)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
    
    _progressUpload = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressUpload setFrame:CGRectMake(10, self.view.frame.size.height-30, self.view.frame.size.width-2*10, 8)];
    [_progressUpload setHidden:YES];
    [self.view addSubview:_progressUpload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    UINavigationController* navigationController = (UINavigationController*)[[self rdv_tabBarController] selectedViewController];
    [navigationController setNavigationBarHidden:NO animated:YES];
    
    [self cacheGalleryPhotos];
}

- (void)cacheGalleryPhotos
{
    // 获取当前应用对照片的访问授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == PHAuthorizationStatusRestricted || authorizationStatus == PHAuthorizationStatusDenied)
    {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
        NSString* tipAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:tipAuthorization preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){[self.navigationController popViewControllerAnimated:YES];}];
        [alert addAction:btnAction];
        [self presentViewController: alert animated: YES completion: nil];
    }
    else
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        
        self.imageManager = [[PHCachingImageManager alloc] init];
    }
}

#pragma mark - UICollectionViewDelegate
// UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell* cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if ( cell.isSelected )
    {
        cell.isSelected = NO;
        cell.backgroundColor = [UIColor clearColor];
    }
    else
    {
        int selectCount = 0;
        for ( UIView* view in collectionView.subviews )
        {
            if ( [view isKindOfClass:NSClassFromString(@"MyCollectionViewCell")] )
            {
                MyCollectionViewCell* cell = (MyCollectionViewCell*)view;
                
                if ( cell.isSelected )
                    selectCount = selectCount + 1;
            }
        }
        
        if ( DEF_MAX_UPLOAD_SHOP <= selectCount )
        {
            NSString* tipText = [NSString stringWithFormat:@"允许上传最大图片数量为%d！", DEF_MAX_UPLOAD_SHOP];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:tipText preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
            [alert addAction:btnAction];
            [self presentViewController: alert animated: YES completion: nil];
            return;
        }
        
        cell.isSelected = YES;
        cell.backgroundColor = [UIColor redColor];
    }
    
    NSLog(@"选择%ld",indexPath.row);
}
// 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDataSource
// 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.assetsFetchResults.count;
    return count;
}
// 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewIdentifier" forIndexPath:indexPath];
    
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;
    
    CGFloat scale = 3.0f;//TODO:TEMP[UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    CGSize gridSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    PHAsset* asset = self.assetsFetchResults[indexPath.item];
    
    [self.imageManager requestImageForAsset:asset
                                 targetSize:gridSize
                                contentMode:PHImageContentModeDefault
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  if (cell.tag == currentTag)
                                      cell.thumbnailImage = result;
                              }];
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(87, 87);
}
// 定义每个UICollectionView 的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
// 定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
// 定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark - onclicked event
- (void)onClickedCommit
{
    NSString* tipText = [NSString stringWithFormat:@"上传照片将会删除之前上传过的照片，是否确定上传！"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:tipText preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) { [self doCommit]; }];
    [alert addAction:btnAction];
    [self presentViewController: alert animated: YES completion: nil];
}
- (void)doCommit
{
    int selectCount = 0;
    NSMutableArray* photoArray = [[NSMutableArray alloc] init];
    for ( UIView* view in _collectionView.subviews )
    {
        if ( [view isKindOfClass:NSClassFromString(@"MyCollectionViewCell")] )
        {
            MyCollectionViewCell* cell = (MyCollectionViewCell*)view;
            
            if ( cell.isSelected )
            {
                selectCount = selectCount + 1;
                [photoArray addObject:cell.thumbnailImage];
            }
        }
    }
    
    // 数量判断
    if ( selectCount <= 0 || DEF_MAX_UPLOAD_SHOP < selectCount )
    {
        NSString* tipText = [NSString stringWithFormat:@"允许上传的最小和最大图片数量分别为%d和%d！", 0, DEF_MAX_UPLOAD_SHOP];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:tipText preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
        [alert addAction:btnAction];
        [self presentViewController: alert animated: YES completion: nil];
        return;
    }
    
    // 上传操作
    [_progressUpload setHidden:NO];
    [[NetUser sharedInstance]
     reqUploadPhotos:^(id success) {
                        if ( success[@"status"] && [[success[@"status"] valueForKey:@"succeed"] intValue] == 1 )
                        {
                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"上传成功！" preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction* btnAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { [self.navigationController popViewControllerAnimated:YES]; }];
                            [alert addAction:btnAction];
                            [self presentViewController: alert animated: YES completion: nil];
                        }
                        else
                        {
                            [MyAlertNotice showMessage:[success[@"status"] valueForKey:@"error_desc"] timer:2.0f];
                        }
                    }
                fail:^(NSError *error) {
                        [MyAlertNotice showMessage:@"upload fail!!" timer:2.0f];
                    }
             process:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                        [_progressUpload setProgress:totalBytesWritten / (float)totalBytesExpectedToWrite animated:YES];
                    }
          photoArray:photoArray];
}



@end
