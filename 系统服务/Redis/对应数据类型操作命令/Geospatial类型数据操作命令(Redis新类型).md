## 地理位置的添加

    geoadd <key> <经度> <纬度> <地理名称>
                 [<经度> <纬度> <地理名称>]
                 [<经度> <纬度> <地理名称>]
                 ...
    
`例`

    geoadd china:city 121.47 31.23 shanghai
    
* 在经纬度超出正常范围时，返回一个错误。

## 获取指定地点的经纬度坐标值

    geopos <key> <地理名称> 
                 [<地理名称>]
                 [<地理名称>]
                 ...
                 
## 获取两个地点之间的直线距离
    
    geodist <key> <地理名称> <地理名称> [m/km/ft/mi]
                 
* ft英尺，mi英里，默认单位为m

## 根据范围查找地理位置
以某经纬度为中心找出以某一半径为圆内的地理位置

    georadius <key> <中心经度> <中心纬度> <半径长度> [m/km/ft/mi]
    
* ft英尺，mi英里，默认单位为m，此处为范半径单位。