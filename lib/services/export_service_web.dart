import 'dart:typed_data';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/health_entry.dart';

class ExportService {
  static Future<void> generateHealthReport(List<HealthEntry> entries) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Rapport Santé & Fitness',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          ...entries.map(
            (entry) => pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 8),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Date: ${entry.date.day}/${entry.date.month}/${entry.date.year}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Genre: ${entry.gender}'),
                  pw.Text('Âge: ${entry.age} ans'),
                  pw.Text('Taille: ${entry.height} cm'),
                  pw.Text('Poids: ${entry.weight} kg'),
                  pw.Text('BMI: ${entry.bmi.toStringAsFixed(2)}'),
                  pw.Text('BMR: ${entry.bmr.toStringAsFixed(1)} kcal'),
                  pw.Text(
                    'Besoins quotidiens: ${entry.dailyCalories.toStringAsFixed(1)} kcal',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final pdfBytes = await pdf.save();

    // Web: trigger browser download
    final blob = html.Blob([Uint8List.fromList(pdfBytes)], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'rapport_sante.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
