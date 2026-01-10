import 'package:flutter/material.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. WELCOME SECTION
          _buildHeader(),
          const SizedBox(height: 24),

          // 2. KEY METRICS (STAT CARDS)
          _buildStatsRow(),
          const SizedBox(height: 24),

          // 3. MAIN CONTENT SPLIT (Alerts + Activity)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Recent Alerts (Flex 2)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Live Emergency Feeds",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    _buildAlertsList(),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              // Right Column: Quick Actions / Activity (Flex 1)
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "System Status",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                   
                    const SizedBox(height: 24),
                    const Text(
                      "Quick Actions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActions(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 1. Header Widget ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overview",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Text(
              "Here is what's happening with your patients today.",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
       
      ],
    );
  }

  // --- 2. Stats Row Widget ---
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard("Total Caregivers", "12", "+2 new", Icons.medical_services, Colors.blue),
        _buildStatCard("Active Patients", "8", "Stable", Icons.elderly, Colors.orange),
        _buildStatCard("Critical Alerts", "3", "Action req", Icons.warning_amber, Colors.red),
        _buildStatCard("Safe Zones", "15", "Active", Icons.map, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, String subtext, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Icon(Icons.more_horiz, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 16),
            Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                subtext,
                style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- 3. Alerts List Widget ---
  Widget _buildAlertsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: index == 0 ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              child: Icon(
                index == 0 ? Icons.notification_important : Icons.warning_amber_rounded,
                color: index == 0 ? Colors.red : Colors.orange,
                size: 20,
              ),
            ),
            title: Text(
              "Patient P00${index + 1} - Left Safezone",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Detected near Downtown area • ${index * 15} mins ago",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: index == 0 ? Colors.red : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                index == 0 ? "Resolve" : "View",
                style: TextStyle(
                  color: index == 0 ? Colors.white : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  // --- 5. Quick Actions Widget ---
  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildActionTile("Add New Patient", Icons.person_add, Colors.blue),
        const SizedBox(height: 10),
        _buildActionTile("Broadcast Message", Icons.campaign, Colors.orange),
        const SizedBox(height: 10),
        _buildActionTile("Manage Safe Zones", Icons.map_outlined, Colors.purple),
      ],
    );
  }

  Widget _buildActionTile(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}