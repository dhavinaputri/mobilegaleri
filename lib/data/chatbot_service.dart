import 'package:mobilegaleri/data/api_client.dart';

class ChatbotService {
  static Future<String> ask(String message, {List<Map<String, String>> context = const []}) async {
    final res = await ApiClient.postJson('/api/v1/chatbot/ask', {
      'message': message,
      'context': context,
    });
    if (res['success'] == true) {
      return (res['answer'] ?? '') as String;
    }
    throw Exception(res['error'] ?? 'Chatbot error');
  }
}
