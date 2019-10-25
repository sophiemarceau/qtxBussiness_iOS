//
//  CommentView.m
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import "CommentView.h"
#import "BaseTableViewCell.h"
#import "WebViewController.h"


@implementation CommentView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.info[@"data"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99/2*AUTO_SIZE_SCALE_X+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"publicTableViewCell";
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
          cell = [(BaseTableViewCell *)[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.info[@"data"] count] > 0) {
        cell.textLabel.text = [[self.info[@"data"] objectAtIndex:indexPath.row]  objectForKey:@"jinNangTit"];
        cell.textLabel.textColor = FontUIColorBlack;
        cell.textLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.arrowImageView = [UIImageView new];
        self.arrowImageView.image = [UIImage imageNamed:@"icon-my-arrowRightgray"];
        self.arrowImageView.frame = CGRectMake(kScreenWidth-12-16 ,(50-16)/2*AUTO_SIZE_SCALE_X,7, 16);
        [cell addSubview:self.arrowImageView];
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 99/2*AUTO_SIZE_SCALE_X, kScreenWidth-15, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [cell addSubview:lineImageView];
        
        if ((int)indexPath.row==([self.info[@"data"] count]-1)) {
            lineImageView.hidden = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   [[NSNotificationCenter defaultCenter] postNotificationName:kProjectDetailToPost object:nil userInfo:@{@"silk":
                                                                                                             [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangUrl"],
                                                                                                         @"webdesc":
                                                                                                             [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangTit"]
                                                                                                         }
    
    ];
}

@end
