//
//  FRNinePatchImage.m
//  FrontierWizard
//
//  Created by Kou on 14/08/14.
//  Copyright 2014 The Frontier Project All rights reserved.
//

#import "FRNinePatchImage.h"
#import "FRNinePatchDefine.h"



/**
 * 9-patchイメージのキャッシュテーブル
 *
 * key   : 9-patchイメージ名 (NSString*)
 * value : キャッシュする画像 (NinePatchImage*)
 */
static NSMutableDictionary*     sNinePatchCaches = nil;





/**
 * 現在のスレッドに指定されたキーと値を確保する。
 *
 * @param key   パラメーター名
 * @param value パラメーター値
 */
void setLocalValue(NSString* key, NSValue* value) {

    NSMutableDictionary*    dictionary = [[NSThread currentThread] threadDictionary];

    // 値を確保する
    [dictionary setValue:value forKey:key];

}


/**
 * 現在のスレッドの指定された値を削除する。
 *
 * @param key   パラメーター名
 */
void removeLocalValue(NSString* key) {

    NSMutableDictionary*    dictionary = [[NSThread currentThread] threadDictionary];

    // 値を削除する
    [dictionary removeObjectForKey:key];

}


/**
 * 現在のスレッドに指定された値を取得する。
 *
 * @param key   パラメーター名
 * @return パラメーター値
 */
id getLocalValue(NSString* key) {

    NSMutableDictionary*    dictionary = [[NSThread currentThread] threadDictionary];

    // 値を返す
    return [dictionary valueForKey:key];
    
}


/**
 * 指定された画像の9-patch情報を取得する。
 *
 * @param outRectLeft   左ライン情報返却先ポインタ
 * @param outRectTop    上ライン情報返却先ポインタ
 * @param outRectRight  右ライン情報返却先ポインタ
 * @param outRectBottom 下ライン情報返却先ポインタ
 * @param inImageSize   画像サイズ情報へのポインタ
 * @param inImageBytes  画像ピクセルデータ情報へのポインタ
 */
void getNinePatchInfo(CGRect* outRectLeft, 
                      CGRect* outRectTop, 
                      CGRect* outRectRight, 
                      CGRect* outRectBottom,
                      const CGSize* inImageSize,
                      const Byte* inImageBytes
                      ) {
    
    const size_t        imageBytePerPixel = COLOR_IMAGE_PIXEL_SIZE_BYTES_PER_PIXEL; // 画像の1ピクセルのバイトサイズ
    const size_t        imageRowByteSize  = inImageSize->width * imageBytePerPixel; // 画像の一行のバイトサイズ
    int                 x, y;                                                       // ピクセルデータ検索用ループカウンタ変数
    BOOL                beginFindPixel;                                             // 9-patchピクセルデータの検索が開始しているかどうか
    
    
    // 各ライン情報返却先をクリアする
    memset(outRectLeft,   0, sizeof(CGRect));
    memset(outRectTop,    0, sizeof(CGRect));
    memset(outRectRight,  0, sizeof(CGRect));
    memset(outRectBottom, 0, sizeof(CGRect));
    
    // 左ライン情報を検索する
    for (x = 0, y = 0, beginFindPixel = false; y < inImageSize->height; y++) {
        
        // 検索位置のピクセルデータを取得する
        const Byte*   pixelColor = &inImageBytes[y * imageRowByteSize + x * imageBytePerPixel];
        
        
        // アルファ値が 0 の場合
        if (pixelColor[IMAGE_PIXEL_INDEX_32BIT_ALPHA] == 0) {
            
            // 9-patchピクセルデータ検索中の場合
            if (beginFindPixel) {
                
                // 9-patchピクセルデータの検索を終了する
                break;
                
            }
            
            // 次のピクセルデータへ
            continue;
            
        }
        
        // 9-patchピクセルデータ以外の場合は例外
        if (*((int32_t*)pixelColor) != COLOR_IMAGE_PIXEL_NINE_PATCH) {

            @throw [NSException exceptionWithName:INVALID_NINE_PATCH_EXCEPTION 
                                           reason:[NSString stringWithFormat:
                                                   @"The invalid pixel is set to this image. [pixel : x = %d, y = %d, color = %d]", 
                                                   x, y, *((int32_t*)pixelColor)]
                                         userInfo:nil];
            
        }
        
        // 9-patch ピクセルデータの検索が開始されていない場合
        if (!beginFindPixel) {
            
            // 最初の 9-patch ピクセルデータが見つかったこととする
            beginFindPixel = true;
            
            // 現在の座標とサイズを設定する
            outRectLeft->origin.x    = 0;
            outRectLeft->origin.y    = y;
            outRectLeft->size.width  = 1;
            outRectLeft->size.height = 1;
            
        } else {
            
            // サイズをインクリメントする
            outRectLeft->size.height++;
            
        }
        
    }
    
    
    // 上ライン情報を検索する
    for (x = 0, y = 0, beginFindPixel = false; x < inImageSize->width; x++) {
        
        // 検索位置のピクセルデータを取得する
        const Byte*   pixelColor = &inImageBytes[y * imageRowByteSize + x * imageBytePerPixel];
        
        
        // アルファ値が 0 の場合
        if (pixelColor[IMAGE_PIXEL_INDEX_32BIT_ALPHA] == 0) {
            
            // 9-patchピクセルデータ検索中の場合
            if (beginFindPixel) {
                
                // 9-patchピクセルデータの検索を終了する
                break;
                
            }
            
            // 次のピクセルデータへ
            continue;
            
        }
        
        // 9-patchピクセルデータ以外の場合は例外
        if (*((int32_t*)pixelColor) != COLOR_IMAGE_PIXEL_NINE_PATCH) {
            
            @throw [NSException exceptionWithName:INVALID_NINE_PATCH_EXCEPTION 
                                           reason:[NSString stringWithFormat:
                                                   @"The invalid pixel is set to this image. [pixel : x = %d, y = %d, color = %d]", 
                                                   x, y, *pixelColor]
                                         userInfo:nil];
            
        }
        
        // 9-patch ピクセルデータの検索が開始されていない場合
        if (!beginFindPixel) {
            
            // 最初の 9-patch ピクセルデータが見つかったこととする
            beginFindPixel = true;
            
            // 現在の座標とサイズを設定する
            outRectTop->origin.x    = x;
            outRectTop->origin.y    = 0;
            outRectTop->size.width  = 1;
            outRectTop->size.height = 1;
            
        } else {
            
            // サイズをインクリメントする
            outRectTop->size.width++;
            
        }
        
    }
    
    
    // 右ライン情報を検索する
    for (x = inImageSize->width - 1, y = 0, beginFindPixel = false; y < inImageSize->height; y++) {
        
        // 検索位置のピクセルデータを取得する
        const Byte*   pixelColor = &inImageBytes[y * imageRowByteSize + x * imageBytePerPixel];
        
        
        // アルファ値が 0 の場合
        if (pixelColor[IMAGE_PIXEL_INDEX_32BIT_ALPHA] == 0) {
            
            // 9-patchピクセルデータ検索中の場合
            if (beginFindPixel) {
                
                // 9-patchピクセルデータの検索を終了する
                break;
                
            }
            
            // 次のピクセルデータへ
            continue;
            
        }
        
        // 9-patchピクセルデータ以外の場合は例外
        if (*((int32_t*)pixelColor) != COLOR_IMAGE_PIXEL_NINE_PATCH) {
            
            @throw [NSException exceptionWithName:INVALID_NINE_PATCH_EXCEPTION 
                                           reason:[NSString stringWithFormat:
                                                   @"The invalid pixel is set to this image. [pixel : x = %d, y = %d, color = %d]", 
                                                   x, y, *pixelColor]
                                         userInfo:nil];
            
        }
        
        // 9-patch ピクセルデータの検索が開始されていない場合
        if (!beginFindPixel) {
            
            // 最初の 9-patch ピクセルデータが見つかったこととする
            beginFindPixel = true;
            
            // 現在の座標とサイズを設定する
            outRectRight->origin.x    = inImageSize->width - 1;
            outRectRight->origin.y    = y;
            outRectRight->size.width  = 1;
            outRectRight->size.height = 1;
            
        } else {
            
            // サイズをインクリメントする
            outRectRight->size.height++;
            
        }
        
    }
    
    
    // 下ライン情報を検索する
    for (x = 0, y = inImageSize->height - 1, beginFindPixel = false; x < inImageSize->width; x++) {
        
        // 検索位置のピクセルデータを取得する
        const Byte*   pixelColor = &inImageBytes[y * imageRowByteSize + x * imageBytePerPixel];
        
        
        // アルファ値が 0 の場合
        if (pixelColor[IMAGE_PIXEL_INDEX_32BIT_ALPHA] == 0) {
            
            // 9-patchピクセルデータ検索中の場合
            if (beginFindPixel) {
                
                // 9-patchピクセルデータの検索を終了する
                break;
                
            }
            
            // 次のピクセルデータへ
            continue;
            
        }
        
        // 9-patchピクセルデータ以外の場合は例外
        if (*((int32_t*)pixelColor) != COLOR_IMAGE_PIXEL_NINE_PATCH) {
            
            @throw [NSException exceptionWithName:INVALID_NINE_PATCH_EXCEPTION 
                                           reason:[NSString stringWithFormat:
                                                   @"The invalid pixel is set to this image. [pixel : x = %d, y = %d, color = %d]", 
                                                   x, y, *pixelColor]
                                         userInfo:nil];
            
        }
        
        // 9-patch ピクセルデータの検索が開始されていない場合
        if (!beginFindPixel) {
            
            // 最初の 9-patch ピクセルデータが見つかったこととする
            beginFindPixel = true;
            
            // 現在の座標とサイズを設定する
            outRectBottom->origin.x    = x;
            outRectBottom->origin.y    = inImageSize->height - 1;
            outRectBottom->size.width  = 1;
            outRectBottom->size.height = 1;
            
        } else {
            
            // サイズをインクリメントする
            outRectBottom->size.width++;
            
        }
        
    }
    
}


/**
 * 指定されたサイズの描画領域を作成して描画を開始する。
 *
 * @param size  描画領域サイズ
 * @param scale スケール値
 * @return 作成したグラフィックコンテキスト情報
 */
CGContextRef beginImageContext(CGSize size, CGFloat scale) {
    
    // 新規描画用コンテキストを作成する
    UIGraphicsBeginImageContextWithOptions(size, false, scale);
        
    // 作成したグラフィックコンテキストを返す
    CGContextRef    context = UIGraphicsGetCurrentContext();
    
    // 原点座標を左上に設定する
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 描画領域サイズを確保する
    setLocalValue(THREAD_LOCAL_DRAW_SIZE, [NSValue valueWithCGSize:size]);

    // スケール値が 0 の場合
    if (scale == 0) {
        
        // ディスプレイのスケール値を確保する
        setLocalValue(THREAD_LOCAL_DRAW_SCALE, [NSNumber numberWithFloat:[[UIScreen mainScreen] scale]]);

    } else {
    
        // 指定されたスケール値を確保する
        setLocalValue(THREAD_LOCAL_DRAW_SCALE, [NSNumber numberWithFloat:scale]);

    }
    
    // 作成したコンテキストを返す
    return context;
    
}


/**
 * 描画を終了し、描画領域のイメージ画像を取得する。
 *
 * @return 作成したイメージ画像
 */
UIImage* endImageContext(void) {
    
    // 描画領域のイメージを取得する
    UIImage*    retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画を終了する
    UIGraphicsEndImageContext();

    // 使用した値を削除する
    removeLocalValue(THREAD_LOCAL_DRAW_SIZE);
    removeLocalValue(THREAD_LOCAL_DRAW_SCALE);

    // 作成したイメージを返す
    return retImage;
    
}


/**
 * 描画座標をCGImage用の座標へ変換する。
 *
 * @param inRect        変換する座標とサイズ情報へのポインタ
 * @param inAreaSize    描画先領域サイズへのポインタ
 */
CGRect convertOriginForCGImage(const CGRect* inRect,
                               const CGSize* inAreaSize
                               ) {
    
    return CGRectMake(inRect->origin.x,
                      inAreaSize->height - (inRect->origin.y + inRect->size.height),
                      inRect->size.width,
                      inRect->size.height
                      );
    
}


/**
 * 指定した画像を拡大縮小描画する。
 *
 * 描画座標は左上原点とする。
 *
 * @param context       描画先コンテキスト
 * @param inDestRect    描画先矩形情報へのポインタ
 * @param inSrcRect     描画元矩形情報へのポインタ
 * @param srcImage      描画元画像
 */
void drawStretchCGImage(CGContextRef context,
                        const CGRect* inDestRect,
                        const CGRect* inSrcRect,
                        CGImageRef srcImage
                        ) {
    
    // 描画サイズが 0 以下の場合
    if ((inDestRect->size.width <= 0)
        || (inDestRect->size.height <= 0)
        || (inSrcRect->size.width <= 0)
        || (inSrcRect->size.height <= 0)
        ) {
        
        // 描画処理なし
        return;
        
    }

    // 元画像から部分画像を取り出す
    CGImageRef  partImage   = CGImageCreateWithImageInRect(srcImage, *inSrcRect);
    CGRect      destRect    = *inDestRect;
    CGFloat     scale       = [(NSNumber*)getLocalValue(THREAD_LOCAL_DRAW_SCALE) floatValue];
    CGSize      contextSize = [(NSValue*)getLocalValue(THREAD_LOCAL_DRAW_SIZE) CGSizeValue];
    
    // 描画先座標位置とサイズをスケール値で乗算する
    destRect.origin.x       /= scale;
    destRect.origin.y       /= scale;
    destRect.size.width     /= scale;
    destRect.size.height    /= scale;
    
    // 画像を拡大縮小描画する
    CGContextDrawImage(context,
                       convertOriginForCGImage(&destRect, &contextSize),
                       partImage
                       );
    
    // 部分画像を解放する
    CGImageRelease(partImage);
    
}




/*
 * 9-patch画像クラス実装部
 */
@implementation FRNinePatchImage


/*
 * アクセサメソッドの実装
 */
@synthesize image  = mImage;
@synthesize bounds = mBounds;


/**
 * 指定されたサイズで9-patch展開画像のインスタンスを作成する。
 *
 * @param imageName リソース画像ファイル名
 * @param size      生成する画像サイズ
 * @return 9-patch展開画像のインスタンス
 */
- (FRNinePatchImage*)initWithName:(NSString*)imageName
                             size:(CGSize)size {
    
    // イメージ名がない場合は例外
    if (imageName == nil) {
        
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil];
        
    }

    
    UIImage*            retImage;           // 展開後の画像
    UIImage*            srcImage = nil;     // 元画像
    CGSize              srcImageSize;       // 元画像サイズ
    CGSize              srcImageDrawSize;   // 元画像描画サイズ
    CGImageRef          srcRefImage;        // 参照用元画像
    Byte*               imageBytes;         // 画像のピクセルデータへのポインタ
    CGColorSpaceRef     colorSpace;         // 画像の色空間
    CGContextRef        srcContext;         // 元画像の描画コンテキスト
    CGContextRef        destContext;        // 9-patch展開画像の描画コンテキスト
    CGRect              rectLeft;           // 左ラインの9-patch情報
    CGRect              rectTop;            // 上ラインの9-patch情報
    CGRect              rectRight;          // 右ラインの9-patch情報
    CGRect              rectBottom;         // 下ラインの9-patch情報
    NSString*           bundlePath;         // 画像のルートパス
    CGSize              createImageSize;    // 生成する画像サイズ
    CGFloat             scale;              // スケール値
    
    // 画像のルートパスを取得する
    bundlePath = [[NSBundle mainBundle] bundlePath];
    
    
    // Retina Displayの場合
    if ([[UIScreen mainScreen] scale] == DISPLAY_SCALE_RETINA) {

        // Retina Display対応画像を取得する
        srcImage = [[UIImage alloc] initWithContentsOfFile:
                    [bundlePath stringByAppendingPathComponent:
                     [NSString stringWithFormat:RETINA_DISPLAY_FILE_NAME_FORMAT, 
                      imageName]]
                    ];
        
    }
    
    // 画像が取得できなかった場合
    if (srcImage == nil) {
        
        // 通常画像を取得する
        srcImage = [[UIImage alloc] initWithContentsOfFile:
                    [bundlePath stringByAppendingPathComponent:
                     [NSString stringWithFormat:DEFAULT_FILE_NAME_FORMAT, 
                      imageName]]
                    ];
        
        // 通常ディスプレイスケール値を設定する
        scale = DISPLAY_SCALE_NORMAL;
        
    } else {
        
        // Retinaディスプレイスケール値を設定する
        scale = DISPLAY_SCALE_RETINA;
        
    }
    
    // 作成する画像サイズを算出する
    createImageSize = CGSizeMake(size.width * scale, size.height * scale);
    
    
    // イメージ情報を読み込む
    // (UIImageのsizeメソッドで取得したサイズはRetina画像だと本来のサイズの半分のサイズが返却されるため、
    //  CGImageGetWidth(), CGImageGetHeight()でサイズ取得をすること)
    srcRefImage         = [srcImage CGImage];
    srcImageDrawSize    = srcImage.size;
    srcImageSize        = CGSizeMake(CGImageGetWidth(srcRefImage), CGImageGetHeight(srcRefImage));

    // ピクセルデータ用定数値を算出する
    const size_t    imageBytePerPixel = COLOR_IMAGE_PIXEL_SIZE_BYTES_PER_PIXEL; // 画像の1ピクセルのバイトサイズ
    const size_t    imageRowByteSize  = srcImageSize.width * imageBytePerPixel; // 画像の一行のバイトサイズ

    // 画像のピクセルデータ格納領域を作成する
    imageBytes = malloc(srcImageSize.width * srcImageSize.height * imageBytePerPixel);
    
    // 画像の色空間を作成する
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 元画像のビットマップコンテキストを作成する
    srcContext = CGBitmapContextCreate(imageBytes, 
                                       srcImageSize.width, 
                                       srcImageSize.height, 
                                       COLOR_IMAGE_PIXEL_SIZE_BITS_PER_COMPONENT, 
                                       imageRowByteSize, 
                                       colorSpace, 
                                       (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                       );
    
    // 描画モードを設定する
    CGContextSetBlendMode(srcContext, kCGBlendModeCopy);
    
    // イメージを確保したピクセルデータ格納領域へコピーする
    CGContextDrawImage(srcContext, CGRectMake(0, 0, srcImageSize.width, srcImageSize.height), srcRefImage);
    
    // 9-patch情報を取得する
    getNinePatchInfo(&rectLeft, &rectTop, &rectRight, &rectBottom, &srcImageSize, imageBytes);
    
    // 使用済み色空間情報、ビットマップコンテキスト、ピクセルデータを解放する
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(srcContext);
    free(imageBytes);

    
    // 転送元の上部ライン領域情報を作成する
    CGRect  transSrcLeftTop      = CGRectMake(1, 
                                              1, 
                                              rectTop.origin.x - 1, 
                                              rectLeft.origin.y - 1
                                              );
    CGRect  transSrcRightTop     = CGRectMake(rectTop.origin.x + rectTop.size.width, 
                                              1, 
                                              srcImageSize.width - transSrcLeftTop.size.width - rectTop.size.width - 2, 
                                              transSrcLeftTop.size.height
                                              );
    CGRect  transSrcTop          = CGRectMake(rectTop.origin.x,
                                              1,
                                              rectTop.size.width,
                                              transSrcLeftTop.size.height
                                              );
    
    // 転送元の下部ライン領域情報を作成する
    CGRect  transSrcLeftBottom   = CGRectMake(transSrcLeftTop.origin.x, 
                                              rectLeft.origin.y + rectLeft.size.height, 
                                              transSrcLeftTop.size.width, 
                                              srcImageSize.height - (rectLeft.origin.y + rectLeft.size.height) - 1
                                              );
    CGRect  transSrcRightBottom  = CGRectMake(transSrcRightTop.origin.x, 
                                              transSrcLeftBottom.origin.y, 
                                              transSrcRightTop.size.width, 
                                              transSrcLeftBottom.size.height
                                              );
    CGRect  transSrcBottom       = CGRectMake(transSrcTop.origin.x,
                                              transSrcLeftBottom.origin.y,
                                              transSrcTop.size.width,
                                              transSrcLeftBottom.size.height
                                              );
    
    // 転送元の中央ライン領域情報を作成する
    CGRect  transSrcLeft         = CGRectMake(transSrcLeftTop.origin.x, 
                                              rectLeft.origin.y, 
                                              transSrcLeftTop.size.width, 
                                              rectLeft.size.height
                                              );
    CGRect  transSrcRight        = CGRectMake(transSrcRightTop.origin.x, 
                                              transSrcLeft.origin.y, 
                                              transSrcRightTop.size.width, 
                                              transSrcLeft.size.height
                                              );
    CGRect  transSrcCenter       = CGRectMake(transSrcTop.origin.x,
                                              transSrcLeft.origin.y,
                                              transSrcTop.size.width,
                                              transSrcLeft.size.height
                                              );
    
    
    // 転送先の上部ライン領域情報を作成する
    CGRect  transDestLeftTop     = CGRectMake(transSrcLeftTop.origin.x - 1,
                                              transSrcLeftTop.origin.y - 1,
                                              transSrcLeftTop.size.width,
                                              transSrcLeftTop.size.height
                                              );
    CGRect  transDestTop         = CGRectMake(transDestLeftTop.origin.x + transDestLeftTop.size.width, 
                                              transDestLeftTop.origin.y, 
                                              createImageSize.width - transSrcLeftTop.size.width - transSrcRightTop.size.width, 
                                              transDestLeftTop.size.height
                                              );    
    CGRect  transDestRightTop    = CGRectMake(transDestTop.origin.x + transDestTop.size.width,
                                              transDestLeftTop.origin.y,
                                              transSrcRightTop.size.width,
                                              transSrcRightTop.size.height
                                              );
    
    // 転送先の下部ライン領域情報を作成する
    CGRect  transDestLeftBottom  = CGRectMake(transSrcLeftBottom.origin.x - 1,
                                              createImageSize.height - transSrcLeftBottom.size.height,
                                              transSrcLeftBottom.size.width,
                                              transSrcLeftBottom.size.height
                                              );
    CGRect  transDestRightBottom = CGRectMake(createImageSize.width - transSrcRightBottom.size.width,
                                              transDestLeftBottom.origin.y,
                                              transSrcRightBottom.size.width,
                                              transSrcRightBottom.size.height
                                              );
    CGRect  transDestBottom      = CGRectMake(transDestLeftBottom.origin.x + transDestLeftBottom.size.width, 
                                              transDestLeftBottom.origin.y, 
                                              createImageSize.width - transDestLeftBottom.size.width - transDestRightBottom.size.width, 
                                              transDestLeftBottom.size.height
                                              );    
    
    // 転送先の中央ライン領域情報を作成する
    CGRect  transDestLeft        = CGRectMake(transDestLeftTop.origin.x, 
                                              transDestTop.origin.y + transDestTop.size.height,
                                              transDestLeftTop.size.width,
                                              createImageSize.height - transDestLeftTop.size.height - transDestLeftBottom.size.height
                                              );
    CGRect  transDestRight       = CGRectMake(transDestRightTop.origin.x, 
                                              transDestLeft.origin.y,
                                              transDestRightTop.size.width,
                                              transDestLeft.size.height
                                              );
    CGRect  transDestCenter      = CGRectMake(transDestTop.origin.x, 
                                              transDestLeft.origin.y,
                                              transDestTop.size.width,
                                              transDestLeft.size.height
                                              );
    
    // 9-patch展開画像転送先グラフィックコンテキストを作成開始する
    destContext = beginImageContext(size, scale);

    
    // 各パーツを描画する
    drawStretchCGImage(destContext, &transDestLeftTop, &transSrcLeftTop, srcRefImage);            // 左上
    drawStretchCGImage(destContext, &transDestTop, &transSrcTop, srcRefImage);                    // 上
    drawStretchCGImage(destContext, &transDestRightTop, &transSrcRightTop, srcRefImage);          // 右上
    drawStretchCGImage(destContext, &transDestLeft, &transSrcLeft, srcRefImage);                  // 左
    drawStretchCGImage(destContext, &transDestCenter, &transSrcCenter, srcRefImage);              // 中央
    drawStretchCGImage(destContext, &transDestRight, &transSrcRight, srcRefImage);                // 右
    drawStretchCGImage(destContext, &transDestLeftBottom, &transSrcLeftBottom, srcRefImage);      // 左下
    drawStretchCGImage(destContext, &transDestBottom, &transSrcBottom, srcRefImage);              // 下
    drawStretchCGImage(destContext, &transDestRightBottom, &transSrcRightBottom, srcRefImage);    // 右下
    

    // 展開後の画像データを取得する
    retImage = endImageContext();

    
    // インスタンスを生成する
    self = [self init];
    
    // インスタンスの生成に成功した場合
    if (self) {
        
        // 各メンバ変数情報を設定する
        self->mImage  = retImage;
        self->mBounds = CGRectMake(rectBottom.origin.x / scale - 1,
                                   rectRight.origin.y / scale - 1,
                                   size.width - (srcImageDrawSize.width - 2 - rectBottom.size.width / scale),
                                   size.height - (srcImageDrawSize.height - 2 - rectRight.size.height / scale)
                                   );

    }
    
    
    // 作成したインスタンスを返す
    return self;
    
}


/**
 * 指定されたサイズで9-patch展開画像の一時インスタンスを作成する。
 *
 * @param imageName リソース画像ファイル名
 * @param size      生成する画像サイズ
 * @return 9-patch展開画像の一時インスタンス
 */
+ (FRNinePatchImage*)imageWithName:(NSString*)imageName
                            size:(CGSize)size {
    
    return [[FRNinePatchImage alloc] initWithName:imageName size:size];
    
}


/**
 * 指定された名称の9-patch展開画像のキャッシュインスタンスを取得する。
 *
 * @param imageName リソース画像ファイル名
 * @param size      生成する画像サイズ
 * @return 9-patch展開画像のキャッシュインスタンス
 */
+ (FRNinePatchImage*)imageCached:(NSString*)imageName
                            size:(CGSize)size {
    
    // クラスオブジェクトでロックする
    @synchronized ([self class]) {
        
        // キャッシュテーブルがない場合
        if (sNinePatchCaches == nil) {
            
            // キャッシュテーブルを作成する
            sNinePatchCaches = [[NSMutableDictionary alloc] init];
            
        }
        
    }
    
    
    FRNinePatchImage*    retImage;   // 返却画像インスタンス
    
    // キャッシュテーブルでロックする
    @synchronized (sNinePatchCaches) {
        
        // キャッシュ画像を取得する
        retImage = [sNinePatchCaches valueForKey:imageName];
        
        // キャッシュ画像がない場合
        if (retImage == nil) {
            
            // イメージを作成する
            retImage = [self imageWithName:imageName size:size];
            
            // イメージをキャッシュする
            [sNinePatchCaches setValue:retImage forKey:imageName];
            
        }
        
    }
    
    
    // 取得した画像を返す
    return retImage;
    
}


/**
 * 指定された名称の9-patch展開画像のキャッシュを削除する。
 *
 * @param imageName 削除するキャッシュされたリソース画像ファイル名
 */
+ (void)removeImageCache:(NSString*)imageName {
    
    // クラスオブジェクトでロックする
    @synchronized ([self class]) {
        
        // キャッシュテーブルがない場合
        if (sNinePatchCaches == nil) {
            
            // 処理なし
            return;
            
        }
        
    }
    
    // キャッシュテーブルでロックする
    @synchronized (sNinePatchCaches) {
        
        // 指定された名称のキャッシュを削除する
        [sNinePatchCaches removeObjectForKey:imageName];
        
    }
    
}


@end
