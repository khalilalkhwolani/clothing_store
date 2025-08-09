import 'package:flutter/material.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true, // هذا يجعل الـ AppBar يظهر عند السحب لأعلى
            expandedHeight: 120,
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Track Order ',
                style: TextStyle(
                  color: AppTheme.backgroundColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      buildTimelineItem(
                        status: 'Order Placed',
                        date: 'May 25, 2025',
                        description: 'Your order has been placed.',
                        isCompleted: true,
                        isFirst: true,
                      ),
                      buildTimelineItem(
                        status: 'Order Confirmed',
                        date: 'May 26, 2025',
                        description: 'Your order has been confirmed.',
                        isCompleted: true,
                      ),
                      buildTimelineItem(
                        status: 'Shipped',
                        date: 'May 27, 2025',
                        description: 'Your order has been shipped.',
                        isCompleted: false,
                      ),
                      buildTimelineItem(
                        status: 'Out for Delivery',
                        date: '',
                        description: '',
                        isCompleted: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delivary Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // SizedBox(height: 16,),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivary address",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  "123 Main Stree , Apt 48\nsanaa ,1001\nUnited states ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // SizedBox(height: 16,),
                            child: Icon(
                              Icons.local_shipping_outlined,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivary Method",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  "Express Delivery (1-2 businass days)",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderTrackingScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Track Order"),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: GradintBottom(
                  text: "Confirm orders",
                  onPressed: () {
                    // Get.to(OrderDetailsScreen(order:ore,));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimelineItem({
    required String status,
    required String date,
    required String description,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 30,
                    color:
                        isCompleted
                            ? AppTheme.primaryColor
                            : AppTheme.textsecandery.withOpacity(0.2),
                  ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? AppTheme.primaryColor : Colors.white,
                    border: Border.all(
                      width: 2,
                      color:
                          isCompleted
                              ? AppTheme.primaryColor
                              : AppTheme.textsecandery,
                    ),
                  ),
                  child:
                      isCompleted
                          ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                          : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    color:
                        isCompleted
                            ? AppTheme.primaryColor
                            : AppTheme.textsecandery.withOpacity(0.2),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isCompleted
                              ? AppTheme.primaryColor
                              : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textsecandery,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
