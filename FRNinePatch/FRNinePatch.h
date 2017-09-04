//
//  FRNinePatch.h
//  FrontierWizard
//
//  Created by Kou on 14/08/14.
//  Copyright 2014 The Frontier Project All rights reserved.
//

#import "FRNinePatchImage.h"


/**
 * 9-patch画像操作クラス。
 *
 * @author Koichi Nagaoka
 */
@interface FRNinePatch : NSObject


/**
 * 指定されたビューに9-patchイメージを設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 */
+ (void)setImage:(UIView*)view 
       imageName:(NSString*)imageName;


/**
 * 指定されたビューに9-patchイメージを設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 * @param contentView   9-patchコンテンツ領域となるビュー (複数指定可能)
 */
+ (void)setImage:(UIView*)view 
       imageName:(NSString*)imageName
     contentView:(UIView*)contentView, ... NS_REQUIRES_NIL_TERMINATION;


/**
 * 指定されたビューに9-patchイメージをキャッシュして設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 */
+ (void)setImageCache:(UIView*)view 
            imageName:(NSString*)imageName;


/**
 * 指定されたビューに9-patchイメージをキャッシュして設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 * @param contentView   9-patchコンテンツ領域となるビュー (複数指定可能)
 */
+ (void)setImageCache:(UIView*)view 
            imageName:(NSString*)imageName
          contentView:(UIView*)contentView, ... NS_REQUIRES_NIL_TERMINATION;


/**
 * 指定された名前の9-patchイメージキャッシュを削除する。
 *
 * @param imageName     キャッシュから削除する9-patchイメージ名
 */
+ (void)removeImageCache:(NSString*)imageName;


@end
