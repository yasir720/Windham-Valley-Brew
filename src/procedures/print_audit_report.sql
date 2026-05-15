CREATE OR REPLACE PROCEDURE print_audit_report IS
    CURSOR c_audit IS
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
BEGIN
    FOR v_entry IN c_audit LOOP
        DBMS_OUTPUT.PUT_LINE(
            'id = ' || v_entry.audit_id ||
            ' | ' || TO_CHAR(v_entry.log_time, 'YYYY-MM-DD HH24:MI:SS') ||
            ' | ' || v_entry.event_type ||
            ' | ' || NVL(v_entry.object_type, '-') ||
            ' | ' || NVL(TO_CHAR(v_entry.object_id), '-') ||
            ' | ' || NVL(v_entry.operation, '-') ||
            ' | ' || NVL(v_entry.details, '-') ||
            ' | ' || NVL(TO_CHAR(v_entry.error_code), '-') ||
            ' | ' || NVL(v_entry.error_message, '-') ||
            ' | ' || NVL(v_entry.source_proc, '-')
        );
    END LOOP;
END;
/
