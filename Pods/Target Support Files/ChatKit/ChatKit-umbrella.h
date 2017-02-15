#ifdef __OBJC__
#import <UIKit/UIKit.h>
#endif

#import "LCChatKit.h"
#import "AVIMMessage+LCCKExtension.h"
#import "AVIMTypedMessage+LCCKExtension.h"
#import "LCCKMessage.h"
#import "LCCKMessageDelegate.h"
#import "LCCKUserDelegate.h"
#import "NSMutableArray+LCCKMessageExtention.h"
#import "NSObject+LCCKExtension.h"
#import "LCCKBaseConversationViewController.h"
#import "LCCKBaseNavigationController.h"
#import "LCCKBaseTableViewController.h"
#import "LCCKBaseViewController.h"
#import "LCCKContactListViewController.h"
#import "LCCKContact.h"
#import "LCCKContactCell.h"
#import "LCCKConversationViewController.h"
#import "LCCKLocationController.h"
#import "LCCKTextFullScreenViewController.h"
#import "AVIMConversation+LCCKExtension.h"
#import "LCCKConversationViewModel.h"
#import "LCCKImageManager.h"
#import "LCCKWeakReference.h"
#import "NSBundle+LCCKSCaleArray.h"
#import "NSMutableDictionary+LCCKWeakReference.h"
#import "NSString+LCCKAddScale.h"
#import "LCCKAVAudioPlayer.h"
#import "LCCKBubbleImageFactory.h"
#import "LCCKCellIdentifierFactory.h"
#import "LCCKCellRegisterController.h"
#import "LCCKChat.h"
#import "LCCKChatUntiles.h"
#import "LCCKFaceManager.h"
#import "LCCKLastMessageTypeManager.h"
#import "LCCKLocationManager.h"
#import "LCCKMessageVoiceFactory.h"
#import "LCCKSoundManager.h"
#import "LCCKChatBar.h"
#import "LCCKChatFaceView.h"
#import "LCCKChatMoreView.h"
#import "LCCKFacePageView.h"
#import "LCCKInputViewPlugin.h"
#import "LCCKInputViewPluginLocation.h"
#import "LCCKInputViewPluginPickImage.h"
#import "LCCKInputViewPluginTakePhoto.h"
#import "LCCKProgressHUD.h"
#import "LCCKChatImageMessageCell.h"
#import "LCCKChatLocationMessageCell.h"
#import "LCCKChatMessageCell.h"
#import "LCCKChatSystemMessageCell.h"
#import "LCCKChatTextMessageCell.h"
#import "LCCKChatVoiceMessageCell.h"
#import "LCCKContentView.h"
#import "LCCKMessageSendStateView.h"
#import "LCCKConversationNavigationTitleView.h"
#import "LCCKMenuItem.h"
#import "LCCKConversationListViewController.h"
#import "LCCKConversationListViewModel.h"
#import "LCCKConversationListCell.h"
#import "NSBundle+LCCKExtension.h"
#import "NSFileManager+LCCKExtension.h"
#import "NSString+LCCKExtension.h"
#import "NSString+LCCKMD5.h"
#import "UIColor+LCCKExtension.h"
#import "UIImage+LCCKExtension.h"
#import "UIImageView+LCCKExtension.h"
#import "UIView+LCCKExtension.h"
#import "ChatKitHeaders.h"
#import "LCChatKit_Internal.h"
#import "LCCKConstants.h"
#import "LCCKServiceDefinition.h"
#import "LCCKSingleton.h"
#import "NSObject+LCCKIsFirstLaunch.h"
#import "LCCKConversationListService.h"
#import "LCCKConversationService.h"
#import "LCCKSessionService.h"
#import "LCCKSettingService.h"
#import "LCCKSignatureService.h"
#import "LCCKUIService.h"
#import "LCCKUserSystemService.h"
#import "LCCKDateToolsConstants.h"
#import "LCCKError.h"
#import "NSDate+LCCKDateTools.h"
#import "LCCKAlertController.h"
#import "LCCKCaptionView.h"
#import "LCCKPBConstants.h"
#import "LCCKPhoto.h"
#import "LCCKPhotoBrowser.h"
#import "LCCKPhotoProtocol.h"
#import "LCCKTapDetectingImageView.h"
#import "LCCKTapDetectingView.h"
#import "LCCKZoomingScrollView.h"
#import "LCCKSafariActivity.h"
#import "LCCKWebViewController.h"
#import "LCCKWebViewProgress.h"
#import "LCCKWebViewProgressView.h"
#import "lame.h"
#import "Mp3Recorder.h"
#import "LCCKBadgeView.h"
#import "LCCKConversationRefreshHeader.h"
#import "LCCKStatusView.h"
#import "LCCKSwipeView.h"

FOUNDATION_EXPORT double ChatKitVersionNumber;
FOUNDATION_EXPORT const unsigned char ChatKitVersionString[];

