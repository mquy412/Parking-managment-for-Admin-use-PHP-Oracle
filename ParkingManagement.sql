CREATE TABLE MANAGER1.ParkingLots (
  parking_lot_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  parking_lot_name VARCHAR2(50),
  parking_lot_address VARCHAR2(200),
  capacity NUMBER
);
CREATE TABLE MANAGER1.ParkingSpaceStatus (
  space_status_id NUMBER PRIMARY KEY,
  status_name VARCHAR2(50)
);
CREATE TABLE MANAGER1.ParkingSpaces (
  space_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  parking_lot_id NUMBER,
  space_status_id NUMBER,
  CONSTRAINT fk_parking_lot_id FOREIGN KEY (parking_lot_id) REFERENCES MANAGER1.ParkingLots(parking_lot_id),
  CONSTRAINT fk_space_status_id FOREIGN KEY (space_status_id) REFERENCES MANAGER1.ParkingSpaceStatus(space_status_id)
);
CREATE TABLE MANAGER1.Vehicles (
  vehicle_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  license_plate VARCHAR2(50),
  owner_name NVARCHAR2(200)
);
CREATE TABLE MANAGER1.Vehicle_ParkingSpace (
  id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vehicle_id NUMBER,
  space_id NUMBER,
  CONSTRAINT fk_space_id FOREIGN KEY (space_id) REFERENCES MANAGER1.ParkingSpaces(space_id),
  CONSTRAINT fk_vehicle_id FOREIGN KEY (vehicle_id) REFERENCES MANAGER1.Vehicles(vehicle_id)
);
CREATE TABLE MANAGER1.Transactions (
  transaction_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vehicle_id NUMBER,
  entry_time TIMESTAMP,
  exit_time TIMESTAMP,
  CONSTRAINT fk_vehicle_id_2 FOREIGN KEY (vehicle_id) REFERENCES MANAGER1.Vehicles(vehicle_id)
);
CREATE TABLE MANAGER1.Payments (
  payment_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transaction_id NUMBER,
  payment_method NVARCHAR2(50),
  payment_time TIMESTAMP,
  amount_paid NUMBER,
  CONSTRAINT fk_transaction_id FOREIGN KEY (transaction_id) REFERENCES MANAGER1.Transactions(transaction_id)
);
CREATE TABLE MANAGER1.Employees (
  employee_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  employee_name NVARCHAR2(200),
  position NVARCHAR2(50),
  contact_number NVARCHAR2(15)
);
CREATE TABLE MANAGER1.Shifts (
  shift_id NUMBER PRIMARY KEY,
  shift_name VARCHAR2(20),
  start_time VARCHAR2(50),
  end_time VARCHAR2(50),
  salary NUMBER(10, 2)
);
CREATE TABLE MANAGER1.WorkSchedule (
  schedule_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  employee_id NUMBER,
  shift_id NUMBER,
  work_date TIMESTAMP,
  CONSTRAINT fk_employee_id FOREIGN KEY (employee_id) REFERENCES MANAGER1.Employees(employee_id),
  CONSTRAINT fk_shift_id FOREIGN KEY (shift_id) REFERENCES MANAGER1.Shifts(shift_id)
);



INSERT INTO MANAGER1.ParkingLots (parking_lot_name, parking_lot_address, capacity) VALUES ('A', 'Floor1', 10);
INSERT INTO MANAGER1.ParkingLots (parking_lot_name, parking_lot_address, capacity) VALUES ('B', 'Floor1', 10);
INSERT INTO MANAGER1.ParkingLots (parking_lot_name, parking_lot_address, capacity) VALUES ('C', 'Floor1', 10);
INSERT INTO MANAGER1.ParkingLots (parking_lot_name, parking_lot_address, capacity) VALUES ('D', 'Floor2', 10);
INSERT INTO MANAGER1.ParkingLots (parking_lot_name, parking_lot_address, capacity) VALUES ('E', 'Floor2', 10);
INSERT INTO MANAGER1.ParkingLots (parking_lot_name, parking_lot_address, capacity) VALUES ('F', 'Floor2', 10);

INSERT INTO MANAGER1.ParkingSpaceStatus (space_status_id ,status_name) VALUES (0, 'available');
INSERT INTO MANAGER1.ParkingSpaceStatus (space_status_id ,status_name) VALUES (1, 'occupied');
INSERT INTO MANAGER1.ParkingSpaceStatus (space_status_id ,status_name) VALUES (2, 'reserved');
--có s?n, ?ã b? chi?m, dành riêng
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (1, 0);

INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (2, 0);

INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (3, 0);

INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (4, 0);

INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (5, 0);

INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);
INSERT INTO MANAGER1.ParkingSpaces (parking_lot_id, space_status_id) VALUES (6, 0);

INSERT INTO MANAGER1.Employees (employee_name, position, contact_number) VALUES ('Quy', 'Manager', '0123123123');
INSERT INTO MANAGER1.Employees (employee_name, position, contact_number) VALUES ('Quan', 'Cashier', '0123123123');
INSERT INTO MANAGER1.Employees (employee_name, position, contact_number) VALUES ('Duc', 'Guard', '0123123123');
INSERT INTO MANAGER1.Employees (employee_name, position, contact_number) VALUES ('An', 'Guard', '0123123123');
INSERT INTO MANAGER1.Employees (employee_name, position, contact_number) VALUES ('LanAnh', 'Cashier', '0123123123');

INSERT INTO MANAGER1.Shifts (shift_id, shift_name, start_time, end_time, salary) VALUES (1, 'Morning', '6h', '12h', 15);
INSERT INTO MANAGER1.Shifts (shift_id, shift_name, start_time, end_time, salary) VALUES (2, 'Afternoon', '12h', '18h', 15);
INSERT INTO MANAGER1.Shifts (shift_id, shift_name, start_time, end_time, salary) VALUES (3, 'Evening', '18h', '0h', 17);
INSERT INTO MANAGER1.Shifts (shift_id, shift_name, start_time, end_time, salary) VALUES (4, 'Night', '0h', '6h', 20);


--TRUNCATE table MANAGER1.vehicles;
--ALTER TABLE MANAGER1.payments MODIFY(payment_id Generated as Identity (START WITH 1));

