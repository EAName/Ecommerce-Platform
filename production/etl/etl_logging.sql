-- ETL Logging and Error Handling

-- ETL Audit Table
CREATE TABLE IF NOT EXISTS ETL_Audit (
    ETLRunID SERIAL PRIMARY KEY,
    StartTime TIMESTAMP,
    EndTime TIMESTAMP,
    Status VARCHAR(20),
    RecordsInserted INT,
    RecordsUpdated INT,
    ErrorMessage TEXT
);

-- Example: Log ETL start
INSERT INTO ETL_Audit (StartTime, Status) VALUES (CURRENT_TIMESTAMP, 'STARTED') RETURNING ETLRunID;

-- Example: Log ETL end
UPDATE ETL_Audit SET EndTime = CURRENT_TIMESTAMP, Status = 'SUCCESS', RecordsInserted = 1000, RecordsUpdated = 200 WHERE ETLRunID = 1;

-- Example: Log ETL error
UPDATE ETL_Audit SET EndTime = CURRENT_TIMESTAMP, Status = 'FAILED', ErrorMessage = 'Error details here' WHERE ETLRunID = 1; 