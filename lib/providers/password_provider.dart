import 'package:flutter/material.dart';
import '../core/dart_basics.dart';
import '../core/password_generator.dart';

/// Experiment 5b: Global State Management using Provider and ChangeNotifier
class PasswordProvider extends ChangeNotifier {
  GeneratorOptions _options = const GeneratorOptions(
    length: 16,
    includeUppercase: true,
    includeLowercase: true,
    includeNumbers: true,
    includeSymbols: true,
    excludeAmbiguous: false,
  );

  PasswordPreset _activePreset = PasswordPreset.standard;
  late GenerationResult _currentResult;
  final List<GenerationResult> _history = [];

  PasswordProvider() {
    _generateInternal();
  }

  // Getters
  GeneratorOptions get options => _options;
  int get length => _options.length;
  bool get includeUppercase => _options.includeUppercase;
  bool get includeLowercase => _options.includeLowercase;
  bool get includeNumbers => _options.includeNumbers;
  bool get includeSymbols => _options.includeSymbols;
  bool get excludeAmbiguous => _options.excludeAmbiguous;
  String? get customExcludeChars => _options.customExcludeChars;

  PasswordPreset get activePreset => _activePreset;
  GenerationResult get currentResult => _currentResult;
  String get currentPassword => _currentResult.password;
  double get currentEntropy => _currentResult.entropy;
  PasswordStrength get currentStrength => _currentResult.strength;
  List<GenerationResult> get history => List.unmodifiable(_history);

  void _generateInternal() {
    try {
      _currentResult = PasswordGenerator.generate(_options);
      _history.insert(0, _currentResult);
      if (_history.length > 20) {
        _history.removeLast();
      }
    } catch (e) {
      // Fallback
      _currentResult = GenerationResult(
        password: '',
        entropy: 0,
        strength: PasswordStrength.veryWeak,
        poolSize: 0,
        generatedAt: DateTime.now(),
      );
    }
  }

  /// Regenerates password with current options
  void regenerate() {
    _generateInternal();
    notifyListeners();
  }

  /// Updates password length
  void setLength(int newLength) {
    if (newLength != _options.length) {
      _options = _options.copyWith(length: newLength);
      _generateInternal();
      notifyListeners();
    }
  }

  void toggleUppercase(bool val) {
    if (_validateOptions(_options.copyWith(includeUppercase: val))) {
      _options = _options.copyWith(includeUppercase: val);
      _generateInternal();
      notifyListeners();
    }
  }

  void toggleLowercase(bool val) {
    if (_validateOptions(_options.copyWith(includeLowercase: val))) {
      _options = _options.copyWith(includeLowercase: val);
      _generateInternal();
      notifyListeners();
    }
  }

  void toggleNumbers(bool val) {
    if (_validateOptions(_options.copyWith(includeNumbers: val))) {
      _options = _options.copyWith(includeNumbers: val);
      _generateInternal();
      notifyListeners();
    }
  }

  void toggleSymbols(bool val) {
    if (_validateOptions(_options.copyWith(includeSymbols: val))) {
      _options = _options.copyWith(includeSymbols: val);
      _generateInternal();
      notifyListeners();
    }
  }

  void toggleAmbiguous(bool val) {
    _options = _options.copyWith(excludeAmbiguous: val);
    _generateInternal();
    notifyListeners();
  }

  void setCustomExcludeChars(String? chars) {
    _options = _options.copyWith(customExcludeChars: chars);
    _generateInternal();
    notifyListeners();
  }

  /// Applies a preset configuration
  void applyPreset(PasswordPreset preset) {
    _activePreset = preset;
    _options = GeneratorOptions(
      length: preset.defaultLength,
      includeUppercase: preset.upper,
      includeLowercase: preset.lower,
      includeNumbers: preset.numbers,
      includeSymbols: preset.symbols,
      excludeAmbiguous: _options.excludeAmbiguous,
    );
    _generateInternal();
    notifyListeners();
  }

  bool _validateOptions(GeneratorOptions opts) {
    return opts.includeUppercase ||
        opts.includeLowercase ||
        opts.includeNumbers ||
        opts.includeSymbols;
  }
}
