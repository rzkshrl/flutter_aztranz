class DataReservasiModel {
  int? idReservasi;
  int? mobilId;
  String? orderId;
  int? grossAmount;
  String? namaMobil;
  String? namaPemesan;
  String? alamatPemesan;
  String? harga;
  String? noKTPPemesan;
  String? noTelpPemesan;
  String? tanggalPesanStart;
  String? tanggalPesanEnd;
  String? fotoUrl;
  String? status;

  DataReservasiModel({
    this.idReservasi,
    this.mobilId,
    this.orderId,
    this.grossAmount,
    this.namaMobil,
    this.namaPemesan,
    this.alamatPemesan,
    this.harga,
    this.noKTPPemesan,
    this.noTelpPemesan,
    this.tanggalPesanStart,
    this.tanggalPesanEnd,
    this.fotoUrl,
    this.status,
  });

  factory DataReservasiModel.fromJson(Map<String, dynamic> json) {
    return DataReservasiModel(
      idReservasi: json['id_reservasi'],
      mobilId: json['mobil_id'],
      orderId: json['order_id'],
      grossAmount: json['gross_amount'],
      namaMobil: json['nama_mobil'],
      namaPemesan: json['nama_pemesan'],
      alamatPemesan: json['alamat'],
      harga: json['harga'],
      noKTPPemesan: json['no_ktp'],
      noTelpPemesan: json['telepon'],
      tanggalPesanStart: json['tanggalpesan_start'],
      tanggalPesanEnd: json['tanggalpesan_end'],
      fotoUrl: json['foto_url'],
      status: json['status'],
    );
  }
}
