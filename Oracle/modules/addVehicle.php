<?php
include 'C:\xampp\htdocs\Oracle\connect\connection.php';
?>

<?php
$licensePlate = $_POST['license_plate'];
$ownerName = $_POST['owner_name'];
$query = "BEGIN MANAGER1.AddVehicleToParkingLot('" . $licensePlate ."','" . $ownerName . "'); END;";

$stid = oci_parse($conn, $query);
oci_execute($stid);
oci_free_statement($stid);
?>

