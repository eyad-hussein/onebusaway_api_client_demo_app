import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'dart:developer';
import 'package:onebusaway_api_client_library/onebusaway_api_client_library.dart'
    as oba_client;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final oba_client.OneBusAwayApiClient _client = oba_client.OneBusAwayApiClient(
      baseUrl: "https://api.pugetsound.onebusaway.org/api/where",
      apiKey: "TEST");
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _urlController = TextEditingController(
      text: "https://api.pugetsound.onebusaway.org/api/where");
  Map<String, dynamic> _response = {};

  oba_client.RequestType selectedRequestType = oba_client.RequestType.get;
  Color? selectedRequestTypeBackgroundColor;
  Color? selectedEndpointBackgroundColor;
  String selectedResponseFormat = "json";
  Color? selectedResponseFormatBackgroundColor;

  Future<Map<String, dynamic>> fetchData() async {
    final response = await _client.getAgenciesWithCoverage();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OneBusAway API Client Demo"),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text("Request Type"),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: oba_client.RequestType.values
                .map((requestType) => InkWell(
                      child: Text(
                        requestType.name.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () => {selectedRequestType = requestType},
                    ))
                .toList(),
          ),
          ExpansionTile(
            title: const Text("Endpoint"),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: oba_client.Endpoints.values
                .map((endpoint) => InkWell(
                      child: Text(endpoint,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center),
                      onTap: () => {_urlController.text += "/$endpoint"},
                    ))
                .toList(),
          ),
          ExpansionTile(
            title: const Text("Response Format"),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                child: const Text(
                  "xml",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                onTap: () => {selectedResponseFormat = "xml"},
              ),
              InkWell(
                child: const Text(
                  "json",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () => {selectedResponseFormat = "json"},
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              readOnly: true,
              controller: _apiKeyController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Enter API Key',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Response",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: SingleChildScrollView(
                    child: JsonView.map(_response),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton(
                onPressed: () async {
                  var res = await fetchData();
                  setState(() {
                    _response = res;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: const RoundedRectangleBorder()),
                child: const Text(
                  "Send Request",
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintStyle: TextStyle(color: Colors.black),
                hintText: "URL",
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
