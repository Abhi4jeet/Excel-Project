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

-- speciality of doctotrs

SELECT 
	  o.doctor_id,
      o.name,
      s.speciality_id,
      s.name
FROM doctor AS o
LEFT JOIN speciality AS s
ON o.speciality_id=s.speciality_id;

-- no of specialist doctors

SELECT 
      s.name,
      COUNT(DISTINCT o.doctor_id) AS docs
 FROM doctor AS o
LEFT JOIN speciality AS s
ON o.speciality_id=s.speciality_id     
GROUP BY 1
ORDER BY 2 desc;

-- category wise drug use

SELECT 
     description,
     COUNT(DISTINCT medication_id) AS items_sold
FROM medication
GROUP BY 1;

-- top manufacturers

SELECT 
     manufacturer,
     COUNT(DISTINCT medication_id) AS items_sold
FROM medication
GROUP BY 1
ORDER BY 2 DESC;

-- usage by strength

SELECT 
     strength,
     COUNT(DISTINCT medication_id) AS medication_used
FROM medication
GROUP BY 1
ORDER BY 2 DESC;

-- no. of male and female patients

SELECT 
     gender,
     COUNT(DISTINCT patient_id) AS no_of_patients
FROM patient
GROUP BY 1;

-- statewise no. of patient

SELECT 
     state_code,
     COUNT(DISTINCT patient_id) AS no_of_patients
FROM patient
GROUP BY 1;