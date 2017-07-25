//
//  ViewController.m
//  MutlThreadPhotos
//
//  Created by xuqian on 2017/7/13.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *arrayImageUrl;
@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (nonatomic,strong) NSOperation *myOperation;
@property (nonatomic,strong) NSOperationQueue *myOperationQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"测试是否添加了新的");
    // Do any additional setup after loading the view, typically from a nib.
    [self.arrayImageUrl addObject:@"http://img.taopic.com/uploads/allimg/140326/235113-1403260U22059.jpg"];
    [self.arrayImageUrl addObject:@"http://img1.3lian.com/2015/w7/85/d/21.jpg"];
    [self.arrayImageUrl addObject:@"http://imgsrc.baidu.com/image/c0%3Dshijue%2C0%2C0%2C245%2C40/sign=626e96b8c711728b24208461a095a9bb/0eb30f2442a7d9337bfbfd5aa74bd11373f00143.jpg"];
    [self.arrayImageUrl addObject:@"http://imgsrc.baidu.com/image/c0%3Dshijue%2C0%2C0%2C245%2C40/sign=efce41b024dda3cc1fe9b06369805374/e1fe9925bc315c609050b3c087b1cb13485477dc.jpg"];
    [self.arrayImageUrl addObject:@"http://pic27.nipic.com/20130319/11935511_225831392000_2.jpg"];
    [self.arrayImageUrl addObject:@"http://pic23.nipic.com/20120908/10639194_105138442151_2.jpg"];
    [self.arrayImageUrl addObject:@"http://pic11.nipic.com/20101215/3400947_015953693504_2.jpg"];
    [self.arrayImageUrl addObject:@"http://imgsrc.baidu.com/image/c0%3Dshijue%2C0%2C0%2C245%2C40/sign=c7905628bb3533fae1bb9b6dc0ba976a/d53f8794a4c27d1e0c53e4e211d5ad6eddc4389b.jpg"];
    [self.arrayImageUrl addObject:@"http://pic32.nipic.com/20130825/13508699_164646522141_2.jpg"];
    [self.arrayImageUrl addObject:@"http://img2.3lian.com/2014/c7/32/d/52.jpg"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 20);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [self.view addSubview:self.myCollectionView];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2-5, collectionView.frame.size.width/2) ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayImageUrl count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *image = [[UIImageView alloc] initWithFrame:cell.bounds];
    image.center = CGPointMake(cell.frame.size.width/2.0, cell.frame.size.height/2.0);
    image.tag = 100;
    image.userInteractionEnabled = YES;
    dispatch_async(dispatch_queue_create("com.xuqian.photos", DISPATCH_QUEUE_CONCURRENT), ^{
        if (indexPath.row < [self.arrayImageUrl count]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.arrayImageUrl[indexPath.row]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data != nil)
                    [image setImage:[UIImage imageWithData:data]];
            });
        }
    });
    [cell addSubview:image];
    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *myCell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *myImageView = [myCell viewWithTag:100];
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        if (indexPath.row < [self.arrayImageUrl count])
        {
            NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.arrayImageUrl[(int)arc4random()%[self.arrayImageUrl count]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (myData != nil)
                {
                    CGRect frame = myImageView.frame;
                    myImageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width/2.0, frame.size.height/2.0);
                    myImageView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
                    myImageView.alpha = 0.5;
                    [UIView animateWithDuration:1.0 animations:^{
                        [myImageView setImage:[UIImage imageWithData:myData]];
                        myImageView.frame = frame;
                        myImageView.alpha = 1.0;
                    }];
                }
            });
        }
    }];
    //添加依赖，保证先点的图片先变
//    if (self.myOperation != nil)
//    {
//        [blockOperation addDependency:self.myOperation];
    
//    }
    self.myOperation = blockOperation;
    [self.myOperationQueue addOperation:blockOperation];
    
    NSLog(@"%ld", indexPath.row);
}

- (NSMutableArray *)arrayImageUrl{
    if (!_arrayImageUrl)
    {
        _arrayImageUrl = [NSMutableArray array];
    }
    return _arrayImageUrl;
}

- (NSOperationQueue *)myOperationQueue{
    if (!_myOperationQueue)
    {
        _myOperationQueue = [[NSOperationQueue alloc] init];
    }
    return _myOperationQueue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
