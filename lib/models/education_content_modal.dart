import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitamind_mobile/models/education_content_model.dart';

class EducationContentModal extends StatelessWidget {
  final EducationContent content;

  const EducationContentModal({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            content.imageWidget ??
                Image.asset(
                  content.imagePath,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.psychology,
                    size: 80,
                    color: Color(0xFF4A90E2),
                  ),
                ),
            const SizedBox(height: 16),
            Text(
              content.content,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
