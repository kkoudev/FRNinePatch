//
//  FRNinePatchImage.h
//  FrontierWizard
//
//  Created by Kou on 14/08/14.
//  Copyright 2014 The Frontier Project All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/**
 * 9-patch画像情報クラス。
 *
 * @author Koichi Nagaoka
 */
@interface FRNinePatchImage : NSObject


/**
 * 9-patch展開画像
 */
@property (nonatomic, strong, readonly) UIImage* image;

/**
 * 9-patchコンテンツ領域
 */
@property (nonatomic, readonly) CGRect bounds;




/**
 * 指定されたサイズで9-patch展開画像のインスタンスを作成する。
 *
 * @param imageName リソース画像ファイル名
 * @param size      生成する画像サイズ
 * @return 9-patch展開画像のインスタンス
 */
- (FRNinePatchImage*)initWithName:(NSString*)imageName 
                             size:(CGSize)size;


/**
 * 指定されたサイズで9-patch展開画像の一時インスタンスを作成する。
 *
 * @param imageName リソース画像ファイル名
 * @param size      生成する画像サイズ
 * @return 9-patch展開画像の一時インスタンス
 */
+ (FRNinePatchImage*)imageWithName:(NSString*)imageName 
                              size:(CGSize)size;


/**
 * 指定された名称の9-patch展開画像のキャッシュインスタンスを取得する。
 *
 * @param imageName リソース画像ファイル名
 * @param size      生成する画像サイズ
 * @return 9-patch展開画像のキャッシュインスタンス
 */
+ (FRNinePatchImage*)imageCached:(NSString*)imageName 
                            size:(CGSize)size;


/**
 * 指定された名称の9-patch展開画像のキャッシュを削除する。
 *
 * @param imageName 削除するキャッシュされたリソース画像ファイル名
 */
+ (void)removeImageCache:(NSString*)imageName;


@end
