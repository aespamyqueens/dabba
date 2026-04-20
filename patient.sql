Database Schema:

PATIENT(patient_id, patient_name, phone_number, doctor_id, insurance_id, other_details)

DOCTOR(doctor_id, doctor_name, specialization, position, other_details)

APPOINTMENT(appointment_id, patient_id, doctor_id, room_number, appointment_date, other_details)

Question 1:
Write an SQL query to display the patient name and doctor ID for those patients who are treated by doctors holding the position of 'Head Doctor'.

Question 2:
Write an SQL query to display the doctor ID, patient name, and appointment count for those cases where a doctor has conducted appointments in the same room more than once.

Question 3:
Write a stored procedure to count the number of insured and uninsured patients for each doctor. The procedure should accept a doctor ID as input and return the doctor name, number of insured patients, and number of uninsured patients. Also, demonstrate how the procedure can be executed for all doctors in the DOCTOR table.

Question 4:
Write a trigger on the APPOINTMENT table that is activated after inserting a new appointment. The trigger should display the details of the newly inserted appointment and the total number of appointments for the corresponding doctor after the insertion.


1) select p.patient_name, d.doctor_id from patient p join appointment a on a.patient_id = p.patient_id join doctor d on a.doctor_id = d.doctor_id where d.position = 'Head Doctor';

2) select d.doctor_id, p.patient_name, count(a.room_number) from patient p join appointment a on a.patient_id = p.patient_id join doctor d on a.doctor_id = d.doctor_id group by d.doctor_id, p.patient_name, a.room_number having count(a.room_number) > 1;

3) create or replace procedure insured_patients (
p_insured_count OUT number,
p_uninsured_count OUT number,
d_id IN doctor.doctor_id%TYPE,
d_name OUT doctor.doctor_name%TYPE) AS

BEGIN

select doctor_name into d_name from doctor where doctor_id=d_id;

select
count(case when insurance_id is NOT NULL then 1 end), count(case when insurance_id is NULL then 1 end)
into p_insured_count, p_uninsured_count from patient where doctor_id=d_id;
END;
/

4) create or replace trigger appointment_trg after insert on APPOINTMENT for each row

declare
d_appointment_count number;

begin
if inserting then
select count(*) into d_appointment_count from appointment where doctor_id=:new.doctor_id;
dbms_output.put_line(:new.appointment_id || :new.patient_id);
dbms_output.put_line(d_appointment_count);
end if;
end;
/
