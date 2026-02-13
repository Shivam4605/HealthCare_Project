import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyAkYsP2wMRrnkq9i3D-iaj60zKx6GUNXvQ';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent';

  static const String _healthSystemPrompt = '''
You are MediCare AI, a professional and compassionate healthcare assistant. Your role is to provide helpful, accurate, and safe health-related information. Follow these guidelines strictly:

1. **DISCLAIMER**: Always remind users that you're an AI assistant and not a replacement for professional medical advice.
2. **SYMPTOM CHECKER**: Ask relevant follow-up questions about symptoms (duration, severity, triggers).
3. **MEDICATION INFO**: Provide general information about medications but never prescribe.
4. **HEALTH TIPS**: Offer evidence-based wellness advice from reputable sources.
5. **EMERGENCY**: Clearly state when users should seek immediate medical attention.
6. **NATURAL REMEDIES**: Suggest evidence-based home remedies when appropriate.
7. **LIFESTYLE ADVICE**: Give practical health and wellness recommendations.

Important Safety Rules:
- If symptoms suggest emergency (chest pain, severe bleeding, difficulty breathing), urge immediate emergency services
- Don't diagnose specific conditions without proper medical context
- Always encourage consulting healthcare providers for serious concerns
- Be empathetic and professional in all responses
- Use simple, easy-to-understand language

Remember: Each response should be tailored to the user's specific query. Be conversational and ask clarifying questions when needed.
''';

  // Track if system prompt has been sent
  bool _systemPromptSent = false;

  Future<String> sendMessage(
    String userMessage,
    List<Map<String, String>> chatHistory,
  ) async {
    try {
      final List<Map<String, dynamic>> contents = [];

      // Only add system prompt once at the beginning
      if (!_systemPromptSent) {
        contents.add({
          "role": "user",
          "parts": [
            {"text": _healthSystemPrompt},
          ],
        });

        contents.add({
          "role": "model",
          "parts": [
            {
              "text":
                  "I understand. I'm MediCare AI, ready to help with your health questions. How can I assist you today?",
            },
          ],
        });

        _systemPromptSent = true;
      }

      // Add recent chat history (excluding system prompt)
      final recentHistory = chatHistory.length > 10
          ? chatHistory.sublist(chatHistory.length - 10)
          : chatHistory;

      for (var msg in recentHistory) {
        // Skip if it's the system prompt or initial response
        if (msg["text"] == _healthSystemPrompt ||
            (msg["text"]?.contains("I understand. I'm MediCare AI") ?? false)) {
          continue;
        }

        contents.add({
          "role": msg["role"] == "user" ? "user" : "model",
          "parts": [
            {"text": msg["text"]},
          ],
        });
      }

      // Add current user message
      contents.add({
        "role": "user",
        "parts": [
          {"text": userMessage},
        ],
      });

      log('Sending request with ${contents.length} messages');

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": contents,
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          },
          "safetySettings": [
            {
              "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE",
            },
            {
              "category": "HARM_CATEGORY_HARASSMENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE",
            },
            {
              "category": "HARM_CATEGORY_HATE_SPEECH",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE",
            },
            {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE",
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('candidates') && data['candidates'].isNotEmpty) {
          final text = data['candidates'][0]['content']['parts'][0]['text'];
          return text;
        } else {
          log('No candidates in response: $data');
          return _getFallbackResponse(userMessage);
        }
      } else {
        log('Error: ${response.statusCode} - ${response.body}');

        if (response.statusCode == 403) {
          return """
I'm having trouble connecting to my AI service due to an authentication issue. 

🔧 **Please check:**
• Your API key is valid
• You have enabled the Gemini API in Google Cloud Console
• Your billing is set up (if required)

For now, here's some general health information based on your query about "$userMessage":

${_getHealthInfoByKeyword(userMessage)}
""";
        } else {
          return _getFallbackResponse(userMessage);
        }
      }
    } catch (e) {
      log('Exception: $e');
      return _getFallbackResponse(userMessage);
    }
  }

  // Reset the service (call this when starting a new chat)
  void reset() {
    _systemPromptSent = false;
  }

  String _getHealthInfoByKeyword(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('headache') ||
        lowerMessage.contains('head pain')) {
      return """
**Headache Information:**

**Common causes:**
• Tension headaches (stress, eye strain)
• Migraines (often with light sensitivity)
• Dehydration
• Sinus issues

**Home remedies:**
• Rest in a dark, quiet room
• Stay hydrated
• Apply cold or warm compress
• Gentle massage

⚠️ **See a doctor if:**
• Sudden severe headache
• Headache with fever, stiff neck
• After head injury
• Persistent for more than 3 days
""";
    } else if (lowerMessage.contains('fever') ||
        lowerMessage.contains('temperature')) {
      return """
**Fever Information:**

**What is fever?**
• Mild: 100.4°F - 102.2°F (38°C - 39°C)
• Moderate: 102.2°F - 104°F (39°C - 40°C)
• High: Above 104°F (40°C)

**Home care:**
• Rest and stay hydrated
• Take over-the-counter fever reducers (acetaminophen/ibuprofen)
• Light clothing and comfortable room temperature

🚨 **Seek immediate care if:**
• Fever exceeds 103°F (39.4°C)
• Persistent for more than 3 days
• Accompanied by severe headache, rash, or difficulty breathing
• Infant under 3 months with any fever
""";
    } else if (lowerMessage.contains('cough')) {
      return """
**Cough Information:**

**Types of cough:**
• Dry cough (no phlegm)
• Wet cough (with mucus)
• Whooping cough (severe fits)

**Home remedies:**
• Honey and warm water (for adults)
• Steam inhalation
• Stay hydrated
• Rest

⚠️ **Consult doctor if:**
• Cough persists > 3 weeks
• Coughing up blood
• Difficulty breathing
• High fever with cough
""";
    } else if (lowerMessage.contains('cold') || lowerMessage.contains('flu')) {
      return """
**Cold & Flu Information:**

**Common symptoms:**
• Runny or stuffy nose
• Sore throat
• Cough
• Fatigue
• Body aches

**Self-care tips:**
• Rest adequately
• Drink warm fluids
• Use saline nasal spray
• Over-the-counter cold medications

🚨 **Seek medical attention if:**
• Symptoms worsen after 7-10 days
• Difficulty breathing
• Severe headache
• Persistent high fever
""";
    } else {
      return """
**Health Information:**

Based on your query about "$userMessage", here are some general health tips:

🩺 **Stay Healthy:**
• Drink 8 glasses of water daily
• Get 7-8 hours of sleep
• Eat a balanced diet
• Exercise 30 minutes daily
• Manage stress

⚠️ **Remember:** I'm an AI assistant. For specific medical concerns, please consult a healthcare provider.

**Would you like to provide more details about your symptoms?**
""";
    }
  }

  String _getFallbackResponse(String userMessage) {
    return _getHealthInfoByKeyword(userMessage);
  }

  static const Map<String, String> quickTips = {
    'fever':
        'For fever: Rest, stay hydrated, and monitor temperature. If fever exceeds 103°F (39.4°C) or persists >3 days, consult a doctor.',
    'headache':
        'For headaches: Rest in dark room, stay hydrated, avoid screens. If severe or recurring, see a doctor.',
    'cold':
        'For common cold: Rest, warm fluids, honey for cough. Symptoms usually resolve in 7-10 days.',
    'cough':
        'For cough: Honey with warm water, steam inhalation. Seek help if persistent >3 weeks.',
  };
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  List<ChatMessage> _messages = [];
  List<Map<String, String>> _chatHistory = [];
  bool _isTyping = false;
  bool _isLoading = true;

  List<ChatMessage> get messages => _messages;
  List<Map<String, String>> get chatHistory => _chatHistory;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;

  final List<String> quickSuggestions = [
    '🤒 Fever symptoms',
    '🤧 Cold remedies',
    '😴 Sleep tips',
    '🥗 Healthy diet',
    '🏃 Exercise advice',
    '💊 Medication info',
    '🧠 Stress relief',
    '🩺 Emergency?',
  ];

  ChatProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false;
    _addWelcomeMessage();
    notifyListeners();
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text: """
👋 **Hello! I'm your MediCare AI Health Assistant**

I'm here to provide helpful health information and guidance. 

**I can help you with:**
• 🤒 Symptom information
• 💊 Medication general info
• 🥗 Nutrition and diet tips
• 🏃 Exercise recommendations
• 😴 Sleep and wellness advice
• 🧠 Mental health support

**⚠️ Important:** I'm an AI assistant and not a replacement for professional medical advice. For emergencies, please call emergency services immediately.

How can I help you today?
""",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    // Add user message
    _messages.add(
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    );
    _chatHistory.add({"role": "user", "text": text});
    _isTyping = true;
    notifyListeners();

    try {
      // Get AI response
      final aiResponse = await _geminiService.sendMessage(text, _chatHistory);

      _messages.add(
        ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()),
      );
      _chatHistory.add({"role": "model", "text": aiResponse});
      _isTyping = false;
      notifyListeners();
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: "I apologize, but I encountered an error. Please try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _geminiService.reset();
    _messages.clear();
    _chatHistory.clear();
    _addWelcomeMessage();
    notifyListeners();
  }
}
