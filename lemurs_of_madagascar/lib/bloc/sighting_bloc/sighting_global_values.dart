import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';

class SightingGlobalValues extends InheritedWidget {

  final SightingBloc bloc = SightingBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  SightingGlobalValues({Key key, Widget child}) : super(key: key, child: child);

  static SightingGlobalValues of(BuildContext context)=> context.inheritFromWidgetOfExactType(SightingGlobalValues) as SightingGlobalValues;

}