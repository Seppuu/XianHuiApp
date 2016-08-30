//
//  UITableViewCell+LCCKCellIdentifier.m
//  LCCKChatBarExample
//
//  v0.6.0 Created by ElonChan (微信向我报BUG:chenyilong1010) ( https://github.com/leancloud/ChatKit-OC ) on 15/11/23.
//  Copyright © 2015年 https://LeanCloud.cn . All rights reserved.
//

#import "LCCKCellIdentifierFactory.h"
#import "LCCKMessage.h"
#import "NSObject+LCCKExtension.h"
#import <AVOSCloudIM/AVIMConversation.h>
#import "AVIMTypedMessage+LCCKExtension.h"
#import "LCCKConstants.h"

@implementation LCCKCellIdentifierFactory

+ (NSString *)cellIdentifierForMessageConfiguration:(id)message conversationType:(LCCKConversationType)conversationType {
    NSString *groupKey;
    switch (conversationType) {
        case LCCKConversationTypeGroup:
            groupKey = LCCKCellIdentifierGroup;
            break;
        case LCCKConversationTypeSingle:
            groupKey = LCCKCellIdentifierSingle;
            break;
        default:
            groupKey = @"";
            break;
    }
    
    if ([message lcck_isCustomMessage]) {
        return [self cellIdentifierForCustomMessageConfiguration:(AVIMTypedMessage *)message groupKey:groupKey];
    }
    return [self cellIdentifierForDefaultMessageConfiguration:(LCCKMessage *)message groupKey:groupKey];
}

+ (NSString *)cellIdentifierForDefaultMessageConfiguration:(LCCKMessage *)message groupKey:(NSString *)groupKey {
    AVIMMessageMediaType messageType = message.mediaType;
    
    LCCKMessageOwnerType messageOwner = message.ownerType;
    
    NSNumber *key = [NSNumber numberWithInteger:messageType];
    if ([message lcck_isCustomLCCKMessage]) {
        key = [NSNumber numberWithInteger:kAVIMMessageMediaTypeText];
    }
    Class aClass = [LCCKChatMessageCellMediaTypeDict objectForKey:key];
    NSString *typeKey = NSStringFromClass(aClass);
    NSString *ownerKey;
    switch (messageOwner) {
        case LCCKMessageOwnerTypeSystem:
            ownerKey = LCCKCellIdentifierOwnerSystem;
            break;
        case LCCKMessageOwnerTypeOther:
            ownerKey = LCCKCellIdentifierOwnerOther;
            break;
        case LCCKMessageOwnerTypeSelf:
            ownerKey = LCCKCellIdentifierOwnerSelf;
            groupKey = LCCKCellIdentifierSingle;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__), @(message.mediaType), NSStringFromClass([message class]));
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

+ (NSString *)cellIdentifierForCustomMessageConfiguration:(AVIMTypedMessage *)message groupKey:(NSString *)groupKey {
    AVIMMessageMediaType messageType;
    if ([message lcck_isSupportThisCustomMessage]) {
       messageType = message.mediaType;
    } else {
        messageType = kAVIMMessageMediaTypeText;
    }
    AVIMMessageIOType messageOwner = message.ioType;
    NSString *typeKey = NSStringFromClass([LCCKChatMessageCellMediaTypeDict objectForKey:@(message.mediaType)]);
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__), @(message.mediaType), NSStringFromClass([message class]));
    NSString *ownerKey;
    switch (messageOwner) {
        case AVIMMessageIOTypeOut:
            ownerKey = LCCKCellIdentifierOwnerSelf;
            groupKey = LCCKCellIdentifierSingle;
            break;
        case AVIMMessageIOTypeIn:
            ownerKey = LCCKCellIdentifierOwnerOther;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

@end
