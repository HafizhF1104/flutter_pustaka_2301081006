<?php
require 'koneksi.php';

if (!$conn) {
    echo json_encode(["status" => "error", "message" => "Gagal koneksi database"]);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    if (empty($username) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Username atau password kosong"]);
        exit();
    }

    // Query untuk memeriksa data user
    $query = "SELECT * FROM user WHERE username = '$username' AND password = '$password'";
    $result = mysqli_query($conn, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        echo json_encode(["status" => "success", "message" => "Login berhasil"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Username atau password salah"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Metode tidak valid"]);
}
