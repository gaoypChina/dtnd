import 'dart:async';

import 'package:flutter/material.dart';

typedef OnTextFormFieldChanged = void Function(
    FormFieldState<String?>? state, String value);

typedef OnSocket = dynamic Function(dynamic);
typedef OnRegisteredCode = FutureOr<void> Function(String);
