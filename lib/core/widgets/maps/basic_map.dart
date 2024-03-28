import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import '../../utils/location_utils.dart';

class BasicMap extends StatefulWidget {
  final Completer<GoogleMapController>? controller;

  final Set<Marker>? markers;

  final LatLng? position;

  final LatLng startPosition;

  final double? initialZoom;

  final bool showCurrentLocation;

  final LatLng? selectedAddressPosition;

  final bool centerOnSelectedAddress;

  final Function(CameraPosition)? onMoveCamera;

  final String? profileImageUrl;

  final bool showRoute;

  final bool setInitialMarker;

  const BasicMap({
    super.key,
    this.controller,
    this.markers,
    this.position,
    this.initialZoom,
    required this.startPosition,
    this.showCurrentLocation = false,
    this.selectedAddressPosition,
    this.centerOnSelectedAddress = false,
    this.profileImageUrl,
    this.onMoveCamera,
    this.showRoute = false,
    this.setInitialMarker = true,
  });

  @override
  State<BasicMap> createState() => BasicMapState();
}

class BasicMapState extends State<BasicMap> with ScreenStateMixin {
  late final Completer<GoogleMapController> _controller =
      widget.controller ?? Completer<GoogleMapController>();

  GoogleMapController? mapController;

  Set<Polyline> lines = {};

  late Set<Marker> markers = widget.markers ?? {};

  bool isCompleted = false;

  String? mapTheme;

  Future<void> setInitialMarkers() async {
    if (widget.selectedAddressPosition != null) {
      BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          size: const Size(21, 21),
          devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
        ),
        PixelPerfectIcons.profilePicture,
        package: PixelPerfectIcons.packageName,
      );

      if (widget.profileImageUrl != null) {
        final Response response = await get(
          Uri.parse(
            FormattingUtil.formatUrl(
              widget.profileImageUrl!,
            )!,
          ),
        );

        if (response.statusCode == 200) {
          Uint8List bytes = response.bodyBytes;

          descriptor = BitmapDescriptor.fromBytes(
            bytes,
            size: const Size(24, 24),
          );
        }
      }
      markers.add(
        Marker(
          markerId: const MarkerId(
            'user-location',
          ),
          position: LatLng(
            widget.selectedAddressPosition?.latitude ?? 0,
            widget.selectedAddressPosition?.longitude ?? 0,
          ),
          icon: descriptor,
        ),
      );

      if (widget.setInitialMarker) {
        setMarker(widget.startPosition);
      }
    }
  }

  void setMarker(LatLng position) {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
      ),
      PixelPerfectIcons.placeIndicator,
      package: PixelPerfectIcons.packageName,
    ).then((BitmapDescriptor descriptor) {
      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId(
              'job-location',
            ),
            position: position,
            icon: descriptor,
          ),
        );
      });
    });
  }

  void setLines() {
    if (widget.selectedAddressPosition == null) {
      setLoading(false);
      return;
    }

    GoogleApi.getDirections(
      from: widget.selectedAddressPosition!,
      to: widget.startPosition,
    ).then((coordinates) {
      setState(() {
        loading = false;
        lines.add(
          Polyline(
            polylineId: const PolylineId('_'),
            visible: true,
            points: coordinates,
            width: 4,
            color: Colors.blue,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap,
          ),
        );
        _controller.future.then((controller) {
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(
              LocationUtils.linesToFit(lines),
              100,
            ),
          );
        });
      });
    });
  }

  void updateMap(Address address) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(address.latitude!, address.longitude!),
        15,
      ),
    );
    setMarker(
      LatLng(
        address.latitude!,
        address.longitude!,
      ),
    );
  }

  String? style;

  Future<void> setStyle() async {
    setLoading(true);

    style = await DefaultAssetBundle.of(context).loadString(
      'lib/assets/styles/map_style.json',
      cache: true,
    );

    setState(() {
      style = style;
    });
  }

  @override
  void initState() {
    Future(() async {
      await setStyle();
      setInitialMarkers();
      setLines();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            Shadows.mainShadow,
          ],
        ),
        child: FractionallySizedBox(
          widthFactor: 1.02,
          heightFactor: 1.02,
          child: LoadingSwitcher(
            loading: loading,
            child: GoogleMap(
              onCameraMove: widget.onMoveCamera,
              myLocationEnabled: widget.showCurrentLocation,
              myLocationButtonEnabled: widget.showCurrentLocation,
              markers: markers,
              polylines: lines,
              style: style,
              onMapCreated: (controller) {
                if (_controller.isCompleted) {
                  return;
                }
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: widget.startPosition,
                zoom: widget.initialZoom ?? 7,
              ),
              compassEnabled: false,
              mapToolbarEnabled: false,
              buildingsEnabled: false,
            ),
          ),
        ),
      ),
    );
  }
}
