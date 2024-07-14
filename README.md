# Flutter functional widget

🚧 EXPERIMENTAL! 🚧

An experiment to see what a functional widget might look like in flutter. Taking inspiration from react to try to reduce boilerplate.

## New API

For example, you might define a function like this

```dart
// 8 lines of code
@Functional()
Widget _fab(BuildContext context, {VoidCallback? onPressed}) {
  return FloatingActionButton(
    onPressed: onPressed,
    tooltip: 'Increment',
    child: const Icon(Icons.add),
  );
}
```

And be able to use the macro version of the widget like you would any other widget.

```dart
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: Fab(
      onPressed: () {
        print("hello world!");
      }
    ),
  );
}
```

## Standard API

The equivalent in the current way to do this is the following, requiring more lines of code.

```dart
// 12 lines of code
class Fab extends StatelessWidget {
  const Fab({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
```

## Limitations

1. Macros don't support default parameters or generics yet.
1. As far as I know, you can't generate a new type from a macro. Until that's resolved, this approach generates a function that uses a Builder widget.
