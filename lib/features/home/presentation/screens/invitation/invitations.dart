import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/data/models/cancle_invtation_model.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _isCancelling = false;
  CancelInvitationResponse? cancelInvitationResponse;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNetworkAndFetchData(isRefresh: true);
    });
  }

  @override
  void didUpdateWidget(covariant InvitationsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkNetworkAndFetchData(isRefresh: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkNetworkAndFetchData(isRefresh: true);
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
        context: context
      );

      setState(() {
        final newData = newUserData.where((newItem) {
          return !_userDataList
              .any((existingItem) => existingItem.id == newItem.id);
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
      return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "From Date",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () => _selectDate(context, true),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _startDate != null
                            ? '${_startDate!.toLocal()}'.split(' ')[0]
                            : '',
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "To Date",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.date_range_rounded),
                          onPressed: () => _selectDate(context, false),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _endDate != null
                            ? '${_endDate!.toLocal()}'.split(' ')[0]
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RefreshIndicator(
            onRefresh: () async => _checkNetworkAndFetchData(isRefresh: true),
            child: _hasNetworkError
                ? _buildNoNetworkContent()
                : _isLoading && _userDataList.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildNoNetworkContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildNoDataContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No data available.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _fetchData(isRefresh: true),
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return _userDataList.isEmpty
        ? _buildNoDataContent()
        : ListView.builder(
            controller: _scrollController,
            itemCount: _userDataList.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _userDataList.length) {
                return Center(child: CircularProgressIndicator());
              }

              VisitModel userData = _userDataList[index];
              return InkWell(
                onTap: () {
                  _showDetailsDialog(context, userData);
                },
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
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              // Use default image if documentImage is null or empty
                              userData.documentImage?.isNotEmpty == true
                                  ? userData.documentImage!
                                  : 'assets/images/defultImage/def1.png',
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      'assets/images/defultImage/def1.png'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${userData.fullName}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date: ${formatDate(userData.registrationDate)}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Expire Data: ${formatDate(userData.expiryDate)}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Status: ${userData.status}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  void _showDetailsDialog(BuildContext context, VisitModel invitation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: 300, // Example width
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        invitation.fullName ?? 'No Name',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (invitation.qrLink != null &&
                          invitation.qrLink!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              invitation.qrLink!,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/placeholder_image.png'),
                            ),
                          ),
                        ),
                      Text(
                        'Card Number: ${invitation.cardNumber ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Created At: ${invitation.expiryDate ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Registration Date: ${invitation.registrationDate ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (invitation.status != 'Blocked' &&
                                invitation.status != 'Canceld' &&
                                invitation.status != 'Expired')
                              TextButton.icon(
                                onPressed: () async {
                                  HomeCubit cubit = HomeCubit.get(context);
                                  await cubit.shareImage(invitation.qrLink!);
                                },
                                icon: Icon(Icons.share,
                                    size: 20, color: Colors.blue),
                                label: Text('Reshare'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  textStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            if (invitation.status == 'Blocked' ||
                                invitation.status == 'Canceld' ||
                                invitation.status == 'Expired')
                              TextButton.icon(
                                onPressed: () async {},
                                icon: Icon(Icons.share,
                                    size: 20, color: Colors.grey),
                                label: Text('Reshare'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  textStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            SizedBox(height: 8),
                            if (_isCancelling)
                              TextButton(
                                onPressed: null,
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Cancelling...',
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              )
                            else if (invitation.status == 'Canceld' ||
                                invitation.status == 'Expired' ||
                                invitation.status == 'Blocked')
                              TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.cancel,
                                    size: 20, color: Colors.grey),
                                label: Text('Cancel Invitation'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  textStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            if (invitation.status != 'Canceld' &&
                                invitation.status != 'Expired' &&
                                invitation.status != 'Blocked')
                              TextButton.icon(
                                onPressed: () async {
                                  setState(() {
                                    _isCancelling = true;
                                  });
                                  await _cancelInvitation(invitation.id);
                                  setState(() {
                                    _isCancelling = false;
                                    Navigator.of(context).pop(true);
                                    _checkNetworkAndFetchData(isRefresh: true);
                                  });
                                },
                                icon: Icon(Icons.cancel,
                                    size: 20, color: Colors.red),
                                label: Text('Cancel Invitation'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  textStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            SizedBox(height: 8),
                            if (invitation.status != 'Blocked')
                              TextButton.icon(
                                onPressed: () async {
                                  List<int> convertAreaIdToList(int? areaId) {
                                    return areaId != null ? [areaId] : [];
                                  }
                  
                                  await createBlackListEntry(
                                    name: invitation.fullName,
                                    documentIdno: invitation.documentId,
                                    areaIds:
                                        convertAreaIdToList(invitation.areaId),
                                    dateTimeFrom: invitation.registrationDate,
                                    dateTimeTo: invitation.expiryDate,
                                  );
                  
                                  // Close the dialog and pass true to indicate changes were made
                                  Navigator.of(context).pop(true);
                                  _checkNetworkAndFetchData(isRefresh: true);
                                },
                                icon: Icon(Icons.block,
                                    size: 20, color: Colors.deepOrange),
                                label: Text('Add To BlackList'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.deepOrange,
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                ),
                              ),
                            if (invitation.status == 'Blocked')
                              TextButton.icon(
                                onPressed: () async {
                                  List<int> convertAreaIdToList(int? areaId) {
                                    return areaId != null ? [areaId] : [];
                                  }
                  
                                  await deleteFromBlackList(
                                      invitation.documentId);
                  
                                  // Close the dialog and pass true to indicate changes were made
                                  Navigator.of(context).pop(true);
                                  _checkNetworkAndFetchData(isRefresh: true);
                                },
                                icon: Icon(Icons.delete_forever,
                                    size: 20, color: Colors.green),
                                label: Text('Delete From BlackList'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                ),
                              ),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Close',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result == true) {
        // Refresh the screen here by calling setState or any other method you use
        // Example: context.findAncestorStateOfType<YourScreenState>()?.refresh();
      }
    });
  }

  Future<void> _cancelInvitation(String? registrationId) async {
    setState(() {
      _isCancelling = true; // Set loading state to true
    });

    try {
      final response = await DioHelper.postData(
        url: '$BASE_URL$SaveApiUrl/api/v1/invitation/cancle',
        data: {'registrationId': registrationId},
        token: TokenSave!,
      );

      // Parse the response
      cancelInvitationResponse =
          CancelInvitationResponse.fromJson(response.data);

      if (cancelInvitationResponse!.statusCode == 200 &&
          cancelInvitationResponse!.succeeded) {
        // Display success message
        Fluttertoast.showToast(
            msg: cancelInvitationResponse!.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green);

        // Optionally refresh data or remove the invitation from the list
        _fetchData(isRefresh: true);
      } else {
        // Display error message from API
        Fluttertoast.showToast(
            msg: cancelInvitationResponse!.message.isNotEmpty
                ? cancelInvitationResponse!.message
                : 'Failed to cancel invitation.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      // Handle error when parsing response
      String errorMessage;
      if (e is DioError) {
        // Check if the error has a response and extract message
        if (e.response != null) {
          final errorResponse =
              CancelInvitationResponse.fromJson(e.response!.data);
          errorMessage = errorResponse.message.isNotEmpty
              ? errorResponse.message
              : 'An error occurred.';
        } else {
          errorMessage = 'An error occurred.';
        }
      } else {
        errorMessage = 'Can only cancel active invitations..';
      }

      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red);
    } finally {
      setState(() {
        _isCancelling = false; // Set loading state to false when done
      });
    }
  }

  Future<void> createBlackListEntry({
    required String? name,
    required String? documentIdno,
    required List<int>? areaIds,
    required String? dateTimeFrom,
    required String? dateTimeTo,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'documentIdno': documentIdno,
        'areaIds': areaIds ?? [],
        'dateTimeFrom': dateTimeFrom,
        'dateTimeTo': dateTimeTo,
      });

      Response response = await DioHelper.postDataToBlackList(
        url: '$BASE_URL$SaveApiUrl/api/v1/black-list/create',
        data: formData,
        token: TokenSave!,
      );

      if (response.statusCode == 201) {
        _fetchData(isRefresh: true);
        Fluttertoast.showToast(
          msg: 'BlackList entry created successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(response.data);
      } else {
        Fluttertoast.showToast(
          msg: 'The DocumentIdno already exists',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'someThing wrong, pls try again',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> deleteFromBlackList(String? documentNo) async {
    final dio = Dio();

    // Set up your headers, including the Authorization token
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $TokenSave', // Replace with your actual token
    };

    // Define the request options
    final options = Options(
      method: 'POST',
      headers: headers,
    );

    try {
      // Send the request
      final response = await dio.post(
        '$BASE_URL$SaveApiUrl/api/v1/black-list/delete',
        queryParameters: {'documentNo': documentNo},
        options: options,
      );

      // Check the response
      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        Fluttertoast.showToast(
            msg: 'Deleted Successfull', backgroundColor: Colors.green);
      } else {
        Fluttertoast.showToast(
            msg: 'this object not found', backgroundColor: Colors.red);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'this object not found', backgroundColor: Colors.red);
    }
  }
}
