import 'package:flutter/material.dart';

class FoodsNutritionScreen extends StatelessWidget {
  const FoodsNutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foods & Nutrition"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nutrition for Cervical Health",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "A balanced diet rich in vitamins and minerals supports your immune system and cervical health. Here are foods you should include in your diet.",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Beneficial Foods
          Text(
            "Foods to Include",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildFoodCard(
            context,
            icon: "🥦",
            name: "Leafy Greens",
            benefits: "Spinach, kale, broccoli - Rich in vitamins A, C, and folate that boost immunity",
            color: Colors.green,
          ),
          _buildFoodCard(
            context,
            icon: "🥕",
            name: "Orange & Yellow Vegetables",
            benefits: "Carrots, sweet potatoes - High in beta-carotene and antioxidants",
            color: Colors.orange,
          ),
          _buildFoodCard(
            context,
            icon: "🫐",
            name: "Berries",
            benefits: "Blueberries, strawberries - Excellent source of vitamin C and antioxidants",
            color: Colors.blue,
          ),
          _buildFoodCard(
            context,
            icon: "🥜",
            name: "Nuts & Seeds",
            benefits: "Almonds, sunflower seeds - Contain vitamin E and selenium for immune support",
            color: Colors.brown,
          ),
          _buildFoodCard(
            context,
            icon: "🐟",
            name: "Fatty Fish",
            benefits: "Salmon, mackerel - Rich in omega-3 fatty acids and vitamin D",
            color: Colors.blue,
          ),
          _buildFoodCard(
            context,
            icon: "🥒",
            name: "Fermented Foods",
            benefits: "Yogurt, kimchi - Support gut health which is linked to immunity",
            color: Colors.purple,
          ),
          const SizedBox(height: 24),

          // Foods to Avoid
          Text(
            "Foods to Limit",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          _buildFoodCard(
            context,
            icon: "🍔",
            name: "Processed Foods",
            benefits: "Limit processed meats and fast food - they contain harmful additives",
            color: Colors.red,
          ),
          _buildFoodCard(
            context,
            icon: "🍬",
            name: "Sugary Foods",
            benefits: "Excess sugar weakens immunity - reduce candy, soda, and pastries",
            color: Colors.red,
          ),
          _buildFoodCard(
            context,
            icon: "🍷",
            name: "Alcohol",
            benefits: "Excessive alcohol consumption can compromise immune function",
            color: Colors.red,
          ),
          const SizedBox(height: 24),

          // Nutrition Tips
          Text(
            "Daily Nutrition Tips",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildTipCard(context, "Drink 8-10 glasses of water daily to stay hydrated"),
          _buildTipCard(context, "Include 5 servings of fruits and vegetables daily"),
          _buildTipCard(context, "Get adequate protein (40-50g per day)"),
          _buildTipCard(context, "Maintain a healthy BMI through balanced diet and exercise"),
          _buildTipCard(context, "Limit caffeine intake to 200mg per day"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFoodCard(
    BuildContext context, {
    required String icon,
    required String name,
    required String benefits,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withAlpha(128)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  benefits,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String tip) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(51),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
