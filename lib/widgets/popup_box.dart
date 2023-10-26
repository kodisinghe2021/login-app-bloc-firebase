import 'package:flutter/material.dart';
import 'package:simple_login_app/animation/hero_dialog_route.dart';

class PopUpBox extends StatelessWidget {
  const PopUpBox({
    Key? key,
    required this.focusWidget,
    required this.enabledWidget,
  }) : super(key: key);

  final Widget enabledWidget;
  final Widget focusWidget;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: Hero(
                tag: _heroAddTodo,
                child: focusWidget,
              ),
            ),
          ),
        );
      },
      child: Hero(
        tag: _heroAddTodo,
        child: enabledWidget,
      ),
    );
  }
}

const String _heroAddTodo = 'add-todo-hero';
