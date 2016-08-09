# LYUnicodeDecodeForConsole [![Build Status](https://api.travis-ci.org/onevcat/VVDocumenter-Xcode.svg)](https://travis-ci.org/onevcat/VVDocumenter-Xcode) <a href="https://flattr.com/submit/auto?user_id=onevcat&url=https%3A%2F%2Fgithub.com%2Fonevcat%2FVVDocumenter-Xcode" target="_blank"><img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0"></a>
---
## What is this?
`LYUnicodeDecodeForConsole` is a plugin for Xcode to Unicode convert Chinese in the console.

Xcode 在控制台打印数组和字典时，如果数组和字典中包含有中文的话，默认中文显示的是Unicode编码，这样有时候对于我们调试是很不方便的，而`LYUnicodeDecodeForConsole`的作用就是将Xcode控制台中打印的中文转换回中文显示。

是否需要将中文Unicode转换成中文，可以在Xcode的Edit菜单下找到LYUnicodeDecodeForConsole 控制是否需要转码。

![image](https://github.com/GeekYL/LYUnicodeDecodeForConsole/blob/master/LYUnicodeDecodeForConsoleTest.gif)

## install:
#### Manually
* Downloading the project
* Opening the project
* command + B build
* Reseting your Xcode

#### Alcatraz

Install [Alcatraz](http://alcatraz.io/), restart Xcode and press ⇧⌘9. You can find `LYUnicodeDecodeForConsole` in the list and click the icon on the left to install.

## License

LYUnicodeDecodeForConsole is published under MIT License. See the LICENSE file for more.