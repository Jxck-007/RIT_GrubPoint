import 'package:googleapis/dialogflow/v2.dart' as dialogflow;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DialogflowService {
  static late dialogflow.DialogflowApi _api;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": dotenv.env['DIALOGFLOW_PROJECT_ID'],
      "private_key_id": dotenv.env['DIALOGFLOW_PRIVATE_KEY_ID'],
      "private_key": dotenv.env['DIALOGFLOW_PRIVATE_KEY']?.replaceAll('\\n', '\n'),
      "client_email": dotenv.env['DIALOGFLOW_CLIENT_EMAIL'],
      "client_id": dotenv.env['DIALOGFLOW_CLIENT_ID'],
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": dotenv.env['DIALOGFLOW_CLIENT_CERT_URL'],
    });

    final client = await clientViaServiceAccount(
      credentials,
      [dialogflow.DialogflowApi.cloudPlatformScope],
    );

    _api = dialogflow.DialogflowApi(client);
    _isInitialized = true;
  }

  static Future<String> getResponse(String message) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final request = dialogflow.GoogleCloudDialogflowV2DetectIntentRequest(
        queryInput: dialogflow.GoogleCloudDialogflowV2QueryInput(
          text: dialogflow.GoogleCloudDialogflowV2TextInput(
            text: message,
            languageCode: 'en',
          ),
        ),
      );

      final response = await _api.projects.agent.sessions.detectIntent(
        request,
        'projects/${dotenv.env['DIALOGFLOW_PROJECT_ID']}/agent/sessions/default',
      );

      return response.queryResult?.fulfillmentText ?? 
             'Sorry, I couldn\'t process your request. Please try again.';
    } catch (e) {
      return 'Sorry, there was an error processing your request. Please try again.';
    }
  }
} 