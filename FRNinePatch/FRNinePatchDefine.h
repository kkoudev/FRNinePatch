//
//  FRNinePatchDefine.h
//  FrontierWizard
//
//  Created by Kou on 14/08/14.
//  Copyright 2014 The Frontier Project All rights reserved.
//


/*
 * 32bitピクセル画像データインデックス情報列挙型。
 */
enum {
    
    IMAGE_PIXEL_INDEX_32BIT_RED = 0,    ///< 32bitピクセル画像の赤要素インデックス
    IMAGE_PIXEL_INDEX_32BIT_GREEN,      ///< 32bitピクセル画像の緑要素インデックス
    IMAGE_PIXEL_INDEX_32BIT_BLUE,       ///< 32bitピクセル画像の青要素インデックス
    IMAGE_PIXEL_INDEX_32BIT_ALPHA,      ///< 32bitピクセル画像のアルファ要素インデックス
    IMAGE_PIXEL_INDEX_32BIT_COUNT,      ///< 32bitピクセル画像のインデックス数
    
};


/**
 * 9-patch画像ファイルの拡張子
 */
#define FILE_NINE_PATCH_EXTENSION                   @"9.png"

/**
 * 画像ピクセルのビットサイズ
 */
#define COLOR_IMAGE_PIXEL_SIZE_BITS_PER_PIXEL       (32)

/**
 * 画像ピクセルのバイトサイズ
 */
#define COLOR_IMAGE_PIXEL_SIZE_BYTES_PER_PIXEL      (COLOR_IMAGE_PIXEL_SIZE_BITS_PER_PIXEL >> 3)

/**
 * 画像ピクセルのRGBA各要素のビットサイズ
 */
#define COLOR_IMAGE_PIXEL_SIZE_BITS_PER_COMPONENT   (8)

/**
 * 9-patchピクセルデータ色
 */
#define COLOR_IMAGE_PIXEL_NINE_PATCH                (0xFF000000)

/**
 * 9-patchが不正である場合の例外名
 */
#define INVALID_NINE_PATCH_EXCEPTION                @"InvalidNinePatchException"

/**
 * Normal Displayスケール値
 */
#define DISPLAY_SCALE_NORMAL                        (1.0)

/**
 * Retina Displayスケール値
 */
#define DISPLAY_SCALE_RETINA                        (2.0)

/**
 * Retina Display対応画像ファイル名フォーマット
 */
#define RETINA_DISPLAY_FILE_NAME_FORMAT             @"%@@2x.9.png"

/**
 * 通常画像ファイル名フォーマット
 */
#define DEFAULT_FILE_NAME_FORMAT                    @"%@.9.png"

/**
 * 描画領域サイズキー
 */
#define THREAD_LOCAL_DRAW_SIZE                      @"THREAD_LOCAL_DRAW_SIZE"

/**
 * 描画スケールキー
 */
#define THREAD_LOCAL_DRAW_SCALE                     @"THREAD_LOCAL_DRAW_SCALE"

