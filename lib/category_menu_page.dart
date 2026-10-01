import 'package:flutter/material.dart';

import 'model/product.dart';

class CategoryMenuPage extends StatelessWidget {
  const CategoryMenuPage({
    required this.currentCategory,
    required this.onCategoryTap,
    Key? key,
  }) : super(key: key);

  final Category currentCategory;
  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 48.0),
      children: <Widget>[
        _CategoryButton(
          category: Category.all,
          currentCategory: currentCategory,
          onTap: onCategoryTap,
        ),
        _CategoryButton(
          category: Category.accessories,
          currentCategory: currentCategory,
          onTap: onCategoryTap,
        ),
        _CategoryButton(
          category: Category.clothing,
          currentCategory: currentCategory,
          onTap: onCategoryTap,
        ),
        _CategoryButton(
          category: Category.home,
          currentCategory: currentCategory,
          onTap: onCategoryTap,
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.currentCategory,
    required this.onTap,
  });

  final Category category;
  final Category currentCategory;
  final ValueChanged<Category> onTap;

  @override
  Widget build(BuildContext context) {
    final bool selected = category == currentCategory;

    return ListTile(
      selected: selected,
      title: Text(
        category.toString().split('.').last.toUpperCase(),
      ),
      onTap: () => onTap(category),
    );
  }
}