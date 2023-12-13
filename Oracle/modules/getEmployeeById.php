<?php
include 'C:\xampp\htdocs\Oracle\connect\connection.php';
?>

<?php
$employeeId = $_GET['employee_id'];
$query = "SELECT * FROM MANAGER1.Employees WHERE employee_id = ".$employeeId."";

$stid = oci_parse($conn, $query);
oci_execute($stid);
$employeeData = array();

    while ($row = oci_fetch_array($stid, OCI_ASSOC)) {
        $employeeData[] = $row;
    }
oci_free_statement($stid);
echo json_encode($employeeData);
?>