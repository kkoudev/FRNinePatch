//
//  FRNinePatch.m
//  FrontierWizard
//
//  Created by Kou on 14/08/14.
//  Copyright 2014 The Frontier Project All rights reserved.
//

#import "FRNinePatch.h"


/*
 * 9-patch画像操作クラス実装部
 */
@implementation FRNinePatch


/**
 * 指定されたビューに9-patchイメージを設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 */
+ (void)setImage:(UIView*)view 
       imageName:(NSString*)imageName {
    
    [self setImage:view imageName:imageName contentView:nil];
    
}


/**
 * 指定されたビューに9-patchイメージを設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 * @param contentView   9-patchコンテンツ領域となるビュー (複数指定可能)
 */
+ (void)setImage:(UIView*)view 
       imageName:(NSString*)imageName
     contentView:(UIView*)contentView, ... {
    
    // イメージビューとイメージ名がない場合は例外
    if ((view == nil) || (imageName == nil)) {
        
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
        
    }
    
    
    // 9-patchイメージを作成する
    FRNinePatchImage*     ninePatchImage = [FRNinePatchImage imageWithName:imageName
                                                             size:view.bounds.size];
    
    // UIImageViewの場合
    if ([view isKindOfClass:[UIImageView class]]) {
        
        // イメージを設定する
        [(UIImageView*)view setImage:ninePatchImage.image];
        
    } else {
        
        // ビューの背景に設定する
        view.backgroundColor = [UIColor colorWithPatternImage:ninePatchImage.image];
        
    }
    
    // 9-patchコンテンツビューが指定されている場合
    if (contentView != nil) {
        
        // コンテンツ領域情報を作成する
        CGRect  frame = CGRectMake(view.frame.origin.x + ninePatchImage.bounds.origin.x,
                                   view.frame.origin.y + ninePatchImage.bounds.origin.y,
                                   ninePatchImage.bounds.size.width,
                                   ninePatchImage.bounds.size.height
                                   );
        
        
        va_list     contentViews;     // フレームビュー取り出し用変数
        
        
        // 残りのコンテンツビュー取り出し開始
        va_start(contentViews, contentView);
        
        // 全てのコンテンツビューを処理する
        UIView*     localContentView = contentView;
        
        // nil以外の場合
        while (localContentView != nil) {
            
            // フレーム領域として設定する
            localContentView.frame = frame;
            
            // 次のコンテンツビューを取り出す
            localContentView = va_arg(contentViews, UIView*);
            
        }
        
        // 取り出し終了
        va_end(contentViews);
        
    }
    
}


/**
 * 指定されたビューに9-patchイメージをキャッシュして設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 */
+ (void)setImageCache:(UIView*)view 
            imageName:(NSString*)imageName {
    
    [self setImageCache:view imageName:imageName contentView:nil];
    
}


/**
 * 指定されたビューに9-patchイメージをキャッシュして設定する。
 *
 * @param view          9-patchイメージ設定先ビュー
 * @param imageName     設定する9-patchイメージ名
 * @param contentView   9-patchコンテンツ領域となるビュー (複数指定可能)
 */
+ (void)setImageCache:(UIView*)view 
            imageName:(NSString*)imageName
          contentView:(UIView*)contentView, ... {
    
    // イメージビューとイメージ名がない場合は例外
    if ((view == nil) || (imageName == nil)) {
        
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
        
    }
    
    
    // 9-patchイメージをキャッシュ作成する
    FRNinePatchImage*     ninePatchImage = [FRNinePatchImage imageCached:imageName
                                                             size:view.bounds.size];
    
    // UIImageViewの場合
    if ([view isKindOfClass:[UIImageView class]]) {
        
        // イメージを設定する
        [(UIImageView*)view setImage:ninePatchImage.image];
        
    } else {
        
        // ビューの背景に設定する
        view.backgroundColor = [UIColor colorWithPatternImage:ninePatchImage.image];
        
    }
    
    // 9-patchコンテンツビューが指定されている場合
    if (contentView != nil) {
        
        // コンテンツ領域情報を作成する
        CGRect  frame = CGRectMake(view.frame.origin.x + ninePatchImage.bounds.origin.x,
                                   view.frame.origin.y + ninePatchImage.bounds.origin.y,
                                   ninePatchImage.bounds.size.width,
                                   ninePatchImage.bounds.size.height
                                   );
        
        
        va_list     contentViews;     // フレームビュー取り出し用変数
        
        
        // 残りのコンテンツビュー取り出し開始
        va_start(contentViews, contentView);
        
        // 全てのコンテンツビューを処理する
        UIView*     localContentView = contentView;
        
        // nil以外の場合
        while (localContentView != nil) {
            
            // フレーム領域として設定する
            localContentView.frame = frame;
            
            // 次のコンテンツビューを取り出す
            localContentView = va_arg(contentViews, UIView*);
            
        }
        
        // 取り出し終了
        va_end(contentViews);
        
    }
    
}


/**
 * 指定された名前の9-patchイメージキャッシュを削除する。
 *
 * @param imageName     キャッシュから削除する9-patchイメージ名
 */
+ (void)removeImageCache:(NSString*)imageName {
    
    [FRNinePatchImage removeImageCache:imageName];
    
}


@end
