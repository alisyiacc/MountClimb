import 'dart:async';

import 'package:flutter/material.dart';
import '../models/mountain.dart';
import '../services/mountain_service.dart';
import '../utils/format.dart';
import '../widgets/app_image.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/state_views.dart';
import 'mountain_detail_page.dart';

// Explore: daftar gunung + pencarian + filter tingkat kesulitan.
// Filter & pencarian dikerjakan SERVER (query PostgREST), bukan di HP:
//   GET /rest/v1/mountains?difficulty=eq.Mudah
//   GET /rest/v1/mountains?or=(name.ilike.*semeru*,location.ilike.*semeru*)
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const List<String> _categories = ['Semua', 'Mudah', 'Sedang', 'Sulit'];

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String _difficulty = 'Semua';
  String _keyword = '';
  late Future<List<Mountain>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Mountain>> _load() {
    return MountainService.getMountains(difficulty: _difficulty, search: _keyword);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  void _onSearchChanged(String value) {
    // Tunggu pengguna berhenti mengetik 400 ms supaya tidak spam request.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _keyword = value.trim();
      if (mounted) _reload();
    });
  }

  void _selectCategory(String category) {
    if (category == _difficulty) return;
    _difficulty = category;
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Text(
              'Explore',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Temukan gunung impianmu berikutnya',
              style: TextStyle(fontSize: 13, color: Color(0xFF78909C)),
            ),
            const SizedBox(height: 18),

            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF78909C)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF263238)),
                      decoration: const InputDecoration(
                        hintText: 'Cari nama gunung atau lokasi...',
                        hintStyle: TextStyle(color: Color(0xFF90A4AE), fontSize: 14),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Kategori tingkat kesulitan
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final c in _categories)
                    _CategoryChip(
                      label: c,
                      selected: c == _difficulty,
                      onTap: () => _selectCategory(c),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daftar gunung dari Supabase
            FutureBuilder<List<Mountain>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return ErrorView(
                    message: errorText(snapshot.error!),
                    onRetry: _reload,
                  );
                }
                final mountains = snapshot.data ?? const <Mountain>[];
                if (mountains.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'Gunung tidak ditemukan.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF78909C)),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mountains.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final mountain = mountains[index];
                    return _MountainListTile(
                      mountain: mountain,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MountainDetailPage(mountain: mountain),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1E88E5) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? const Color(0xFF1E88E5) : const Color(0xFFBBDEFB),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF546E7A),
          ),
        ),
      ),
    );
  }
}

class _MountainListTile extends StatelessWidget {
  final Mountain mountain;
  final VoidCallback onTap;

  const _MountainListTile({required this.mountain, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 84,
                height: 84,
                child: AppImage(
                  path: mountain.thumbnail,
                  fit: BoxFit.cover,
                  fallback: Container(
                    color: const Color(0xFFBBDEFB),
                    alignment: Alignment.center,
                    child: const Icon(Icons.terrain, color: Color(0xFF42A5F5)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mountain.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Color(0xFF78909C)),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          mountain.location,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFFFB300)),
                      const SizedBox(width: 2),
                      Text(
                        mountain.rating.toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F5FE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          mountain.difficulty,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1E88E5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatRupiah(mountain.price),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E88E5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
