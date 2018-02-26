//
//  ViewController.m
//  CleenProjectDemo
//
//  Created by saifing on 2018/2/26.
//  Copyright © 2018年 BKZ. All rights reserved.
//

#import "ViewController.h"
#import "RowModel.h"
#import "NetWorkTools.h"
#import "CleenTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController{
    
    UITableView *myTableView;
    NSArray *dataSourceArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KmainW, KmainH) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    myTableView.sd_layout.
    topSpaceToView(self.view, 0).
    bottomSpaceToView(self.view, 0).
    leftSpaceToView(self.view, 0).
    rightSpaceToView(self.view, 0);
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestData];
    }];
    
    [self requestData];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)requestData{
    
    [NetWorkTools getDataShowHUD:YES withUrl:HOSTURL parameter:nil andResponse:^(BOOL sucess, id contentData) {
        
        if (sucess) {
            
            
            
            dataSourceArray = [RowModel mj_objectArrayWithKeyValuesArray:[self AmendmentData:contentData[@"rows"]]];
            
            self.navigationItem.title = contentData[@"title"];
            
            [myTableView.mj_header endRefreshing];
            [myTableView reloadData];
        }        
    }];
}
//因为IOS中 description 为系统属性,不能拿来直接使用.此处转换为自定义
- (NSArray *)AmendmentData:(NSArray*)array{
    
    NSMutableArray *returnArray = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
        [mutableDict setObject:dict[@"description"] forKey:@"myDescription"];
        [mutableDict removeObjectForKey:@"description"];
        [returnArray addObject:mutableDict];
    }
    
    return returnArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RowModel *model = dataSourceArray[indexPath.row];
    
    if (!model.title && !model.myDescription && !model.imageHref)
        return 0;
    else
        return [myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"RowModel" cellClass:[CleenTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseString = @"reuseString";
    
    CleenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseString];
    
    if (cell == nil)
    {
        cell = [[CleenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //为方便查看自适应高度,此处设置随机背景颜色
        cell.backgroundColor = RANDOM_COLOR;
    }
    
    RowModel *model = dataSourceArray[indexPath.row];
    if (!model.title && !model.myDescription && !model.imageHref)
        cell.accessoryType = UITableViewCellAccessoryNone; //隐藏最右边的箭头
    else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    cell.rowModel = model;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
