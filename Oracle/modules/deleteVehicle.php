<?php
include 'C:\xampp\htdocs\Oracle\connect\connection.php';
?>

<?php
$licensePlate = $_POST['license_plate'];
$paymentMethod = $_POST['payment_method'];
$query = "BEGIN MANAGER1.DeleteVehicleFromParkingLot('" . $licensePlate ."','" . $paymentMethod . "'); END;";

$stid = oci_parse($conn, $query);
oci_execute($stid);
oci_free_statement($stid);
?>

