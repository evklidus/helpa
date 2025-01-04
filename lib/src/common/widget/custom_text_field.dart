import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom-styled [TextFormField].
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.label,
    this.errorText,
    this.hintText,
    this.inputFormatters,
    this.maxLength,
    this.maxLines,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.suffix,
    this.labelStyle,
    this.errorStyle,
    this.onTapOutside,
    this.dense = true,
    this.enabled = true,
    this.decoration,
    this.style,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  ///
  final TextInputAction? textInputAction;

  ///
  final FocusNode? focusNode;

  ///
  final bool enabled;

  /// Optional text that describes this input field.
  final String? label;

  ///
  final TextStyle? labelStyle;

  /// Text that appears below the [InputDecorator.child] and the border.
  final String? errorText;

  ///
  final String? hintText;

  /// Indicator whether this text field should have a dense appearance.
  final bool dense;

  /// Maximum length of this text field.
  final int? maxLength;

  /// Maximum lines of this text field.
  final int? maxLines;

  /// Keyboard type to use for this text field.
  final TextInputType? keyboardType;

  /// [List] of [TextInputFormatter] to apply to this text field.
  final List<TextInputFormatter>? inputFormatters;

  ///
  final void Function(String)? onChanged;

  /// Callback that validates the input text.
  final String? Function(String?)? validator;

  ///
  final void Function(PointerDownEvent)? onTapOutside;

  ///
  final TextStyle? errorStyle;

  ///
  final Widget? suffix;

  ///
  final InputDecoration? decoration;

  ///
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 8 : 2),
      child: TextFormField(
        style: style,
        maxLines: maxLines,
        controller: controller,
      ),
    );
  }
}
