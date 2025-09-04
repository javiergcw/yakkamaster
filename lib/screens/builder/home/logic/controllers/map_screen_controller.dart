import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../config/app_flavor.dart';
import '../../presentation/pages/builder_home_screen.dart';
import '../../presentation/pages/worker_list_screen.dart';
import '../../presentation/pages/messages_screen.dart' as builder_messages;
import '../../presentation/pages/profile_screen.dart' as builder_profile;

class MapScreenController extends GetxController {
  final Rx<AppFlavor> currentFlavor = AppFlavorConfig.currentFlavor.obs;
  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  final TextEditingController searchController = TextEditingController();
  
  // Palo Alto area coordinates
  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(37.4419, -122.1430), // Palo Alto area
    zoom: 12.0,
  );

  final List<String> skillChips = [
    'General Labourer',
    'Carpenter',
    'Electrician',
    'Plumber',
    'Painter',
    'Welder',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['flavor'] != null) {
      currentFlavor.value = Get.arguments['flavor'];
    }
    searchController.text = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }

  Set<Marker> createMarkers() {
    return {
      Marker(
        markerId: const MarkerId('worker_location'),
        position: const LatLng(37.4419, -122.1430), // Near MONTA LOMA
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };
  }

  void navigateToList() {
    Get.toNamed(WorkerListScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToHome() {
    Get.offAllNamed(BuilderHomeScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToMessages() {
    Get.toNamed(builder_messages.MessagesScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void navigateToProfile() {
    Get.toNamed(builder_profile.ProfileScreen.id, arguments: {'flavor': currentFlavor.value});
  }

  void getCurrentLocation() {
    // TODO: Get current location
    Get.snackbar(
      'Info',
      'Current location feature not implemented yet',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Dark style for the map
  static const String mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#1a1a2e"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1a1a2e"
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#4b6878"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#64779e"
        }
      ]
    },
    {
      "featureType": "administrative.province",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#4b6878"
        }
      ]
    },
    {
      "featureType": "landscape.man_made",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#334e87"
        }
      ]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#023e58"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#283d6a"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#6f9ba5"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1e3c72"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#023e58"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#6b9a76"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#304a7d"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#1a365d"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#98a5be"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1a365d"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#2c6675"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#255763"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#b0d5ce"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#023e58"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#98a5be"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#1a365d"
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#283d6a"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#3a4762"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#0e1626"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#4e6d70"
        }
      ]
    }
  ]
  ''';
}
