<?php
include 'C:\xampp\htdocs\Oracle\connect\connection.php';
?>

<?php
$employeeId = $_GET['employee_id'];
$query = "DELETE FROM MANAGER1.Employees WHERE employee_id = ".$employeeId."";

$stid = oci_parse($conn, $query);
oci_execute($stid);
oci_free_statement($stid);
?>