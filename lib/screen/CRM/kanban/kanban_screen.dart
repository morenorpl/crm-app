import 'package:flutter/material.dart';
import 'package:crm_app/constants/app_colors.dart';
import 'package:crm_app/widgets/header_bar.dart';
import 'controllers/crm_controller.dart';
import 'widgets/crm_board_info.dart';
import 'widgets/crm_search_panel.dart';
import 'widgets/crm_statistics_grid.dart';
import 'widgets/crm_kanban_tabs.dart';
import 'widgets/crm_prospect_card.dart';

class CrmBoardScreen extends StatefulWidget {
  final String avatarLetter;

  const CrmBoardScreen({super.key, required this.avatarLetter});

  @override
  State<CrmBoardScreen> createState() => _CrmBoardScreenState();
}

class _CrmBoardScreenState extends State<CrmBoardScreen> {
  late final CrmController _crmController;

  @override
  void initState() {
    super.initState();
    _crmController = CrmController();
    // Memuat data saat screen pertama kali dibuka
    _crmController.fetchLeads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderBar(
                  title: 'Dashboard CRM',
                  subtitle: 'Selamat datang kembali!',
                  avatarText: widget.avatarLetter,
                ),
                const SizedBox(height: 12),
                const CrmBoardInfo(),
                const SizedBox(height: 12),
                CrmSearchPanel(crmController: _crmController),
                const SizedBox(height: 14),
                const CrmStatisticsGrid(),
                const SizedBox(height: 14),
                const CrmKanbanTabs(),
                const SizedBox(height: 14),
                const CrmProspectCard(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
