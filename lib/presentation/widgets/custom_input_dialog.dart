import 'package:flutter/material.dart';

class CustomInputDialog extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String hintText;
  final String? initialValue;
  final String confirmText;
  final Color confirmColor;
  final String cancelText;
  final Color cancelColor;
  final Function(String)? onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;

  const CustomInputDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.hintText = '',
    this.initialValue,
    required this.confirmText,
    required this.confirmColor,
    required this.cancelText,
    required this.cancelColor,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
  });

  @override
  State<CustomInputDialog> createState() => _CustomInputDialogState();

  /// Fungsi helper untuk memanggil dialog dengan mudah
  static void show(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    String hintText = '',
    String? initialValue,
    required String confirmText,
    required Color confirmColor,
    required String cancelText,
    required Color cancelColor,
    Function(String)? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    TextInputType? keyboardType,
    int? maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomInputDialog(
        icon: icon,
        iconColor: iconColor,
        title: title,
        message: message,
        hintText: hintText,
        initialValue: initialValue,
        confirmText: confirmText,
        confirmColor: confirmColor,
        cancelText: cancelText,
        cancelColor: cancelColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }
}

class _CustomInputDialogState extends State<CustomInputDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.8;
    final maxDialogWidth = 400.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 0,
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          minWidth: dialogWidth < maxDialogWidth ? dialogWidth : maxDialogWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: widget.iconColor, size: 50),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.message,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controller,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.confirmColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: widget.validator,
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: widget.cancelColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: widget.cancelColor,
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.onCancel != null) widget.onCancel!();
                        },
                        child: Text(widget.cancelText),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.confirmColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            if (widget.onConfirm != null) {
                              widget.onConfirm!(_controller.text);
                            }
                          }
                        },
                        child: Text(
                          widget.confirmText,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
