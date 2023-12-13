<?php
// Thông tin kết nối Oracle
$db_user = "manager1";
$db_password = "manager1";
$db_port = "1521";
$db_host = "localhost"; // Địa chỉ IP và số cổng của máy chủ Oracle
$db_sid = "orcl"; // Tên dịch vụ (service name) của cơ sở dữ liệu

// Kết nối Oracle
$connection_string = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=" . $db_host . ")(PORT=" . $db_port . "))(CONNECT_DATA=(SID=" . $db_sid . ")))";
$conn = oci_connect($db_user, $db_password, $connection_string);

if (!$conn) {
    $error = oci_error();
    echo "Kết nối Oracle không thành công: " . $error['message'];
    exit;
} else {
}
?>