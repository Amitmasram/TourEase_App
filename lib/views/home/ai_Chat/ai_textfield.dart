// import 'package:flutter/material.dart';

// import '../../../core/constants/colors.dart';
// import '../../../core/utils/text_styles.dart';

// class AiTextField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController controller;
//   final String? label;
//   final IconData? icon;
//   final bool obscureText;
//   final IconButton? suffixIcon;

//   const AiTextField({
//     super.key,
//     this.icon,
//     required this.hintText,
//     required this.controller,
//     this.label,
//     this.obscureText = false,
//     this.suffixIcon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         if (label != null) Text(label!, style: AppTextStyles.bodyText),
//         const SizedBox(
//           height: 5,
//         ),
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           cursorColor: AppColors.primary,
//           maxLines: null, // This will allow the text field to grow as needed
//           minLines: 1, // Minimum height of the text field
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: AppTextStyles.bodyText,
//             prefixIcon: icon == null ? null : Icon(icon),
//             suffixIcon: suffixIcon,
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             border: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             focusedBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: AppColors.primary),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class AiTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool isDarkMode;

  const AiTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: isDarkMode ? Colors.white : Colors.black87,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
