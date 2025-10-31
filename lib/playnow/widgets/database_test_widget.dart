import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';

/// Widget to test database connectivity and table existence
class DatabaseTestWidget extends StatefulWidget {
  const DatabaseTestWidget({super.key});

  @override
  State<DatabaseTestWidget> createState() => _DatabaseTestWidgetState();
}

class _DatabaseTestWidgetState extends State<DatabaseTestWidget> {
  final List<String> _results = [];
  bool _isRunning = false;

  Future<void> _runTests() async {
    setState(() {
      _results.clear();
      _isRunning = true;
    });

    await _testConnection();
    await _testTable('playnow_games');
    await _testTable('playnow_game_participants');
    await _testTable('playnow_game_join_requests');
    await _testTable('playnow_notifications');
    await _testInsertPermission();

    setState(() => _isRunning = false);
  }

  Future<void> _testConnection() async {
    _addResult('Testing Supabase connection...');
    try {
      final client = SupaFlow.client;
      _addResult('✓ Client initialized');
      _addResult('  URL: ${client.supabaseUrl}');
    } catch (e) {
      _addResult('✗ Connection failed: $e');
    }
  }

  Future<void> _testTable(String tableName) async {
    _addResult('\nTesting table: $tableName');
    try {
      final result = await SupaFlow.client
          .from(tableName)
          .select('*')
          .limit(1);

      _addResult('✓ Table exists and is readable');
      _addResult('  Sample data: ${result.length} rows');
    } catch (e) {
      _addResult('✗ Error: $e');

      if (e.toString().contains('relation') || e.toString().contains('does not exist')) {
        _addResult('  → Table does not exist. Run migration script.');
      } else if (e.toString().contains('permission')) {
        _addResult('  → Permission denied. Check RLS policies.');
      }
    }
  }

  Future<void> _testInsertPermission() async {
    _addResult('\nTesting insert permission on playnow.games...');
    try {
      // Try to insert a test game (will fail validation but tests permission)
      await SupaFlow.client
          .schema('playnow').from('games')
          .insert({
            'created_by': 'test',
            'sport_type': 'badminton',
            'game_date': DateTime.now().toIso8601String().split('T')[0],
            'start_time': '10:00',
            'players_needed': 4,
            'game_type': 'doubles',
            'is_free': true,
            'join_type': 'auto',
            'status': 'open',
          })
          .select()
          .single();

      _addResult('✗ Unexpected: Test insert succeeded (should use real user ID)');
    } catch (e) {
      if (e.toString().contains('violates foreign key')) {
        _addResult('✓ Insert permission OK (foreign key constraint as expected)');
      } else if (e.toString().contains('permission') || e.toString().contains('policy')) {
        _addResult('✗ No insert permission. Check RLS policies.');
        _addResult('  Make sure authenticated users can insert into playnow.games');
      } else {
        _addResult('⚠ Insert test error: $e');
      }
    }
  }

  void _addResult(String message) {
    setState(() => _results.add(message));
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isRunning ? null : _runTests,
              child: Text(_isRunning ? 'Running Tests...' : 'Run Database Tests'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                final isError = result.contains('✗');
                final isSuccess = result.contains('✓');
                final isWarning = result.contains('⚠');

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    result,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isError
                          ? Colors.red
                          : isSuccess
                              ? Colors.green
                              : isWarning
                                  ? Colors.orange
                                  : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
