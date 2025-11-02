import 'package:flutter/material.dart';

/// Utility class untuk helper functions terkait UI
class UIHelpers {
  // Private constructor to prevent instantiation
  UIHelpers._();

  /// Mendapatkan warna berdasarkan role user
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'building manager':
        return Colors.purple;
      case 'iss supervisor':
        return Colors.blue;
      case 'staff':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Mendapatkan warna berdasarkan ekstensi file
  static Color getFileColor(String extension) {
    switch (extension.toUpperCase()) {
      case 'PDF':
        return Colors.red;
      case 'XLSX':
      case 'XLS':
        return Colors.green;
      case 'DOCX':
      case 'DOC':
        return Colors.blue;
      case 'JPG':
      case 'JPEG':
      case 'PNG':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Mendapatkan icon berdasarkan ekstensi file
  static IconData getFileIcon(String extension) {
    switch (extension.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'XLSX':
      case 'XLS':
        return Icons.table_chart;
      case 'DOCX':
      case 'DOC':
        return Icons.description;
      case 'JPG':
      case 'JPEG':
      case 'PNG':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
