import 'package:flutter/material.dart';

class KCustomKeypad extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback onDelete;

  const KCustomKeypad({
    super.key,
    required this.onKeyTap,
    required this.onDelete,
  });

  static const _keys = [
    ['1', ''],
    ['2', 'ABC'],
    ['3', 'DEF'],
    ['4', 'GHI'],
    ['5', 'JKL'],
    ['6', 'MNO'],
    ['7', 'PQRS'],
    ['8', 'TUV'],
    ['9', 'WXYZ'],
  ];

  Widget _buildKey(
    BuildContext context,
    String label,
    String subLabel,
    VoidCallback onTap,
  ) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: w * 0.15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: w * 0.05,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF222222),
              ),
            ),
            if (subLabel.isNotEmpty)
              Text(
                subLabel,
                style: TextStyle(
                  fontSize: w * 0.022,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF888888),
                  letterSpacing: 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final spacing = w * 0.01;

    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.03, w * 0.03, w * 0.03, w * 0.06),
      decoration: const BoxDecoration(color: Color(0xFFF2F2F7)),
      child: Column(
        children: [
          for (int row = 0; row < 3; row++)
            Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: Row(
                children: [
                  for (int col = 0; col < 3; col++) ...[
                    Expanded(
                      child: _buildKey(
                        context,
                        _keys[row * 3 + col][0],
                        _keys[row * 3 + col][1],
                        () => onKeyTap(_keys[row * 3 + col][0]),
                      ),
                    ),
                    if (col < 2) SizedBox(width: spacing),
                  ],
                ],
              ),
            ),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: w * 0.15,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(child: _buildKey(context, '0', '', () => onKeyTap('0'))),
              SizedBox(width: spacing),
              Expanded(
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    height: w * 0.15,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.backspace_outlined,
                      size: w * 0.05,
                      color: const Color(0xFF444444),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
