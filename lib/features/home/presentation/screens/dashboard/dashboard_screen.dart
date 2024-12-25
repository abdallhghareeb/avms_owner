import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avms/core/utils/app_values.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/widgets/carousel_card.dart';
import 'package:avms/features/home/data/models/dashInfo_Model.dart';
import 'package:avms/features/home/data/models/get_all_inv.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardTabsInfo?> _dashboardInfo = Future.value(null);
  bool _hasNetwork = true;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  List<VisitModel> _recentInvitations = [];
  bool _hasMoreData = true;
  bool _hasNetworkError = false;

  @override
  void initState() {
    super.initState();
    // Initialize data fetching
    _checkNetworkAndFetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // You may want to refetch data when dependencies change
    _checkNetworkAndFetchData();
  }

  Future<void> _checkNetworkAndFetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasNetwork = false;
      });
    } else {
      setState(() {
        _hasNetwork = true;
        _currentPage = 1; // Reset to first page on network check
        _dashboardInfo = DioHelper.fetchDashInfo(context);
        _fetchRecentInvitations();
      });
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

  Future<void> _fetchRecentInvitations({int pageNumber = 1}) async {
    if (!_hasNetwork) {
      setState(() {
        _hasNetworkError = true;
      });
      return;
    }

    setState(() {
      _hasNetworkError = false;
    });

    try {
      final result = await DioHelper.fetchDataToDash(
          token: TokenSave!,
          parameters: {"PageNumber": pageNumber},
          context: context
      );

      if (result.isNotEmpty) {
        setState(() {
          _recentInvitations.addAll(result);
        });
      } else {
        if (_hasMoreData) {
          await _fetchRecentInvitations(pageNumber: pageNumber + 1);
        } else {
          setState(() {
            _hasMoreData = false;
            _isLoadingMore = false;
          });
        }
      }
    } on DioError catch (dioError) {
      print('DioError fetching invitations: ${dioError.message}');
      setState(() {
        _hasNetworkError = true;
      });
    } catch (e) {
      print('Error fetching invitations: $e');
      setState(() {
        _hasNetworkError = true;
      });
    } finally {
      // Set _isLoadingMore to false regardless of whether data was fetched or not
      setState(() {
        _isLoadingMore = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today Dashboard',style: TextStyle(
            color: Colors.white,
            fontSize: 20
        ),),
        backgroundColor:  AppColors.primaryColor,

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RefreshIndicator(
            onRefresh: _checkNetworkAndFetchData,
            child: _hasNetwork
                ? _buildDashboardContent()
                : _buildNoNetworkContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<DashboardTabsInfo?>(
          future: _dashboardInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade100,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.4,
                    viewportFraction: 1.0,
                    autoPlay: true,
                  ),
                  items: [
                    CarouselCard(
                      itemTitle: "Loading...",
                      itemCount: 0,
                      itemColor: Colors.blue,
                      itemIcon: Icons.class_,
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data available'));
            } else {
              final info = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(

                      height: SizeConfig.screenHeight * 0.20,
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.17,
                    ),
                    items: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselCard(
                          itemTitle: "Total Invitations ",
                          itemCount: info.totalInvitation,
                          itemColor: Colors.blue,
                          itemIcon: Icons.class_,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselCard(
                          itemTitle: "Entered",
                          itemCount: info.entered,
                          itemColor: Colors.green,
                          itemIcon: Icons.transit_enterexit,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselCard(
                          itemTitle: "Exited",
                          itemCount: info.exited,
                          itemColor: Colors.red,
                          itemIcon: Icons.exit_to_app,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselCard(
                          itemTitle: "Pending",
                          itemCount: info.pending,
                          itemColor: Colors.orange,
                          itemIcon: Icons.pending,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 250.w),
          child: TextButton(
            onPressed: () {
              HomeCubit.get(context).changeNavBar(index: 2);
            },
            child: Text(
              Config.Localization['SeeAll'],
              style: TextStyle(fontSize: AppSize.s18),
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification &&
                  scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent &&
                  !_isLoadingMore) {
                _currentPage++;
                _fetchRecentInvitations(pageNumber: _currentPage);
              }
              return false;
            },
            child: _recentInvitations.isEmpty && !_isLoadingMore
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'There are no invitations available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : _isLoadingMore // Check if loading more data
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: _recentInvitations.length,
              itemBuilder: (context, index) {
                VisitModel invitation = _recentInvitations[index];
                return GestureDetector(
                  onTap: () => _showDetailsDialog(context, invitation),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 100.h,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                invitation.documentImage?.isNotEmpty == true
                                    ? invitation.documentImage!
                                    : 'assets/images/defultImage/def1.png',
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/images/defultImage/def1.png'),
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
                                'Name: ${invitation.fullName}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Date: ${formatDate(invitation.registrationDate)}',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Expire Date: ${formatDate(invitation.expiryDate)}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Status: ${invitation.status}',
                                style: TextStyle(fontSize: 14, color: Colors.green),
                              ),
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
        ),


        if (_isLoadingMore)
          SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            ),
          ),
      ],
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
            onPressed: _checkNetworkAndFetchData,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, VisitModel invitation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(invitation.fullName ?? 'No Name'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (invitation.qrLink != null && invitation.qrLink!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.network(
                      invitation.qrLink!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/placeholder_image.png'),
                    ),
                  ),
                ),
              Text('Card Number: ${invitation.cardNumber ?? 'N/A'}'),
              Text('Created At: ${invitation.expiryDate ?? 'N/A'}'),
              Text('Registration Date: ${invitation.registrationDate ?? 'N/A'}'),
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
                  await cubit.shareImage(invitation.qrLink!);
                },
                child: Text('Reshare'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}