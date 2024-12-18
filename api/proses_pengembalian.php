<?php
require 'koneksi.php';


$aksi = isset($_GET['aksi']) ? $_GET['aksi'] : null;

switch ($aksi) {
    case 'insert':
        $tanggal_dikembalikan = $_POST["tanggal_dikembalikan"];
        $terlambat = $_POST["terlambat"];
        $denda = $_POST["denda"];
        $id_peminjaman = $_POST["id_peminjaman"];
    
        $data_pengembalian = mysqli_query($conn, "INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, id_peminjaman) 
                                    VALUES ('$tanggal_dikembalikan', '$terlambat', '$denda', '$id_peminjaman')");
    
        if ($data_pengembalian) {
            $update_peminjaman = mysqli_query($conn, "UPDATE peminjaman SET is_deleted = 1 WHERE id = '$id_peminjaman'");
            if ($update_peminjaman) {
                echo json_encode(['pesan' => 'Sukses']);
            } else {
                echo json_encode(['pesan' => 'Gagal mengupdate tabel peminjaman']);
            }
        } else {
            echo json_encode(['pesan' => 'Gagal menambahkan data pengembalian']);
        }
        break;
    

    case 'edit':
        $id = $_POST["id"];
        $tanggal_dikembalikan = $_POST["tanggal_dikembalikan"];
        $terlambat = $_POST["terlambat"];
        $denda = $_POST["denda"];
        $id_peminjaman = $_POST["id_peminjaman"];
       

        $data = mysqli_query($conn, "UPDATE pengembalian 
                                    SET tanggal_dikembalikan='$tanggal_dikembalikan', terlambat='$terlambat', denda='$denda', id_peminjaman='$id_peminjaman' WHERE id='$id'");
        if ($data) {
            echo json_encode(['pesan' => 'Sukses']);
        } else {
            echo json_encode(['pesan' => 'Gagal']);
        }
        break;

    case 'delete':
        $id = $_POST["id"];

        $data = mysqli_query($conn, "DELETE FROM pengembalian WHERE id='$id'");
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
