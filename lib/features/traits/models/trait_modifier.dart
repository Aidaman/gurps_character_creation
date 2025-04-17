import 'package:uuid/uuid.dart';

class TraitModifier {
  final String id;
  final String name;
  final num cost;
  final String affects;
  final String reference;
  final String notes;
  final bool disabled;

  TraitModifier({
    required this.id,
    required this.name,
    required this.cost,
    required this.affects,
    required this.reference,
    this.notes = '',
    this.disabled = false,
  });

  factory TraitModifier.fromJson(Map<String, dynamic> json) => TraitModifier(
        id: json['id'] ?? const Uuid().v4(),
        name: json['name'] ?? '',
        cost: json['cost'] ?? 0,
        affects: json['affects'] ?? 'total',
        reference: json['reference'] ?? '',
        notes: json['notes'] ?? '',
        disabled: json['disabled'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cost': cost,
        'affects': affects,
        'reference': reference,
        'notes': notes,
        'disabled': disabled,
      };
}
