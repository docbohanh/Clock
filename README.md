# Clock
## Hướng giải quyết:
```
Tạo một hàm cập nhật vị trí của 3 kim đồng hồ sau mỗi giây, bằng cách tính toán góc xoay của từng kim.
```

File ClockView.xib:
```
![Clock 1](https://viblo.asia/uploads/600a7ec8-dda1-428c-a7f2-c195d38de721.png "File Clock.xib")
```

Trong file .xib này nhớ chú ý một điểm là chúng ta sẽ có ba cái hình, tương ứng với ba cây kim hiển thị giờ, phút và giây, nhớ là canh chúng nó ở giữa cái khung của đồng hồ, chứ đừng canh cái gốc của nó ở giữa khung theo thực tế, mục đích để xoay kim đồng hồ (xoay view) không bị lệch.

*Phân tích:*
Nếu chia cái khung đồng hồ thành một vòng tròn, thì mỗi 1s, cây kim giây sẽ xoay 1 góc là 6 độ = 1/60 của 360 độ. Khi kim giây xoay xong 1 vòng tròn thì kim phút sẽ xoay cũng 1 góc 6 độ. Khi kim phút xoay xong 1 vòng tròn thì kim giờ sẽ xoay 1 góc 30 độ.
Theo đơn vị radian thì một vòng tròn thì là 2π, vậy tại một thời điểm thì:

```
giây = giây * 2 * π / 60 
phút = phút * 2 * π / 60
giờ = giờ * 2 * π / 12
```

Áp dụng điều đó vào trong code thì chúng ta sẽ làm từng bước như sau:
Đầu tiên là get các date components tại thời điểm hiện tại Date().

```
let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
let units = [Calendar.Component.hour, 
             Calendar.Component.minute, 
             Calendar.Component.second,
             Calendar.Component.nanosecond]
let components = calendar.dateComponents(Set<Calendar.Component>(units), from: Date())
```

Ở đây chúng ta để ý đến 1 component là nanosecond. Nó chính là cái khoảng dư thật sự của giây hiện tại, ví dụ: second chúng ta get được là giây thứ 10, nhưng thực tế là đang ở khoảng giữa 10s và 11s thì sẽ có thêm 1 khoảng dư nanosecond nữa,nghe tên là chúng ta biết nó tỉ lệ đến 1/1.000.000.000 giây. Nên khi mà tính giây thì ta cộng thêm nano giây này vào thì sẽ chính xác nhất.

Rồi xoay:
```
secondImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(secondAngle))
minuteImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(minuteAngle))
hourImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(hourAngle))
```


![Clock 2](https://viblo.asia/uploads/b303d857-7518-4396-ac61-e160a1e32bb6.png "Khi chưa chỉnh anchorPoint")

anchorPoint là một điểm mà nó thể hiện mối liên hệ giữa layer và superlayer. Hiểu như thế này, toạ độ (coordinate) của 1 layer thì có giá trị từ 0 -> 1. Góc dưới bên trái thì là (0, 0), góc trên bên phải thì là (1, 1). Thì giá trị mặc định của anchorPoint là (0.5, 0.5), ngay chính giữa tâm, trùng với điểm position của layer và center của view. Bây giờ ta chỉ việc dời cái điểm "anchor" này đi thì layer nó cũng dời theo mà k làm ảnh hưởng đến cái center của view, nên việc xoay vẫn bình thường không có bất thường cả.

Cuối cùng ta có một hàm tick() như sau:
```
fileprivate func tick() {
        let components = calendar.dateComponents(Set<Calendar.Component>(units), from: Date())
        guard let hour = components.hour,
            let minute = components.minute,
            let second = components.second,
            let nanoSecond = components.nanosecond else {
                return
        }
        let realSecond = Double(second) + pow(Double(nanoSecond),Double(-9))
        let realMinute = Double(minute) + realSecond / 60.0
        let realHour = Double(hour) + realMinute / 60.0
        let secondAngle = realSecond / 60.0 * .pi * 2.0
        let minuteAngle = realMinute / 60.0 * .pi * 2.0
        let hourAngle = realHour / 12.0 * .pi * 2.0
        
        hourImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(hourAngle))
        minuteImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(minuteAngle))
        secondImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(secondAngle))
    }
```

Tạo một timer và cho nó chạy từng giây một
```
timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil,
                                     repeats: true)
```

Chi tiết 
[iOS Tạo một cái đồng hồ treo tường đơn giản - Viblo](https://viblo.asia/p/ios-tao-mot-cai-dong-ho-treo-tuong-don-gian-maGK7z1D5j2)