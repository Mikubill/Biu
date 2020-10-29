
<p align="center">
  <img width="750" src="Screenshots/ScreenShot.png">
</p>

<h1 align="center">Biu</h1>

<p align="center">Just a Music App written with SwiftUI</p>

## Demo

~~[TestFlight](https://testflight.apple.com/join/6rzLbQiU)~~

~~Testflight中的APP包含完整功能（包括注册、登陆、播放、收藏等）。如对构建本(laji)App有兴趣，也可以通过Testflight中的开发者邮箱联系我获得 `Biu.plist`。~~

API故障，App暂时无法使用QwQ

## Build 

编译需要使用较高版本的XCode（以支持SwiftUI）。另由于使用了较多SwiftUI特性，估计App仅能支持iOS 13及以上的设备。

### API

Biu使用了Biu.Moe的API来实现各种音乐功能。由于Biu.Moe的限制，本Repo中并未包含API凭据文件`Biu.plist`，因此编译下来以后有可能无法正常使用。可以直接联系@Mikubill或者通过Testflight中的开发者邮箱获得这个文件。（主要是为了防止滥用）

### Dependencies

Biu使用`carthage`来管理依赖，安装`carthage`后只需要简单运行以下命令即可更新所有依赖包。

```
carthage update --cache-builds --platform iOS 
```

## Contribution

Feel free to contribute.

因为作者太菜，很多bug的QwQ。欢迎各位大佬pr

