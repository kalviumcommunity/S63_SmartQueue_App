import 'package:flutter/material.dart';

/// Global [ScaffoldMessenger] so auth success snackbars survive route changes.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
