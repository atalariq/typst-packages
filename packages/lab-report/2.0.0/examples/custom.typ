// Custom composition using individual components (no preset).
// Shows how to build a report from building blocks.
// Compile: typst compile examples/custom.typ

#import "@atalariq/lab-report:2.0.0": *

#let meta = (
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "Praktikum Basis Data",
  course-code: "PBD",
  lecturer: "Firma Syahrian",
  meeting: "8",
  title: "Implementasi Trigger dan View",
)

// Base setup — just page, fonts, heading numbering
#show: report.with(
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 12pt,
  bib: bibliography("references.bib"),
)

// ── Cover (manual, before TOC) ──────────────────────────────────────

#cover(..meta, association: (
  program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
  department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
  faculty: "SEKOLAH VOKASI",
  university: "UNIVERSITAS GADJAH MADA",
  city: "YOGYAKARTA",
  logo: image("assets/logo.png", width: 6cm),
))

// ── Table of Contents ───────────────────────────────────────────────

#toc()

// ── Manual sections ─────────────────────────────────────────────────
// No component helpers — write headings and content directly.

= Tujuan Praktikum

+ Memahami konsep _trigger_ pada Oracle Database.
+ Mampu mengimplementasikan _trigger_ `BEFORE DELETE` untuk _audit trail_.

= Dasar Teori

== Trigger

_Trigger_ adalah program PL/SQL yang tersimpan di database dan dieksekusi secara otomatis ketika suatu DML event terjadi pada tabel.

= Hasil dan Pembahasan

== Tugas 1: Trigger untuk Backup

#code(```sql
CREATE OR REPLACE TRIGGER trg_emp_backup
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO emp_backup VALUES (:OLD.employee_id, :OLD.last_name);
END;
```)

#rect[TODO: Screenshot hasil eksekusi]

= Kesimpulan

+ Trigger dapat digunakan untuk otomatisasi _audit trail_ dan _backup_.
+ Pseudorecord `:OLD` dan `:NEW` memungkinkan akses data sebelum/sesudah operasi DML.
