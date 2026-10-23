# wx_box

> [!IMPORTANT]
> **Repository Moved to Monorepo**: Active development of $(System.Collections.Hashtable.Name) has migrated to the official [**davigmacode/flutter_wx**](https://github.com/davigmacode/flutter_wx) monorepo under [packages/wx_box](https://github.com/davigmacode/flutter_wx/tree/main/packages/wx_box).
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
  border: CircleBorder(),
)

WxBox.circle(
  color: Colors.amber,
  radius: 25,
  borderWidth: 5,
  borderStyle: BorderStyle.solid,
  borderColor: Theme.of(context).colorScheme.surface,
  borderOffset: BorderSide.strokeAlignOutside,
  alignment: Alignment.center,
  child: Text(
    '1',
    style: Theme.of(context).textTheme.titleLarge,
  ),
)

WxBox.stadium(
  color: Colors.amber,
  width: 150,
  height: 50,
  borderSide: BorderSide(
    width: 5,
    style: BorderStyle.solid,
    color: Colors.black,
    strokeAlign: BorderSide.strokeAlignOutside,
  ),
  alignment: Alignment.center,
  child: Text(
    'text',
    style: Theme.of(context).textTheme.titleLarge,
  ),
)
```

### Animated Box

Use `WxAnimatedBox` for smooth implicit animations across size, padding, margin, color, elevation, and border shapes:

```dart
WxAnimatedBox(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: isExpanded ? 200 : 100,
  height: 60,
  color: isExpanded ? Colors.indigo : Colors.blue,
  borderRadius: BorderRadius.circular(isExpanded ? 24 : 8),
  elevation: isExpanded ? 6 : 1,
  child: const Center(
    child: Text('Animated Box'),
  ),
)
```

### Advanced Borders

Draw customizable borders with solid, dashed, dotted, or morse patterns:

```dart
WxBorder(
  shape: WxRectangleBorder(
    corners: BorderRadius.circular(12),
    width: 2,
    color: Colors.blueAccent,
    style: WxBorderStyle.dashed,
  ),
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: Text('Dashed Border Box'),
  ),
)
```

## Sponsoring

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="45"></a>
<a href="https://ko-fi.com/davigmacode" target="_blank"><img src="https://storage.ko-fi.com/cdn/brandasset/kofi_s_tag_white.png" alt="Ko-Fi" height="45"></a>

If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.