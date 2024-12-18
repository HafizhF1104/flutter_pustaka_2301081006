<?php
require 'koneksi.php';


$table = isset($_GET['table']) ? $_GET['table'] : null;

switch ($table) {
    case 'anggota':
        
        $query = "SELECT * FROM anggota";
        $result = mysqli_query($conn, $query);

        if ($result) {
            $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(['pesan' => 'Gagal mengambil data dari tabel anggota']);
        }
        break;

    case 'buku':
        
        $query = "SELECT * FROM buku";
        $result = mysqli_query($conn, $query);

        if ($result) {
            $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(['pesan' => 'Gagal mengambil data dari tabel buku']);
        }
        break;

    case 'peminjaman':
        
        $query = "SELECT peminjaman.id, peminjaman.tanggal_pinjam, peminjaman.tanggal_kembali, peminjaman.id_anggota, 
                peminjaman.id_buku, anggota.nama AS nama_anggota, buku.judul AS judul_buku 
                FROM peminjaman
                INNER JOIN anggota ON peminjaman.id_anggota = anggota.id
                INNER JOIN buku ON peminjaman.id_buku = buku.id
                WHERE peminjaman.is_deleted = 0";
        $result = mysqli_query($conn, $query);

        if ($result) {
            $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(['pesan' => 'Gagal mengambil data dari tabel peminjaman']);
        }
        break;

    case 'pengembalian':
        
        $query = "SELECT pengembalian.id AS id_pengembalian, pengembalian.tanggal_dikembalikan, pengembalian.terlambat, 
                pengembalian.denda, peminjaman.id AS id_peminjaman, anggota.nama AS nama_anggota, buku.judul AS judul_buku
                FROM pengembalian
                INNER JOIN peminjaman ON pengembalian.id_peminjaman = peminjaman.id
                INNER JOIN anggota ON peminjaman.id_anggota = anggota.id
                INNER JOIN buku ON peminjaman.id_buku = buku.id
                WHERE peminjaman.is_deleted = 1";
        $result = mysqli_query($conn, $query);

        if ($result) {
            $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(['pesan' => 'Gagal mengambil data dari tabel pengembalian']);
        }
        break;

    default:
        echo json_encode(['pesan' => 'Aksi tidak dikenali']);
        break;
}
?>
