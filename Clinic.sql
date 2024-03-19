SELECT * FROM mis602_ass2.appointment;

-- monthwise patient count

SELECT
     MONTH(appointment_date) AS MONTH_NAME,
     COUNT(DISTINCT appointment_id) AS No_of_appt
FROM appointment
GROUP BY 1;

-- no. of patients per doctor

SELECT 
	a.doctor_id,
    o.name,
    COUNT(DISTINCT a.appointment_id) AS patient_count
FROM appointment AS a
LEFT JOIN doctor AS o
ON a.doctor_id=o.doctor_id
GROUP BY 1;

-- types of patient
 
 SELECT
      notes,
      COUNT(DISTINCT appointment_id) AS no_of_patients
FROM appointment
GROUP BY 1
ORDER BY 2 DESC;