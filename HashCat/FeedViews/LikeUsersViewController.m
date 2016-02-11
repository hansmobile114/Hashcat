//
//  LikeUsersViewController.m
//  HashCat
//
//  Created by iOSDevStar on 8/3/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "LikeUsersViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "UserProfileViewController.h"
#import "CatProfileViewController.h"

@interface LikeUsersViewController ()

@end

@implementation LikeUsersViewController
@synthesize m_arrayResult;
@synthesize m_arrayData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [[[NSLocalizedString(@"badge_type_likes", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"badge_type_likes", nil) substringFromIndex:1]];

    m_arrayResult = [[NSMutableArray alloc] init];
    m_arrayData = [[NSMutableArray alloc] init];
    
    lBeforeId = 0;
    lSinceId = 0;
    
    __weak LikeUsersViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.m_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadAboveMore];
    }];
    
    // setup infinite scrolling
    [self.m_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadBelowMore];
    }];
    
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];

    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil
                              action:nil];
    item0.width = NAVI_BUTTON_OFFSET;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMainView)];
    self.navigationItem.leftBarButtonItems = @[item0, item1];

    bLoad = false;
    nPreLoadedCount = -1;
    fScrollHeight = 0.f;
    
    bDirectionMode = false;
    lBeforeId = 0;
    lSinceId = 0;
    
    if (!g_Delegate.m_bHasBottomBar)
        self.m_tableView.frame = CGRectMake(self.m_tableView.frame.origin.x, self.m_tableView.frame.origin.y, self.m_tableView.frame.size.width, self.m_tableView.frame.size.height + MENU_TAB_HEIGHT);
    
    [self getLikesRequest];

}

- (void)insertRowAtTop {
    __weak LikeUsersViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = 0; nIdx < weakSelf.m_arrayData.count; nIdx++)
        {
            [weakSelf.m_tableView beginUpdates];
            [weakSelf.m_arrayResult insertObject:[weakSelf.m_arrayData objectAtIndex:nIdx] atIndex:0];
            [weakSelf.m_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [weakSelf.m_tableView endUpdates];
        }
        
        [weakSelf.m_tableView.pullToRefreshView stopAnimating];
    });
}

- (void)insertRowAtBottom {
    __weak LikeUsersViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = 0; nIdx < weakSelf.m_arrayData.count; nIdx++)
//        for (int nIdx = weakSelf.m_arrayData.count - 1; nIdx >= 0; nIdx--)
        {
            [weakSelf.m_tableView beginUpdates];
            [weakSelf.m_arrayResult addObject:[weakSelf.m_arrayData objectAtIndex:nIdx]];
            [weakSelf.m_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.m_arrayResult.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.m_tableView endUpdates];
        }
        
        [weakSelf.m_tableView.infiniteScrollingView stopAnimating];
    });
}

- (void) loadAboveMore
{
    bDirectionMode = true;
    
    [self getLikesRequest];
}

- (void) loadBelowMore
{
    bDirectionMode = false;
    
    [self getLikesRequest];
}

- (void) getLikesRequest
{
    [self showLoadingView];
    
    if (!bLoad)
        [FeedService getLikes:self.m_nId siceId:0 beforeId:0 withDelegate:self];
    else
    {
        if (bDirectionMode)
            [FeedService getLikes:self.m_nId siceId:lSinceId beforeId:0 withDelegate:self];
        else
            [FeedService getLikes:self.m_nId siceId:0 beforeId:lBeforeId withDelegate:self];
    }
}

- (void) showLoadingView
{
    [self.view endEditing:YES];
    
    [YXSpritesLoadingView showWithText:NSLocalizedString(@"loading", nil) andShimmering:YES andBlurEffect:NO];
}

- (void) hideLoadingView
{
    [YXSpritesLoadingView dismiss];
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self.navigationController navigationBar] setBarTintColor:NAVI_COLOR];
    self.navigationController.navigationBar.translucent = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    
}

- (void) actionClickAdd:(SearchProfileView *)searchProfileView index:(int)nSelectedIndex
{
    NSLog(@"clicked add button");
}

- (void) actionViewProfile:(SearchProfileView *) searchProfileView index:(int) nSelectedIndex
{
    FollowEntity* entity = [m_arrayResult objectAtIndex:nSelectedIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
    viewCon.m_bMyProfile = false;
    viewCon.m_nUserId = entity.m_user.m_nID;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrayResult.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customcell";
    
    SearchProfileView *cell = [tableView
                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchProfileView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.m_imageView.image = [UIImage imageNamed:@"avatar_add_profile.png"];
    cell.delegate = self;
    cell.m_nIndex = (int)indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FollowEntity* followEntity = [m_arrayResult objectAtIndex:indexPath.row];
    cell.m_lblName.hidden = NO;
    cell.m_lblUserName.hidden = YES;
    cell.m_btnAdd.hidden = YES;
    cell.m_lblName.center = CGPointMake(cell.m_lblName.center.x, cell.m_imageView.center.y);
    
    cell.m_lblName.font = [UIFont fontWithName:MAIN_FONT_NAME size:18.f];
    
    cell.m_lblName.text = followEntity.m_user.m_strUsername;
    //load image=================================
    NSString* strPhoto = followEntity.m_user.m_strAvatarUrl;
    [[Utils sharedObject] loadImageFromServerAndLocal:strPhoto imageView:cell.m_imageView];
    //=======================================
    
    cell.m_lblName.center = CGPointMake(cell.m_lblName.center.x, 30.f);
    cell.m_imageView.center = CGPointMake(cell.m_imageView.center.x, 30.f);
    
    cell.m_viewContainer.frame = CGRectMake(3, 3, self.m_tableView.frame.size.width - 6.f, 54.f);
    
    cell.m_viewContainer.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
    cell.m_viewContainer.layer.borderWidth = 1.f;
    cell.m_viewContainer.clipsToBounds = YES;
    
    [[Utils sharedObject] makeShadowEffect:cell.m_viewContainer radius:3.f color:BOX_SHADOW_COLOR corner:0.f];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [self.m_tableView.pullToRefreshView stopAnimating];
    [self.m_tableView.infiniteScrollingView stopAnimating];
    
    NSString *receivedData = [request responseString];
    NSArray* arrResponse = [receivedData JSONValue];
    
    if (arrResponse.count == 0) return;
    
    NSString* strToSortBy = @"id";
    NSArray* arraySorted = [arrResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSString* s1 = [obj1 objectForKey:strToSortBy];
        NSString* s2 = [obj2 objectForKey:strToSortBy];
        
        long long lStr1 = [s1 longLongValue];
        long long lStr2 = [s2 longLongValue];
        
        NSComparisonResult result;
        
        if (lStr1 < lStr2) result = NSOrderedDescending;
        else if (lStr1 == lStr2) result = NSOrderedSame;
        else if (lStr1 >	 lStr2) result = NSOrderedAscending;
        
        return result;
    }];
    
    if (nPreLoadedCount == -1)
    {
        [m_arrayResult removeAllObjects];
    }
    
    NSMutableArray* arrTemp = [[NSMutableArray alloc] init];
    for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
    {
        NSDictionary* dictOne = [arraySorted objectAtIndex:nIdx];
        
        FollowEntity* followEntity = [[FollowEntity alloc] initWithDictInfo:dictOne];
        [arrTemp addObject:followEntity];
    }
    
    [m_arrayData removeAllObjects];
    
    if (!bLoad)
    {
        [m_arrayData addObjectsFromArray:arrTemp];
        
        lBeforeId = ((FollowEntity *)[arrTemp lastObject]).m_nID;
        lSinceId = ((FollowEntity *)[arrTemp firstObject]).m_nID;
        
        bLoad = true;
        
        [self insertRowAtBottom];
    }
    else
    {
        if (bDirectionMode)
        {
            nPreLoadedCount = -1;
            
            lSinceId = ((FollowEntity *)[arrTemp firstObject]).m_nID;
            for (int nIdx = (int)arrTemp.count - 1; nIdx >= 0 ; nIdx--)
            {
                FollowEntity* followEntity = [arrTemp objectAtIndex:nIdx];
                [m_arrayData insertObject:followEntity atIndex:0];
            }
            
            [self insertRowAtTop];
        }
        else
        {
            [m_arrayData addObjectsFromArray:arrTemp];
            
            lBeforeId = ((FollowEntity *)[arrTemp lastObject]).m_nID;
            
            [self insertRowAtBottom];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [self.m_tableView.pullToRefreshView stopAnimating];
    [self.m_tableView.infiniteScrollingView stopAnimating];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}


@end
