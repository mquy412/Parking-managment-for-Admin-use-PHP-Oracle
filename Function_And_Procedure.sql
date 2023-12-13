--DANH SACH CAC BAI DO XE VA SO LUONG CHO TRONG TRONG MOI BAI
SELECT a.parking_lot_id, a.parking_lot_name, a.capacity, 
       (a.capacity - COALESCE(occupied_spaces.count, 0)) AS available_spaces
FROM MANAGER1.ParkingLots a
LEFT JOIN (
    SELECT b.parking_lot_id, COUNT(c.space_id) AS count
    FROM MANAGER1.ParkingSpaces b
    LEFT JOIN MANAGER1.Vehicle_ParkingSpace c ON b.space_id = c.space_id
    GROUP BY b.parking_lot_id
) occupied_spaces ON a.parking_lot_id = occupied_spaces.parking_lot_id;

--DANH SACH CAC BAI DO XE VA SO LUONG XE TRONG MOI BAI
SELECT a.parking_lot_name, COUNT(c.id) AS vehicle_count
FROM MANAGER1.ParkingLots a
LEFT JOIN MANAGER1.ParkingSpaces b ON a.parking_lot_id = b.parking_lot_id
LEFT JOIN MANAGER1.Vehicle_ParkingSpace c ON b.space_id = c.space_id
GROUP BY a.parking_lot_name
ORDER BY a.parking_lot_name;

--TONG TIEN THU DUOC TU CAC PHUONG THUC THANH TOAN KHAC NHAU
SELECT a.payment_method, SUM(a.amount_paid) AS total_amount
FROM MANAGER1.Payments a
JOIN MANAGER1.Transactions b ON a.transaction_id = b.transaction_id
GROUP BY a.payment_method;

--TONG TIEN THU DUOC TU TRUOC DEN NAY
SELECT SUM(amount_paid) AS total_amount
FROM MANAGER1.Payments;

--HOA DON CO GIA TRI LON NHAT
SELECT MAX(amount_paid) AS max_amount_paid
FROM MANAGER1.Payments;

--CAC CA LAM CUA NHAN VIEN TU NGAY MAI
SELECT schedule_id, b.employee_id,b.employee_name, c.shift_name, a.work_date
FROM MANAGER1.WorkSchedule a
JOIN MANAGER1.Employees b ON a.employee_id = b.employee_id
JOIN MANAGER1.Shifts c ON a.shift_id = c.shift_id
WHERE a.work_date >= TRUNC(SYSDATE) + 1;

--HAM TINH SO HOA DON
CREATE OR REPLACE FUNCTION MANAGER1.get_payments_between(start_date DATE, end_date DATE)
  RETURN NUMBER
IS
  paid_invoice_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO paid_invoice_count
  FROM MANAGER1.Payments
  WHERE TRUNC(payment_time) >= TRUNC(start_date)
    AND TRUNC(payment_time) <= TRUNC(end_date);
  RETURN paid_invoice_count;
END;
/
SELECT MANAGER1.get_payments_between(DATE '2023-11-20', DATE '2023-11-23') AS payment_quantity 
FROM DUAL;

--HAM TINH TONG DOANH THU
CREATE OR REPLACE FUNCTION MANAGER1.Total_revenue(start_date DATE, end_date DATE)
  RETURN NUMBER
IS
  total_revenue NUMBER := 0;
BEGIN
  FOR payment IN (
    SELECT amount_paid
    FROM MANAGER1.Payments
    WHERE payment_time >= start_date
      AND payment_time <= end_date
  ) LOOP
    total_revenue := total_revenue + payment.amount_paid;
  END LOOP;

  RETURN total_revenue;
END;
/
DECLARE
  total_revenue NUMBER;
BEGIN
  total_revenue := MANAGER1.Total_revenue(DATE '2022-01-01', DATE '2023-12-31');
  DBMS_OUTPUT.PUT_LINE('Total Revenue: ' || total_revenue);
END;

--HAM TINH LUONG NHAN VIEN
CREATE OR REPLACE FUNCTION MANAGER1.CalculateSalary(
  p_employee_id IN NUMBER,
  p_start_date IN TIMESTAMP,
  p_end_date IN TIMESTAMP
) RETURN NUMBER
AS
  v_total_salary NUMBER(10, 2);
BEGIN
  SELECT SUM(b.salary)
  INTO v_total_salary
  FROM MANAGER1.WorkSchedule a
  JOIN MANAGER1.Shifts b ON a.shift_id = b.shift_id
  WHERE a.employee_id = p_employee_id
    AND a.work_date >= p_start_date
    AND a.work_date <= p_end_date;
  RETURN v_total_salary;
END;
/
DECLARE
  v_salary NUMBER(10, 2);
BEGIN
  v_salary := MANAGER1.CalculateSalary(2, TIMESTAMP '2023-11-01 00:00:00', TIMESTAMP '2023-11-30 23:59:59');
  DBMS_OUTPUT.PUT_LINE('Total Salary: ' || v_salary);
END;

--THU TUC THEM XE VAO BAI GUI
CREATE OR REPLACE PROCEDURE MANAGER1.AddVehicleToParkingLot(
  p_license_plate IN VARCHAR2,
  p_owner_name IN NVARCHAR2
)
AS
  vehicle_count NUMBER;
  new_vehicle_id NUMBER;
  entry_time TIMESTAMP;
  parking_space_id NUMBER;
BEGIN

  SELECT COUNT(*)
  INTO vehicle_count
  FROM MANAGER1.Vehicle_ParkingSpace a
  JOIN MANAGER1.Vehicles b ON a.vehicle_id = b.vehicle_id
  WHERE b.license_plate = p_license_plate;

  IF vehicle_count > 0 THEN
    dbms_output.put_line('The license plate already exists.');
    RETURN;
  END IF;

  INSERT INTO MANAGER1.Vehicles (license_plate, owner_name)
  VALUES (p_license_plate, p_owner_name)
  RETURNING vehicle_id INTO new_vehicle_id;

  entry_time := SYSTIMESTAMP;
  INSERT INTO MANAGER1.Transactions (vehicle_id, entry_time)
  VALUES (new_vehicle_id, entry_time);

  -- Tìm mot cho gui có space_status_id = 0
  -- và thêm mot ban ghi moi trong bang Vehicle_ParkingSpace
  SELECT space_id INTO parking_space_id
  FROM (
    SELECT space_id
    FROM MANAGER1.ParkingSpaces
    WHERE space_status_id = 0
    ORDER BY space_id )
  WHERE ROWNUM = 1;

  INSERT INTO MANAGER1.Vehicle_ParkingSpace (vehicle_id, space_id)
  VALUES (new_vehicle_id, parking_space_id);

  UPDATE MANAGER1.ParkingSpaces
  SET space_status_id = 1
  WHERE space_id = parking_space_id;
  
  COMMIT;
END;


--THU TUC XOA XE KHOI BAI
CREATE OR REPLACE PROCEDURE MANAGER1.DeleteVehicleFromParkingLot(
  p_license_plate IN VARCHAR2,
  p_payment_method IN VARCHAR2
)
AS
  v_vehicle_count NUMBER;
  v_entry_time TIMESTAMP;
  v_exit_time TIMESTAMP;
  v_transaction_id NUMBER;
  v_space_id NUMBER;
  v_hours_diff NUMBER;
  v_amount_paid NUMBER;
BEGIN

  SELECT COUNT(*)
  INTO v_vehicle_count
  FROM MANAGER1.Vehicle_ParkingSpace a
  JOIN MANAGER1.Vehicles b ON a.vehicle_id = b.vehicle_id
  WHERE b.license_plate = p_license_plate;

  IF v_vehicle_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('The car is not in the parking lot.');
    RETURN;
  END IF;
  
  -- Lay entry_time và transaction_id tu bang Transactions dua trên license_plate
  SELECT entry_time, transaction_id
  INTO v_entry_time, v_transaction_id
  FROM MANAGER1.Transactions a
  INNER JOIN MANAGER1.Vehicles b ON a.vehicle_id = b.vehicle_id
  WHERE license_plate = p_license_plate
  ORDER BY transaction_id DESC
  FETCH FIRST 1 ROW ONLY;
    
    IF v_transaction_id IS NOT NULL THEN
    -- Cap nhap exit_time trong b?ng Transactions
    v_exit_time := CURRENT_TIMESTAMP;
    UPDATE MANAGER1.Transactions
    SET exit_time = v_exit_time
    WHERE transaction_id = v_transaction_id;

    v_hours_diff := EXTRACT(DAY FROM v_exit_time - v_entry_time) * 24 +
                  EXTRACT(HOUR FROM v_exit_time - v_entry_time);

    IF v_hours_diff = 0 THEN
        v_hours_diff := 1;
    END IF;

    v_amount_paid := 2 * v_hours_diff;
    INSERT INTO MANAGER1.Payments (transaction_id, payment_method, payment_time, amount_paid)
    VALUES (v_transaction_id, p_payment_method, v_exit_time, v_amount_paid);

    -- Cap nhap space_status_id = 0 trong bang ParkingSpaces
    SELECT space_id
    INTO v_space_id
    FROM MANAGER1.Vehicle_ParkingSpace
    WHERE vehicle_id = (SELECT a.vehicle_id FROM MANAGER1.Vehicle_ParkingSpace a join MANAGER1.Vehicles b on a.vehicle_id = b.vehicle_id WHERE b.license_plate = p_license_plate);

    UPDATE MANAGER1.ParkingSpaces
    SET space_status_id = 0
    WHERE space_id = v_space_id;

    DELETE FROM MANAGER1.Vehicle_ParkingSpace
    WHERE space_id = v_space_id;
    COMMIT;

    ELSE
    RETURN;
    END IF;
END;


--THU TUC HIEN THI CON BAO NHIEU CHO TRONG
CREATE OR REPLACE PROCEDURE MANAGER1.show_available_spaces
IS
  available_spaces NUMBER := 0;
  v_space_id NUMBER;
BEGIN
  DECLARE
    CURSOR cursor_spaces IS
      SELECT space_id
      FROM MANAGER1.ParkingSpaces
      WHERE space_status_id = 0;
  BEGIN
    OPEN cursor_spaces;
    LOOP
      FETCH cursor_spaces INTO v_space_id;
      EXIT WHEN cursor_spaces%NOTFOUND;

      available_spaces := available_spaces + 1;
    END LOOP;
    CLOSE cursor_spaces;
  END;
  DBMS_OUTPUT.PUT_LINE('Available Spaces: ' || available_spaces);
END;
/
EXECUTE MANAGER1.show_available_spaces;

--THU TUC HIEN THI THONG TIN MOT XE CU THE
CREATE OR REPLACE PROCEDURE MANAGER1.GetCarInformation(
  p_license_plate IN VARCHAR2
)
AS
  v_vehicle_count NUMBER;
  v_license_plate VARCHAR2(50);
  v_owner_name NVARCHAR2(200);
  v_space_id NUMBER;
  v_parking_lot_name VARCHAR2(50);
  v_parking_lot_address VARCHAR2(200);
BEGIN
  SELECT COUNT(*)
  INTO v_vehicle_count
  FROM MANAGER1.Vehicle_ParkingSpace a
  JOIN MANAGER1.Vehicles b ON a.vehicle_id = b.vehicle_id
  WHERE b.license_plate = p_license_plate;

  IF v_vehicle_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('The car is not in the parking lot.');
    RETURN;
  END IF;

  SELECT b.space_id, d.parking_lot_name, d.parking_lot_address , a.owner_name
  INTO v_space_id, v_parking_lot_name, v_parking_lot_address ,v_owner_name
  FROM MANAGER1.Vehicles a
  JOIN MANAGER1.vehicle_parkingspace b ON a.vehicle_id = b.vehicle_id
  JOIN MANAGER1.parkingspaces c ON b.space_id = c.space_id
  JOIN MANAGER1.parkinglots d ON c.parking_lot_id = d.parking_lot_id
  WHERE a.license_plate = p_license_plate;
  
  IF v_space_id IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('License Plate: ' || p_license_plate);
      DBMS_OUTPUT.PUT_LINE('Space Id: ' || v_space_id);
      DBMS_OUTPUT.PUT_LINE('Parking Lot Name: ' || v_parking_lot_name);
      DBMS_OUTPUT.PUT_LINE('Parking Lot Address: ' || v_parking_lot_address);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Invalid parking information for the car.');
    END IF;
END;
/
EXECUTE MANAGER1.GetCarInformation('34K7-87876');

--THU TUC HIEN THI THONG TIN CAC XE DANG GUI TRONG BAI
CREATE OR REPLACE PROCEDURE MANAGER1.displayParkingLotInfo
IS
  cursor_parked_cars SYS_REFCURSOR;
  v_space_id NUMBER;
  v_license_plate VARCHAR2(50);
  v_owner_name NVARCHAR2(200);
BEGIN
  OPEN cursor_parked_cars FOR
    SELECT a.space_id, b.license_plate, b.owner_name
    FROM MANAGER1.vehicle_parkingspace a
    JOIN MANAGER1.vehicles b ON a.vehicle_id = b.vehicle_id;
  LOOP
    FETCH cursor_parked_cars INTO v_space_id, v_license_plate, v_owner_name;
    EXIT WHEN cursor_parked_cars%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Space ID: ' || v_space_id);
    DBMS_OUTPUT.PUT_LINE('Plate Number: ' || v_license_plate);
    DBMS_OUTPUT.PUT_LINE('Owner: ' || v_owner_name);
    DBMS_OUTPUT.NEW_LINE;
  END LOOP;
  CLOSE cursor_parked_cars;
END;
/
BEGIN
  MANAGER1.displayParkingLotInfo();
END;

--THU TUC DANG KY CA LAM VIEC
CREATE OR REPLACE PROCEDURE MANAGER1.RegisterWorkSchedule(
  p_employee_id IN NUMBER,
  p_shift_id IN NUMBER,
  p_work_date IN TIMESTAMP
)
AS
  v_max_employees CONSTANT NUMBER := 2;
  v_current_employees NUMBER;
  v_current_date TIMESTAMP := SYSTIMESTAMP;
BEGIN
  IF p_work_date <= v_current_date THEN
    DBMS_OUTPUT.PUT_LINE('Invalid work date. Work date must be greater than the current date.');
  ELSE
    SELECT COUNT(*)
    INTO v_current_employees
    FROM MANAGER1.WorkSchedule
    WHERE shift_id = p_shift_id AND work_date = p_work_date;

    IF v_current_employees >= v_max_employees THEN
      DBMS_OUTPUT.PUT_LINE('This shift is already full.');
    ELSE
      INSERT INTO MANAGER1.WorkSchedule (employee_id, shift_id, work_date)
      VALUES (p_employee_id, p_shift_id, p_work_date);
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Work schedule registered successfully.');
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occurred while registering work schedule: ' || SQLERRM);
END;
/
EXECUTE MANAGER1.RegisterWorkSchedule(3, 2, TO_TIMESTAMP('2023-11-25', 'YYYY-MM-DD'));