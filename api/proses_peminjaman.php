<?php
require 'koneksi.php';


$aksi = isset($_GET['aksi']) ? $_GET['aksi'] : null;

switch ($aksi) {
    case 'insert':
        $tanggal_pinjam = $_POST["tanggal_pinjam"];
        $tanggal_kembali = $_POST["tanggal_kembali"];
        $id_anggota = $_POST["id_anggota"];
        $id_buku = $_POST["id_buku"];
        

        $data = mysqli_query($conn, "INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, id_anggota, id_buku) 
                                    VALUES ('$tanggal_pinjam', '$tanggal_kembali', '$id_anggota', '$id_buku')");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    case 'edit':
        $id = $_POST["id"];
        $tanggal_pinjam = $_POST["tanggal_pinjam"];
        $tanggal_kembali = $_POST["tanggal_kembali"];
        $id_anggota = $_POST["id_anggota"];
        $id_buku = $_POST["id_buku"];
       

        $data = mysqli_query($conn, "UPDATE peminjaman 
                                    SET tanggal_pinjam='$tanggal_pinjam', tanggal_kembali='$tanggal_kembali', id_anggota='$id_anggota', id_buku='$id_buku' WHERE id='$id'");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    case 'delete':
        $id = $_POST["id"];

        $data = mysqli_query($conn, "DELETE FROM peminjaman WHERE id='$id'");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    default:
        echo json_encode(['pesan' => 'Aksi tidak dikenali']);
        break;
}
?>
