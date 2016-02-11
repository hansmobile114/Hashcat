//
//  GameCategoryViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/5/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "GameCategoryViewController.h"
#import "Global.h"
#import "GameService.h"
#import "PlayGameViewController.h"

@interface GameCategoryViewController ()

@end

@implementation GameCategoryViewController
@synthesize m_arrayResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"game_category_title_pick_category", nil);

    self.m_arrayResult = [[NSMutableArray alloc] init];
    arrayViews = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[self.navigationController navigationBar] setTintColor:[UIColor whiteColor]];
    [self.navigationController navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                              [UIColor whiteColor], UITextAttributeTextColor,
                                                              [UIColor grayColor], UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                              nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

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
    
    self.m_arrayResult = [g_Delegate.m_arrGameCategories mutableCopy];
    [self loadCategories];

    /*
    [self showLoadingView];
    [GameService categoriesWithDelegate:self];
     */

}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
//    self.m_topImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
}

- (void) backToMainView
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) loadCategories
{
    CGFloat viewWidth = CGRectGetWidth(self.m_scrollView.frame);
    
    for (int nIdx = 0; nIdx < arrayViews.count; nIdx++)
    {
        CatSubView* subView = (CatSubView *)[arrayViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    
    [arrayViews removeAllObjects];
    
    float fItemSizeWidth = (viewWidth - 3.f) / 3.f;
    float fItemSizeHeight = CAT_SUB_VIEW_HEIGHT;
    
    int nCatItemIdx = -1;
    int nRowIdx = 0;
    
    for (int nIdx = 0; nIdx < m_arrayResult.count; nIdx++)
    {
        GameCategoryEntity* entity = [m_arrayResult objectAtIndex:nIdx];
        
        nCatItemIdx++;
        nRowIdx = nCatItemIdx / 3;
        
        CatSubView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
        catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
        catSubView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        if (entity.m_bSelectable)
            catSubView.m_lblTitle.text = [NSString stringWithFormat:@"#%@", entity.m_strName];
        else
            catSubView.m_lblTitle.text = [NSString stringWithFormat:@"%@", entity.m_strName];
        
        catSubView.m_bCreateNewButton = false;
        catSubView.delegate = self;
        catSubView.m_nIndex = nIdx;
        catSubView.center = CGPointMake((nCatItemIdx % 3 + 1) * 2.f + fItemSizeWidth / 2.f * (nCatItemIdx % 3 * 2 + 1), (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));
        
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:entity.m_strPhotoLink imageView:catSubView.m_imageView];
        
        [self.m_scrollView addSubview:catSubView];
        [arrayViews addObject:catSubView];
    }
    
    float fScrollHeight = (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + 2.f + fItemSizeHeight / 2.f;
    
    self.m_scrollView.contentSize = CGSizeMake(viewWidth, fScrollHeight);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) actionAdditionalProcess:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    
}

- (void) actionViewInfo:(CatSubView *) catSubView withIndex:(NSInteger) index
{
    GameCategoryEntity* entity = [m_arrayResult objectAtIndex:index];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    PlayGameViewController *gameViewCon = [storyboard instantiateViewControllerWithIdentifier:@"gameview"];
    gameViewCon.m_categoryEntity = entity;
    
    [self.navigationController pushViewController:gameViewCon animated:YES];

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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    NSString *receivedData = [request responseString];
    NSArray* arrResponse = [receivedData JSONValue];
    if (arrResponse.count == 0)
        return;
    
    [m_arrayResult removeAllObjects];
    for (int nIdx = 0; nIdx < arrResponse.count; nIdx++)
    {
        NSDictionary* dictOne = [arrResponse objectAtIndex:nIdx];
        
        GameCategoryEntity* gameCategoryEntity = [[GameCategoryEntity alloc] initWithDictInfo:dictOne];
        
        [m_arrayResult addObject:gameCategoryEntity];
    }
    
    [self loadCategories];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}


@end
