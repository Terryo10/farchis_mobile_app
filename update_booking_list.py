import re

with open('lib/presentation/screens/booking/booking_list_screen.dart', 'r') as f:
    content = f.read()

# Replace all imports block at the top
content = re.sub(
    r"import 'package:auto_route/auto_route\.dart';\nimport 'package:flutter/material\.dart';",
    "import 'package:auto_route/auto_route.dart';\nimport 'package:flutter/material.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport '../../../blocs/booking/booking_bloc.dart';\nimport '../../../data/models/booking_model.dart';\nimport '../../../utils/formatters.dart';",
    content
)

# Remove mockBookings list
content = re.sub(r'  static const _mockBookings = \[.*?\];\n', '', content, flags=re.DOTALL)

# Replace initState, dispose and _filteredBookings
replacement_state_methods = """  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    context.read<BookingBloc>().add(LoadBookings());
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  List<BookingModel> _getFilteredBookings(BookingsLoaded state) {
    switch (_selectedFilterIndex) {
      case 1: // Upcoming
        return state.active.where((b) => b.status == BookingStatus.confirmed || b.status == BookingStatus.pending || b.status == BookingStatus.ready || b.status == BookingStatus.in_queue || b.status == BookingStatus.being_assessed).toList();
      case 2: // In Progress
        return state.active.where((b) => b.status == BookingStatus.in_progress).toList();
      case 3: // Completed
        return state.past;
      default:
        return [...state.active, ...state.past];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingInitial || state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookingError) {
            return Center(child: Text(state.failure.message));
          }
          if (state is BookingsLoaded) {
            final bookings = _getFilteredBookings(state);
            final totalBookings = state.active.length + state.past.length;

            return CustomScrollView(
"""

content = re.sub(
    r'  @override\n  void initState\(\) \{.*?\n  Widget build\(BuildContext context\) \{.*?\n      body: CustomScrollView\(',
    replacement_state_methods,
    content,
    flags=re.DOTALL
)

# Replace `${_mockBookings.length} total bookings`
content = content.replace("'${_mockBookings.length} total bookings'", "'${totalBookings} total bookings'")

# Now add closing braces for BlocBuilder at the end of CustomScrollView slivers.
# Wait, let's search for the end of CustomScrollView and close the BlocBuilder.
# We'll just replace the entire ending of the file, starting from the last brace of the CustomScrollView.
