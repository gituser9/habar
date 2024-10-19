import 'package:flutter/material.dart';
import 'package:habar/common/costants.dart';
import 'package:intl/intl.dart';

class FooterItemWidget extends StatelessWidget {
  final IconData icon;
  final int? value;
  final Color? textColor;
  final bool? isMinus;
  final bool? isPlus;

  const FooterItemWidget({
    super.key,
    required this.icon,
    this.value,
    this.textColor,
    this.isMinus,
    this.isPlus,
  });

  @override
  Widget build(BuildContext context) {
    final formattedNumber = NumberFormat.decimalPattern();
    Color txtColor = AppColors.actionIcon;
    String txtValue = formattedNumber.format(value).toString();

    if (isMinus != null && isMinus!) {
      txtColor = Colors.red;
    }

    if (isPlus != null && isPlus!) {
      txtColor = Colors.green.shade700;
      txtValue = '+$txtValue';
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.actionIcon,
        ),
        const SizedBox(width: 5),
        if (value != null)
          Text(
            txtValue,
            style: TextStyle(
              fontSize: 11,
              color: txtColor,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
