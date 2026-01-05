import 'package:TourEase/core/utils/responsive.dart';
import 'package:TourEase/core/widgets/custom_button.dart';
import 'package:TourEase/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _sendFeedback() async {
    final name = _nameController.text.trim();
    final feedback = _feedbackController.text.trim();

    if (name.isEmpty || feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'hello@tourease.us',
      queryParameters: {
        'subject': 'Feedback from $name',
        'body': 'Name: $name\n\nFeedback:\n$feedback',
      },
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email client')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:40.0,left: 20.0,right: 20.0),
        child: Column(
          children: [
            CustomTextField(
                maxLines: 6,
                hintText: 'Type here...',
                controller: _nameController,
                label: 'Your Feedback or Suggestion'),
            const SizedBox(height: 20),
            GradientButton(
              width: Responsive.screenWidth(context) * 0.5,
              onPressed: _sendFeedback,
              text: 'Send Feedback',
            ),
          ],
        ),
      ),
    );
  }
}
