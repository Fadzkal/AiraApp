import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F7),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildForumTab(),
                _buildArticlesTab(),
                _buildTipsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _showCreatePostDialog,
              backgroundColor: const Color(0xFF00695C),
              icon: const Icon(Icons.add),
              label: const Text('Buat Postingan'),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00695C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people,
                  color: Color(0xFF00695C),
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Komunitas ISPA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00695C),
                      ),
                    ),
                    Text(
                      'Berbagi & Belajar Bersama',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4DD0E1), Color(0xFF26A69A)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Mari bersama-sama mencegah ISPA dengan berbagi pengalaman dan informasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF00695C),
          borderRadius: BorderRadius.circular(15),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Forum'),
          Tab(text: 'Artikel'),
          Tab(text: 'Tips'),
        ],
      ),
    );
  }

  Widget _buildForumTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildForumPost(
          userName: 'Dr. Sarah Wijaya',
          userRole: 'Dokter Spesialis Paru',
          timeAgo: '2 jam yang lalu',
          content:
              'Musim hujan telah tiba. Penting untuk menjaga kualitas udara di rumah dan meningkatkan daya tahan tubuh. Beberapa hal yang perlu diperhatikan:\n\n1. Pastikan ventilasi rumah baik\n2. Jaga kelembaban ruangan\n3. Konsumsi makanan bergizi\n4. Istirahat yang cukup',
          likes: 245,
          comments: 32,
          isExpert: true,
        ),
        const SizedBox(height: 15),
        _buildForumPost(
          userName: 'Budi Santoso',
          userRole: 'Member',
          timeAgo: '5 jam yang lalu',
          content:
              'Anak saya (4 tahun) sering batuk-batuk akhir-akhir ini. Kualitas udara di rumah menunjukkan PM2.5 agak tinggi. Ada saran untuk mengatasi ini?',
          likes: 87,
          comments: 24,
          isExpert: false,
        ),
        const SizedBox(height: 15),
        _buildForumPost(
          userName: 'Ns. Lisa Permata',
          userRole: 'Perawat Pediatrik',
          timeAgo: '1 hari yang lalu',
          content:
              'Tips mencegah ISPA pada balita:\n\n✓ Hindari paparan asap rokok\n✓ Jaga kebersihan tangan\n✓ Berikan ASI eksklusif\n✓ Lengkapi imunisasi\n✓ Monitor kualitas udara ruangan',
          likes: 312,
          comments: 45,
          isExpert: true,
        ),
      ],
    );
  }

  Widget _buildForumPost({
    required String userName,
    required String userRole,
    required String timeAgo,
    required String content,
    required int likes,
    required int comments,
    required bool isExpert,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    isExpert ? const Color(0xFF00695C) : Colors.grey[300],
                child: Text(
                  userName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (isExpert) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF00695C),
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      userRole,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.thumb_up_outlined,
                label: likes.toString(),
                onTap: () {},
              ),
              const SizedBox(width: 20),
              _buildActionButton(
                icon: Icons.comment_outlined,
                label: comments.toString(),
                onTap: () {},
              ),
              const Spacer(),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: 'Bagikan',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildArticleCard(
          title: 'Memahami ISPA: Penyebab dan Pencegahan',
          author: 'Dr. Ahmad Hidayat',
          readTime: '5 menit',
          image: Icons.medical_information,
          category: 'Edukasi',
        ),
        const SizedBox(height: 15),
        _buildArticleCard(
          title: 'Hubungan Kualitas Udara dengan Kesehatan Pernapasan',
          author: 'Prof. Siti Rahayu',
          readTime: '8 menit',
          image: Icons.air,
          category: 'Penelitian',
        ),
        const SizedBox(height: 15),
        _buildArticleCard(
          title: 'Peran Orang Tua dalam Mencegah ISPA pada Anak',
          author: 'Ns. Maya Kusuma',
          readTime: '6 menit',
          image: Icons.family_restroom,
          category: 'Parenting',
        ),
        const SizedBox(height: 15),
        _buildArticleCard(
          title: 'Teknologi Monitor Udara untuk Kesehatan Keluarga',
          author: 'Ir. Doni Prasetyo',
          readTime: '7 menit',
          image: Icons.sensors,
          category: 'Teknologi',
        ),
      ],
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String author,
    required String readTime,
    required IconData image,
    required String category,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4DD0E1), Color(0xFF26A69A)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Center(
              child: Icon(
                image,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00695C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF00695C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person_outline,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      readTime,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTipCard(
          icon: Icons.home,
          title: 'Tips Menjaga Kualitas Udara di Rumah',
          tips: [
            'Buka jendela secara teratur untuk sirkulasi udara',
            'Gunakan air purifier jika diperlukan',
            'Hindari merokok di dalam rumah',
            'Bersihkan debu secara rutin',
            'Atur kelembaban ruangan 40-60%',
          ],
          color: const Color(0xFF4DD0E1),
        ),
        const SizedBox(height: 15),
        _buildTipCard(
          icon: Icons.child_care,
          title: 'Mencegah ISPA pada Anak',
          tips: [
            'Berikan ASI eksklusif 6 bulan',
            'Lengkapi imunisasi sesuai jadwal',
            'Jaga kebersihan tangan anak',
            'Hindari paparan asap dan polusi',
            'Cukupi kebutuhan nutrisi anak',
          ],
          color: const Color(0xFF26A69A),
        ),
        const SizedBox(height: 15),
        _buildTipCard(
          icon: Icons.restaurant,
          title: 'Makanan untuk Meningkatkan Imunitas',
          tips: [
            'Konsumsi buah-buahan kaya vitamin C',
            'Makan sayuran hijau setiap hari',
            'Tambahkan bawang putih dan jahe',
            'Minum air putih minimal 8 gelas/hari',
            'Konsumsi makanan berprotein tinggi',
          ],
          color: const Color(0xFF00695C),
        ),
        const SizedBox(height: 15),
        _buildTipCard(
          icon: Icons.masks,
          title: 'Perlindungan Saat Beraktivitas',
          tips: [
            'Gunakan masker saat kualitas udara buruk',
            'Hindari aktivitas outdoor saat polusi tinggi',
            'Cuci tangan dengan sabun secara teratur',
            'Jaga jarak dari orang yang sedang sakit',
            'Bawa hand sanitizer saat bepergian',
          ],
          color: const Color(0xFFFF6F00),
        ),
        const SizedBox(height: 15),
        _buildTipCard(
          icon: Icons.bedtime,
          title: 'Gaya Hidup Sehat',
          tips: [
            'Tidur cukup 7-8 jam per hari',
            'Olahraga rutin minimal 30 menit/hari',
            'Kelola stres dengan baik',
            'Hindari begadang',
            'Rutin check-up kesehatan',
          ],
          color: const Color(0xFF7B1FA2),
        ),
      ],
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required List<String> tips,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: tips
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Buat Postingan Baru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _postController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Bagikan pengalaman atau pertanyaan Anda...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00695C)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Postingan akan direview oleh moderator',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_postController.text.isNotEmpty) {
                        Navigator.pop(context);
                        _postController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Postingan berhasil dikirim!'),
                            backgroundColor: Color(0xFF00695C),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00695C),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Posting',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
