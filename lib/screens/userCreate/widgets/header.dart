import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16.0),
          Text(
            'Welcome to Bubble',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(
                  color: Color(0xFF2D3243),
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Est ad dolor aute ex commodo tempor exercitation proident.',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Color(0xFF2D3243).withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
