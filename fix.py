import re

with open('lib/presentation/screens/booking/booking_list_screen.dart', 'r') as f:
    text = f.read()

# Add imports
if 'package:flutter_bloc/flutter_bloc.dart' not in text:
    text = text.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport '../../../blocs/booking/booking_bloc.dart';\nimport '../../../data/models/booking_model.dart';\nimport '../../../utils/formatters.dart';")

# Remove mock data
text = re.sub(r'  static const _mockBookings = \[.*?\];', '', text, flags=re.DOTALL)
text = re.sub(r'// ---------- Mock Data Model ----------\nclass _MockBooking \{.*?\n\}\n', '', text, flags=re.DOTALL)

# Replace build methods and getters
text = re.sub(r'  List<_MockBooking> get _filteredBookings \{.*?\}\n\n  @override\n  Widget build\(BuildContext context\) \{.*?\}\n\}', '', text, flags=re.DOTALL)

with open('lib/presentation/screens/booking/booking_list_screen.dart', 'w') as f:
    f.write(text)

