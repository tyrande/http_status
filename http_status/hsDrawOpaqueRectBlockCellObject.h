//
//  hsDrawOpaqueRectBlockCellObject.h
//  http_status
//
//  Created by tyrande on 1/1/13.
//  Copyright (c) 2013 tyrande. All rights reserved.
//

#import "NICellFactory.h"
#import "NICellCatalog.h"

@interface hsDrawOpaqueRectBlockCellObject : NICellObject
- (id)initWithBlock:(NICellDrawRectBlock)block object:(id)object;
+ (id)objectWithBlock:(NICellDrawRectBlock)block object:(id)object;
@property (nonatomic, copy) NICellDrawRectBlock block;
@property (nonatomic, NI_STRONG) id object;
@end


@interface NIDrawOpaqueRectBlockCell : NIDrawRectBlockCell

@end