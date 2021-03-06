/*

 Name:          statspack_snap_schedule.sql

 Purpose:       schedule for statspack snap
 
 Usage:         Schedule this within the PERFSTAT schema. 
 
 Pre-Requirements: Schema must have been GRANTED the SCHEDULER_ADMIN role 
				e.g. GRANT SCHEDULER_ADMIN to PERFSTAT;
 
 Date            Who             Description

 12th Dec 2014   Aidan Lawrence  Converted from DBMS_JOB and frequency changed to reduce contention
 15th Jun 2017	 Aidan Lawrence  Example clean up for git  
*/

BEGIN

	DECLARE

    object_not_exist_exception EXCEPTION; 

    PRAGMA EXCEPTION_INIT (object_not_exist_exception, -27475); 

	BEGIN

		dbms_scheduler.drop_job(
        job_name            => 'STATSPACK_SNAP_JOB'
		);
    		
    EXCEPTION
    WHEN object_not_exist_exception
    THEN NULL; -- Ignore simple drop errors for object not existing;
    
	END;


	DECLARE

    object_not_exist_exception EXCEPTION; 

    PRAGMA EXCEPTION_INIT (object_not_exist_exception, -27476); 

	BEGIN

		dbms_scheduler.drop_schedule(
        schedule_name            => 'STATSPACK_SNAP_SCH'
		);
    		
    EXCEPTION
    WHEN object_not_exist_exception
    THEN NULL; -- Ignore simple drop errors for object not existing;
    
	END;

dbms_scheduler.create_schedule(
    schedule_name       => 'STATSPACK_SNAP_SCH'
  , start_date          => to_timestamp('04-JUL-2014 10:00','DD-MON-YYYY HH24:MI')
  , repeat_interval     => 'FREQ=DAILY; BYHOUR=02,05,08,11,14,17,20,23; BYMINUTE=30; BYSECOND=00;'
  , end_date            => to_timestamp('31-DEC-2099 0:00','DD-MON-YYYY HH24:MI')
  , comments            => 'Schedule to control statspack snap'
    );

END;
/  