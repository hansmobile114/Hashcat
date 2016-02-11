//
//  RankingViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/4/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "RankingViewController.h"
#import "Global.h"
#import "GameService.h"
#import "FeedService.h"
#import "RankingService.h"
#import "CatProfileViewController.h"
#import "FeedMainViewController.h"

@interface RankingViewController ()

@end

@implementation RankingViewController
@synthesize m_arrayResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arraySelectedFilterName = [[NSMutableArray alloc] init];
    
    m_arrayResult = [[NSMutableArray alloc] init];
    arrayViews = [[NSMutableArray alloc] init];
    arrayData = [[NSMutableArray alloc] init];
    arrayCategory = [[NSMutableArray alloc] init];
    arrayMonths = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"15", @"18", @"21", @"24", @"36", @"48", @"60", @"120", @"240", nil];
    
    nRequestMode = CATEGORY_REQUEST;
    [GameService categoriesWithDelegate:self];

    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];

    self.m_picker.delegate = self;

    self.navigationItem.title = NSLocalizedString(@"ranking_title_ranking_by_wins", nil);
    
    self.navigationController.navigationBarHidden = NO;
    
    [[self.navigationController navigationBar] setBarTintColor:NAVI_COLOR];
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

    FAKFontAwesome *naviFilterIcon = [FAKFontAwesome filterIconWithSize:NAVI_ICON_SIZE];
    [naviFilterIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *imageFilter = [UIImage imageNamed:@"filter_icon.png"];//[naviFilterIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];

    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil
                              action:nil];
    item3.width = NAVI_BUTTON_OFFSET;
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithImage:imageFilter style:UIBarButtonItemStylePlain target:self action:@selector(showFilterView)];
    self.navigationItem.rightBarButtonItems = @[item3, item4];

    self.m_viewChoose.hidden = YES;
    self.m_viewFilter.hidden = YES;
    
    bLikeOrWin = false;
    
    nSelectedBreedIdx = -1;
    nSelectedCategoryIdx = -1;
    nSelectedMaxAge = -1;
    nSelectedMinAge = -1;
    nSelectedCountryIdx = -1;
    bLikeOrWin = false;

    self.m_viewTagView.hidden = YES;
    self.m_tableView.frame = self.view.frame;
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self.navigationController navigationBar] setBarTintColor:NAVI_COLOR];
    self.navigationController.navigationBar.translucent = NO;

    CGPoint fOriginCenter = CGPointZero;
    fOriginCenter = self.m_btnBreed.center;
    if (self.m_btnBreed.frame.size.width > self.m_btnBreed.frame.size.height)
        self.m_btnBreed.frame = CGRectMake(0, 0, self.m_btnBreed.frame.size.height, self.m_btnBreed.frame.size.height);
    else
        self.m_btnBreed.frame = CGRectMake(0, 0, self.m_btnBreed.frame.size.width, self.m_btnBreed.frame.size.width);
    self.m_btnBreed.center = fOriginCenter;

    fOriginCenter = self.m_btnCategory.center;
    if (self.m_btnCategory.frame.size.width > self.m_btnCategory.frame.size.height)
        self.m_btnCategory.frame = CGRectMake(0, 0, self.m_btnCategory.frame.size.height, self.m_btnCategory.frame.size.height);
    else
        self.m_btnCategory.frame = CGRectMake(0, 0, self.m_btnCategory.frame.size.width, self.m_btnCategory.frame.size.width);
    self.m_btnCategory.center = fOriginCenter;

    fOriginCenter = self.m_btnAge.center;
    if (self.m_btnAge.frame.size.width > self.m_btnAge.frame.size.height)
        self.m_btnAge.frame = CGRectMake(0, 0, self.m_btnAge.frame.size.height, self.m_btnAge.frame.size.height);
    else
        self.m_btnAge.frame = CGRectMake(0, 0, self.m_btnAge.frame.size.width, self.m_btnAge.frame.size.width);
    self.m_btnAge.center = fOriginCenter;

    fOriginCenter = self.m_btnCountry.center;
    if (self.m_btnCountry.frame.size.width > self.m_btnCountry.frame.size.height)
        self.m_btnCountry.frame = CGRectMake(0, 0, self.m_btnCountry.frame.size.height, self.m_btnCountry.frame.size.height);
    else
        self.m_btnCountry.frame = CGRectMake(0, 0, self.m_btnCountry.frame.size.width, self.m_btnCountry.frame.size.width);
    self.m_btnCountry.center = fOriginCenter;

    fOriginCenter = self.m_btnMoreLikes.center;
    if (self.m_btnMoreLikes.frame.size.width > self.m_btnMoreLikes.frame.size.height)
        self.m_btnMoreLikes.frame = CGRectMake(0, 0, self.m_btnMoreLikes.frame.size.height, self.m_btnMoreLikes.frame.size.height);
    else
        self.m_btnMoreLikes.frame = CGRectMake(0, 0, self.m_btnMoreLikes.frame.size.width, self.m_btnMoreLikes.frame.size.width);
    self.m_btnMoreLikes.center = fOriginCenter;

    fOriginCenter = self.m_btnMoreWins.center;
    if (self.m_btnMoreWins.frame.size.width > self.m_btnMoreWins.frame.size.height)
        self.m_btnMoreWins.frame = CGRectMake(0, 0, self.m_btnMoreWins.frame.size.height, self.m_btnMoreWins.frame.size.height);
    else
        self.m_btnMoreWins.frame = CGRectMake(0, 0, self.m_btnMoreWins.frame.size.width, self.m_btnMoreWins.frame.size.width);
    self.m_btnMoreWins.center = fOriginCenter;

    self.m_btnMoreLikes.layer.cornerRadius = self.m_btnMoreLikes.frame.size.height / 2;
    self.m_btnMoreLikes.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.m_btnMoreLikes.layer.borderWidth = 2.f;
    self.m_btnMoreLikes.clipsToBounds = YES;
    
    self.m_btnMoreWins.layer.cornerRadius = self.m_btnMoreWins.frame.size.height / 2;
    self.m_btnMoreWins.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_btnMoreWins.layer.borderWidth = 2.f;
    self.m_btnMoreWins.clipsToBounds = YES;
    
    self.m_btnAge.layer.cornerRadius = self.m_btnAge.frame.size.height / 2;
    self.m_btnAge.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_btnAge.layer.borderWidth = 2.f;
    self.m_btnAge.clipsToBounds = YES;
    
    self.m_btnBreed.layer.cornerRadius = self.m_btnBreed.frame.size.height / 2;
    self.m_btnBreed.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_btnBreed.layer.borderWidth = 2.f;
    self.m_btnBreed.clipsToBounds = YES;
    
    self.m_btnCategory.layer.cornerRadius = self.m_btnCategory.frame.size.height / 2;
    self.m_btnCategory.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_btnCategory.layer.borderWidth = 2.f;
    self.m_btnCategory.clipsToBounds = YES;
    
    self.m_btnCountry.layer.cornerRadius = self.m_btnCountry.frame.size.height / 2;
    self.m_btnCountry.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_btnCountry.layer.borderWidth = 2.f;
    self.m_btnCountry.clipsToBounds = YES;

}

- (void) filterProcess
{
    [self showLoadingView];
    
    nRequestMode = GET_RANNKING_REQUEST;
    
    [RankingService filterWithCategoryId:nSelectedCategoryIdx withBreedId:nSelectedBreedIdx withCountryId:nSelectedCountryIdx withMonthsMin:nSelectedMinAge withMonthsMax:nSelectedMaxAge withOrderByLikes:bLikeOrWin withDelegate:self];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.m_viewChoose.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showFilterView
{
    self.m_viewFilter.hidden = NO;
    self.m_viewChoose.hidden = YES;
}

- (void) backToMainView
{
    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) actionViewPhoto:(RankingSubView *)rankingSubView index:(int)nSelectedIndex
{
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nSelectedIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    FeedMainViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"feedmainview"];
    feedMainView.m_lPhotoId = photoEntity.m_nID;
    feedMainView.m_bShowFromRanking = true;
    
    [self.navigationController pushViewController:feedMainView animated:YES];

}

- (void) actionViewProfile:(RankingSubView *)rankingSubView index:(int)nSelectedIndex
{
    PhotoEntity* photEntity = [m_arrayResult objectAtIndex:nSelectedIndex];
    ProfileEntity* profile = photEntity.m_profile;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
    
    viewCon.m_nProfileId = profile.m_nId;
    viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:profile.m_strUsername];
    viewCon.m_strProfileUsername = profile.m_strUsername;
    viewCon.m_profileEntity = profile;
    
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

- (IBAction)actionChooseDone:(id)sender {
    int row = (int)[self.m_picker selectedRowInComponent:0];
    
    if (nChooseMode == CHOOSE_BREED)
    {
        BreedEntity* breedEntity = [g_Delegate.m_arrBreeds objectAtIndex:row];
        nSelectedBreedIdx = breedEntity.m_nID;
        strSelectedFilterBreed = breedEntity.m_strName;
    }
    else if (nChooseMode == CHOOSE_COUNTRY)
    {
        CountryEntity* countryEntity = [g_Delegate.m_arrCountries objectAtIndex:row];
        nSelectedCountryIdx = countryEntity.m_nID;
        strSelectedFilterCountry = countryEntity.m_strName;
    }
    else if (nChooseMode == CHOOSE_CATEGOTY)
    {
        GameCategoryEntity* categoryEntity = [arrayCategory objectAtIndex:row];
        nSelectedCategoryIdx = categoryEntity.m_nID;
        strSelectedFilterCategory = categoryEntity.m_strName;
    }
    else
    {
        nSelectedMinAge = (int)[[arrayMonths objectAtIndex:row] integerValue];
        nSelectedMaxAge = (int)[[arrayMonths objectAtIndex:(row + 1)] integerValue];
        
        strSelectedFilterAge = [NSString stringWithFormat:@"%d - %d %@", nSelectedMinAge, nSelectedMaxAge, NSLocalizedString(@"ranking_label_months", nil)];
    }

    self.m_viewChoose.hidden = YES;
}

- (IBAction)actionBreed:(id)sender
{
    nChooseMode = CHOOSE_BREED;

    self.m_lblChooseTitle.title = NSLocalizedString(@"input_breed_alert_title", nil);
    self.m_picker.delegate = self;
    [self.m_picker reloadAllComponents];
    self.m_viewChoose.hidden = NO;
}

- (IBAction)actionCategory:(id)sender
{
    nChooseMode = CHOOSE_CATEGOTY;
    
    self.m_lblChooseTitle.title = NSLocalizedString(@"input_category_alert_title", nil);
    self.m_picker.delegate = self;
    [self.m_picker reloadAllComponents];
    self.m_viewChoose.hidden = NO;
}

- (IBAction)actionAge:(id)sender
{
    nChooseMode = CHOOSE_AGE;

    self.m_lblChooseTitle.title = NSLocalizedString(@"input_age_alert_title", nil);
    self.m_picker.delegate = self;
    [self.m_picker reloadAllComponents];
    self.m_viewChoose.hidden = NO;
}

- (IBAction)actionCountry:(id)sender
{
    nChooseMode = CHOOSE_COUNTRY;

    self.m_lblChooseTitle.title = NSLocalizedString(@"input_country_alert_title", nil);
    self.m_picker.delegate = self;
    [self.m_picker reloadAllComponents];
    self.m_viewChoose.hidden = NO;
}

- (IBAction)actionMoreLikes:(id)sender
{
    bLikeOrWin = true;

    self.m_btnMoreLikes.layer.cornerRadius = self.m_btnMoreLikes.frame.size.height / 2;
    self.m_btnMoreLikes.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_btnMoreLikes.layer.borderWidth = 2.f;
    self.m_btnMoreLikes.clipsToBounds = YES;
    
    self.m_btnMoreWins.layer.cornerRadius = self.m_btnMoreWins.frame.size.height / 2;
    self.m_btnMoreWins.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.m_btnMoreWins.layer.borderWidth = 2.f;
    self.m_btnMoreWins.clipsToBounds = YES;

}

- (IBAction)actionmoreWins:(id)sender
{
    bLikeOrWin = false;

    self.m_btnMoreLikes.layer.cornerRadius = self.m_btnMoreLikes.frame.size.height / 2;
    self.m_btnMoreLikes.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.m_btnMoreLikes.layer.borderWidth = 2.f;
    self.m_btnMoreLikes.clipsToBounds = YES;
    
    self.m_btnMoreWins.layer.cornerRadius = self.m_btnMoreWins.frame.size.height / 2;
    self.m_btnMoreWins.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_btnMoreWins.layer.borderWidth = 2.f;
    self.m_btnMoreWins.clipsToBounds = YES;
}

- (IBAction)actionCancelFilter:(id)sender
{
    self.m_viewFilter.hidden = YES;

}

- (IBAction)actionFilter:(id)sender
{
    NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
    [self.m_tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.m_viewFilter.hidden = YES;
    
    if (bLikeOrWin)
        self.navigationItem.title = NSLocalizedString(@"ranking_title_ranking_by_likes", nil);
    else
        self.navigationItem.title = NSLocalizedString(@"ranking_title_ranking_by_wins", nil);

    [arraySelectedFilterName removeAllObjects];
    
    NSMutableArray* arraySelectedFilter = [[NSMutableArray alloc] init];
    if (nSelectedBreedIdx != -1)
    {
        [arraySelectedFilter addObject:strSelectedFilterBreed];
        [arraySelectedFilterName addObject:@"breed"];
    }
    
    if (nSelectedCategoryIdx != -1)
    {
        if ([strSelectedFilterCategory isEqualToString:NSLocalizedString(@"category_overall", nil)] || [strSelectedFilterCategory isEqualToString:NSLocalizedString(@"category_random", nil)])
            [arraySelectedFilter addObject:strSelectedFilterCategory];
        else
            [arraySelectedFilter addObject:[NSString stringWithFormat:@"#%@", strSelectedFilterCategory]];
        
        [arraySelectedFilterName addObject:@"category"];
    }
    
    if (nSelectedCountryIdx != -1)
    {
        [arraySelectedFilter addObject:strSelectedFilterCountry];
        [arraySelectedFilterName addObject:@"country"];
    }
    
    if (nSelectedMaxAge != -1)
    {
        [arraySelectedFilter addObject:strSelectedFilterAge];
        [arraySelectedFilterName addObject:@"age"];
    }

    if (arraySelectedFilter.count > 0)
    {
        self.m_viewTagView.hidden = NO;
        self.m_tableView.frame = CGRectMake(0, self.m_viewTagView.frame.origin.y + self.m_viewTagView.frame.size.height, self.m_tableView.frame.size.width, self.view.frame.size.height - self.m_viewTagView.frame.origin.y - self.m_viewTagView.frame.size.height);
        
        self.m_tagList.tags = [arraySelectedFilter mutableCopy];
        self.m_tagList.mode = TLTagsControlModeEdit;
        self.m_tagList.tagsBackgroundColor = MAIN_COLOR;
        self.m_tagList.tagsDeleteButtonColor = [UIColor whiteColor];
        self.m_tagList.tagsTextColor = [UIColor whiteColor];
        [self.m_tagList reloadTagSubviews];
        [self.m_tagList setTapDelegate:self];
    }
    else
    {
        self.m_viewTagView.hidden = YES;
        self.m_tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self filterProcess];
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

- (void) deleteTagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index
{
    NSLog(@"deleted tag");
    NSString* strFilterName = [arraySelectedFilterName objectAtIndex:index];
    if ([strFilterName isEqualToString:@"breed"])
    {
        nSelectedBreedIdx = -1;
    }
    else if ([strFilterName isEqualToString:@"country"])
    {
        nSelectedCountryIdx = -1;
    }
    else if ([strFilterName isEqualToString:@"age"])
    {
        nSelectedMaxAge = -1;
        nSelectedMinAge = -1;
    }
    else if ([strFilterName isEqualToString:@"category"])
    {
        nSelectedCategoryIdx = -1;
    }
    
    [arraySelectedFilterName removeObjectAtIndex:index];
    if (arraySelectedFilterName.count == 0)
    {
        self.m_viewTagView.hidden = YES;
        self.m_tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
    [self.m_tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];

    [self filterProcess];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32.f;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if (nChooseMode == CHOOSE_BREED)
    {
        return g_Delegate.m_arrBreeds.count;
    }
    else if (nChooseMode == CHOOSE_COUNTRY)
        return g_Delegate.m_arrCountries.count;
    else if (nChooseMode == CHOOSE_CATEGOTY)
        return arrayCategory.count;
    else return arrayMonths.count - 1;

}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (nChooseMode == CHOOSE_BREED)
    {
        BreedEntity* breedEntity = [g_Delegate.m_arrBreeds objectAtIndex:row];
        return breedEntity.m_strName;
    }
    else if (nChooseMode == CHOOSE_COUNTRY)
    {
        CountryEntity* countryEntity = [g_Delegate.m_arrCountries objectAtIndex:row];
        return countryEntity.m_strName;
    }
    else if (nChooseMode == CHOOSE_CATEGOTY)
    {
        GameCategoryEntity* categoryEntity = [arrayCategory objectAtIndex:row];
        
        if ([categoryEntity.m_strName isEqualToString:NSLocalizedString(@"category_overall", nil)] || [categoryEntity.m_strName isEqualToString:NSLocalizedString(@"category_random", nil)])
            return categoryEntity.m_strName;
        else
            return [NSString stringWithFormat:@"#%@", categoryEntity.m_strName];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@", [arrayMonths objectAtIndex:row], NSLocalizedString(@"ranking_label_months", nil)];
    }
}

// Picker Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    return;

}

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
    return 150.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customcell";
    
    RankingSubView *cell = [tableView
                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RankingSubView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.m_imageCatView.image = [UIImage imageNamed:@"avatar_add_profile.png"];
    cell.delegate = self;
    cell.m_nIndex = (int)indexPath.row;
    cell.m_lblName.text = [NSString stringWithFormat:@"%d. %@", (int)(indexPath.row + 1), photoEntity.m_profile.m_strUsername];
    
    if (indexPath.row == 0)
        cell.m_imageRankingView.image = [UIImage imageNamed:@"badge_ranking_position_gold.png"];
    else if (indexPath.row == 1)
        cell.m_imageRankingView.image = [UIImage imageNamed:@"badge_ranking_position_silver.png"];
    else if (indexPath.row == 2)
        cell.m_imageRankingView.image = [UIImage imageNamed:@"badge_ranking_position_bronze.png"];
    else
        cell.m_imageRankingView.image = [UIImage imageNamed:@"badge_ranking_position_default.png"];
    
    cell.m_lblAge.text = [NSString stringWithFormat:@"%d %@", photoEntity.m_profile.m_nAgeInMonths, NSLocalizedString(@"ranking_label_months", nil)];
    cell.m_lblBreed.text = photoEntity.m_profile.m_breed.m_strName;
    cell.m_lblCountry.text = photoEntity.m_profile.m_country.m_strName;
    cell.m_lblLikes.text = [NSString stringWithFormat:@"%d %@", photoEntity.m_nLikeCnt, NSLocalizedString(@"feed_label_likes", nil)];
    
    /*
     if (bLikeOrWin)
     catSubView.m_lblWins.text = @"-";
     else
     */
    {
        float fWinRate = 0.f;
        if (nSelectedCategoryIdx == -1)
            fWinRate = photoEntity.m_fWins / photoEntity.m_fMashs * 100.f;
        else
        {
            for (int nCategoryIdx = 0; nCategoryIdx < photoEntity.m_arrCategories.count; nCategoryIdx++)
            {
                CategoriesEntity* categoriesEntity = [photoEntity.m_arrCategories objectAtIndex:nCategoryIdx];
                if ([categoriesEntity.m_category.m_strName isEqualToString:strSelectedFilterCategory])
                {
                    fWinRate = categoriesEntity.m_nWinsCategory / (float)categoriesEntity.m_nMashsCategory * 100.f;
                    break;
                }
            }
        }
        
        int intValue = (int)fWinRate;
        float fractional = fmodf(fWinRate, (float)intValue);
        if(fractional > .5f)
            intValue++;
        
        cell.m_lblWins.text = [NSString stringWithFormat:@"%d%% %@", intValue, NSLocalizedString(@"ranking_label_of_wins", nil)];
    }
    
    //load image=================================
    NSString* strPhoto = photoEntity.m_strPhotoLink;
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:strPhoto imageView:cell.m_imageCatView];

    cell.m_viewContainer.frame = CGRectMake(3, 3, self.m_tableView.frame.size.width - 6.f, 144.f);
    
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
    {
        if (nRequestMode == GET_RANNKING_REQUEST)
        {
            [m_arrayResult removeAllObjects];
            [self.m_tableView reloadData];
        }

        return;
    }
    
    if (nRequestMode == GET_RANNKING_REQUEST)
    {
        [m_arrayResult removeAllObjects];
        for (int nIdx = 0; nIdx < arrResponse.count; nIdx++)
        {
            NSDictionary* dictOne = [arrResponse objectAtIndex:nIdx];
            
            PhotoEntity* photoEntity = [[PhotoEntity alloc] initWithDictInfo:dictOne];
            
            [m_arrayResult addObject:photoEntity];
        }
        
        [self.m_tableView reloadData];
    }
    
    if (nRequestMode == CATEGORY_REQUEST)
    {
        [arrayCategory removeAllObjects];
        for (int nIdx = 0; nIdx < arrResponse.count; nIdx++)
        {
            NSDictionary* dictOne = [arrResponse objectAtIndex:nIdx];
            
            GameCategoryEntity* gameCategoryEntity = [[GameCategoryEntity alloc] initWithDictInfo:dictOne];
            if ([gameCategoryEntity.m_strName isEqualToString:NSLocalizedString(@"category_random", nil)])
                continue;
            
            [arrayCategory addObject:gameCategoryEntity];
        }

        [self performSelector:@selector(filterProcess) withObject:nil afterDelay:0.1f];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}


@end
