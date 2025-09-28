import 'dart:convert';
import 'package:campus_hub/features/session_management/domain/entities/session.dart';
import 'package:flutter/services.dart';

class SessionLocalDataSource {
  Future<List<Session>> getSessions() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/sessions_sample.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => Session.fromJson(json)).toList();
  }

  Future<void> saveSession(Session session) async {
    // Placeholder for saving new sessions
    throw UnimplementedError('Saving to JSON files not implemented');
  }

  Future<void> updateSession(Session session) async {
    // Placeholder for updating sessions
    throw UnimplementedError('Updating JSON files not implemented');
  }

  Future<void> deleteSession(String id) async {
    // Placeholder for deleting sessions
    throw UnimplementedError('Deleting from JSON files not implemented');
  }
}
