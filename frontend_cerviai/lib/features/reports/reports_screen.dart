import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  String _assessmentFromRisk(String risk) {
    final r = risk.toLowerCase();
    if (r.contains('low')) return 'Good';
    if (r.contains('medium')) return 'Watch';
    return 'Warning';
  }

  List<String> _warningSignsForRisk(String risk) {
    final r = risk.toLowerCase();
    if (r.contains('high')) {
      return [
        'Abnormal vaginal bleeding',
        'Unusual discharge',
        'Pelvic pain or pain during intercourse',
      ];
    }
    if (r.contains('medium')) {
      return ['Follow-up screening recommended', 'Repeat test in 6 months'];
    }
    return ['No immediate warning signs. Continue regular screening.'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock patient header and reports data
    final patient = {
      'name': 'Ananya Rao',
      'age': 34,
      'patientId': 'PT-2026-556',
      'lastVisit': 'Feb 14, 2026'
    };

    final List<Map<String, dynamic>> reports = [
      {
        'id': 'R-2026-001',
        'date': 'Feb 14, 2026',
        'risk': 'Low Risk',
        'color': Colors.green,
        'summary': 'No abnormal cells detected.'
      },
      {
        'id': 'R-2025-119',
        'date': 'Dec 11, 2025',
        'risk': 'Medium Risk',
        'color': Colors.orange,
        'summary': 'Minor atypical cells; monitoring advised.'
      },
      {
        'id': 'R-2024-087',
        'date': 'Aug 02, 2024',
        'risk': 'High Risk',
        'color': Colors.red,
        'summary': 'High-grade lesion found; immediate follow-up recommended.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Health Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Patient header
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: theme.colorScheme.primary.withAlpha(38),
                    child: Icon(Icons.person, size: 36, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient['name'].toString(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Age: ${patient['age']} • ID: ${patient['patientId']}', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 6),
                        Text('Last Visit: ${patient['lastVisit']}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      ],
                    ),
                  ),
                  // Overall quick action/status
                  Column(
                    children: [
                      Text('Overall', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(31),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Good', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Reports list
          Text('Reports', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...reports.map((item) {
            final assessment = _assessmentFromRisk(item['risk'] as String);
            final warnings = _warningSignsForRisk(item['risk'] as String);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: (item['color'] as Color).withAlpha(31),
                          child: Icon(Icons.description, color: item['color']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['id'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(item['date'], style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (item['color'] as Color).withAlpha(31),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(item['risk'], style: TextStyle(color: item['color'], fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: assessment == 'Good' ? Colors.green.withAlpha(31) : (assessment == 'Watch' ? Colors.orange.withAlpha(31) : Colors.red.withAlpha(31)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(assessment, style: TextStyle(color: assessment == 'Good' ? Colors.green : (assessment == 'Watch' ? Colors.orange : Colors.red), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(item['summary'], style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    if (warnings.isNotEmpty) ...[
                      Text('Warning signs / notes:', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...warnings.map((w) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber_outlined, size: 16, color: Colors.redAccent.withAlpha(230)),
                                const SizedBox(width: 8),
                                Expanded(child: Text(w, style: theme.textTheme.bodySmall)),
                              ],
                            ),
                          )),
                    ],
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('View details'),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
