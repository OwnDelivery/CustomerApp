import 'package:flutter/cupertino.dart';
import 'package:own_delivery/core/presenter.dart';

abstract class PageState<D, T extends StatefulWidget, P extends Presenter<D>>
    extends State<T> {
  late P presenter;

  P initializePresenter();

  @override
  void initState() {
    super.initState();
    presenter = initializePresenter();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: presenter.getViewStateStream(),
        builder: (context, snapshot) {
          return buildWidget(context, snapshot.data);
        });
  }

  Widget buildWidget(BuildContext context, D? snapshot);

  @override
  void dispose() {
    super.dispose();
    initializePresenter().onDestroy();
  }
}
