import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const EventHallApp());

/// EventHall Flutter UI starter.
/// This is a front-end prototype: connect these screens to the shared API
/// before treating availability, inquiries, payments, or reservations as live.
class EventHallApp extends StatefulWidget {
  const EventHallApp({super.key});

  @override
  State<EventHallApp> createState() => _EventHallAppState();
}

class _EventHallAppState extends State<EventHallApp> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    const champagne = Color(0xFFB08B53);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventHall',
      // Enables mouse click-and-drag scrolling on Windows/Web in VS Code
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: champagne,
          brightness: Brightness.light,
          surface: const Color(0xFFFFFEFA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5EF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F5EF),
          foregroundColor: Color(0xFF242621),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFEFA),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFE5E2D8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F5EF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E2D8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E2D8)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD3B47C),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E211D),
        ),
        scaffoldBackgroundColor: const Color(0xFF151714),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151714),
          foregroundColor: Color(0xFFF3F0E8),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E211D),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFF363A32)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF292C26),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF363A32)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF363A32)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        ),
      ),
      // Preserves exact mobile aspect ratio when running on Windows Desktop or Chrome
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 520) {
              return child!;
            }
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return ColoredBox(
              color: isDark ? const Color(0xFF0D0E0C) : const Color(0xFFEAE6DC),
              child: Center(
                child: Container(
                  width: 430,
                  height: constraints.maxHeight > 900 ? 880 : constraints.maxHeight,
                  margin: constraints.maxHeight > 900
                      ? const EdgeInsets.symmetric(vertical: 16)
                      : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: constraints.maxHeight > 900
                        ? BorderRadius.circular(32)
                        : BorderRadius.zero,
                    border: Border.all(
                      color: isDark ? const Color(0xFF2C3029) : const Color(0xFFD6D1C4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: Size(
                        430,
                        constraints.maxHeight > 900 ? 880 : constraints.maxHeight,
                      ),
                    ),
                    child: child!,
                  ),
                ),
              ),
            );
          },
        );
      },
      home: EventHallShell(
        darkMode: _darkMode,
        onThemeChanged: (value) => setState(() => _darkMode = value),
      ),
    );
  }
}

class EventHallShell extends StatefulWidget {
  const EventHallShell({super.key, required this.darkMode, required this.onThemeChanged});
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<EventHallShell> createState() => _EventHallShellState();
}

class _EventHallShellState extends State<EventHallShell> {
  int _tab = 0;

  void _openInquiry() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const InquiryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onExplore: () => setState(() => _tab = 1), onInquiry: _openInquiry),
      ExploreScreen(onInquiry: _openInquiry),
      const MyEventScreen(),
      ProfileScreen(darkMode: widget.darkMode, onThemeChanged: widget.onThemeChanged),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore_rounded), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note_rounded), label: 'My Event'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onExplore, required this.onInquiry});
  final VoidCallback onExplore;
  final VoidCallback onInquiry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const BrandLockup(),
          actions: [
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => _showInfo(context, 'Notifications', 'Booking updates and reminders will appear here.'),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text('A PLACE FOR YOUR NEXT CHAPTER', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w800, color: const Color(0xFF9A7845))),
              const SizedBox(height: 12),
              Text('Beautiful occasions.\nEffortless bookings.', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 38, height: 1.03, fontWeight: FontWeight.w500, letterSpacing: -1.5)),
              const SizedBox(height: 11),
              Text('Find a setting that feels like yours, then plan the details with our team.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5)),
              const SizedBox(height: 20),
              VenueHero(onTap: onExplore),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onInquiry,
                icon: const Icon(Icons.event_available_outlined),
                label: const Text('Check your date'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: const Color(0xFFB08B53), foregroundColor: const Color(0xFF211D15)),
              ),
              const SizedBox(height: 9),
              Center(child: Text('An inquiry is not a confirmed reservation.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))),
              const SizedBox(height: 30),
              SectionHeading(title: 'Find your kind of room', action: 'See all', onTap: onExplore),
              const SizedBox(height: 14),
              SizedBox(
                height: 205,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: demoSpaces.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 13),
                  itemBuilder: (context, index) => SizedBox(width: 265, child: SpaceCard(space: demoSpaces[index], onTap: onExplore)),
                ),
              ),
              const SizedBox(height: 30),
              const _TrustPanel(),
            ]),
          ),
        ),
      ],
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.onInquiry});
  final VoidCallback onInquiry;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _filter = 'All spaces';
  final _filters = const ['All spaces', 'Weddings', 'Celebrations', 'Corporate'];

  @override
  Widget build(BuildContext context) {
    final spaces = _filter == 'All spaces'
        ? demoSpaces
        : demoSpaces.where((space) => space.tags.contains(_filter)).toList();
    return CustomScrollView(
      slivers: [
        const SliverAppBar(pinned: true, title: BrandLockup()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          sliver: SliverList(delegate: SliverChildListDelegate([
            Text('THE VENUE', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w800, color: const Color(0xFF9A7845))),
            const SizedBox(height: 8),
            Text('Explore the spaces', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: -1)),
            const SizedBox(height: 7),
            Text('Thoughtful rooms for gatherings big and small.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 18),
            SizedBox(height: 42, child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => ChoiceChip(
                label: Text(_filters[i]),
                selected: _filter == _filters[i],
                onSelected: (_) => setState(() => _filter = _filters[i]),
              ),
            )),
            const SizedBox(height: 16),
            ...spaces.map((space) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: SpaceDetailCard(space: space, onInquiry: widget.onInquiry),
            )),
            const _TrustPanel(),
          ])),
        ),
      ],
    );
  }
}

class MyEventScreen extends StatelessWidget {
  const MyEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SliverAppBar(pinned: true, title: BrandLockup()),
      SliverPadding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 30), sliver: SliverList(delegate: SliverChildListDelegate([
        Text('YOUR EVENT, AT A GLANCE', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w800, color: const Color(0xFF9A7845))),
        const SizedBox(height: 8),
        Text('My Event', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w500, letterSpacing: -1)),
        const SizedBox(height: 18),
        Card(child: Padding(padding: const EdgeInsets.all(21), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.event_note_rounded)),
          const SizedBox(height: 16),
          Text('Your plans will live here', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Text('Once you submit an inquiry, you can follow its status, review quotes and terms, and access booking documents here.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 18),
          const _StatusLine(number: '01', title: 'Inquiry received', detail: 'A request reference and next steps are provided.'),
          const _StatusLine(number: '02', title: 'Quote and review', detail: 'Review the exact quote version and booking terms.'),
          const _StatusLine(number: '03', title: 'Reservation confirmed', detail: 'Confirmation follows staff approval and required conditions.'),
        ]))),
        const SizedBox(height: 14),
        Card(child: ListTile(leading: const Icon(Icons.lock_outline_rounded), title: const Text('Secure booking access'), subtitle: const Text('Sign in or use a secure access link to view private event details.'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () => _showInfo(context, 'Secure access', 'Connect this screen to the managed sign-in provider and customer booking API.'))),
      ]))),
    ]);
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.darkMode, required this.onThemeChanged});
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SliverAppBar(pinned: true, title: BrandLockup()),
      SliverPadding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 30), sliver: SliverList(delegate: SliverChildListDelegate([
        Text('PREFERENCES & SUPPORT', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w800, color: const Color(0xFF9A7845))),
        const SizedBox(height: 8),
        Text('Profile', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w500, letterSpacing: -1)),
        const SizedBox(height: 18),
        Card(child: SwitchListTile(
          value: darkMode,
          onChanged: onThemeChanged,
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Dark appearance'),
          subtitle: const Text('Use EventHall charcoal and champagne tones.'),
        )),
        const SizedBox(height: 12),
        Card(child: Column(children: [
          ListTile(leading: const Icon(Icons.notifications_active_outlined), title: const Text('Contact preferences'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () => _showInfo(context, 'Contact preferences', 'Manage booking updates separately from optional marketing messages.')),
          const Divider(height: 1, indent: 56),
          ListTile(leading: const Icon(Icons.accessibility_new_rounded), title: const Text('Accessibility'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () => _showInfo(context, 'Accessibility', 'Text scaling and screen-reader support follow your device settings.')),
          const Divider(height: 1, indent: 56),
          ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('Privacy and policies'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () => _showInfo(context, 'Privacy and policies', 'Connect approved EventHall privacy, booking, payment, and cancellation policies here.')),
        ])),
        const SizedBox(height: 12),
        Card(child: ListTile(leading: const Icon(Icons.support_agent_rounded), title: const Text('Contact the venue'), subtitle: const Text('Questions about a tour or your event?'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () => _showInfo(context, 'Contact EventHall', 'Add the venue’s approved phone number, email, address, and opening hours.'))),
        const SizedBox(height: 18),
        Text('EventHall app preview · Customer experience', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]))),
    ]);
  }
}

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _guests = TextEditingController();
  final _message = TextEditingController();
  String? _eventType;
  String? _room;
  DateTime? _date;
  TimeOfDay? _start;
  TimeOfDay? _end;
  bool _terms = false;
  bool _marketing = false;
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _guests.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
      initialDate: _date ?? now.add(const Duration(days: 30)),
    );
    if (result != null) setState(() => _date = result);
  }

  Future<void> _chooseTime({required bool isStart}) async {
    final result = await showTimePicker(context: context, initialTime: isStart ? (_start ?? const TimeOfDay(hour: 17, minute: 0)) : (_end ?? const TimeOfDay(hour: 23, minute: 0)));
    if (result != null) setState(() => isStart ? _start = result : _end = result);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null || _start == null || _end == null || _eventType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose event type, date, start time, and end time.')));
      return;
    }
    if (_minutes(_end!) <= _minutes(_start!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End time must be later than start time.')));
      return;
    }
    if (!_terms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to be contacted about this inquiry.')));
      return;
    }
    setState(() => _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _sending = false);
    await showDialog<void>(context: context, builder: (context) => AlertDialog(
      icon: const Icon(Icons.check_circle_outline_rounded, size: 38),
      title: const Text('Request details ready'),
      content: const Text('This demo does not send or reserve anything yet. Connect the form to the EventHall API to check live availability, create an inquiry reference, and notify the venue team.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it'))],
    ));
  }

  int _minutes(TimeOfDay value) => value.hour * 60 + value.minute;
  String _dateLabel() => _date == null ? 'Choose a date' : '${_date!.day.toString().padLeft(2, '0')}/${_date!.month.toString().padLeft(2, '0')}/${_date!.year}';
  String _timeLabel(TimeOfDay? value) => value == null ? 'Choose time' : value.format(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date inquiry'), leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded))),
      body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 30), children: [
        Text('Start with the essentials', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: -1)),
        const SizedBox(height: 7),
        Text('The venue team will review your request. Your date is not reserved by submitting this form.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.45)),
        const SizedBox(height: 21),
        DropdownButtonFormField<String>(
          initialValue: _eventType,
          decoration: const InputDecoration(labelText: 'Event type'),
          items: const ['Wedding', 'Birthday or celebration', 'Corporate gathering', 'Other'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => _eventType = v),
          validator: (v) => v == null ? 'Choose an event type' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _room,
          decoration: const InputDecoration(labelText: 'Space preference'),
          items: ['No preference', ...demoSpaces.map((e) => e.name)].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => _room = v),
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _guests, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Estimated guest count', hintText: 'For example, 120'), validator: (v) { final n = int.tryParse(v ?? ''); return n == null || n < 1 ? 'Enter a valid guest count' : null; }),
        const SizedBox(height: 12),
        OutlinedButton.icon(onPressed: _chooseDate, icon: const Icon(Icons.calendar_month_outlined), label: Align(alignment: Alignment.centerLeft, child: Text(_dateLabel())), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 14))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () => _chooseTime(isStart: true), icon: const Icon(Icons.schedule_rounded), label: Text(_timeLabel(_start)), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)))),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton.icon(onPressed: () => _chooseTime(isStart: false), icon: const Icon(Icons.schedule_rounded), label: Text(_timeLabel(_end)), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)))),
        ]),
        const SizedBox(height: 12),
        TextFormField(controller: _name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Your name'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address'), validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email address' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _message, maxLines: 4, decoration: const InputDecoration(labelText: 'Tell us a little about your event', hintText: 'Your plans, questions, or anything helpful…')),
        const SizedBox(height: 6),
        CheckboxListTile(value: _terms, onChanged: (v) => setState(() => _terms = v ?? false), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: const Text('I agree to be contacted about this inquiry.', style: TextStyle(fontSize: 14)), subtitle: const Text('Required to respond to your request.', style: TextStyle(fontSize: 12))),
        CheckboxListTile(value: _marketing, onChanged: (v) => setState(() => _marketing = v ?? false), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: const Text('Send me occasional venue news and offers.', style: TextStyle(fontSize: 14)), subtitle: const Text('Optional marketing consent.', style: TextStyle(fontSize: 12))),
        const SizedBox(height: 8),
        FilledButton(onPressed: _sending ? null : _submit, style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: const Color(0xFFB08B53), foregroundColor: const Color(0xFF211D15)), child: _sending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Review date request')),
        const SizedBox(height: 10),
        Text('Availability is advisory until staff review and a confirmed reservation.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ])),
    );
  }
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 34, height: 34, decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFD3B47C), size: 19)),
    const SizedBox(width: 10),
    Text('EventHall', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
  ]);
}

class VenueHero extends StatelessWidget {
  const VenueHero({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Explore EventHall venue photography',
    child: GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Stack(alignment: Alignment.bottomLeft, children: [
          SizedBox(height: 245, width: double.infinity, child: VenueImage(url: demoSpaces.first.image, fit: BoxFit.cover)),
          Container(height: 245, decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xCC10110E)]))),
          Padding(padding: const EdgeInsets.all(18), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('A PLACE TO GATHER', style: TextStyle(color: Color(0xFFE7D2A5), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            const Text('Find a room that feels right', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(children: [const Text('Explore venue spaces', style: TextStyle(color: Colors.white70, fontSize: 13)), const SizedBox(width: 5), Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: .8), size: 16)]),
          ])),
        ]),
      ),
    ),
  );
}

class SpaceCard extends StatelessWidget {
  const SpaceCard({super.key, required this.space, required this.onTap});
  final VenueSpace space;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, child: InkWell(onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(child: Stack(fit: StackFit.expand, children: [VenueImage(url: space.image, fit: BoxFit.cover), Align(alignment: Alignment.bottomLeft, child: Padding(padding: const EdgeInsets.all(12), child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: Colors.black.withValues(alpha: .62), borderRadius: BorderRadius.circular(30)), child: Text(space.capacity, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))))])),
    Padding(padding: const EdgeInsets.fromLTRB(14, 11, 14, 12), child: Row(children: [Expanded(child: Text(space.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))), const Icon(Icons.arrow_outward_rounded, size: 17)])),
  ])));
}

class SpaceDetailCard extends StatelessWidget {
  const SpaceDetailCard({super.key, required this.space, required this.onInquiry});
  final VenueSpace space;
  final VoidCallback onInquiry;

  @override
  Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(height: 190, width: double.infinity, child: VenueImage(url: space.image, fit: BoxFit.cover)),
    Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(space.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))), const Icon(Icons.auto_awesome_outlined, color: Color(0xFF9A7845), size: 19)]),
      const SizedBox(height: 5),
      Text(space.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4)),
      const SizedBox(height: 12),
      Wrap(spacing: 7, runSpacing: 7, children: [InfoChip(icon: Icons.people_alt_outlined, label: space.capacity), ...space.amenities.take(2).map((item) => InfoChip(icon: Icons.check_circle_outline_rounded, label: item))]),
      const SizedBox(height: 14),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: onInquiry, icon: const Icon(Icons.calendar_month_outlined), label: const Text('Ask about this space'))),
    ])),
  ]));
}

class VenueImage extends StatelessWidget {
  const VenueImage({super.key, required this.url, this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: fit,
    loadingBuilder: (context, child, progress) => progress == null ? child : Container(color: Theme.of(context).colorScheme.surfaceContainerHighest, child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
    errorBuilder: (context, error, stack) => Container(color: Theme.of(context).colorScheme.surfaceContainerHighest, child: const Center(child: Icon(Icons.image_not_supported_outlined, size: 36))),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, required this.action, required this.onTap});
  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -.5))), TextButton(onPressed: onTap, child: Text(action))]);
}

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: .55), borderRadius: BorderRadius.circular(30)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14), const SizedBox(width: 5), Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600))]));
}

class _TrustPanel extends StatelessWidget {
  const _TrustPanel();

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: .45), borderRadius: BorderRadius.circular(19)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Icon(Icons.verified_user_outlined, color: Color(0xFF9A7845)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Thoughtful planning, with a real team', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('Your request is reviewed by staff. A quote or date inquiry alone does not reserve a space.', style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45, color: Theme.of(context).colorScheme.onSurfaceVariant))])),
  ]));
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.number, required this.title, required this.detail});
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 13), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(10)), child: Text(number, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800))),
    const SizedBox(width: 11),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 2), Text(detail, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35))])),
  ]));
}

class VenueSpace {
  const VenueSpace({required this.name, required this.capacity, required this.description, required this.image, required this.tags, required this.amenities});
  final String name;
  final String capacity;
  final String description;
  final String image;
  final List<String> tags;
  final List<String> amenities;
}

const demoSpaces = <VenueSpace>[
  VenueSpace(
    name: 'The Grand Hall',
    capacity: 'Up to 220 guests*',
    description: 'An elegant, flexible setting for ceremonies, receptions, and memorable celebrations.',
    image: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=1100&q=82',
    tags: ['Weddings', 'Celebrations', 'Corporate'],
    amenities: ['Flexible layouts', 'Reception ready'],
  ),
  VenueSpace(
    name: 'The Gallery Room',
    capacity: 'Up to 90 guests*',
    description: 'A bright, intimate room suited to dinners, smaller weddings, and team gatherings.',
    image: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=1100&q=82',
    tags: ['Weddings', 'Celebrations', 'Corporate'],
    amenities: ['Daylight', 'Private setting'],
  ),
  VenueSpace(
    name: 'The Courtyard',
    capacity: 'Seasonal availability*',
    description: 'An open-air backdrop for relaxed receptions and outdoor celebrations.',
    image: 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=1100&q=82',
    tags: ['Weddings', 'Celebrations'],
    amenities: ['Outdoor setting', 'Photo moments'],
  ),
];

void _showInfo(BuildContext context, String title, String message) {
  showDialog<void>(context: context, builder: (context) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
}