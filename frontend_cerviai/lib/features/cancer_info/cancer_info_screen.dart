import 'package:flutter/material.dart';

class CancerInfoScreen extends StatefulWidget {
  const CancerInfoScreen({super.key});

  @override
  State<CancerInfoScreen> createState() => _CancerInfoScreenState();
}

class _CancerInfoScreenState extends State<CancerInfoScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cervical Cancer Info & News"),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Selection
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primary.withAlpha(13),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 0
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        "Information",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 0
                              ? theme.colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 1
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        "Latest News",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 1
                              ? theme.colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedTab == 0
                ? _buildInformationTab(context)
                : _buildNewsTab(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Overview
        _buildSectionHeader(context, "What is Cervical Cancer?"),
        _buildInfoCard(
          context,
          "Cervical cancer is a type of cancer that develops in the cervix (the lower part of the uterus). It is primarily caused by the Human Papillomavirus (HPV), which is transmitted through sexual contact.",
        ),
        const SizedBox(height: 20),

        // Risk Factors
        _buildSectionHeader(context, "Risk Factors"),
        _buildInfoCard(
          context,
          "• HPV infection (main cause)\n• Smoking\n• Weak immune system\n• Early sexual activity\n• Multiple sexual partners\n• Use of birth control for extended periods\n• Family history of cervical cancer",
        ),
        const SizedBox(height: 20),

        // Prevention
        _buildSectionHeader(context, "Prevention"),
        _buildInfoCard(
          context,
          "✓ Get vaccinated against HPV (best protection)\n✓ Regular screening tests (Pap smear or HPV test)\n✓ Practice safe sex\n✓ Don't smoke\n✓ Maintain a healthy diet\n✓ Exercise regularly",
        ),
        const SizedBox(height: 20),

        // Symptoms
        _buildSectionHeader(context, "Symptoms to Watch For"),
        _buildInfoCard(
          context,
          "• Abnormal vaginal bleeding\n• Abnormal vaginal discharge\n• Pelvic pain\n• Pain during intercourse\n• Vaginal bleeding after menopause",
        ),
        const SizedBox(height: 20),

        // Screening
        _buildSectionHeader(context, "Screening Guidelines"),
        _buildInfoCard(
          context,
          "Women aged 21-65 should get:\n\n• Pap smear: Every 3 years\n• HPV test: Every 5 years\n• Combined test: Every 5 years\n\nTalk to your doctor about the best screening plan for you.",
        ),
        const SizedBox(height: 20),

        // Treatment
        _buildSectionHeader(context, "Early Detection & Treatment"),
        _buildInfoCard(
          context,
          "When detected early, cervical cancer is highly treatable with high survival rates. Treatment options may include:\n\n• Surgery\n• Radiation therapy\n• Chemotherapy\n• Combination treatments",
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildNewsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildNewsCard(
          context,
          title: "New HPV Vaccines Show 99% Effectiveness",
          date: "February 10, 2026",
          description: "Latest clinical trials demonstrate that newer HPV vaccines provide comprehensive protection against multiple strains of human papillomavirus.",
          image: "🔬",
        ),
        _buildNewsCard(
          context,
          title: "Self-Sampling HPV Test Approved for Home Use",
          date: "January 28, 2026",
          description: "Health authorities approve new HPV self-sampling kits that allow women to perform screening tests at home, improving accessibility to cervical cancer prevention.",
          image: "🏥",
        ),
        _buildNewsCard(
          context,
          title: "AI-Powered Screening Improves Detection Rates",
          date: "January 15, 2026",
          description: "A study shows that AI-assisted cervical cancer screening increases detection rates of precancerous lesions by 23% compared to manual review alone.",
          image: "🤖",
        ),
        _buildNewsCard(
          context,
          title: "Global Initiative Aims to Eliminate Cervical Cancer",
          date: "December 5, 2025",
          description: "The WHO launches a comprehensive plan targeting the elimination of cervical cancer globally through vaccination, screening, and treatment programs.",
          image: "🌍",
        ),
        _buildNewsCard(
          context,
          title: "New Treatment Breakthrough for Advanced Cervical Cancer",
          date: "November 20, 2025",
          description: "Researchers report positive results from immunotherapy trials for advanced cervical cancer, offering new hope for patients with limited treatment options.",
          image: "💊",
        ),
        _buildNewsCard(
          context,
          title: "Importance of Regular Screening Emphasized",
          date: "November 10, 2025",
          description: "Medical experts stress the importance of regular cervical cancer screening, noting that early detection significantly improves treatment outcomes and survival rates.",
          image: "📋",
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String content) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(51),
        ),
      ),
      child: Text(
        content,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildNewsCard(
    BuildContext context, {
    required String title,
    required String date,
    required String description,
    required String image,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                image,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text("Read More"),
            ),
          ),
        ],
      ),
    );
  }
}
