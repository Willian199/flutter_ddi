import 'dart:async';

/// Lightweight one-way communication channel based on actions and effects.
///
/// This pattern allows creating a **unique link** between who triggers an action
/// (`TAction`) and who produces an effect (`TEffect`). It is useful
/// for **decoupled rule execution** or **internal reactive flows**,
/// without the need for direct dependency between modules.
///
/// ### Generics
/// - `TAction`: type of the action or command that triggers the execution.
/// - `TEffect`: type of the effect, result or notification produced by the handler.
///   Can be `null` if no return is necessary.
///
/// ### Concept
/// - **Executor (handler)**: registers the function that processes the action via [`on`].
/// - **Emitter**: triggers the execution via [`execute`] and receives the result
///   of the effect returned by the handler.
///
/// ### Features
/// - Supports synchronous or asynchronous execution (`FutureOr<TEffect?>`).
/// - Allows redefining or clearing the handler with [`clear`].
/// - Generic types allow reuse for any action and effect.
///
/// ### Usage example
///
/// ```dart
/// // Definition of a command with return effect
/// final Command<String, int> lengthCommand = Command();
///
/// // Executor registers the command behavior
/// lengthCommand.on((input) {
///   if (input == null) return 0;
///   return input.length;
/// });
///
/// // Emitter triggers execution and receives effect
/// final result = lengthCommand.execute('Hello');
/// print(result); // 5
///
/// // Clears the handler, if necessary
/// lengthCommand.clear();
/// ```
///
///
/// ### Notes
/// - If the handler is not registered before execution, [`execute`] throws
///   an `AssertionError`.
/// - `TAction` is optional (`null`) in the current implementation, but can be
///   adjusted to force concrete values if necessary.
class _CommandLink<TAction, TEffect> {
  FutureOr<TEffect?> Function(TAction? command)? _handler;

  /// Registers the handler responsible for processing the action.
  ///
  /// Only one handler can be registered per link; subsequent calls
  /// throw `AssertionError` unless the handler is cleared via [`clear`].
  void on(FutureOr<TEffect?> Function(TAction? command) handler) {
    assert(_handler == null, 'Handler already registered.');
    _handler = handler;
  }

  /// Executes the registered action and returns the effect produced by the handler.
  ///
  /// Can be synchronous or asynchronous, depending on the handler implementation.
  /// Throws `AssertionError` if no handler has been registered.
  FutureOr<TEffect?> execute([TAction? command]) {
    assert(_handler != null, 'No handler registered.');
    return _handler!.call(command);
  }

  /// Removes the registered handler, allowing new configuration.
  void clear() => _handler = null;
}

/// Semantic alias to represent an **execution command**.
/// Ideal for the side that triggers actions.
typedef Command<TAction, TEffect> = _CommandLink<TAction, TEffect>;

/// Semantic alias to represent an **execution effect**.
/// Ideal for the side that observes effects or returns.
typedef Effect<TAction, TEffect> = _CommandLink<TAction, TEffect>;
