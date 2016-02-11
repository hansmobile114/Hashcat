//
//  BadgeDetailViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "BadgeDetailViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "BadgeInfoViewController.h"

@interface BadgeDetailViewController ()

@end

@implementation BadgeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.m_strTitle;
    
    FAKFontAwesome *naviBackIcon = [FAKFontAwesome arrowLeftIconWithSize:NAVI_ICON_SIZE];
    [naviBackIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *imgButton = [naviBackIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil
                              action:nil];
    item0.width = NAVI_BUTTON_OFFSET;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMainView)];
    self.navigationItem.leftBarButtonItems = @[item0, item1];

    self.m_lblName.text = self.m_strTitle;
    
    switch (self.m_nBadgeType) {
        case WINS:
            self.m_imageVIew.image = [UIImage imageNamed:@"badge_wins.png"];
            break;
        case LIKES:
            self.m_imageVIew.image = [UIImage imageNamed:@"badge_likes.png"];
            break;
        case FOLLOWERS:
            self.m_imageVIew.image = [UIImage imageNamed:@"badge_followers.png"];
            break;
        case FOLLOWING:
            self.m_imageVIew.image = [UIImage imageNamed:@"badge_following.png"];
            break;
            
        default:
            break;
    }
    
    arrayBadges = [g_Delegate.m_arrBadgesList valueForKey:[self.m_strTitle lowercaseString]];
    
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;

    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];
    
    if (!g_Delegate.m_bHasBottomBar)
        self.m_viewBottomPart.frame = CGRectMake(self.m_viewBottomPart.frame.origin.x, self.m_viewBottomPart.frame.origin.y, self.m_viewBottomPart.frame.size.width, self.m_viewBottomPart.frame.size.height + MENU_TAB_HEIGHT);

    if (arrayBadges.count == 0)
    {
        [self showLoadingView];
        [FeedService getBadgesPerType:self.m_nBadgeType WithDelegate:self];
        
        return;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGPoint ptOrigin = self.m_imageVIew.center;
    if (self.m_imageVIew.frame.size.width > self.m_imageVIew.frame.size.height)
    {
        self.m_imageVIew.frame = CGRectMake(0, 0, self.m_imageVIew.frame.size.height, self.m_imageVIew.frame.size.height);
        self.m_imageVIew.layer.cornerRadius = self.m_imageVIew.frame.size.height / 2.f;
    }
    else
    {
        self.m_imageVIew.frame = CGRectMake(0, 0, self.m_imageVIew.frame.size.width, self.m_imageVIew.frame.size.width);
        self.m_imageVIew.layer.cornerRadius = self.m_imageVIew.frame.size.width / 2.f;
    }
    
    self.m_imageVIew.center = ptOrigin;

    self.m_viewBottomPart.layer.cornerRadius = 2.f;
    self.m_viewBottomPart.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_viewBottomPart.layer.borderWidth = 1.f;
    self.m_viewBottomPart.clipsToBounds = YES;
    
    [[Utils sharedObject] makeBoxShadowEffect:self.m_viewBottomPart radius:2.f color:CONTAINER_SHADOW_COLOR corner:2.f];
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayBadges.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BadgeEntity* entity = [arrayBadges objectAtIndex:indexPath.row];
    float fTextHeight = 50.f + [[Utils sharedObject] getHeightOfText:entity.m_strName fontSize:16.f width:self.m_tableView.frame.size.width / 2];
    
    return 30.f + fTextHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"badgelistcell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    BadgeEntity* entity = [arrayBadges objectAtIndex:indexPath.row];
    
    float fTextHeight = 50.f + [[Utils sharedObject] getHeightOfText:entity.m_strName fontSize:16.f width:self.m_tableView.frame.size.width / 2];
    
    float fCellHeight = 30 + fTextHeight;
    
    UIImageView* imageView = (UIImageView *)[cell viewWithTag:10];
    imageView.image = [UIImage imageNamed:[[Utils sharedObject] getBadgeImageName:entity]];
    
    UILabel* lblName = (UILabel *)[cell viewWithTag:11];
    UILabel* lblLikes = (UILabel *)[cell viewWithTag:12];
    UIView* viewContainer = (UIView *)[cell viewWithTag:20];
    
    lblName.text = entity.m_strName;
    
    switch (self.m_nBadgeType) {
        case LIKES:
            lblLikes.text = [NSString stringWithFormat:@"%@ %@", [[Utils sharedObject] getLikes:entity.m_nLikes], [self.m_strTitle lowercaseString]];
            break;
        case WINS:
            lblLikes.text = [NSString stringWithFormat:@"%@ %@", [[Utils sharedObject] getLikes:entity.m_nWin], [self.m_strTitle lowercaseString]];
            break;
        case FOLLOWING:
            lblLikes.text = [NSString stringWithFormat:@"%@ %@", [[Utils sharedObject] getLikes:entity.m_nValue], [self.m_strTitle lowercaseString]];
            break;
        case FOLLOWERS:
            lblLikes.text = [NSString stringWithFormat:@"%@ %@", [[Utils sharedObject] getLikes:entity.m_nValue], [self.m_strTitle lowercaseString]];
            break;
            
        default:
            break;
    }
    
    [lblLikes sizeToFit];
    lblLikes.layer.cornerRadius = lblLikes.frame.size.height / 2.f;
    lblLikes.backgroundColor = MAIN_COLOR;
    lblLikes.clipsToBounds = YES;
    
    lblName.lineBreakMode = NSLineBreakByWordWrapping;
    lblLikes.frame = CGRectMake(0, 0, lblLikes.frame.size.width + 20.f - 1.f, lblLikes.frame.size.height + 5.f);
    
    imageView.center = CGPointMake(5.f + imageView.frame.size.width / 2, fCellHeight / 2);
    lblLikes.center = CGPointMake(self.m_tableView.frame.size.width - 10.f - lblLikes.frame.size.width / 2, fCellHeight / 2);
    
    float fNameWidth = self.m_tableView.frame.size.width - 20.f - imageView.frame.size.width - lblLikes.frame.size.width;
    lblName.frame = CGRectMake(0, 0, fNameWidth, fTextHeight);
    lblName.center = CGPointMake(10.f + imageView.frame.size.width+ fNameWidth / 2, fCellHeight / 2);
    
    viewContainer.frame = CGRectMake(3, 3, self.m_tableView.frame.size.width - 6.f, fTextHeight + 30.f - 6.f);
    
    viewContainer.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
    viewContainer.layer.borderWidth = 1.f;
    viewContainer.clipsToBounds = YES;
    
    [[Utils sharedObject] makeShadowEffect:viewContainer radius:3.f color:BOX_SHADOW_COLOR corner:0.f];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BadgeEntity* badgeEntity = [arrayBadges objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    BadgeInfoViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"badgeinfoview"];
    viewCon.m_badge = badgeEntity;
    
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

- (void) showLoadingView
{
    [self.view endEditing:YES];
    
    [YXSpritesLoadingView showWithText:NSLocalizedString(@"loading", nil) andShimmering:YES andBlurEffect:NO];
}

- (void) hideLoadingView
{
    [YXSpritesLoadingView dismiss];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    NSString *receivedData = [request responseString];
    
    NSArray* arrValues = [receivedData JSONValue];

    [g_Delegate.m_arrBadgesList removeAllObjects];
    
    NSMutableArray* arrayTemp = [[NSMutableArray alloc] init];
    for (int nIdx = 0; nIdx < arrValues.count; nIdx++)
    {
        NSDictionary* dictInfo = [arrValues objectAtIndex:nIdx];
        
        NSLog(@"%@", dictInfo);
        
        BadgeEntity *entity = [[BadgeEntity alloc] initWithDictInfo:dictInfo];
        
        [arrayTemp addObject:entity];
    }

    [g_Delegate.m_arrBadgesList setValue:arrayTemp forKey:[self.m_strTitle lowercaseString]];
    
    arrayBadges = [arrayTemp mutableCopy];
    
    [self.m_tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];

    [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
}

@end
