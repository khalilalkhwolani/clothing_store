import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/admin/add_catagory_screen.dart';

import 'package:myprojectshop/admin/add_products_screen.dart';
import 'package:myprojectshop/admin/manage_products_screen.dart';
import 'package:myprojectshop/theme/theme.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,

        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _DashboardCard(
              title: 'Manage Products',
              icon: Icons.inventory,
              onTap: () => Get.to(() => ManageProductsScreen()),
            ),
            _DashboardCard(
              title: 'Add Product',
              icon: Icons.add_box,
              onTap: () => Get.to(() => AddProductsScreen()),
            ),
            _DashboardCard(
              title: 'Users',
              icon: Icons.person,
              onTap: () => Get.to(() => AddProductsScreen()),
            ),
            _DashboardCard(
              title: 'Total Product ',
              icon: Icons.production_quantity_limits,
              onTap: () => Get.to(() => AddProductsScreen()),
            ),
            _DashboardCard(
              title: 'Total Orders ',
              icon: Icons.production_quantity_limits,
              onTap: () => Get.to(() => AddProductsScreen()),
            ),
            _DashboardCard(
              title: 'Add Catgory ',
              icon: Icons.card_travel,
              onTap: () => Get.to(() => AddCatagoryScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
