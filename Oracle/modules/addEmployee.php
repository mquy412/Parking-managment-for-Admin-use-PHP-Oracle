<?php
include 'C:\xampp\htdocs\Oracle\connect\connection.php';
?>

<?php
$employeeName = $_POST['employee_name'];
$position = $_POST['position'];
$contactNumber = $_POST['contact_number'];
$query = "INSERT INTO MANAGER1.Employees(employee_name, position, contact_number) VALUES ('".$employeeName."','".$position."','".$contactNumber."')";

$stid = oci_parse($conn, $query);
oci_execute($stid);
oci_free_statement($stid);
?>

