<?php
include 'connect/connection.php';
?>

<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <title>Hello, world!</title>
  </head>
  <body>

    <header class="header">
    <div class="logo">
        <div class="title"><a class="page-linka" href="index.php">Quản lý bãi gửi xe ô tô</a></div>
    </div>
    <div class="info">
        Số chỗ còn trống: ??
    </div>
    </header>

    

    <div class="content">
        <div class="content-left">
            <div class="option" id="add-vehicle-btn">Thêm xe vào bãi</div>
                <div class="modal" id="myModal">
                    <div class="modal-content">
                        <span class="close">x</span>
                        <h3>Thêm xe vào bãi</h3>                   
                        <p>Nhập thông tin xe:</p>
                        <input class="fie" type="text" id="license_plate" placeholder="Biển số xe">
                        <input class="fie" type="text" id="owner_name" placeholder="Chủ sở hữu">
                        <button class="modal-btn" onclick="addVehicle()">Thêm</button>
                    </div>
                </div>
            <div class="option" id="delete-vehicle-btn">Xoá xe khỏi bãi</div>
                <div class="modal" id="myModal1">
                    <div class="modal-content">
                        <span class="close1">x</span> 
                        <h3>Xoá xe khỏi bãi</h3>                  
                        <p>Nhập thông tin xe:</p>
                        <input class="fie" type="text" id="license_plate_2" placeholder="Biển số xe">
                        <input class="fie" type="text" id="payment_method" placeholder="Phương thức thanh toán">
                        <button class="modal-btn" onclick="deleteVehicle()">Xoá</button>
                    </div>
                </div>
            <div class="option"><a href="employees.php" style="color: #000;">Nhân viên</a></div>
            <div class="option"><a href="payments.php" style="color: #000;">Hoá đơn</a></div>
        </div>
        <div class="content-right">
            <table>
                <thead>
                    <tr>
                        <th>ID hoá đơn</th>
                        <th>ID giao dịch</th>
                        <th>PTTT</th>
                        <th>Thời gian</th>
                        <th>Tổng tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $query = "SELECT * FROM MANAGER1.Payments ORDER BY payment_id DESC";

                    $stid = oci_parse($conn, $query);
                    oci_execute($stid);
                        while ($row = oci_fetch_assoc($stid)) {
                            echo "<tr>";    
                            echo "<td>" . $row['PAYMENT_ID'] . "</td>";
                            echo "<td>" . $row['TRANSACTION_ID'] . "</td>";
                            echo "<td>" . $row['PAYMENT_METHOD'] . "</td>";
                            echo "<td>" . $row['PAYMENT_TIME'] . "</td>";
                            echo "<td>" . $row['AMOUNT_PAID'] . "</td>";
                            echo "</tr>";
                    }
                    oci_free_statement($stid);
                    ?>
                </tbody>
            </table>
        </div>
    </div>


    <footer class="footer">
    <div class="container">
        <div class="footer-content">
            Web quản lý bãi gửi ô tô - Nhóm 4
        </div>
    </div>
    </footer>
    
    <script src="javascript.js"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
  </body>
</html>