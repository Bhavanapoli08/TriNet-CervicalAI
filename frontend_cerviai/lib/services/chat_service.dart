// lib/services/chat_service.dart
//
// Chatbot backend powered by Google Gemini (free tier).
// Specialized for cervical cancer Q&A with strict safety guardrails.
//
// Free tier: 15 requests/min, 1500 requests/day, no credit card required.
// Get a free API key at: https://aistudio.google.com/apikey

import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String role;          // 'user' or 'model'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Gemini uses {role, parts: [{text}]} format
  Map<String, dynamic> toApiFormat() => {
    'role': role,
    'parts': [
      {'text': content}
    ],
  };

  bool get isUser => role == 'user';
}

class ChatService {
  // Gemini 1.5 Flash — fast, free, good quality for Q&A
  static const String _model = 'gemini-2.5-flash-lite';
  static String _apiUrl(String key) =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$key';

  // System prompt — Gemini calls it "systemInstruction"
  static const String _systemPrompt = '''
You are CerviAI Assistant, an AI educational helper specializing in cervical
cancer awareness, Pap smear screening, HPV, and women's reproductive health.

YOUR ROLE:
- Answer general educational questions about cervical cancer, screening, HPV,
  symptoms, prevention, and risk factors.
- Explain medical terminology in simple, accessible language.
- Encourage users to seek qualified medical care for any personal concerns.

STRICT BOUNDARIES:
- You are NOT a doctor and you do NOT provide medical diagnosis, prognosis,
  or treatment recommendations for individual cases.
- If a user describes their own symptoms or asks "do I have cancer?" — gently
  redirect them to consult a gynecologist or healthcare provider in person.
- For any urgent symptom (heavy bleeding, severe pain, fainting), advise them
  to seek immediate medical attention.
- Do not invent statistics. If you don't know a specific number, say so.
- If asked about non-cervical-cancer topics (weather, politics, coding, etc.),
  politely redirect: "I'm specialized in cervical cancer education — I can't
  help with that, but I'd be happy to answer questions about Pap smears,
  HPV vaccines, or screening."

TONE:
- Warm, calm, factual. Use plain English, not jargon.
- Keep responses concise (2–4 paragraphs max unless asked for detail).
- Never alarm or moralize. Be respectful of user privacy and emotion.

Always end responses about personal health concerns with a brief reminder
to consult a healthcare professional for individual guidance.
''';

  final String _apiKey;
  final List<ChatMessage> _history = [];

  ChatService({required String apiKey}) : _apiKey = apiKey;

  List<ChatMessage> get history => List.unmodifiable(_history);

  void clearHistory() => _history.clear();

  Future<String> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }

    _history.add(ChatMessage(role: 'user', content: userMessage));

    // Keep last 20 turns for context
    final recentHistory = _history.length > 20
        ? _history.sublist(_history.length - 20)
        : _history;

    // Build Gemini request body
    final body = {
      'contents': recentHistory.map((m) => m.toApiFormat()).toList(),
      'systemInstruction': {
        'parts': [
          {'text': _systemPrompt}
        ]
      },
      'generationConfig': {
        'temperature':     0.4,
        'maxOutputTokens': 500,
      },
      // Disable Gemini's overly aggressive safety filters that sometimes
      // block legitimate medical questions
      'safetySettings': [
        {'category': 'HARM_CATEGORY_DANGEROUS_CONTENT', 'threshold': 'BLOCK_ONLY_HIGH'},
        {'category': 'HARM_CATEGORY_HARASSMENT',        'threshold': 'BLOCK_ONLY_HIGH'},
        {'category': 'HARM_CATEGORY_HATE_SPEECH',       'threshold': 'BLOCK_ONLY_HIGH'},
        {'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT', 'threshold': 'BLOCK_ONLY_HIGH'},
      ],
    };

    try {
      final response = await http
          .post(
        Uri.parse(_apiUrl(_apiKey)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        _history.removeLast();
        final data = jsonDecode(response.body);
        final msg = data['error']?['message'] ?? 'Unknown error';
        throw Exception('API error (${response.statusCode}): $msg');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // Defensive parsing — Gemini sometimes returns no candidates if blocked
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        _history.removeLast();
        final block = data['promptFeedback']?['blockReason'];
        throw Exception(block != null
            ? 'Response blocked: $block. Try rephrasing.'
            : 'No response generated. Try rephrasing.');
      }

      final candidate = candidates[0];
      final parts = candidate['content']?['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        _history.removeLast();
        throw Exception('Empty response. Try rephrasing.');
      }

      final reply = (parts[0]['text'] as String).trim();
      _history.add(ChatMessage(role: 'model', content: reply));
      return reply;
    } catch (e) {
      if (_history.isNotEmpty && _history.last.isUser) {
        _history.removeLast();
      }
      rethrow;
    }
  }

  static const List<String> suggestedQuestions = [
    'What is cervical cancer?',
    'How often should I get a Pap smear?',
    'What are the symptoms of cervical cancer?',
    'How does the HPV vaccine work?',
    'What does an abnormal Pap smear mean?',
    'Can cervical cancer be prevented?',
  ];
}