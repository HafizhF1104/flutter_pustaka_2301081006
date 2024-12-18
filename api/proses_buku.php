<?php
require 'koneksi.php';


$aksi = isset($_GET['aksi']) ? $_GET['aksi'] : null;

switch ($aksi) {
    case 'insert':
        $kode_buku = $_POST["kode_buku"];
        $judul = $_POST["judul"];
        $pengarang = $_POST["pengarang"];
        $penerbit = $_POST["penerbit"];
        $tahun_terbit = $_POST["tahun_terbit"];

        $data = mysqli_query($conn, "INSERT INTO buku (kode_buku, judul, pengarang, penerbit, tahun_terbit) 
                                    VALUES ('$kode_buku', '$judul', '$pengarang', '$penerbit','$tahun_terbit')");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    case 'edit':
        $id = $_POST["id"];
        $kode_buku = $_POST["kode_buku"];
        $judul = $_POST["judul"];
        $pengarang = $_POST["pengarang"];
        $penerbit = $_POST["penerbit"];
        $tahun_terbit = $_POST["tahun_terbit"];

        $data = mysqli_query($conn, "UPDATE buku 
                                    SET kode_buku='$kode_buku', judul='$judul', pengarang='$pengarang', penerbit='$penerbit', tahun_terbit='$tahun_terbit' WHERE id='$id'");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    case 'delete':
        $id = $_POST["id"];

        $data = mysqli_query($conn, "DELETE FROM buku WHERE id='$id'");
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
