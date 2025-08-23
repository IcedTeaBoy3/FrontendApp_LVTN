import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  String searchText = '';
  InputSearch({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: searchText,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        // Viền khi focus
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        // Viền khi không focus
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[300]!
                  : Colors.white54,
              width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      keyboardType: TextInputType.text,
      onChanged: (value) {},
    );
  }
}
