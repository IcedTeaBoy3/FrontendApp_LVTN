import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;

class DoctorDetailBio extends StatefulWidget {
  final String doctorId;
  const DoctorDetailBio({super.key, required this.doctorId});

  @override
  State<DoctorDetailBio> createState() => _DoctorDetailBioState();
}

class _DoctorDetailBioState extends State<DoctorDetailBio> {
  bool _isExpanded = false;
  final int _maxLength = 150; // giới hạn ký tự hiển thị
  String _stripHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = widget.doctorId;
    final doctor = context.read<DoctorProvider>().findById(doctorId);
    // Chuyển đổi HTML sang plain text để đếm ký tự
    final String rawHtml = doctor?.bio ?? "";
    final String plainText = _stripHtmlTags(rawHtml);

    // Tại sao phải chuyển về plain text?
    // Vì nếu dùng rawHtml.length sẽ tính cả các thẻ HTML, dẫn đến việc cắt ngắn không đúng ý muốn.
    final bool shouldTruncate = plainText.length > _maxLength;
    final String displayText =
        shouldTruncate ? "${plainText.substring(0, _maxLength)}..." : plainText;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleUser,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 8),
              Text(
                "Giới thiệu",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Nội dung
          SizedBox(
            width: double.infinity,
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              // Bản rút gọn (plain text)
              firstChild: Text(
                displayText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // Bản đầy đủ (render HTML gốc, không ép style)
              secondChild: Html(
                data: rawHtml,
                style: {
                  "p": Style(
                      fontSize: FontSize(16), margin: Margins.only(bottom: 8)),
                  "b":
                      Style(fontWeight: FontWeight.bold, color: Colors.black87),
                  "strong":
                      Style(fontWeight: FontWeight.bold, color: Colors.black87),
                  "i": Style(fontStyle: FontStyle.italic),
                  "em": Style(fontStyle: FontStyle.italic),
                  "u": Style(textDecoration: TextDecoration.underline),
                  "a": Style(
                      color: Colors.blue,
                      textDecoration: TextDecoration.underline),
                  "ul": Style(margin: Margins.only(left: 20, bottom: 8)),
                  "ol": Style(margin: Margins.only(left: 20, bottom: 8)),
                  "li": Style(margin: Margins.only(bottom: 4)),
                  "h1": Style(
                      fontSize: FontSize(28), fontWeight: FontWeight.bold),
                  "h2": Style(
                      fontSize: FontSize(24), fontWeight: FontWeight.w600),
                  "h3": Style(
                      fontSize: FontSize(20), fontWeight: FontWeight.w500),
                  "br": Style(
                      display: Display.block, margin: Margins.only(bottom: 6)),
                },
              ),
            ),
          ),
          if (shouldTruncate)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _isExpanded ? "Thu gọn" : "Xem thêm",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
