import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// --- 1. نماذج البيانات (Data Models) - (No changes needed here) ---
class CropFollowUpData {
  final String cropId;
  final String cropName;
  final String cropType;
  final DateTime plantingDate;
  final DateTime? expectedHarvestDate;
  final String currentGrowthStage;
  final String? coverImageAssetPath;
  final DateTime? lastInspectionDate;
  final String? lastInspectionStatus;
  final String? lastInspectionReportId;
  List<RecommendedAction> recommendedActions;
  List<CropLogEntry> logEntries;

  CropFollowUpData({
    required this.cropId,
    required this.cropName,
    required this.cropType,
    required this.plantingDate,
    this.expectedHarvestDate,
    required this.currentGrowthStage,
    this.coverImageAssetPath,
    this.lastInspectionDate,
    this.lastInspectionStatus,
    this.lastInspectionReportId,
    this.recommendedActions = const [],
    this.logEntries = const [],
  });
}

class RecommendedAction {
  final String id;
  final String description;
  final IconData iconData;
  final DateTime? dueDate;
  bool isDone;

  RecommendedAction({
    required this.id,
    required this.description,
    required this.iconData,
    this.dueDate,
    this.isDone = false,
  });
}

class CropLogEntry {
  final String id;
  final DateTime date;
  final String note;
  final String? photoAssetPath;

  CropLogEntry({
    required this.id,
    required this.date,
    required this.note,
    this.photoAssetPath,
  });
}

// --- 2. صفحة متابعة المحصول ---
class CropFollowUpScreen extends StatefulWidget {
  final String cropId;
  final String? initialCropName;
  final String? initialCropType;
  final DateTime? initialPlantingDate;
  final DateTime? initialExpectedHarvestDate;
  final String? initialCurrentGrowthStage;
  final String? initialCoverImageAssetPath;
  final DateTime? initialLastInspectionDate;
  final String? initialLastInspectionStatus;
  final String? initialLastInspectionReportId;

  const CropFollowUpScreen({
    super.key,
    required this.cropId,
    this.initialCropName,
    this.initialCropType,
    this.initialPlantingDate,
    this.initialExpectedHarvestDate,
    this.initialCurrentGrowthStage,
    this.initialCoverImageAssetPath,
    this.initialLastInspectionDate,
    this.initialLastInspectionStatus,
    this.initialLastInspectionReportId,
  });

  @override
  State<CropFollowUpScreen> createState() => _CropFollowUpScreenState();
}

class _CropFollowUpScreenState extends State<CropFollowUpScreen> {
  late CropFollowUpData _cropData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Pass all initial data from the widget to the loading function
    _loadCropData(isInitialLoad: true);
  }

  // Simulates fetching data from an API
  Future<void> _loadCropData({bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      setState(() => _isLoading = true);
    }
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // In a real app, this data would come from a network request.
    // The initial values from the widget are used here.
    setState(() {
      _cropData = CropFollowUpData(
        cropId: widget.cropId,
        cropName: widget.initialCropName ?? "متابعة محصول القمح",
        cropType: widget.initialCropType ?? "قمح",
        plantingDate:
            widget.initialPlantingDate ??
            DateTime.now().subtract(const Duration(days: 30)),
        expectedHarvestDate:
            widget.initialExpectedHarvestDate ??
            DateTime.now().add(const Duration(days: 60)),
        currentGrowthStage:
            widget.initialCurrentGrowthStage ?? "مرحلة النمو الخضري",
        coverImageAssetPath:
            widget.initialCoverImageAssetPath ?? "imgs/wheat_field.png",
        lastInspectionDate: widget.initialLastInspectionDate,
        lastInspectionStatus: widget.initialLastInspectionStatus,
        lastInspectionReportId: widget.initialLastInspectionReportId,
        recommendedActions: [
          RecommendedAction(
            id: "1",
            description: "فحص رطوبة التربة وزيادة الري",
            iconData: Icons.water_drop_outlined,
            dueDate: DateTime.now().add(const Duration(days: 2)),
            isDone: true,
          ),
          RecommendedAction(
            id: "2",
            description: "تطبيق الدفعة الأولى من السماد النيتروجيني",
            iconData: Icons.eco_outlined,
            dueDate: DateTime.now().add(const Duration(days: 7)),
          ),
          RecommendedAction(
            id: "3",
            description: "مراقبة ظهور الآفات الحشرية",
            iconData: Icons.bug_report_outlined,
            dueDate: DateTime.now().add(const Duration(days: 10)),
          ),
        ],
        logEntries: [
          CropLogEntry(
            id: "log1",
            date: DateTime.now().subtract(const Duration(days: 2)),
            note: "تمت عملية الري الأولية بنجاح، والتربة تبدو رطبة بشكل جيد.",
          ),
        ],
      );
      _isLoading = false;
    });
  }

  // --- UI Builder Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadCropData,
                child: AnimationLimiter(
                  child: CustomScrollView(
                    slivers: [
                      _buildSliverAppBar(),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 375),
                            childAnimationBuilder:
                                (widget) => SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(child: widget),
                                ),
                            children: _buildContentCards(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLogEntrySheet,
        backgroundColor: Colors.green.shade600,
        tooltip: 'إضافة ملاحظة جديدة',
        child: const Icon(Icons.add_comment_outlined, color: Colors.white),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      floating: true,
      backgroundColor: Colors.green.shade700,
      elevation: 4,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _cropData.cropName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 2, color: Colors.black45)],
          ),
        ),
        background:
            _cropData.coverImageAssetPath != null
                ? Image.asset(
                  _cropData.coverImageAssetPath!,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.4),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Container(color: Colors.green.shade400),
                )
                : Container(color: Colors.green.shade400),
      ),
    );
  }

  List<Widget> _buildContentCards() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          "النوع: ${_cropData.cropType} | المرحلة: ${_cropData.currentGrowthStage}",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
      ),
      _buildSectionCard(
        title: "معلومات المحصول",
        icon: Icons.info_outline,
        content: _buildBasicInfoContent(),
      ),
      if (_cropData.lastInspectionDate != null)
        _buildSectionCard(
          title: "ملخص آخر فحص",
          icon: Icons.assignment_turned_in_outlined,
          content: _buildLastInspectionSummary(),
        ),
      _buildSectionCard(
        title: "المهام الموصى بها",
        icon: Icons.list_alt_outlined,
        content: _buildRecommendedActions(),
      ),
      _buildSectionCard(
        title: "سجل المتابعة",
        icon: Icons.history_edu_outlined,
        content: _buildLogEntries(),
      ),
      const SizedBox(height: 80), // Space for FAB
    ];
  }

  // --- Card Content Widgets ---

  Widget _buildBasicInfoContent() {
    return Column(
      children: [
        _buildInfoRow(
          Icons.calendar_today_outlined,
          "تاريخ الزراعة",
          _formatDate(_cropData.plantingDate),
        ),
        if (_cropData.expectedHarvestDate != null)
          _buildInfoRow(
            Icons.event_available_outlined,
            "الحصاد المتوقع",
            _formatDate(_cropData.expectedHarvestDate!),
          ),
      ],
    );
  }

  Widget _buildLastInspectionSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          Icons.date_range_outlined,
          "تاريخ الفحص",
          _formatDate(_cropData.lastInspectionDate!),
        ),
        _buildInfoRow(
          Icons.check_circle_outline,
          "الحالة",
          _cropData.lastInspectionStatus ?? "غير محدد",
        ),
        const SizedBox(height: 12),
        if (_cropData.lastInspectionReportId != null)
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long_outlined, size: 20),
              label: const Text("عرض التقرير الكامل"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
              onPressed:
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'سيتم عرض التقرير رقم: ${_cropData.lastInspectionReportId}',
                      ),
                    ),
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendedActions() {
    if (_cropData.recommendedActions.isEmpty) {
      return const Text("لا توجد مهام حاليًا.", textAlign: TextAlign.center);
    }

    return Column(
      children:
          _cropData.recommendedActions.map((action) {
            final color = action.isDone ? Colors.green : Colors.amber;
            return Card(
              elevation: 0,
              color: color.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: color.shade200),
              ),
              child: CheckboxListTile(
                title: Text(action.description),
                subtitle:
                    action.dueDate != null
                        ? Text(
                          "تاريخ الاستحقاق: ${_formatDate(action.dueDate!)}",
                        )
                        : null,
                value: action.isDone,
                onChanged:
                    (bool? newValue) =>
                        setState(() => action.isDone = newValue!),
                secondary: Icon(action.iconData, color: color.shade700),
                activeColor: Colors.green.shade600,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildLogEntries() {
    if (_cropData.logEntries.isEmpty) {
      return const Text("لا توجد ملاحظات مسجلة.", textAlign: TextAlign.center);
    }

    return Column(
      children:
          _cropData.logEntries.reversed.map((entry) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.speaker_notes_outlined,
                      color: Colors.grey.shade500,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.note,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatDateTime(entry.date),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  // --- Helper and Utility Widgets ---

  void _showAddLogEntrySheet() {
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'إضافة ملاحظة جديدة',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'اكتب ملاحظتك هنا...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_task_outlined),
                  label: const Text('إضافة الملاحظة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    if (noteController.text.isNotEmpty) {
                      final newEntry = CropLogEntry(
                        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
                        date: DateTime.now(),
                        note: noteController.text,
                      );
                      setState(() => _cropData.logEntries.add(newEntry));
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade100, Colors.green.shade50],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.green.shade700, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16.0), child: content),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }

  // --- Date Formatting ---
  String _formatDate(DateTime date) => "${date.year}/${date.month}/${date.day}";
  String _formatDateTime(DateTime date) =>
      "${_formatDate(date)}  ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
}
