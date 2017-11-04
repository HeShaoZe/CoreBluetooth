

/*
 一、获取外围数据
 1.开始扫描外围设备---->2.连接外围设备---->3.停止扫描外围设备---->4.扫描外围设备的服务---->5.扫描服务的特征---->6.扫描外围设备的服务的特征根据特征进行对外围进行操作
 
 
 二、向外围传输数据：
 NSData *data = [[NSData alloc]initWithBase64EncodedString:@"要传给外围设备的数据" options:NSUTF8StringEncoding];
 [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
 */


#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

//中心设备
@property (nonatomic, strong) CBCentralManager *centralManager;

//外围设备
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) CBCharacteristic *characteristic;

//把扫描的外围设备装进数组
@property (nonatomic, strong) NSMutableArray  *devData;//蓝牙设备信息

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -  loadLazy
- (NSMutableArray *)devData
{
    if (!_devData)
    {
        _devData = [NSMutableArray array];
    }
    return _devData;
}

#pragma mark - Action

//1.开始扫描外围设备
- (void)startScan
{
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager = centralManager;
}

//4.停止扫描外围设备---停止扫描外围设备
- (void)stopScan
{
    [self.centralManager stopScan];
}

//2.连接外围设备-----根据骚到的外围设备进行对外围设备进行连接
- (void)selectConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.centralManager connectPeripheral:peripheral options:nil];
    
}

#pragma mark - CBCentralManagerDelegate
//中心设备的状态进行开始扫描
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBManagerStatePoweredOn:
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
            
        default:
            break;
    }
}

//扫描外围设备成功
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    NSLog(@"扫描外围设备成功---%@--%@",peripheral.name,peripheral.identifier);
    if (peripheral.name.length != 0)
    {
        if (![self.devData containsObject:peripheral])
        {
            [self.devData addObject:peripheral];
        }
    }
    
    
    if (self.devData.count > 0)
    {
        [self selectConnectPeripheral:self.devData[0]];
        [self stopScan];
        NSLog(@"devDatadjfidfjdi-------%@",self.devData);
    }
}

//连接外围设备成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接外围设备成功");
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    //3.扫描外围设备的服务---开始发现外围设备的服务
    [self.peripheral discoverServices:nil];
}


#pragma mark CBPeripheralDelegate

//发现外围设备的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"发现外围设备的服务");
    if (error)
    {
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        NSLog(@"servicedfj---%@",service.UUID.UUIDString);
        //5.扫描服务的特征
        [self.peripheral discoverCharacteristics:@[service.UUID] forService:service];
    }
}


//6.扫描外围设备的服务的特征根据特征进行对外围进行操作-----发现外围设备的服务的特性
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        return;
    }
    NSLog(@"发现外围设备的服务的特性");
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        self.characteristic = characteristic;
        NSLog(@"characteristicfdfjdifj---------%@",characteristic.value);
    }
}


//外围设备更新服务中的特性
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        return;
    }
}


#pragma mark XIB--TakeAction

- (IBAction)startScan:(id)sender
{
    [self startScan];
}

- (IBAction)sendMessage:(id)sender
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:@"要传给外围设备的数据" options:NSUTF8StringEncoding];
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
}

- (IBAction)cancelScan:(id)sender
{
    [self stopScan];
}


@end
