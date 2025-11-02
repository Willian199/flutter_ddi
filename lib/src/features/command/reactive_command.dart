import 'dart:async';

import 'package:flutter/foundation.dart';

/// Reactive communication channel based on actions and effects,
/// using [ValueNotifier] to automatically notify listeners when effects change.
///
/// This is a reactive variation of [`Command`] that combines the command/effect
/// pattern with Flutter's reactive system. When an action is executed, the resulting
/// effect is stored in a [ValueNotifier], automatically notifying all registered
/// listeners.
///
/// ### Generics
/// - `TAction`: type of the action or command that triggers the execution.
/// - `TEffect`: type of the effect, result or notification produced by the handler.
///
/// ### Concept
/// - **Executor (handler)**: registers the function that processes the action via [`on`].
/// - **Emitter**: triggers the execution via [`execute`] and notifies listeners automatically.
/// - **Observers**: can listen to effect changes via [`addListener`] or use Flutter widgets
///   that listen to [ValueNotifier].
///
/// ### Features
/// - Supports synchronous or asynchronous execution (`FutureOr<TEffect?>`).
/// - Automatically notifies listeners when effects change.
/// - Extends [ValueNotifier], making it compatible with Flutter's reactive system.
/// - Can be used with widgets like [`ValueListenableBuilder`] or the `.listen()` extension.
/// - Allows redefining or clearing the handler with [`clear`].
///
/// ### Usage example
///
/// ```dart
/// // Definition of a reactive command
/// final ReactiveCommand<String, int> lengthCommand = ReactiveCommand();
///
/// // Executor registers the command behavior
/// lengthCommand.on((input) {
///   if (input == null) return 0;
///   return input.length;
/// });
///
/// // Listen to changes in the effect
/// lengthCommand.addListener(() {
///   print('New effect: ${lengthCommand.value}');
/// });
///
/// // Emitter triggers execution (automatically notifies listeners)
/// await lengthCommand.execute('Hello');
/// // Prints: "New effect: 5"
///
/// // Access current effect value
/// print(lengthCommand.value); // 5
/// ```
///
/// ### Usage with Flutter widgets
///
/// ```dart
/// // In a widget
/// ValueListenableBuilder<int?>(
///   valueListenable: lengthCommand,
///   builder: (context, value, child) {
///     return Text('Length: ${value ?? 0}');
///   },
/// )
///
/// // Or using the extension
/// Text('Length: ${lengthCommand.value ?? 0}').listen(lengthCommand);
/// ```
///
/// ### Notes
/// - If the handler is not registered before execution, [`execute`] throws
///   an `AssertionError`.
/// - The initial value is `null` until the first execution.
/// - When asynchronous handlers are used, listeners are notified after the
///   `Future` completes.
/// - Disposing this command will also dispose the internal `ValueNotifier`.
class _ReactiveCommandLink<TAction, TEffect> extends ValueNotifier<TEffect?> {
  _ReactiveCommandLink() : super(null);

  FutureOr<TEffect?> Function(TAction? command)? _handler;

  /// Registers the handler responsible for processing the action.
  ///
  /// Only one handler can be registered per link; subsequent calls
  /// throw `AssertionError` unless the handler is cleared via [`clear`].
  void on(FutureOr<TEffect?> Function(TAction? command) handler) {
    assert(_handler == null, 'Handler already registered.');
    _handler = handler;
  }

  /// Executes the registered action, updates the effect value, and notifies listeners.
  ///
  /// Can be synchronous or asynchronous, depending on the handler implementation.
  /// If the handler returns a `Future`, listeners are notified after it completes.
  /// Throws `AssertionError` if no handler has been registered.
  ///
  /// Returns the effect produced by the handler (same as [`value`] after execution).
  FutureOr<TEffect?> execute([TAction? command]) async {
    assert(_handler != null, 'No handler registered.');
    final effect = await _handler!.call(command);
    value = effect;
    return effect;
  }

  /// Removes the registered handler and resets the value, allowing new configuration.
  ///
  /// This also notifies listeners that the value has been cleared.
  void clear() {
    _handler = null;
    value = null;
  }
}

/// Semantic alias to represent a **reactive execution command**.
/// Ideal for scenarios where you need to observe effect changes reactively.
typedef ReactiveCommand<TAction, TEffect>
    = _ReactiveCommandLink<TAction, TEffect>;

/// Semantic alias to represent a **reactive execution effect**.
/// Ideal for reactive scenarios where effects should notify listeners automatically.
typedef ReactiveEffect<TAction, TEffect>
    = _ReactiveCommandLink<TAction, TEffect>;
