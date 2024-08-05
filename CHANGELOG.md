## 4.2.0

* Improved elevation rendering
* Separate box and border entry point
* Renamed util function to create shape border and provides api doc
* Moved createShapeBorder into separated entry point

## 4.1.0

* Improved clipper and elevation renderer.
* Early preview of widgetarian border shape system.

## 4.0.0

* Fixed animated box losing border radius
* Paint color using DecoratedBox, PhysicalModel or PhysicalShape only draw elevation
* Paint border using DecoratedBox
* Provides option to add image, shadows, or gradient
* Renamed shadowColor to elevationColor, and improved box renderer
* Renamed borderAlign to borderOffset

## 3.0.0

* Removed WxBoxShape and `shape` property, use `border` instead.
* Animated width, height, and constraints.

## 2.0.3

* Rectangle shape use PhysicalModel otherwise use PhysicalShape

## 2.0.2

* Bring back the WxBoxShape getter
* Adjust sdk constraints

## 2.0.1

* Removed WxBoxShape getter

## 2.0.0

* Use a custom WxBoxShape instead of BoxShape to simplify the creation of boxes with stadium shape.
* Added variant constructor

## 1.0.0

* Added box widget
* Added animated box widget
* Added border painter widget
