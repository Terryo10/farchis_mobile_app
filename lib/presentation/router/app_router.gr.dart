// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [BookingListScreen]
class BookingListRoute extends PageRouteInfo<void> {
  const BookingListRoute({List<PageRouteInfo>? children})
    : super(BookingListRoute.name, initialChildren: children);

  static const String name = 'BookingListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BookingListScreen();
    },
  );
}

/// generated route for
/// [ChatThreadScreen]
class ChatThreadRoute extends PageRouteInfo<ChatThreadRouteArgs> {
  ChatThreadRoute({
    Key? key,
    required int conversationId,
    List<PageRouteInfo>? children,
  }) : super(
         ChatThreadRoute.name,
         args: ChatThreadRouteArgs(key: key, conversationId: conversationId),
         initialChildren: children,
       );

  static const String name = 'ChatThreadRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatThreadRouteArgs>();
      return ChatThreadScreen(
        key: args.key,
        conversationId: args.conversationId,
      );
    },
  );
}

class ChatThreadRouteArgs {
  const ChatThreadRouteArgs({this.key, required this.conversationId});

  final Key? key;

  final int conversationId;

  @override
  String toString() {
    return 'ChatThreadRouteArgs{key: $key, conversationId: $conversationId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatThreadRouteArgs) return false;
    return key == other.key && conversationId == other.conversationId;
  }

  @override
  int get hashCode => key.hashCode ^ conversationId.hashCode;
}

/// generated route for
/// [ConversationsScreen]
class ConversationsRoute extends PageRouteInfo<void> {
  const ConversationsRoute({List<PageRouteInfo>? children})
    : super(ConversationsRoute.name, initialChildren: children);

  static const String name = 'ConversationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ConversationsScreen();
    },
  );
}

/// generated route for
/// [CreateBookingScreen]
class CreateBookingRoute extends PageRouteInfo<void> {
  const CreateBookingRoute({List<PageRouteInfo>? children})
    : super(CreateBookingRoute.name, initialChildren: children);

  static const String name = 'CreateBookingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateBookingScreen();
    },
  );
}

/// generated route for
/// [DriverConvenienceMapScreen]
class DriverConvenienceMapRoute
    extends PageRouteInfo<DriverConvenienceMapRouteArgs> {
  DriverConvenienceMapRoute({
    Key? key,
    String? bookingId,
    List<PageRouteInfo>? children,
  }) : super(
         DriverConvenienceMapRoute.name,
         args: DriverConvenienceMapRouteArgs(key: key, bookingId: bookingId),
         initialChildren: children,
       );

  static const String name = 'DriverConvenienceMapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriverConvenienceMapRouteArgs>(
        orElse: () => const DriverConvenienceMapRouteArgs(),
      );
      return DriverConvenienceMapScreen(
        key: args.key,
        bookingId: args.bookingId,
      );
    },
  );
}

class DriverConvenienceMapRouteArgs {
  const DriverConvenienceMapRouteArgs({this.key, this.bookingId});

  final Key? key;

  final String? bookingId;

  @override
  String toString() {
    return 'DriverConvenienceMapRouteArgs{key: $key, bookingId: $bookingId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverConvenienceMapRouteArgs) return false;
    return key == other.key && bookingId == other.bookingId;
  }

  @override
  int get hashCode => key.hashCode ^ bookingId.hashCode;
}

/// generated route for
/// [GalleryScreen]
class GalleryRoute extends PageRouteInfo<void> {
  const GalleryRoute({List<PageRouteInfo>? children})
    : super(GalleryRoute.name, initialChildren: children);

  static const String name = 'GalleryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GalleryScreen();
    },
  );
}

/// generated route for
/// [HelpSupportScreen]
class HelpSupportRoute extends PageRouteInfo<void> {
  const HelpSupportRoute({List<PageRouteInfo>? children})
    : super(HelpSupportRoute.name, initialChildren: children);

  static const String name = 'HelpSupportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HelpSupportScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [InspectionRequestDetailScreen]
class InspectionRequestDetailRoute
    extends PageRouteInfo<InspectionRequestDetailRouteArgs> {
  InspectionRequestDetailRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
         InspectionRequestDetailRoute.name,
         args: InspectionRequestDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'InspectionRequestDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InspectionRequestDetailRouteArgs>();
      return InspectionRequestDetailScreen(key: args.key, id: args.id);
    },
  );
}

class InspectionRequestDetailRouteArgs {
  const InspectionRequestDetailRouteArgs({this.key, required this.id});

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'InspectionRequestDetailRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InspectionRequestDetailRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [InspectionRequestFormScreen]
class InspectionRequestFormRoute extends PageRouteInfo<void> {
  const InspectionRequestFormRoute({List<PageRouteInfo>? children})
    : super(InspectionRequestFormRoute.name, initialChildren: children);

  static const String name = 'InspectionRequestFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InspectionRequestFormScreen();
    },
  );
}

/// generated route for
/// [InspectionRequestListScreen]
class InspectionRequestListRoute extends PageRouteInfo<void> {
  const InspectionRequestListRoute({List<PageRouteInfo>? children})
    : super(InspectionRequestListRoute.name, initialChildren: children);

  static const String name = 'InspectionRequestListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InspectionRequestListScreen();
    },
  );
}

/// generated route for
/// [JobTrackerScreen]
class JobTrackerRoute extends PageRouteInfo<JobTrackerRouteArgs> {
  JobTrackerRoute({
    Key? key,
    required BookingModel booking,
    List<PageRouteInfo>? children,
  }) : super(
         JobTrackerRoute.name,
         args: JobTrackerRouteArgs(key: key, booking: booking),
         initialChildren: children,
       );

  static const String name = 'JobTrackerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<JobTrackerRouteArgs>();
      return JobTrackerScreen(key: args.key, booking: args.booking);
    },
  );
}

class JobTrackerRouteArgs {
  const JobTrackerRouteArgs({this.key, required this.booking});

  final Key? key;

  final BookingModel booking;

  @override
  String toString() {
    return 'JobTrackerRouteArgs{key: $key, booking: $booking}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! JobTrackerRouteArgs) return false;
    return key == other.key && booking == other.booking;
  }

  @override
  int get hashCode => key.hashCode ^ booking.hashCode;
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [LoyaltyScreen]
class LoyaltyRoute extends PageRouteInfo<void> {
  const LoyaltyRoute({List<PageRouteInfo>? children})
    : super(LoyaltyRoute.name, initialChildren: children);

  static const String name = 'LoyaltyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoyaltyScreen();
    },
  );
}

/// generated route for
/// [MainLayoutScreen]
class MainLayoutRoute extends PageRouteInfo<void> {
  const MainLayoutRoute({List<PageRouteInfo>? children})
    : super(MainLayoutRoute.name, initialChildren: children);

  static const String name = 'MainLayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainLayoutScreen();
    },
  );
}

/// generated route for
/// [MyVehiclesScreen]
class MyVehiclesRoute extends PageRouteInfo<void> {
  const MyVehiclesRoute({List<PageRouteInfo>? children})
    : super(MyVehiclesRoute.name, initialChildren: children);

  static const String name = 'MyVehiclesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyVehiclesScreen();
    },
  );
}

/// generated route for
/// [NotificationListScreen]
class NotificationListRoute extends PageRouteInfo<void> {
  const NotificationListRoute({List<PageRouteInfo>? children})
    : super(NotificationListRoute.name, initialChildren: children);

  static const String name = 'NotificationListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationListScreen();
    },
  );
}

/// generated route for
/// [NotificationPrefsScreen]
class NotificationPrefsRoute extends PageRouteInfo<void> {
  const NotificationPrefsRoute({List<PageRouteInfo>? children})
    : super(NotificationPrefsRoute.name, initialChildren: children);

  static const String name = 'NotificationPrefsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationPrefsScreen();
    },
  );
}

/// generated route for
/// [PaymentMethodsScreen]
class PaymentMethodsRoute extends PageRouteInfo<void> {
  const PaymentMethodsRoute({List<PageRouteInfo>? children})
    : super(PaymentMethodsRoute.name, initialChildren: children);

  static const String name = 'PaymentMethodsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaymentMethodsScreen();
    },
  );
}

/// generated route for
/// [PersonalInfoScreen]
class PersonalInfoRoute extends PageRouteInfo<void> {
  const PersonalInfoRoute({List<PageRouteInfo>? children})
    : super(PersonalInfoRoute.name, initialChildren: children);

  static const String name = 'PersonalInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PersonalInfoScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [ReferralScreen]
class ReferralRoute extends PageRouteInfo<void> {
  const ReferralRoute({List<PageRouteInfo>? children})
    : super(ReferralRoute.name, initialChildren: children);

  static const String name = 'ReferralRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReferralScreen();
    },
  );
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [ScratchCardScreen]
class ScratchCardRoute extends PageRouteInfo<void> {
  const ScratchCardRoute({List<PageRouteInfo>? children})
    : super(ScratchCardRoute.name, initialChildren: children);

  static const String name = 'ScratchCardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ScratchCardScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}
