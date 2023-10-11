import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const LabelValue({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 16,
                  color: CustomColors.textColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: CustomColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
