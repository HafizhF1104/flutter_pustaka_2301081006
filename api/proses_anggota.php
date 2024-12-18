<?php
require 'koneksi.php';

$aksi = isset($_GET['aksi']) ? $_GET['aksi'] : null;

switch ($aksi) {
    case 'insert':
        $nim = $_POST["nim"];
        $nama = $_POST["nama"];
        $jenis_kelamin = $_POST["jenis_kelamin"];
        $alamat = $_POST["alamat"];

        $data = mysqli_query($conn, "INSERT INTO anggota (nim, nama, jenis_kelamin, alamat) 
                                    VALUES ('$nim', '$nama', '$jenis_kelamin', '$alamat')");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    case 'edit':
        $id = $_POST["id"];
        $nim = $_POST["nim"];
        $nama = $_POST["nama"];
        $jenis_kelamin = $_POST["jenis_kelamin"];
        $alamat = $_POST["alamat"];

        $data = mysqli_query($conn, "UPDATE anggota 
                                    SET nim='$nim', nama='$nama', jenis_kelamin='$jenis_kelamin', alamat='$alamat' 
                                    WHERE id='$id'");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    case 'delete':
        $id = $_POST["id"];

        $data = mysqli_query($conn, "DELETE FROM anggota WHERE id='$id'");
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
