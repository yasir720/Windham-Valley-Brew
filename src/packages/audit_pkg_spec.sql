CREATE OR REPLACE PACKAGE audit_pkg AS
    -- Procedures:
    -- Procedure to log a general audit entry.
    PROCEDURE log_audit_entry(
        p_event_type IN VARCHAR2,
        p_object_type IN VARCHAR2,
        p_object_id IN NUMBER,
        p_operation IN VARCHAR2,
        p_details IN VARCHAR2,
        p_error_code IN NUMBER := NULL,
        p_error_message IN VARCHAR2 := NULL,
        p_source_proc IN VARCHAR2 := NULL
    );

    -- Procedure to log an error entry.
    PROCEDURE log_error_entry(
        p_object_type IN VARCHAR2,
        p_object_id IN NUMBER,
        p_operation IN VARCHAR2,
        p_details IN VARCHAR2,
        p_error_code IN NUMBER,
        p_error_message IN VARCHAR2,
        p_source_proc IN VARCHAR2
    );
    
    -- Functions:
    -- Function to retrieve all audit entries.
    FUNCTION get_audit_entries RETURN SYS_REFCURSOR;
END audit_pkg;
/