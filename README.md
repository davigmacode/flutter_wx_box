[![Pub Version](https://img.shields.io/pub/v/wx_box)](https://pub.dev/packages/wx_box) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_wx_box) [![GitHub](https://badgen.net/badge/icon/buymeacoffee?icon=buymeacoffee&color=yellow&label)](https://www.buymeacoffee.com/davigmacode) [![GitHub](https://badgen.net/badge/icon/ko-fi?icon=kofi&color=red&label)](https://ko-fi.com/davigmacode)

Const widget that provides a box-like layout with customizable elevation.

## Usage

To read more about classes and other references used by `wx_box`, see the [API Reference](https://pub.dev/documentation/wx_box/latest/).

```dart
WxBox(
  width: 50,
  height: 50,
)

WxBox(
  color: Theme.of(context).colorScheme.surface,
  width: 50,
  height: 50,
  elevation: 2,
  shape: BoxShape.circle,
)

WxBox(
  color: Colors.amber,
  width: 50,
  height: 50,
  borderWidth: 5,
  borderStyle: BorderStyle.solid,
  borderColor: Theme.of(context).colorScheme.surface,
  borderAlign: BorderSide.strokeAlignOutside,
  shape: BoxShape.circle,
  alignment: Alignment.center,
  child: Text(
    '1',
    style: Theme.of(context).textTheme.titleLarge,
  ),
)

WxBox(
  color: Colors.amber,
  width: 150,
  height: 50,
  border: const StadiumBorder(
    side: BorderSide(
      width: 5,
      style: BorderStyle.solid,
      color: Colors.black,
      strokeAlign: BorderSide.strokeAlignOutside,
    ),
  ),
  alignment: Alignment.center,
  child: Text(
    'text',
    style: Theme.of(context).textTheme.titleLarge,
  ),
)
```

## Sponsoring

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="45"></a>
<a href="https://ko-fi.com/davigmacode" target="_blank"><img src="https://storage.ko-fi.com/cdn/brandasset/kofi_s_tag_white.png" alt="Ko-Fi" height="45"></a>

If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.