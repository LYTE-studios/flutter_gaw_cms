import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/core/widgets/maps/basic_map.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerDialog extends StatefulWidget {
  final Address? address;

  final Function(Address)? onAddressSelected;

  const LocationPickerDialog({
    super.key,
    this.address,
    this.onAddressSelected,
  });

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog>
    with ScreenStateMixin {
  GlobalKey<BasicMapState> mapKey = GlobalKey();

  bool isLateLoading = false;

  bool canRequest = true;

  Address? address;

  Map<PlaceAddress, String> options = {};

  Map<PlaceAddress, String> placesToOptions(List<PlaceAddress> places) {
    Map<PlaceAddress, String> map = {};

    for (PlaceAddress place in places) {
      map[place] = place.formattedAddress;
    }

    return map;
  }

  void setLateLoader(String query) {
    setState(() {
      isLateLoading = true;
    });
    Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    ).then((_) {
      setState(() {
        isLateLoading = false;
      });
      placeAutocomplete(query);
    });
  }

  void setTicker() {
    setState(() {
      canRequest = false;
    });

    Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    ).then((_) {
      setState(() {
        canRequest = true;
      });
    });
  }

  void placeAutocomplete(String? query) {
    if (query?.isEmpty ?? true) {
      return;
    }

    if (!canRequest) {
      if (isLateLoading) {
        return;
      }
      setLateLoader(query!);
      return;
    }

    GoogleApi.autocomplete(query!.trim()).then(
      (value) {
        setTicker();
        if (value != null) {
          if (value.predictions != null) {
            setState(() {
              options = placesToOptions(
                value.predictions!,
              );
            });
          }
        }
      },
    );
  }

  ParsedAddress parseAddress(String address) {
    // First, remove any trailing commas that might be present.
    address = address.replaceAll(',', '');

    // Split the address into parts.
    final parts = address.split(' ');

    // Try to find the index of the part that looks like a postal code.
    final postalCodeIndex =
        parts.indexWhere((part) => RegExp(r'\b\d{4}\b').hasMatch(part));

    String streetName = '';
    String? streetNumber;
    String postalCode = '';
    String city = '';

    if (postalCodeIndex != -1) {
      // Extract postal code and city.
      postalCode = parts[postalCodeIndex];
      city = parts.sublist(postalCodeIndex + 1).join(' ');

      // Extract street name and number.
      // Assume that the street number, if present, is the part right before the postal code.
      if (postalCodeIndex > 0 &&
          RegExp(r'^\d+[a-zA-Z]?$').hasMatch(parts[postalCodeIndex - 1])) {
        streetNumber = parts[postalCodeIndex - 1];
        streetName = parts.sublist(0, postalCodeIndex - 1).join(' ');
      } else {
        streetName = parts.sublist(0, postalCodeIndex).join(' ');
      }
    } else {
      // Fallback if the address doesn't contain a postal code.
      streetName = address;
    }

    return ParsedAddress(
      streetName: streetName,
      streetNumber: streetNumber,
      postalCode: postalCode,
      city: city,
    );
  }

  void updateMap(Address address) {
    mapKey.currentState?.updateMap(address);
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      width: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: PaddingSizes.mainPadding,
              left: PaddingSizes.bigPadding,
              right: PaddingSizes.bigPadding,
            ),
            child: InputSelectionForm(
              options: options,
              onSelected: (dynamic place) {
                if (place is PlaceAddress) {
                  ParsedAddress parsedAddress =
                      parseAddress(place.formattedAddress);
                  Address newAddress = Address(
                    (b) => b
                      ..latitude = place.latitude
                      ..longitude = place.longitude
                      ..streetName = parsedAddress.streetName
                      ..postalCode = parsedAddress.postalCode
                      ..houseNumber = parsedAddress.streetNumber
                      ..city = parsedAddress.city,
                  );

                  updateMap(newAddress);

                  setState(() {
                    address = newAddress;
                  });
                }
              },
              onChanged: placeAutocomplete,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                PaddingSizes.bigPadding,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border.fromBorderSide(
                      Borders.lightSide,
                    ),
                  ),
                  child: BasicMap(
                    key: mapKey,
                    setInitialMarker: widget.address != null,
                    initialZoom: widget.address == null ? null : 15,
                    startPosition: widget.address == null ||
                            widget.address!.latitude == null ||
                            widget.address!.longitude == null
                        ? const LatLng(
                            50.5039,
                            4.4699,
                          )
                        : LatLng(
                            widget.address!.latitude!,
                            widget.address!.longitude!,
                          ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.bigPadding,
            ),
            child: GenericButton(
              label: 'Select address',
              textStyleOverride: TextStyles.mainStyle.copyWith(
                color: GawTheme.clearText,
              ),
              onTap: () {
                if (address == null) {
                  return;
                }

                widget.onAddressSelected?.call(address!);

                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
