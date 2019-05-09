import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();
}


class BlocProvider<T extends BlocBase> extends StatefulWidget {


  final T bloc;
  final Widget child;


  BlocProvider({Key key,@required this.bloc, @required this.child}):super(key:key);


  static T of<T extends BlocBase>(BuildContext context) {
    //final type =  <BlocProvider<T>>();
    // TODO check the runtimetype function below compared to the function above
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(BlocProvider<T>().runtimeType);
    return provider.bloc;

  }

  @override
  State<StatefulWidget> createState() {
    return _BlocProviderState();
  }

}


class _BlocProviderState<T> extends State<BlocProvider>{

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

}