<?php
include 'C:\xampp\htdocs\Oracle\connect\connection.php';
?>

<?php
$employeeId = $_POST['employee_id'];
$employeeName = $_POST['employee_name'];
$position = $_POST['position'];
$contactNumber = $_POST['contact_number'];
$query = "UPDATE MANAGER1.Employees SET employee_name = '".$employeeName."',
                                        position = '".$position."',
                                        contact_number = '".$contactNumber."'
                                     WHERE employee_id = ".$employeeId."";

$stid = oci_parse($conn, $query);
oci_execute($stid);
oci_free_statement($stid);
?>