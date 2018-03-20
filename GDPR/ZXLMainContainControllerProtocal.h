//
//  ZXLMainContainControllerProtocal.h
//  GDPR
//
//  Created by zxl on 2017/12/26.
//  Copyright © 2017年 EM. All rights reserved.
//

@protocol ZXLMainContainControllerProtocal <NSObject>

typedef enum : NSUInteger {
    ZXLChildViewType_qb=0,   /**<全部*/
    ZXLChildViewType_gg,   /**<公告*/
    ZXLChildViewType_yw   /**<要闻*/
} ZXLChildViewType;

@end
