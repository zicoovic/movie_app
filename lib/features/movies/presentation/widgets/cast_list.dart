import 'package:flutter/material.dart';

/// CastList - Shows movie cast with circular avatars
///
/// Matches Screen 2 design:
/// - 4 circular avatars (2x2 grid)
/// - Actor name + role below each avatar
class CastList extends StatelessWidget {
  final List<CastMember> cast;

  const CastList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          cast.take(4).map((member) => _CastItem(member: member)).toList(),
    );
  }
}

/// Individual cast member item
class _CastItem extends StatelessWidget {
  final CastMember member;

  const _CastItem({required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Circular avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white24,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              member.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.person, color: Colors.white54),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Actor name
        Text(
          member.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Role
        Text(
          member.role,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

/// Cast member model (temporary - until we create proper data model)
class CastMember {
  final String name;
  final String role;
  final String imageUrl;

  CastMember({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}
