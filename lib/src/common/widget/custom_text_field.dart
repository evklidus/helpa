import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpa/src/common/utils/context_extension.dart';

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
        onTapOutside: onTapOutside,
        enabled: enabled,
        focusNode: focusNode,
        validator: validator,
        maxLength: maxLength,
        maxLines: maxLines,
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: decoration ??
            InputDecoration(
              labelStyle: labelStyle ??
                  context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
              errorStyle: errorStyle,
              hintText: hintText,
              filled: true,
              fillColor: context.colorScheme.background,
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB95D6D)),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB95D6D)),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF272727)),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF272727)),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.colorScheme.primary.withOpacity(.4),
                  width: 1.5,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              labelText: label,
              isDense: true,
              suffixIcon: suffix,
            ),
      ),
    );
  }
}
