import 'package:flutter/material.dart';

enum PageButtonMode {
  left,
  right,
}

class PaginationWidget extends StatelessWidget {
  final int page;
  final int pageCount;
  final int _pageViewCount = 4;
  final double _splashRadius = 20.0;
  final double _pageConstraint = 35.0;
  final Function(int) callback;

  const PaginationWidget({
    Key? key,
    required this.page,
    required this.pageCount,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pageCount <= 1) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMoveButton(PageButtonMode.left, () {
          if (page == 1) {
            return;
          }
          callback(page - 1);
        }),
        _buildVisiblePageButtons(),
        _buildMoveButton(PageButtonMode.right, () {
          if (page == pageCount) {
            return;
          }
          callback(page + 1);
        }),
      ],
    );
  }

  Widget _buildMoveButton(
    PageButtonMode mode,
    Function func, {
    double iconSize = 24,
    Color iconColor = Colors.blue,
  }) {
    IconData icon;

    switch (mode) {
      case PageButtonMode.left:
        icon = Icons.keyboard_arrow_left;
        break;
      case PageButtonMode.right:
        icon = Icons.keyboard_arrow_right;
        break;
      default:
        icon = Icons.more_horiz;
    }

    return IconButton(
      icon: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      splashRadius: _splashRadius,
      onPressed: () {
        func();
      },
    );
  }

  Widget _buildPageButton(int num) {
    bool isCurrent = num == page;

    return IconButton(
      splashRadius: _splashRadius,
      padding: const EdgeInsets.all(0),
      constraints: BoxConstraints(
        maxHeight: _pageConstraint,
        maxWidth: _pageConstraint,
        minHeight: _pageConstraint,
        minWidth: _pageConstraint,
      ),
      icon: Container(
        decoration: !isCurrent
            ? const BoxDecoration()
            : BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              ),
        child: Center(
          child: Text(
            num.toString(),
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ),
      onPressed: () {
        callback(num);
      },
    );
  }

  Widget _buildVisiblePageButtons() {
    List<Widget> buttons = [];

    if (pageCount > _pageViewCount && page <= 3) {
      for (int i = 1; i <= 4; i++) {
        buttons.add(_buildPageButton(i));
      }

      buttons.add(
        const Center(
          child: const Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text('...', style: const TextStyle(color: Colors.blue)),
          ),
        ),
      );
      buttons.add(_buildPageButton(pageCount));
    } else if (pageCount > _pageViewCount && page > 3) {
      buttons.add(_buildPageButton(1));

      if (page > 3) {
        buttons.add(
          const Center(
            child: const Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('...', style: const TextStyle(color: Colors.blue)),
            ),
          ),
        );
      }

      buttons.add(_buildPageButton(page));

      if ((page + 2) < pageCount) {
        buttons.add(
          const Center(
            child: const Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('...', style: const TextStyle(color: Colors.blue)),
            ),
          ),
        );
      }

      if (page < pageCount) {
        buttons.add(_buildPageButton(pageCount));
      }
    } else {
      for (int i = page; i <= pageCount; i++) {
        buttons.add(_buildPageButton(i));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
