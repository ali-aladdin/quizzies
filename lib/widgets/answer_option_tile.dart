import 'package:flutter/material.dart';

class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    super.key,
  });

  final int value;
  final int? groupValue;
  final String label;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.8)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Radio<int>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
