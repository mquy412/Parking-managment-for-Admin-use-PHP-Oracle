// Lấy các phần tử cần sử dụng
var modal = document.getElementById("myModal");
var modal1 = document.getElementById("myModal1");
var modal2 = document.getElementById("myModal2");
var modal3 = document.getElementById("myModal3");
var modal4 = document.getElementById("employeeModal");
var modal5 = document.getElementById("employeeModaldelete");
var btn = document.getElementById("add-vehicle-btn");
var btn1 = document.getElementById("delete-vehicle-btn");
var btn2 = document.getElementById("add-employee-btn");
var btn3 = document.getElementById("update-employee-btn");
var closeBtn = document.getElementsByClassName("close")[0];
var closeBtn1 = document.getElementsByClassName("close1")[0];
var closeBtn2 = document.getElementsByClassName("close2")[0];
var closeBtn3 = document.getElementsByClassName("close3")[0];

// Khi nhấp vào nút "Thêm xe vào bãi", hiển thị modal
btn.onclick = function () {
  modal.style.display = "block";
};

// Khi nhấp vào nút đóng, đóng modal
closeBtn.onclick = function () {
  modal.style.display = "none";
};

btn1.onclick = function () {
  modal1.style.display = "block";
};

// Khi nhấp vào nút đóng, đóng modal
closeBtn1.onclick = function () {
  modal1.style.display = "none";
};

btn2.onclick = function () {
  modal2.style.display = "block";
};

// Khi nhấp vào nút đóng, đóng modal
closeBtn2.onclick = function () {
  modal2.style.display = "none";
};


// Khi nhấp bên ngoài modal, đóng modal
window.onclick = function (event) {
  if (event.target == modal || event.target == modal1 || event.target == modal2 || event.target == modal4 || event.target == modal5) {
    modal.style.display = "none";
    modal1.style.display = "none";
    modal2.style.display = "none";
    modal4.style.display = "none";
    modal5.style.display = "none";
  }
};

function addVehicle() {
  var licensePlate = document.getElementById("license_plate").value;
  var ownerName = document.getElementById("owner_name").value;

  // Tạo một đối tượng FormData chứa dữ liệu
  var formData = new FormData();
  formData.append("license_plate", licensePlate);
  formData.append("owner_name", ownerName);

  // Gửi yêu cầu POST đến mã PHP
  fetch("modules/addVehicle.php", {
    method: "POST",
    body: formData,
  })
    .then((response) => response.text())
    .then((result) => {
      // Xử lý kết quả từ mã PHP
      window.location.reload();
      alert("Thêm xe thành công")
    })
    .catch((error) => {
      console.error("Lỗi:", error);
    });
}

function deleteVehicle() {
  var licensePlate = document.getElementById("license_plate_2").value;
  var paymentMethod = document.getElementById("payment_method").value;

  // Tạo một đối tượng FormData chứa dữ liệu
  var formData = new FormData();
  formData.append("license_plate", licensePlate);
  formData.append("payment_method", paymentMethod);

  // Gửi yêu cầu POST đến mã PHP
  fetch("modules/deleteVehicle.php", {
    method: "POST",
    body: formData,
  })
    .then((response) => response.text())
    .then((result) => {
      // Xử lý kết quả từ mã PHP
      window.location.reload();
      alert("Xoá xe thành công");
    })
    .catch((error) => {
      console.error("Lỗi:", error);
    });
}

function addEmployee() {
  var employeeName = document.getElementById("employee_name").value;
  var position = document.getElementById("position").value;
  var contactNumber = document.getElementById("contact_number").value;

  // Tạo một đối tượng FormData chứa dữ liệu
  var formData = new FormData();
  formData.append("employee_name", employeeName);
  formData.append("position", position);
  formData.append("contact_number", contactNumber);

  // Gửi yêu cầu POST đến mã PHP
  fetch("modules/addEmployee.php", {
    method: "POST",
    body: formData,
  })
    .then((response) => response.text())
    .then((result) => {
      console.log(result);
      window.location.reload();
      alert("Thêm nhân viên thành công");
    })
    .catch((error) => {
      console.error("Lỗi:", error);
    });
}

function showEmployee(employeeId) {
  // Hiển thị modal
  var modal = document.getElementById("employeeModal");
  modal.style.display = "block";

  var employeeId1 = document.getElementById("employee_id_1");
  var employeeName = document.getElementById("employee_name_1");
  var position = document.getElementById("position_1");
  var contactNumber = document.getElementById("contact_number_1");

  // Gửi yêu cầu XMLHttpRequest để lấy thông tin nhân viên dựa trên employeeId
  var params = new URLSearchParams();
  params.append("employee_id", employeeId);
  var url = "modules/getEmployeeById.php?" + params.toString();

  fetch(url)
    .then((response) => response.json())
    .then((result) => {
      console.log(result);
      if (result.length > 0) {
        var employeeName1 = result[0].EMPLOYEE_NAME;
        var position1 = result[0].POSITION;
        var contactNumber1 = result[0].CONTACT_NUMBER;
        employeeId1.value = employeeId;
        employeeName.value = employeeName1;
        position.value = position1;
        contactNumber.value = contactNumber1;
      }
    })
    .catch((error) => {
      console.error("Lỗi:", error);
    });
}

// Đóng modal khi nhấn vào nút đóng (X)
var closeButton = document.getElementsByClassName("closee")[0];
closeButton.onclick = function () {
  var modal = document.getElementById("employeeModal");
  modal.style.display = "none";
};

function updateEmployee() {
  var employeeId1 = document.getElementById("employee_id_1").value;
  var employeeName = document.getElementById("employee_name_1").value;
  var position = document.getElementById("position_1").value;
  var contactNumber = document.getElementById("contact_number_1").value;

  // Tạo một đối tượng FormData chứa dữ liệu
  var formData = new FormData();
  formData.append("employee_id", employeeId1);
  formData.append("employee_name", employeeName);
  formData.append("position", position);
  formData.append("contact_number", contactNumber);

  // Gửi yêu cầu POST đến mã PHP
  fetch("modules/updateEmployee.php", {
    method: "POST",
    body: formData,
  })
    .then((response) => response.text())
    .then((result) => {
      console.log(result);
      window.location.reload();
      alert("Sửa nhân viên thành công");
    })
    .catch((error) => {
      console.error("Lỗi:", error);
    });
}

function deleteEmployee(employeeId) {
  // Hiển thị modal
  var modal = document.getElementById("employeeModaldelete");
  modal.style.display = "block";

  var deletebtn = document.getElementById("confirm-delete");
  deletebtn.onclick = function () {
    // Gửi yêu cầu XMLHttpRequest để lấy thông tin nhân viên dựa trên employeeId
    var params = new URLSearchParams();
    params.append("employee_id", employeeId);
    var url = "modules/deleteEmployee.php?" + params.toString();

    fetch(url)
      .then((response) => response.json())
      .then((result) => {
        console.log(result);
        window.location.reload();
        alert("Xoá nhân viên thành công");
      })
      .catch((error) => {
        window.location.reload();
      });
  }
}

// Đóng modal khi nhấn vào nút đóng (X)
var closeButton1 = document.getElementsByClassName("closee1")[0];
closeButton1.onclick = function () {
  var modal = document.getElementById("employeeModaldelete");
  modal.style.display = "none";
};