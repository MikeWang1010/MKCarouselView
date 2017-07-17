# MKCarouselView
轻量级本地图片无限轮播器，使用简单，可以轻松扩展其他功能~~~~

使用方式：

MKCarouselView *carouseView = [[MKCarouselView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 150) dataArray:imageDataArray];
    carouseView.delegate = self;
    [self.view addSubview:carouseView];
