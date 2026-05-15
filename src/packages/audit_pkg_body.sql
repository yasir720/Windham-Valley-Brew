CREATE OR REPLACE PACKAGE BODY audit_pkg AS
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
    ) IS
    BEGIN
        INSERT INTO audit_log (
            audit_id,
            event_type,
            object_type,
            object_id,
            operation,
            details,
            error_code,
            error_message,
            source_proc
        ) VALUES (
            audit_seq.NEXTVAL,
            p_event_type,
            p_object_type,
            p_object_id,
            p_operation,
            p_details,
            p_error_code,
            p_error_message,
            p_source_proc
        );
    END;

    -- Procedure to log an error entry.
    PROCEDURE log_error_entry(
        p_object_type IN VARCHAR2,
        p_object_id IN NUMBER,
        p_operation IN VARCHAR2,
        p_details IN VARCHAR2,
        p_error_code IN NUMBER,
        p_error_message IN VARCHAR2,
        p_source_proc IN VARCHAR2
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        log_audit_entry(
            'ERROR',
            p_object_type,
            p_object_id,
            p_operation,
            p_details,
            p_error_code,
            p_error_message,
            p_source_proc
        );
        COMMIT;
    END;

    -- Functions:
    -- Function to retrieve all audit entries.
    FUNCTION get_audit_entries RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT
                audit_id,
                log_time,
                event_type,
                object_type,
                object_id,
                operation,
                details,
                error_code,
                error_message,
                source_proc
            FROM audit_log
            ORDER BY log_time DESC;

        RETURN v_cursor;
    END;
END audit_pkg;
/