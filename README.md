# menu_float

This library makes a floating menu appear in the window when clicking on another widget, like a button or link, for example.

## Getting Started
The use is very simple. The menu float receives a generic object to determine what object it has to send after the options click.

```
class Product {
	final String name;
  final double value;
	...
}

final options = [
	MenuFloatOption<T>(
		label: e.name,
		value: e,
		onClick: (Product v) {
			final n = v.name;
			print('Product is: $n');
		})
	),
	...
]

MenuFloat<Product>(
	title: 'Hello menu float',
	items: options,
	child: ElevatedButton(
    onPressed: () => {}, 
		child: const Text('Click me')
	),
))
```

For more details see the project demo in the [example
](https://github.com/emirdeliz/menu_float/tree/master/example/menu_float_demo) folder.

**readBarcodeFromStack**: This method receives a ReadBarcodeProps and inserts the request on the stack of requests. This can be utils when you make multiple barcodes reads at the same.

**readBarcode**: This method receives a ReadBarcodeProps and makes a simple read.

About **ReadBarcodeProps**:

**file** (optional): The file related to pdf file.

**filePath** (optional): The url related to pdf file.

**scale** (optional): The scale or zoom applied on the pdf document before search barcode.

**sequenceNum** (optional): The sequence number of the image when working with multiple barcodes.
