import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'AddressSelectionViewModel.dart';

class AddressSelectionView extends StatelessWidget {
  const AddressSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressSelectionViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => AddressSelectionViewModel(),
    );
  }
}
