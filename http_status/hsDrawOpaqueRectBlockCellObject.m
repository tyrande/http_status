//
//  hsDrawOpaqueRectBlockCellObject.m
//  http_status
//
//  Created by tyrande on 1/1/13.
//  Copyright (c) 2013 tyrande. All rights reserved.
//

#import "hsDrawOpaqueRectBlockCellObject.h"

@implementation hsDrawOpaqueRectBlockCellObject

@synthesize block = _block;
@synthesize object = _object;

- (id)initWithBlock:(NICellDrawRectBlock)block object:(id)object {
    if ((self = [super initWithCellClass:[NIDrawOpaqueRectBlockCell class]])) {
        _block = block;
        _object = object;
    }
    return self;
}

+ (id)objectWithBlock:(NICellDrawRectBlock)block object:(id)object {
    return [[self alloc] initWithBlock:block object:object];
}

@end

@implementation NIDrawOpaqueRectBlockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.opaque = NO;
    }
    return self;
}

@end