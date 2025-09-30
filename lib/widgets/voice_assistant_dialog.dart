// lib/widgets/voice_assistant_dialog.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'voice_wave_painter.dart';

class VoiceAssistantDialog extends StatefulWidget {
  final VoidCallback onClose;
  final Map<String, dynamic> sensorData;

  const VoiceAssistantDialog({
    Key? key,
    required this.onClose,
    required this.sensorData,
  }) : super(key: key);

  @override
  // DIPERBAIKI: Menghapus underscore `_` untuk menjadikan class public
  VoiceAssistantDialogState createState() => VoiceAssistantDialogState();
}

// DIPERBAIKI: Menghapus underscore `_` untuk menjadikan class public
class VoiceAssistantDialogState extends State<VoiceAssistantDialog>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  bool _isListening = true;
  String _currentText = "Mendengarkan...";
  final List<String> _conversation = [];
  final ScrollController _scrollController = ScrollController();

  // DIPERBARUI: Menambahkan ikon pada setiap pertanyaan
  final List<Map<String, dynamic>> _sampleQuestions = [
    {
      "question": "Bagaimana suhu ruangan?",
      "type": "temperature",
      "icon": Icons.thermostat
    },
    {
      "question": "Perlu disiram?",
      "type": "watering",
      "icon": Icons.water_drop_outlined
    },
    {"question": "Kualitas udara hari ini?", "type": "air", "icon": Icons.air},
    {
      "question": "Waktu panen?",
      "type": "harvest",
      "icon": Icons.agriculture_outlined
    },
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _startListening();
  }

  void _startListening() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentText = "Silakan tanya atau pilih pertanyaan cepat...";
          _isListening = false;
        });
      }
    });
  }

  void _handleQuestionTap(String question, String type) {
    setState(() {
      _conversation.add("User: $question");
      _isListening = true;
      _currentText = "Memproses...";
    });
    _scrollToBottom();

    Timer(const Duration(seconds: 1, milliseconds: 500), () {
      if (mounted) {
        String response = _generateResponse(type);
        setState(() {
          _conversation.add("AIRA: $response");
          _isListening = false;
          _currentText = "Ada pertanyaan lain?";
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    // Memberi sedikit jeda agar UI sempat update sebelum scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateResponse(String type) {
    switch (type) {
      case "temperature":
        double temp = widget.sensorData['temperature'];
        return "Suhu ruangan saat ini ${temp.toStringAsFixed(1)}°C. ${temp > 26 ? 'Agak hangat, pertimbangkan untuk menambah ventilasi.' : temp < 20 ? 'Agak dingin, tanaman mungkin perlu kehangatan.' : 'Suhu dalam kondisi optimal untuk pertumbuhan tanaman.'}";
      case "watering":
        double moisture = widget.sensorData['soilMoisture'];
        return "Kelembaban tanah ${moisture.toStringAsFixed(0)}%. ${moisture < 40 ? 'Tanaman membutuhkan penyiraman segera.' : moisture > 80 ? 'Tanah cukup lembab, tunda penyiraman.' : 'Kelembaban tanah dalam kondisi baik.'}";
      case "air":
        double air = widget.sensorData['airQuality'];
        String airStatus = air > 90
            ? 'sangat baik'
            : air > 70
                ? 'baik'
                : air > 50
                    ? 'sedang'
                    : 'buruk';
        return "Kualitas udara saat ini $airStatus dengan index ${air.toStringAsFixed(0)}%. Kondisi udara mendukung pertumbuhan tanaman yang sehat.";
      case "harvest":
        return "Berdasarkan kondisi saat ini, perkiraan waktu panen optimal adalah 20-25 hari lagi. Pertahankan kondisi kelembaban dan suhu yang ada.";
      default:
        return "Maaf, saya belum memahami pertanyaan tersebut.";
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF006064),
              const Color(0xFF00838F),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: [
              _buildDialogHeader(),
              _buildVoiceVisualizer(),
              _buildCurrentStatus(),
              _buildConversation(),
              _buildQuickQuestions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          const Icon(Icons.assistant, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'AIRA Voice Assistant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.onClose();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceVisualizer() {
    return SizedBox(
      height: 80,
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(
            painter: VoiceWavePainter(
              animationValue: _waveController.value,
              isActive: _isListening,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  Widget _buildCurrentStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isListening)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red
                          .withOpacity(0.7 + 0.3 * _pulseController.value),
                      shape: BoxShape.circle,
                    ),
                  ),
                if (_isListening) const SizedBox(width: 10),
                Text(
                  _currentText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildConversation() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: _conversation.isEmpty
            ? Center(
                child: Text(
                  'Percakapan akan muncul di sini...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _conversation.length,
                itemBuilder: (context, index) {
                  final message = _conversation[index];
                  final isUser = message.startsWith('User:');
                  final text = message.substring(isUser ? 6 : 6);

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color(0xFF4DD0E1).withOpacity(0.8)
                            : Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser
                              ? const Radius.circular(16)
                              : const Radius.circular(4),
                          bottomRight: isUser
                              ? const Radius.circular(4)
                              : const Radius.circular(16),
                        ),
                      ),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Text(
                        text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _sampleQuestions.map((q) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ActionChip(
                onPressed: () => _handleQuestionTap(q['question']!, q['type']!),
                avatar: Icon(q['icon']!, size: 18, color: Colors.white70),
                label: Text(
                  q['question']!,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
