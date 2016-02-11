//
//  FeedPostViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTagsDefines.h"
#import "AKTagsInputView.h"
#import "JCTagListView.h"

@interface FeedPostViewController : UIViewController<UITextViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, AKTagsInputViewDelegate, JCTagListViewDelegate>
{
    UIImage* postImage;
    int nSelProfileId;

    AKTagsInputView *_tagsInputView;
    
    NSMutableArray* arrCategoryList;
}

@property (nonatomic, assign) BOOL animated;

@property (weak, nonatomic) IBOutlet UIImageView *m_profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *m_bgProfileImageView;

@property (weak, nonatomic) IBOutlet UIImageView *m_postImageView;
@property (weak, nonatomic) IBOutlet UITextView *m_txtPost;
@property (weak, nonatomic) IBOutlet JCTagListView *m_viewTag;
@property (weak, nonatomic) IBOutlet UIView *m_viewCaption;
@property (weak, nonatomic) IBOutlet UIView *m_viewPostInfo;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWarning;

- (IBAction)actionPost:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *m_viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *m_pickerProfile;

- (IBAction)actionChooseDone:(id)sender;


@end
