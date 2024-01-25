import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class LocationPickerDialog extends StatefulWidget {
  final Function(Address)? onAddressSelected;

  const LocationPickerDialog({
    super.key,
    this.onAddressSelected,
  });

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  Map<PlaceAddress, String> options = {};

  Map<PlaceAddress, String> placesToOptions(List<PlaceAddress> places) {
    Map<PlaceAddress, String> map = {};

    for (PlaceAddress place in places) {
      map[place] = place.formattedAddress;
    }

    return map;
  }

  void placeAutocomplete(String? query) {
    if (query?.isEmpty ?? true) {
      return;
    }

    GoogleApi.fetchUrl(
      {
        "query": query!,
        "key": Configuration.googleApiKey,
        "region": "be",
      },
    ).then((value) {
      if (value != null) {
        // print(value);
        PlaceAutocompleteResponse response =
            PlaceAutocompleteResponse.fromJson(value);
        if (response.predictions != null) {
          setState(() {
            options = placesToOptions(response.predictions!);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputSelectionForm(
            options: options,
            onChanged: placeAutocomplete,
          ),
        ],
      ),
    );
  }
}
