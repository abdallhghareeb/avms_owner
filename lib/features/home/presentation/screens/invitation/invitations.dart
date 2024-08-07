import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/features/home/data/models/get_all_inv.dart';

class InvitationsScreen extends StatefulWidget {
  static const route = "Invitations";

  const InvitationsScreen({Key? key}) : super(key: key);

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  late ScrollController _scrollController;
  List<VisitModel> _userDataList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool _hasNetworkError = false;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _checkNetworkAndFetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkNetworkAndFetchData({bool isRefresh = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasNetworkError = true;
      });
    } else {
      _fetchData(isRefresh: isRefresh);
    }
  }

  Future<void> _fetchData({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (isRefresh) {
      _currentPage = 1;
      _userDataList.clear();
      _hasMoreData = true;
    }
    if (!_hasMoreData) return;

    setState(() {
      _isLoading = true;
      _hasNetworkError = false;
    });

    try {
      Map<String, dynamic> parameters = {
        'Search': _searchController.text,
        'PageNumber': _currentPage,
      };

      if (_startDate != null) {
        parameters['RegistrationDateFrom'] = _startDate!.toIso8601String();
      }

      if (_endDate != null) {
        parameters['RegistrationDateTo'] = _endDate!.toIso8601String();
      }

      List<VisitModel> newUserData = await DioHelper.fetchData(
        token: TokenSave!,
        parameters: parameters,
      );

      setState(() {
        final newData = newUserData.where((newItem) {
          return !_userDataList.any((existingItem) => existingItem.id == newItem.id);
        }).toList();

        _userDataList.addAll(newData);
        _hasMoreData = newUserData.isNotEmpty;
        _currentPage++;
      });
    } catch (error) {
      setState(() {
        _hasNetworkError = true;
      });
      print('Error fetching data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      _fetchData();
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    } catch (e) {
      print('Error parsing date: $e');
      return 'N/A';
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            cardColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _fetchData(isRefresh: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Config.Localization['Invitations']),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _selectDate(context, true),
          ),
          IconButton(
            icon: Icon(Icons.date_range_outlined),
            onPressed: () => _selectDate(context, false),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _fetchData(isRefresh: true),
                ),
              ),
              onSubmitted: (value) => _fetchData(isRefresh: true),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchData(isRefresh: true);
        },
        child: _isLoading && _userDataList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : _userDataList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_hasNetworkError) ...[
                Icon(Icons.signal_wifi_off, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No internet connection.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Check your connection and try again.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _checkNetworkAndFetchData(isRefresh: true),
                  child: Text('Retry'),
                ),
              ] else ...[
                Text('No data available', style: TextStyle(fontSize: 18)),
              ],
            ],
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          itemCount: _userDataList.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _userDataList.length) {
              return Center(child: CircularProgressIndicator());
            }

            VisitModel userData = _userDataList[index];
            return GestureDetector(
              onTap: () => _showDetailsDialog(context, userData),
              child: Container(
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        userData.qrLink ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/placeholder_image.png'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.fullName ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text('Card Number: ${userData.cardNumber ?? ''}'),
                          Text('Created At: ${formatDate(userData.expiryDate)}'),
                          Text('Registration Date: ${formatDate(userData.registrationDate)}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, VisitModel userData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invitation Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Full Name: ${userData.fullName ?? ''}'),
            Text('Card Number: ${userData.cardNumber ?? ''}'),
            Text('Created At: ${formatDate(userData.expiryDate)}'),
            Text('Registration Date: ${formatDate(userData.registrationDate)}'),
            SizedBox(height: 20),
            Center(
              child: FutureBuilder<void>(
                future: precacheImage(
                  NetworkImage(userData.qrLink ?? ''),
                  context,
                  onError: (_, __) =>
                      AssetImage('assets/placeholder_image.png'),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Image.asset('assets/placeholder_image.png');
                  } else {
                    return Image.network(userData.qrLink ?? '');
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              // handle HomeCubit states if needed
            },
            child: TextButton(
              onPressed: () async {
                HomeCubit cubit = HomeCubit.get(context);
                await cubit.shareImage(userData.qrLink!);
              },
              child: Text('Reshare'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
