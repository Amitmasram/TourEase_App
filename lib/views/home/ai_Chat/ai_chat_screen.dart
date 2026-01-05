import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ai_textfield.dart';

class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;

  Message({
    required this.content,
    required this.isUser,
    this.imageUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final String _pixabayApiKey =
      'YOUR_PIXABAY_API_KEY'; // Replace with your Pixabay API key

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    const apiKey = 'AIzaSyCDv8WgaWR5IL99I6T-O7n3JXmFNg6GeEY';
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );

    _chat = _model.startChat(history: [
      Content.text(
          'You are a knowledgeable travel assistant. Help users discover places and provide detailed information. '
          'When users ask about specific places or want to see images, provide descriptions and also mention '
          '[I can show you images of this place]. Keep responses informative but concise. '
          'Please provide responses in plain text without markdown formatting like asterisks or other special characters.'),
    ]);
  }

  Future<String?> _fetchImageUrl(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://pixabay.com/api/?key=$_pixabayApiKey&q=${Uri.encodeComponent(query)}&image_type=photo&per_page=1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['hits'] != null && data['hits'].isNotEmpty) {
          return data['hits'][0]['webformatURL'];
        }
      }
    } catch (e) {
      debugPrint('Error fetching image: $e');
    }
    return null;
  }

  // Function to parse markdown-like text and return formatted TextSpan
  List<TextSpan> _parseFormattedText(String text, bool isDarkMode) {
    final List<TextSpan> spans = [];
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final RegExp italicRegex = RegExp(r'\*(.*?)\*');

    String remainingText = text;
    int lastIndex = 0;

    // Find all bold patterns
    final boldMatches = boldRegex.allMatches(text).toList();
    final italicMatches = italicRegex.allMatches(text).toList();

    // Combine and sort all matches by position
    final allMatches = <Match>[];
    allMatches.addAll(boldMatches);
    allMatches.addAll(italicMatches.where((match) =>
        !boldMatches.any((boldMatch) =>
            boldMatch.start <= match.start && boldMatch.end >= match.end)));

    allMatches.sort((a, b) => a.start.compareTo(b.start));

    for (final match in allMatches) {
      // Add text before the match
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ));
      }

      // Add formatted text
      final matchedText = match.group(1) ?? '';
      if (boldRegex.hasMatch(match.group(0)!)) {
        spans.add(TextSpan(
          text: matchedText,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (italicRegex.hasMatch(match.group(0)!)) {
        spans.add(TextSpan(
          text: matchedText,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ));
      }

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ));
    }

    // If no formatting found, return the original text
    if (spans.isEmpty) {
      spans.add(TextSpan(
        text: text,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ));
    }

    return spans;
  }

  // Clean text from markdown formatting
  String _cleanMarkdownText(String text) {
    return text
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1') // Remove bold markers
        .replaceAll(RegExp(r'(?<!\*)\*(?!\*)(.*?)(?<!\*)\*(?!\*)'), r'$1') // Remove italic markers
        .replaceAll(RegExp(r'#{1,6}\s'), '') // Remove headers
        .replaceAll(RegExp(r'`(.*?)`'), r'$1') // Remove code markers
        .replaceAll(RegExp(r'\[(.*?)\]\(.*?\)'), r'$1') // Remove links, keep text
        .trim();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(content: message, isUser: true));
      _isLoading = true;
      _controller.clear();
    });

    try {
      final response = await _chat.sendMessage(Content.text(message));
      final responseText =
          response.text ?? 'I apologize, but I couldn\'t generate a response.';

      String? imageUrl;
      if (message.toLowerCase().contains('show') &&
              message.toLowerCase().contains('image') ||
          responseText.contains('[I can show you images of this place]')) {
        // Extract place name from the message or response
        String searchQuery = message
            .toLowerCase()
            .replaceAll('show', '')
            .replaceAll('image', '')
            .replaceAll('of', '')
            .trim();
        imageUrl = await _fetchImageUrl(searchQuery);
      }

      // Clean the response text from markdown formatting
      final cleanedResponse = responseText.replaceAll(
          '[I can show you images of this place]', '');

      setState(() {
        _messages.add(Message(
          content: cleanedResponse,
          isUser: false,
          imageUrl: imageUrl,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(
          content: 'I apologize, but I encountered an error. Please try again.',
          isUser: false,
        ));
        _isLoading = false;
      });
      debugPrint('Error in chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? Colors.grey[900] : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(dark),
            Expanded(child: _buildChatArea(dark)),
            if (_isLoading) const LinearProgressIndicator(),
            _buildInputArea(dark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(width: 12),
          Text(
            'Travel Assistant',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        reverse: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[_messages.length - 1 - index];
          return _buildMessageItem(message, isDarkMode);
        },
      ),
    );
  }

  Widget _buildMessageItem(Message message, bool isDarkMode) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _buildChatBubble(message.content,
                isUser: message.isUser, isDarkMode: isDarkMode),
            if (message.imageUrl != null) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    message.imageUrl!,
                    width: 250,
                    height: 180,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 250,
                        height: 180,
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 250,
                        height: 180,
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String message,
      {required bool isUser, required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
                colors: [
                  Color(0xff6366f1),
                  Color(0xff8b5cf6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !isUser
            ? (isDarkMode ? Colors.grey[800] : Colors.white)
            : null,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          children: isUser
              ? [TextSpan(
                  text: message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )]
              : _parseFormattedText(message, isDarkMode),
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AiTextField(
              controller: _controller,
              obscureText: false,
              hintText: 'Ask about any destination...',
              isDarkMode: isDarkMode,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff6366f1), Color(0xff8b5cf6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
