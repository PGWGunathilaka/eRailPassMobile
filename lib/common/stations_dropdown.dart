import 'package:erailpass_mobile/context/station_model.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StationDropDown extends StatelessWidget {
  final void Function(Station?)? onChanged;
  final Station? initialValue;

  const StationDropDown({Key? key, this.onChanged, this.initialValue})
      : super(key: key);

@override
Widget build(BuildContext context) {
  return Scrollbar(
    child: FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 1,
      child: Consumer<StationModel>(
        builder: (context, stationModel, child) {
          List<Station> stations = stationModel.getAll();
          return DropdownSearch<Station>(

            popupProps: const PopupProps.menu(
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Type here to find your station",
                ),
              ),
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: stations,
            itemAsString: (s) => s.name,
            compareFn: (a, b) => a == b,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Select Station",
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: onChanged,
            selectedItem: initialValue,// Set the initial value here
          );
        },
      ),
    ),
  );
}}
