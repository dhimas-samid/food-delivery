CREATE TABLE ms_akun (
  id_akun VARCHAR(255) NOT NULL,
  username varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  PRIMARY KEY (id_akun)
);

CREATE TABLE ms_pelanggan (
  id_pelanggan VARCHAR(255) NOT NULL,
  nama VARCHAR(255) NOT NULL,
  no_telp VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_pelanggan),
  FOREIGN KEY (id_pelanggan) REFERENCES ms_akun(id_akun)
);

CREATE TABLE ms_penjual (
  id_penjual VARCHAR(255) NOT NULL,
  nama VARCHAR(255) NOT NULL,
  no_telp VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_penjual),
  FOREIGN KEY (id_penjual) REFERENCES ms_akun(id_akun)
);

CREATE TABLE ms_kurir (
  id_kurir VARCHAR(255) NOT NULL,
  nama VARCHAR(255) NOT NULL,
  no_telp VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_kurir),
  FOREIGN KEY (id_kurir) REFERENCES ms_akun(id_akun)
);

SET @id_pelanggan = (SELECT UUID());
INSERT INTO ms_akun VALUES (@id_pelanggan, 'pelanggan', '1234');
INSERT INTO ms_pelanggan VALUES (@id_pelanggan, 'pelanggan', '081234567890');

SET @id_penjual = (SELECT UUID());
INSERT INTO ms_akun VALUES (@id_penjual, 'penjual', '1234');
INSERT INTO ms_penjual VALUES (@id_penjual, 'penjual', '081234567891');

SET @id_kurir = (SELECT UUID());
INSERT INTO ms_akun VALUES (@id_kurir, 'kurir', '1234');
INSERT INTO ms_kurir VALUES (@id_kurir, 'kurir', '081234567892');

CREATE TABLE ms_barang (
  id_barang VARCHAR(255) NOT NULL,
  id_penjual VARCHAR(255) NOT NULL,
  nama VARCHAR(255) NOT NULL,
  keterangan VARCHAR(255) DEFAULT 'lorem ipsum dolor sit amet',
  harga INT NOT NULL DEFAULT 10000,
  foto VARCHAR(255) DEFAULT 'https://source.unsplash.com/random/100x100',
  stok INT NOT NULL DEFAULT 10,
  tersedia TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_barang),
  FOREIGN KEY (id_penjual) REFERENCES ms_penjual(id_penjual)
);

SET @id_barang = (SELECT UUID());
INSERT INTO ms_barang (id_barang, id_penjual, nama) VALUES (@id_barang, @id_penjual, 'barang');

CREATE TABLE tr_keranjang (
  id_keranjang VARCHAR(255) NOT NULL,
  id_pelanggan VARCHAR(255) NOT NULL,
  id_penjual VARCHAR(255) NOT NULL,
  alamat VARCHAR(255) NOT NULL DEFAULT 'lorem ipsum dolor sit amet',
  total_barang INT NOT NULL DEFAULT 0,
  total_harga INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_keranjang),
  FOREIGN KEY (id_pelanggan) REFERENCES ms_pelanggan(id_pelanggan),
  FOREIGN KEY (id_penjual) REFERENCES ms_penjual(id_penjual)
);

CREATE TABLE tr_barang_keranjang (
  id_keranjang VARCHAR(255) NOT NULL,
  id_barang VARCHAR(255) NOT NULL,
  jumlah INT NOT NULL DEFAULT 1,
  PRIMARY KEY (id_keranjang, id_barang),
  FOREIGN KEY (id_keranjang) REFERENCES tr_keranjang(id_keranjang),
  FOREIGN KEY (id_barang) REFERENCES ms_barang(id_barang)
);

SET @id_keranjang = (SELECT UUID());
INSERT INTO tr_keranjang (id_keranjang, id_pelanggan, id_penjual, total_barang, total_harga) VALUES (@id_keranjang, @id_pelanggan, @id_penjual, 1, 10000);
INSERT INTO tr_barang_keranjang (id_keranjang, id_barang, jumlah) VALUES (@id_keranjang, @id_barang, 1);

CREATE TABLE tr_pesanan (
  id_pesanan VARCHAR(255) NOT NULL,
  id_pelanggan VARCHAR(255) NOT NULL,
  id_penjual VARCHAR(255) NOT NULL,
  id_kurir VARCHAR(255),
  tanggal TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  alamat_asal VARCHAR(255) NOT NULL DEFAULT 'lorem ipsum dolor sit amet',
  alamat_tujuan VARCHAR(255) NOT NULL DEFAULT 'lorem ipsum dolor sit amet',
  total_barang INT NOT NULL DEFAULT 0,
  total_harga_barang INT NOT NULL DEFAULT 0,
  biaya_pesan INT NOT NULL DEFAULT 0,
  biaya_kirim INT NOT NULL DEFAULT 0,
  potongan_harga INT NOT NULL DEFAULT 0,
  total_harga INT NOT NULL DEFAULT 0,
  status VARCHAR(255) NOT NULL DEFAULT 'menunggu konfirmasi',
  PRIMARY KEY (id_pesanan),
  FOREIGN KEY (id_pelanggan) REFERENCES ms_pelanggan(id_pelanggan),
  FOREIGN KEY (id_penjual) REFERENCES ms_penjual(id_penjual),
  FOREIGN KEY (id_kurir) REFERENCES ms_kurir(id_kurir)
);

CREATE TABLE tr_barang_pesanan (
  id_pesanan VARCHAR(255) NOT NULL,
  id_barang VARCHAR(255) NOT NULL,
  jumlah INT NOT NULL DEFAULT 0,
  nama VARCHAR(255) NOT NULL,
  keterangan VARCHAR(255) NOT NULL DEFAULT 'lorem ipsum dolor sit amet',
  harga INT NOT NULL DEFAULT 0,
  foto VARCHAR(255) NOT NULL DEFAULT 'https://source.unsplash.com/random/100x100',
  PRIMARY KEY (id_pesanan, id_barang),
  FOREIGN KEY (id_pesanan) REFERENCES tr_pesanan(id_pesanan),
  FOREIGN KEY (id_barang) REFERENCES ms_barang(id_barang)
);

CREATE TABLE tr_log_status_pesanan (
  id_pesanan VARCHAR(255) NOT NULL,
  cap_waktu TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_pesanan, cap_waktu),
  FOREIGN KEY (id_pesanan) REFERENCES tr_pesanan(id_pesanan)
);

CREATE TABLE tr_log_pengiriman (
  id_pesanan VARCHAR(255) NOT NULL,
  cap_waktu TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  lokasi VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_pesanan, cap_waktu),
  FOREIGN KEY (id_pesanan) REFERENCES tr_pesanan(id_pesanan)
);

SET @id_menunggu_konfirmasi = (SELECT UUID());
INSERT INTO tr_pesanan (
  id_pesanan,
  id_pelanggan,
  id_penjual,
  total_barang,
  total_harga_barang,
  biaya_kirim,
  total_harga
) VALUES (
  @id_menunggu_konfirmasi,
  @id_pelanggan,
  @id_penjual,
  1,
  10000,
  5000,
  15000
);

INSERT INTO tr_barang_pesanan (
  id_pesanan,
  id_barang,
  jumlah,
  nama,
  harga
) VALUES (
  @id_menunggu_konfirmasi,
  @id_barang,
  1,
  'barang 1',
  10000
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
  status
) VALUES (
  @id_menunggu_konfirmasi,
  'menunggu konfirmasi'
);

SET @id_diproses = (SELECT UUID());
INSERT INTO tr_pesanan (
  id_pesanan,
  id_pelanggan,
  id_penjual,
  total_barang,
  total_harga_barang,
  biaya_kirim,
  total_harga,
  status
) VALUES (
  @id_diproses,
  @id_pelanggan,
  @id_penjual,
  1,
  10000,
  5000,
  15000,
  'diproses'
);

INSERT INTO tr_barang_pesanan (
  id_pesanan,
  id_barang,
  jumlah,
  nama,
  harga
) VALUES (
  @id_diproses,
  @id_barang,
  1,
  'barang 1',
  10000
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_diproses,
  DATE_SUB(NOW(), INTERVAL 5 MINUTE),
  'menunggu konfirmasi'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
  status
) VALUES (
  @id_diproses,
  'diproses'
);

SET @id_siap_dikirim = (SELECT UUID());
INSERT INTO tr_pesanan (
  id_pesanan,
  id_pelanggan,
  id_penjual,
  total_barang,
  total_harga_barang,
  biaya_kirim,
  total_harga,
  status
) VALUES (
  @id_siap_dikirim,
  @id_pelanggan,
  @id_penjual,
  1,
  10000,
  5000,
  15000,
  'siap dikirim'
);

INSERT INTO tr_barang_pesanan (
  id_pesanan,
  id_barang,
  jumlah,
  nama,
  harga
) VALUES (
  @id_siap_dikirim,
  @id_barang,
  1,
  'barang 1',
  10000
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_siap_dikirim,
  DATE_SUB(NOW(), INTERVAL 10 MINUTE),
  'menunggu konfirmasi'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_siap_dikirim,
  DATE_SUB(NOW(), INTERVAL 5 MINUTE),
  'diproses'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
  status
) VALUES (
  @id_siap_dikirim,
  'siap dikirim'
);

SET @id_dikirim = (SELECT UUID());
INSERT INTO tr_pesanan (
  id_pesanan,
  id_pelanggan,
  id_penjual,
  total_barang,
  total_harga_barang,
  biaya_kirim,
  total_harga,
  status
) VALUES (
  @id_dikirim,
  @id_pelanggan,
  @id_penjual,
  1,
  10000,
  5000,
  15000,
  'dikirim'
);

INSERT INTO tr_barang_pesanan (
  id_pesanan,
  id_barang,
  jumlah,
  nama,
  harga
) VALUES (
  @id_dikirim,
  @id_barang,
  1,
  'barang 1',
  10000
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_dikirim,
  DATE_SUB(NOW(), INTERVAL 20 MINUTE),
  'menunggu konfirmasi'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_dikirim,
  DATE_SUB(NOW(), INTERVAL 15 MINUTE),
  'diproses'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_dikirim,
	DATE_SUB(NOW(), INTERVAL 10 MINUTE),
  'siap dikirim'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_dikirim,
	DATE_SUB(NOW(), INTERVAL 5 MINUTE),
  'dikirim'
);

INSERT INTO tr_log_pengiriman (
	id_pesanan,
	cap_waktu,
	lokasi
) VALUES (
	@id_dikirim,
	DATE_SUB(NOW(), INTERVAL 5 MINUTE),
	'alamat asal'
);

INSERT INTO tr_log_pengiriman (
	id_pesanan,
	lokasi
) VALUES (
	@id_dikirim,
	'lokasi 1'
);

SET @id_selesai = (SELECT UUID());
INSERT INTO tr_pesanan (
  id_pesanan,
  id_pelanggan,
  id_penjual,
  total_barang,
  total_harga_barang,
  biaya_kirim,
  total_harga,
  status
) VALUES (
  @id_selesai,
  @id_pelanggan,
  @id_penjual,
  1,
  10000,
  5000,
  15000,
  'selesai'
);

INSERT INTO tr_barang_pesanan (
  id_pesanan,
  id_barang,
  jumlah,
  nama,
  harga
) VALUES (
  @id_selesai,
  @id_barang,
  1,
  'barang 1',
  10000
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_selesai,
  DATE_SUB(NOW(), INTERVAL 25 MINUTE),
  'menunggu konfirmasi'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_selesai,
  DATE_SUB(NOW(), INTERVAL 20 MINUTE),
  'diproses'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_selesai,
	DATE_SUB(NOW(), INTERVAL 15 MINUTE),
  'siap dikirim'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
	cap_waktu,
  status
) VALUES (
  @id_selesai,
	DATE_SUB(NOW(), INTERVAL 10 MINUTE),
  'dikirim'
);

INSERT INTO tr_log_status_pesanan (
  id_pesanan,
  status
) VALUES (
  @id_selesai,
  'selesai'
);

INSERT INTO tr_log_pengiriman (
	id_pesanan,
	cap_waktu,
	lokasi
) VALUES (
	@id_selesai,
	DATE_SUB(NOW(), INTERVAL 10 MINUTE),
	'alamat asal'
);

INSERT INTO tr_log_pengiriman (
	id_pesanan,
	cap_waktu,
	lokasi
) VALUES (
	@id_selesai,
	DATE_SUB(NOW(), INTERVAL 5 MINUTE),
	'lokasi 1'
);

INSERT INTO tr_log_pengiriman (
	id_pesanan,
	lokasi
) VALUES (
	@id_selesai,
	'lokasi tujuan'
);
