import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/add_theater_controller.dart';
import '../models/theater_screen.dart';
import '../models/theater_time_slot.dart';
import 'screen_form_dialog.dart';
import 'time_slots_management_dialog.dart';

class TheaterScreensSection extends ConsumerStatefulWidget {
  const TheaterScreensSection({super.key});

  @override
  ConsumerState<TheaterScreensSection> createState() => _TheaterScreensSectionState();
}

class _TheaterScreensSectionState extends ConsumerState<TheaterScreensSection> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addTheaterControllerProvider);
    final screens = controller.screens;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theater Screens',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Configure the screens available in your theater. You can add multiple screens, each with its own capacity, pricing, and time slots.',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildGuidelinesCard(theme),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Screens (${screens.length})',
              style: theme.textTheme.headlineSmall,
            ),
            ElevatedButton.icon(
              onPressed: _addScreen,
              icon: const Icon(Icons.add),
              label: const Text('Add Screen'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (screens.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No screens added yet. Click \'Add Screen\' to get started.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: screens.length,
            itemBuilder: (context, index) {
              return _buildScreenCard(screens[index], theme);
            },
          ),
      ],
    );
  }

  Widget _buildGuidelinesCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.secondaryContainer.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guidelines for Managing Screens',
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSecondaryContainer),
            ),
            const SizedBox(height: 12),
            _buildGuidelineItem(
              theme,
              icon: Icons.screenshot_monitor,
              text: 'Add each screen with its specific name, capacity, and price.',
            ),
            _buildGuidelineItem(
              theme,
              icon: Icons.schedule,
              text: 'Define available time slots for each screen.',
            ),
            _buildGuidelineItem(
              theme,
              icon: Icons.edit,
              text: 'You can edit or delete screens at any time.',
            ),
            _buildGuidelineItem(
              theme,
              icon: Icons.info_outline,
              text: 'Ensure all information is accurate to avoid booking issues.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(ThemeData theme, {required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: theme.colorScheme.onSecondaryContainer))),
        ],
      ),
    );
  }

  Widget _buildScreenCard(TheaterScreen screen, ThemeData theme) {
    final controller = ref.read(addTheaterControllerProvider);
    final screenTimeSlots = controller.getScreenTimeSlots(screen.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    screen.screenName,
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editScreen(screen);
                    } else if (value == 'delete') {
                      _confirmDeleteScreen(screen.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Capacity: ${screen.allowedCapacity}'),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Price: \u20b9${screen.originalHourlyPrice.toStringAsFixed(2)}/hr'),
              ],
            ), 
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time Slots (${screenTimeSlots.length})',
                  style: theme.textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => _manageTimeSlots(screen),
                  child: const Text('Manage Slots'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (screenTimeSlots.isEmpty)
              const Text('No time slots configured for this screen.', style: TextStyle(color: Colors.grey))
            else
              _buildTimeSlotsList(screenTimeSlots, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsList(List<TheaterTimeSlot> slots, ThemeData theme) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: slots.map((slot) {
        return Chip(
          label: Text('${slot.startTime} - ${slot.endTime}'),
          backgroundColor: theme.colorScheme.secondaryContainer,
          labelStyle: TextStyle(color: theme.colorScheme.onSecondaryContainer),
        );
      }).toList(),
    );
  }

  void _addScreen() {
    final controller = ref.read(addTheaterControllerProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScreenFormDialog(
          onSave: (newScreen) {
            controller.addScreen(newScreen);
            Navigator.of(context).pop();
          },
          existingScreens: controller.screens,
        );
      },
    );
  }

  void _editScreen(TheaterScreen screen) {
    final controller = ref.read(addTheaterControllerProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScreenFormDialog(
          screen: screen,
          onSave: (updatedScreen) {
            controller.updateScreen(updatedScreen);
            Navigator.of(context).pop();
          },
          existingScreens: controller.screens,
        );
      },
    );
  }

  void _confirmDeleteScreen(String screenId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this screen and all its time slots?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                ref.read(addTheaterControllerProvider).deleteScreen(screenId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _manageTimeSlots(TheaterScreen screen) {
    final controller = ref.read(addTheaterControllerProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimeSlotsManagementDialog(
          screen: screen,
          onSlotsUpdated: (updatedSlots) {
            controller.updateScreenTimeSlots(screen.id, updatedSlots);
          },
          existingSlots: controller.getScreenTimeSlots(screen.id),
          basePrice: screen.originalHourlyPrice,
        );
      },
    );
  }
}