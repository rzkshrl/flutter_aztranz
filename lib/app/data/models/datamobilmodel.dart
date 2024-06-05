class DataMobilModel {
  int? id;
  String? namaMobil;
  String? merek;
  String? noPolisi;
  String? hargaPerHari;
  String? tipeBahanBakar;
  String? tahun;
  String? deskripsi;
  String? fotoMobil;
  String? status;

  DataMobilModel({
    this.id,
    this.namaMobil,
    this.merek,
    this.noPolisi,
    this.hargaPerHari,
    this.tipeBahanBakar,
    this.tahun,
    this.deskripsi,
    this.fotoMobil,
    this.status,
  });

  factory DataMobilModel.fromJson(Map<String, dynamic> json) {
    return DataMobilModel(
      id: json['id_mobil'],
      namaMobil: json['nama_mobil'],
      merek: json['merek'],
      noPolisi: json['no_polisi'],
      hargaPerHari: json['harga'],
      tipeBahanBakar: json['bahan_bakar'],
      tahun: json['tahun'],
      deskripsi: json['deskripsi'],
      fotoMobil: json['foto_url'],
      status: json['status'],
    );
  }
}
