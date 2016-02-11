//
//  CommentViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/28/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CommentViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "MenuTabViewController.h"
#import "UserProfileViewController.h"
#import "FeedMainViewController.h"

#define GET_COMMENTS_REQUEST            1
#define COMMENT_REQUEST                 2

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize m_arrayData;
@synthesize m_arrayResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [[[NSLocalizedString(@"feed_label_comments", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"feed_label_comments", nil) substringFromIndex:1]];
    
    g_Delegate.m_bHasBottomBar = false;
    
    m_arrayResult = [[NSMutableArray alloc] init];
    m_arrayData = [[NSMutableArray alloc] init];
    
    lBeforeId = 0;
    lSinceId = 0;

    FAKFontAwesome *naviBackIcon = [FAKFontAwesome arrowLeftIconWithSize:NAVI_ICON_SIZE];
    [naviBackIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *imgBack = [naviBackIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil
                              action:nil];
    item0.width = NAVI_BUTTON_OFFSET;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMainView)];
    self.navigationItem.leftBarButtonItems = @[item0, item1];

    __weak CommentViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.m_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadAboveMore];
    }];
    
    /*
    // setup infinite scrolling
    [self.m_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadBelowMore];
    }];
     */

    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 6.f, 32.f, 32.f)];
    userImageView.layer.cornerRadius = 16.f;
    userImageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    userImageView.layer.borderColor = MAIN_COLOR.CGColor;
    userImageView.layer.borderWidth = 1.f;
    userImageView.clipsToBounds = YES;
    [self.m_toolBar addSubview:userImageView];
    
    userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureForImage = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGestureForImage.numberOfTapsRequired = 1;
    [tapGestureForImage setDelegate:self];
    [userImageView addGestureRecognizer:tapGestureForImage];

    [[Utils sharedObject] loadImageFromServerAndLocal:self.m_photoEntity.m_strPhotoLink imageView:userImageView];
    
    txtFieldComment = [[UITextField alloc] initWithFrame:CGRectMake(52.0f,
                                                                    7.0f,
                                                                    self.m_toolBar.bounds.size.width - 20.0f - 40.0f - 40.f,
                                                                    30.0f)];
    txtFieldComment.borderStyle = UITextBorderStyleRoundedRect;
    txtFieldComment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    txtFieldComment.font = [UIFont fontWithName:MAIN_FONT_NAME size:14.f];
    [self.m_toolBar addSubview:txtFieldComment];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    FAKFontAwesome *sendIcon = [FAKFontAwesome paperPlaneIconWithSize:ICON_SIZE];
    [sendIcon addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR];
    UIImage *sendImage = [sendIcon imageWithSize:CGSizeMake(ICON_SIZE, ICON_SIZE)];
    [sendButton setImage:[UIImage imageNamed:@"btn_send.png"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(createComment) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(self.m_toolBar.bounds.size.width - 40.0f,
                                  10.f,
                                  ICON_SIZE,
                                  ICON_SIZE);
    [self.m_toolBar addSubview:sendButton];
    
    self.view.keyboardTriggerOffset = self.m_toolBar.bounds.size.height;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = weakSelf.m_toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakSelf.m_toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = weakSelf.m_tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        weakSelf.m_tableView.frame = tableViewFrame;
        
        if (weakSelf.m_arrayResult.count > 0)
        {
            [weakSelf.m_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.m_arrayResult.count - 1 inSection:0]
                                        atScrollPosition:UITableViewScrollPositionBottom
                                                animated:YES];
        }
    } constraintBasedActionHandler:nil];

    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;

    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];

    bLoad = false;
    
    bDirectionMode = false;
    lBeforeId = 0;
    lSinceId = 0;
    
    [self getCommentRequest];

}

- (void) tapGesture
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    FeedMainViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"feedmainview"];
    feedMainView.m_lPhotoId = self.m_photoEntity.m_nID;
    
    [self.navigationController pushViewController:feedMainView animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) createComment
{
    if (txtFieldComment.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_comment_alert_title", nil)];
        return;
    }
    
    [self showLoadingView];
    
    nRequestMode = COMMENT_REQUEST;
    
    [FeedService comment:self.m_nPhotoId withComment:txtFieldComment.text withDelegate:self];
}

- (void) loadAboveMore
{
    bDirectionMode = false;
    
    [self getCommentRequest];
}

- (void) loadBelowMore
{
    bDirectionMode = true;
    
    [self getCommentRequest];
}

- (void)insertRowAtTop {
    __weak CommentViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = weakSelf.m_arrayData.count - 1; nIdx >= 0; nIdx--)
        {
            [weakSelf.m_tableView beginUpdates];
            [weakSelf.m_arrayResult insertObject:[weakSelf.m_arrayData objectAtIndex:nIdx] atIndex:0];
            [weakSelf.m_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [weakSelf.m_tableView endUpdates];
        }
        
        [weakSelf.m_tableView.pullToRefreshView stopAnimating];
    });
}

- (void)insertRowAtTopAtFirstLoad {
    __weak CommentViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = 0; nIdx <= weakSelf.m_arrayData.count - 1; nIdx++)
        {
            [weakSelf.m_tableView beginUpdates];
            [weakSelf.m_arrayResult addObject:[weakSelf.m_arrayData objectAtIndex:nIdx]];
            [weakSelf.m_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.m_arrayResult.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.m_tableView endUpdates];
        }
        
        [weakSelf.m_tableView.pullToRefreshView stopAnimating];
    });
}

- (void)insertRowAtBottom {
    __weak CommentViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = weakSelf.m_arrayData.count - 1; nIdx >= 0; nIdx--)
        {
            [weakSelf.m_tableView beginUpdates];
            [weakSelf.m_arrayResult addObject:[weakSelf.m_arrayData objectAtIndex:nIdx]];
            [weakSelf.m_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.m_arrayResult.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.m_tableView endUpdates];
        }
        
        [weakSelf.m_tableView.infiniteScrollingView stopAnimating];
    });
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) getCommentRequest
{
    [self showLoadingView];
    
    nRequestMode = GET_COMMENTS_REQUEST;
    
    if (!bLoad)
        [FeedService getCommentsWithPhotoId:self.m_nPhotoId withSinceId:0 beforeId:0 withDelegate:self];
    else
    {
        if (bDirectionMode)
            [FeedService getCommentsWithPhotoId:self.m_nPhotoId withSinceId:lSinceId beforeId:0 withDelegate:self];
        else
            [FeedService getCommentsWithPhotoId:self.m_nPhotoId withSinceId:0 beforeId:lBeforeId withDelegate:self];
    }
}

- (void) backToMainView
{
    [self.view removeKeyboardControl];
    
    if (g_Delegate.m_curMenuTabViewCon)
        g_Delegate.m_bHasBottomBar = true;
    
    MenuTabViewController* parentView = (MenuTabViewController *)self.navigationController.parentViewController;
    [parentView showMenuTabView];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
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
    CommentEntity* commentEntity = [m_arrayResult objectAtIndex:indexPath.row];
    float fTextHeight = 30.f + [[Utils sharedObject] getHeightOfText:commentEntity.m_strComent fontSize:16.f width:[[UIScreen mainScreen] bounds].size.width - 50.f];
    
    return 24.f + fTextHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentcell";
    
    UITableViewCell *cell = [tableView
                                  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    CommentEntity* commentEntity = [m_arrayResult objectAtIndex:indexPath.row];

    float fTextHeight = 30.f + [[Utils sharedObject] getHeightOfText:commentEntity.m_strComent fontSize:16.f width:[[UIScreen mainScreen] bounds].size.width - 50.f];
    
    UIImageView* imageView = (UIImageView *)[cell viewWithTag:10];
    imageView.layer.cornerRadius = imageView.frame.size.height / 2;
    imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    imageView.layer.borderColor = MAIN_COLOR.CGColor;
    imageView.layer.borderWidth = 1.f;
    imageView.clipsToBounds = YES;
    [[Utils sharedObject] loadImageFromServerAndLocal:commentEntity.m_user.m_strAvatarUrl imageView:imageView];
    
    UILabel* lblUserName = (UILabel *)[cell viewWithTag:11];
    UILabel* lblTime = (UILabel *)[cell viewWithTag:12];
    UILabel* lblComment = (UILabel *)[cell viewWithTag:13];
    UIView* viewContainer = (UIView *)[cell viewWithTag:20];
    
    lblUserName.text = commentEntity.m_user.m_strUsername;
    lblTime.text = [[Utils sharedObject] DateToString:[[Utils sharedObject] getDateFromMilliSec:commentEntity.m_nDate] withFormat:@"MMM dd"];
    [lblTime sizeToFit];
    lblTime.frame = CGRectMake(self.view.frame.size.width - lblTime.frame.size.width - 10.f, lblUserName.frame.origin.y, lblTime.frame.size.width, lblTime.frame.size.height);
    
    lblComment.lineBreakMode = NSLineBreakByWordWrapping;
    lblComment.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5.f, imageView.frame.origin.y + imageView.frame.size.height - 10.f, [[UIScreen mainScreen] bounds].size.width - imageView.frame.origin.x - imageView.frame.size.width - 10.f, fTextHeight);
    lblComment.text = commentEntity.m_strComent;
    
    viewContainer.frame = CGRectMake(3, 3, self.m_tableView.frame.size.width - 6.f, fTextHeight + 24.f - 6.f);
    
    viewContainer.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
    viewContainer.layer.borderWidth = 1.f;
    viewContainer.clipsToBounds = YES;
    
    [[Utils sharedObject] makeShadowEffect:viewContainer radius:3.f color:BOX_SHADOW_COLOR corner:0.f];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommentEntity* commentEntity = [m_arrayResult objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
    
    if ([g_Delegate.m_currentUser.m_strUsername isEqualToString:commentEntity.m_user.m_strUsername])
        viewCon.m_bMyProfile = true;
    else
        viewCon.m_bMyProfile = false;
    
    g_Delegate.m_bHasBottomBar = false;
    
    viewCon.m_nUserId = commentEntity.m_user.m_nID;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [self.m_tableView.pullToRefreshView stopAnimating];
    [self.m_tableView.infiniteScrollingView stopAnimating];
    
    NSString *receivedData = [request responseString];
    
    if (nRequestMode == GET_COMMENTS_REQUEST)
    {
        NSArray* arrResponse = [receivedData JSONValue];
        
        if (arrResponse.count == 0) return;
        
        NSString* strToSortBy = @"id";
        NSArray* arraySorted = [arrResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSString* s1 = [obj1 objectForKey:strToSortBy];
            NSString* s2 = [obj2 objectForKey:strToSortBy];
            
            long long lStr1 = [s1 longLongValue];
            long long lStr2 = [s2 longLongValue];
            
            NSComparisonResult result;
            
            if (lStr1 > lStr2) result = NSOrderedDescending;
            else if (lStr1 == lStr2) result = NSOrderedSame;
            else if (lStr1 < lStr2) result = NSOrderedAscending;
            
            return result;
        }];
        
        [m_arrayData removeAllObjects];
        
        if (!bLoad)
        {
            [m_arrayResult removeAllObjects];
            [self.m_tableView reloadData];
        }
        
        for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
        {
            NSDictionary* dictInfo = [arraySorted objectAtIndex:nIdx];
            CommentEntity* commentEntity = [[CommentEntity alloc] initWithDictInfo:dictInfo];;
            if (commentEntity.m_strComent == nil)
                continue;
            
            if ([commentEntity.m_strComent isKindOfClass:[NSNull class]])
                continue;
            
            if ([commentEntity.m_strComent isEqualToString:@""] || commentEntity.m_strComent.length == 0)
                continue;
            
            [m_arrayData addObject:commentEntity];
        }
        
        if (!bLoad)
        {
            lBeforeId = ((CommentEntity *)[m_arrayData firstObject]).m_nID;
            lSinceId = ((CommentEntity *)[m_arrayData lastObject]).m_nID;
            
            bLoad = true;
            
            [self insertRowAtTopAtFirstLoad];
        }
        else
        {
            if (bDirectionMode)
            {
                [self insertRowAtBottom];
                lSinceId = ((CommentEntity *)[m_arrayData lastObject]).m_nID;
            }
            else
            {
                [self insertRowAtTop];
                lBeforeId = ((CommentEntity *)[m_arrayData firstObject]).m_nID;
            }
        }
    }
    else if (nRequestMode == COMMENT_REQUEST)
    {
        NSDictionary* dictResponse = [receivedData JSONValue];
        
        CommentEntity* commentEntity = [[CommentEntity alloc] initWithDictInfo:dictResponse];
        commentEntity.m_user = g_Delegate.m_currentUser;
        
        [m_arrayData removeAllObjects];
        [m_arrayData addObject:commentEntity];
        
        [self insertRowAtBottom];
        
        lSinceId = commentEntity.m_nID;
        
        txtFieldComment.text = @"";
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
