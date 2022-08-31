BEGIN TRANSACTION;

DROP INDEX graphql.ix_graphql_field_name_regex;

DROP INDEX graphql.ix_graphql_type_name_regex;

DROP SCHEMA pgbouncer;

DROP SCHEMA pgsodium_masks;

DROP SCHEMA pgsodium;

SET allow_system_table_mods TO 'off';
SET application_name TO 'PostgresCompare 1.1.91.0';
SET archive_cleanup_command TO '';
SET archive_command TO '(disabled)';
SET archive_mode TO 'off';
SET archive_timeout TO '0';
SET array_nulls TO 'on';
SET authentication_timeout TO '60';
SET autovacuum TO 'on';
SET autovacuum_analyze_scale_factor TO '0.1';
SET autovacuum_analyze_threshold TO '50';
SET autovacuum_freeze_max_age TO '200000000';
SET autovacuum_max_workers TO '3';
SET autovacuum_multixact_freeze_max_age TO '400000000';
SET autovacuum_naptime TO '60';
SET autovacuum_vacuum_cost_delay TO '2';
SET autovacuum_vacuum_cost_limit TO '-1';
SET autovacuum_vacuum_insert_scale_factor TO '0.2';
SET autovacuum_vacuum_insert_threshold TO '1000';
SET autovacuum_vacuum_scale_factor TO '0.2';
SET autovacuum_vacuum_threshold TO '50';
SET autovacuum_work_mem TO '-1';
SET backend_flush_after TO '0';
SET backslash_quote TO 'safe_encoding';
SET backtrace_functions TO '';
SET bgwriter_delay TO '200';
SET bgwriter_flush_after TO '64';
SET bgwriter_lru_maxpages TO '100';
SET bgwriter_lru_multiplier TO '2';
SET block_size TO '8192';
SET bonjour TO 'off';
SET bonjour_name TO '';
SET bytea_output TO 'hex';
SET check_function_bodies TO 'on';
SET checkpoint_completion_target TO '0.5';
SET checkpoint_flush_after TO '32';
SET checkpoint_timeout TO '300';
SET checkpoint_warning TO '30';
SET client_connection_check_interval TO '0';
SET client_encoding TO 'UTF8';
SET client_min_messages TO 'notice';
SET cluster_name TO 'main';
SET commit_delay TO '0';
SET commit_siblings TO '5';
SET compute_query_id TO 'auto';
SET config_file TO '/etc/postgresql/postgresql.conf';
SET constraint_exclusion TO 'partition';
SET cpu_index_tuple_cost TO '0.005';
SET cpu_operator_cost TO '0.0025';
SET cpu_tuple_cost TO '0.01';
SET cron.database_name TO 'postgres';
SET cron.enable_superuser_jobs TO 'on';
SET cron.host TO 'localhost';
SET cron.log_min_messages TO 'warning';
SET cron.log_run TO 'on';
SET cron.log_statement TO 'on';
SET cron.max_running_jobs TO '32';
SET cron.use_background_workers TO 'off';
SET cursor_tuple_fraction TO '0.1';
SET data_checksums TO 'off';
SET data_directory TO '/var/lib/postgresql/data';
SET data_directory_mode TO '0700';
SET data_sync_retry TO 'off';
SET DateStyle TO 'ISO, MDY';
SET db_user_namespace TO 'off';
SET deadlock_timeout TO '1000';
SET debug_assertions TO 'off';
SET debug_discard_caches TO '0';
SET debug_pretty_print TO 'on';
SET debug_print_parse TO 'off';
SET debug_print_plan TO 'off';
SET debug_print_rewritten TO 'off';
SET default_statistics_target TO '100';
SET default_table_access_method TO 'heap';
SET default_tablespace TO '';
SET default_text_search_config TO 'pg_catalog.english';
SET default_toast_compression TO 'pglz';
SET default_transaction_deferrable TO 'off';
SET default_transaction_isolation TO 'read committed';
SET default_transaction_read_only TO 'off';
SET dynamic_library_path TO '$libdir';
SET dynamic_shared_memory_type TO 'posix';
SET effective_cache_size TO '16384';
SET effective_io_concurrency TO '1';
SET enable_async_append TO 'on';
SET enable_bitmapscan TO 'on';
SET enable_gathermerge TO 'on';
SET enable_hashagg TO 'on';
SET enable_hashjoin TO 'on';
SET enable_incremental_sort TO 'on';
SET enable_indexonlyscan TO 'on';
SET enable_indexscan TO 'on';
SET enable_material TO 'on';
SET enable_memoize TO 'on';
SET enable_mergejoin TO 'on';
SET enable_nestloop TO 'on';
SET enable_parallel_append TO 'on';
SET enable_parallel_hash TO 'on';
SET enable_partition_pruning TO 'on';
SET enable_partitionwise_aggregate TO 'off';
SET enable_partitionwise_join TO 'off';
SET enable_seqscan TO 'on';
SET enable_sort TO 'on';
SET enable_tidscan TO 'on';
SET escape_string_warning TO 'on';
SET event_source TO 'PostgreSQL';
SET exit_on_error TO 'off';
SET extension_destdir TO '';
SET external_pid_file TO '';
SET extra_float_digits TO '0';
SET force_parallel_mode TO 'off';
SET from_collapse_limit TO '8';
SET fsync TO 'on';
SET full_page_writes TO 'on';
SET geqo TO 'on';
SET geqo_effort TO '5';
SET geqo_generations TO '0';
SET geqo_pool_size TO '0';
SET geqo_seed TO '0';
SET geqo_selection_bias TO '2';
SET geqo_threshold TO '12';
SET gin_fuzzy_search_limit TO '0';
SET gin_pending_list_limit TO '4096';
SET hash_mem_multiplier TO '1';
SET hba_file TO '/etc/postgresql/pg_hba.conf';
SET hot_standby TO 'on';
SET hot_standby_feedback TO 'off';
SET huge_page_size TO '0';
SET huge_pages TO 'try';
SET ident_file TO '/etc/postgresql/pg_ident.conf';
SET idle_in_transaction_session_timeout TO '0';
SET idle_session_timeout TO '0';
SET ignore_checksum_failure TO 'off';
SET ignore_invalid_pages TO 'off';
SET ignore_system_indexes TO 'off';
SET in_hot_standby TO 'off';
SET integer_datetimes TO 'on';
SET IntervalStyle TO 'postgres';
SET jit TO 'on';
SET jit_above_cost TO '100000';
SET jit_debugging_support TO 'off';
SET jit_dump_bitcode TO 'off';
SET jit_expressions TO 'on';
SET jit_inline_above_cost TO '500000';
SET jit_optimize_above_cost TO '500000';
SET jit_profiling_support TO 'off';
SET jit_provider TO 'llvmjit';
SET jit_tuple_deforming TO 'on';
SET join_collapse_limit TO '8';
SET krb_caseins_users TO 'off';
SET krb_server_keyfile TO 'FILE:/etc/postgresql-common/krb5.keytab';
SET lc_collate TO 'en_US.UTF-8';
SET lc_ctype TO 'en_US.UTF-8';
SET lc_messages TO 'en_US.UTF-8';
SET lc_monetary TO 'en_US.UTF-8';
SET lc_numeric TO 'en_US.UTF-8';
SET lc_time TO 'en_US.UTF-8';
SET listen_addresses TO '*';
SET lo_compat_privileges TO 'off';
SET local_preload_libraries TO '';
SET lock_timeout TO '0';
SET log_autovacuum_min_duration TO '-1';
SET log_checkpoints TO 'off';
SET log_connections TO 'off';
SET log_destination TO 'csvlog';
SET log_directory TO '/var/log/postgresql';
SET log_disconnections TO 'off';
SET log_duration TO 'off';
SET log_error_verbosity TO 'default';
SET log_executor_stats TO 'off';
SET log_file_mode TO '0640';
SET log_filename TO 'postgresql.log';
SET log_hostname TO 'off';
SET log_line_prefix TO '%h %m [%p] %q%u@%d ';
SET log_lock_waits TO 'off';
SET log_min_duration_sample TO '-1';
SET log_min_duration_statement TO '-1';
SET log_min_error_statement TO 'error';
SET log_min_messages TO 'warning';
SET log_parameter_max_length TO '-1';
SET log_parameter_max_length_on_error TO '0';
SET log_parser_stats TO 'off';
SET log_planner_stats TO 'off';
SET log_recovery_conflict_waits TO 'off';
SET log_replication_commands TO 'off';
SET log_rotation_age TO '0';
SET log_rotation_size TO '0';
SET log_statement TO 'all';
SET log_statement_sample_rate TO '1';
SET log_statement_stats TO 'off';
SET log_temp_files TO '-1';
SET log_timezone TO 'UTC';
SET log_transaction_sample_rate TO '0';
SET log_truncate_on_rotation TO 'off';
SET logging_collector TO 'on';
SET logical_decoding_work_mem TO '65536';
SET maintenance_io_concurrency TO '10';
SET maintenance_work_mem TO '65536';
SET max_connections TO '100';
SET max_files_per_process TO '1000';
SET max_function_args TO '100';
SET max_identifier_length TO '63';
SET max_index_keys TO '32';
SET max_locks_per_transaction TO '64';
SET max_logical_replication_workers TO '4';
SET max_parallel_maintenance_workers TO '2';
SET max_parallel_workers TO '8';
SET max_parallel_workers_per_gather TO '2';
SET max_pred_locks_per_page TO '2';
SET max_pred_locks_per_relation TO '-2';
SET max_pred_locks_per_transaction TO '64';
SET max_prepared_transactions TO '0';
SET max_replication_slots TO '5';
SET max_slot_wal_keep_size TO '1024';
SET max_stack_depth TO '2048';
SET max_standby_archive_delay TO '30000';
SET max_standby_streaming_delay TO '30000';
SET max_sync_workers_per_subscription TO '2';
SET max_wal_senders TO '10';
SET max_wal_size TO '1024';
SET max_worker_processes TO '8';
SET min_dynamic_shared_memory TO '0';
SET min_parallel_index_scan_size TO '64';
SET min_parallel_table_scan_size TO '1024';
SET min_wal_size TO '80';
SET old_snapshot_threshold TO '-1';
SET parallel_leader_participation TO 'on';
SET parallel_setup_cost TO '1000';
SET parallel_tuple_cost TO '0.1';
SET password_encryption TO 'scram-sha-256';
SET pg_net.batch_size TO '500';
SET pg_net.ttl TO '3 days';
SET pg_stat_monitor.pgsm_bucket_time TO '60';
SET pg_stat_monitor.pgsm_enable_query_plan TO 'off';
SET pg_stat_monitor.pgsm_extract_comments TO 'off';
SET pg_stat_monitor.pgsm_histogram_buckets TO '10';
SET pg_stat_monitor.pgsm_histogram_max TO '100000';
SET pg_stat_monitor.pgsm_histogram_min TO '0';
SET pg_stat_monitor.pgsm_max TO '100';
SET pg_stat_monitor.pgsm_max_buckets TO '10';
SET pg_stat_monitor.pgsm_normalized_query TO 'on';
SET pg_stat_monitor.pgsm_overflow_target TO '1';
SET pg_stat_monitor.pgsm_query_max_len TO '2048';
SET pg_stat_monitor.pgsm_query_shared_buffer TO '20';
SET pg_stat_monitor.pgsm_track TO 'top';
SET pg_stat_monitor.pgsm_track_planning TO 'off';
SET pg_stat_monitor.pgsm_track_utility TO 'on';
SET pgaudit.log TO 'none';
SET pgaudit.log_catalog TO 'on';
SET pgaudit.log_client TO 'off';
SET pgaudit.log_level TO 'log';
SET pgaudit.log_parameter TO 'off';
SET pgaudit.log_relation TO 'off';
SET pgaudit.log_rows TO 'off';
SET pgaudit.log_statement TO 'on';
SET pgaudit.log_statement_once TO 'off';
SET pgaudit.role TO '';
SET pgsodium.getkey_script TO '/usr/lib/postgresql/14/bin/pgsodium_getkey_urandom.sh';
SET plan_cache_mode TO 'auto';
SET plpgsql.check_asserts TO 'on';
SET plpgsql.extra_errors TO 'none';
SET plpgsql.extra_warnings TO 'none';
SET plpgsql.print_strict_params TO 'off';
SET plpgsql.variable_conflict TO 'error';
SET plpgsql_check.enable_tracer TO 'off';
SET plpgsql_check.fatal_errors TO 'on';
SET plpgsql_check.mode TO 'by_function';
SET plpgsql_check.profiler TO 'off';
SET plpgsql_check.profiler_max_shared_chunks TO '15000';
SET plpgsql_check.regress_test_mode TO 'off';
SET plpgsql_check.show_nonperformance_extra_warnings TO 'off';
SET plpgsql_check.show_nonperformance_warnings TO 'off';
SET plpgsql_check.show_performance_warnings TO 'off';
SET plpgsql_check.trace_assert TO 'off';
SET plpgsql_check.trace_assert_verbosity TO 'default';
SET plpgsql_check.tracer TO 'off';
SET plpgsql_check.tracer_errlevel TO 'notice';
SET plpgsql_check.tracer_test_mode TO 'off';
SET plpgsql_check.tracer_variable_max_length TO '1024';
SET plpgsql_check.tracer_verbosity TO 'default';
SET port TO '5432';
SET post_auth_delay TO '0';
SET pre_auth_delay TO '0';
SET primary_conninfo TO '';
SET primary_slot_name TO '';
SET promote_trigger_file TO '';
SET quote_all_identifiers TO 'off';
SET random_page_cost TO '4';
SET recovery_end_command TO '';
SET recovery_init_sync_method TO 'fsync';
SET recovery_min_apply_delay TO '0';
SET recovery_target TO '';
SET recovery_target_action TO 'pause';
SET recovery_target_inclusive TO 'on';
SET recovery_target_lsn TO '';
SET recovery_target_name TO '';
SET recovery_target_time TO '';
SET recovery_target_timeline TO 'latest';
SET recovery_target_xid TO '';
SET remove_temp_files_after_crash TO 'on';
SET restart_after_crash TO 'on';
SET restore_command TO '';
SET row_security TO 'on';
SET search_path TO '"\$user", public, extensions';
SET segment_size TO '131072';
SET seq_page_cost TO '1';
SET server_encoding TO 'UTF8';
SET server_version TO '14.3 (Debian 14.3-1.pgdg110+1)';
SET server_version_num TO '140003';
SET session_preload_libraries TO '';
SET session_replication_role TO 'origin';
SET shared_buffers TO '16384';
SET shared_memory_type TO 'mmap';
SET shared_preload_libraries TO 'pg_stat_monitor, pgaudit, plpgsql, plpgsql_check, pg_cron, pg_net, pgsodium, timescaledb';
SET ssl TO 'off';
SET ssl_ca_file TO '';
SET ssl_cert_file TO '';
SET ssl_ciphers TO 'HIGH:MEDIUM:+3DES:!aNULL';
SET ssl_crl_dir TO '';
SET ssl_crl_file TO '';
SET ssl_dh_params_file TO '';
SET ssl_ecdh_curve TO 'prime256v1';
SET ssl_key_file TO '';
SET ssl_library TO 'OpenSSL';
SET ssl_max_protocol_version TO '';
SET ssl_min_protocol_version TO 'TLSv1.2';
SET ssl_passphrase_command TO '';
SET ssl_passphrase_command_supports_reload TO 'off';
SET ssl_prefer_server_ciphers TO 'on';
SET standard_conforming_strings TO 'on';
SET statement_timeout TO '0';
SET stats_temp_directory TO 'pg_stat_tmp';
SET superuser_reserved_connections TO '3';
SET synchronize_seqscans TO 'on';
SET synchronous_commit TO 'on';
SET synchronous_standby_names TO '';
SET syslog_facility TO 'local0';
SET syslog_ident TO 'postgres';
SET syslog_sequence_numbers TO 'on';
SET syslog_split_messages TO 'on';
SET tcp_keepalives_count TO '9';
SET tcp_keepalives_idle TO '7200';
SET tcp_keepalives_interval TO '75';
SET tcp_user_timeout TO '0';
SET temp_buffers TO '1024';
SET temp_file_limit TO '-1';
SET temp_tablespaces TO '';
SET timescaledb.disable_load TO 'off';
SET timescaledb.max_background_workers TO '16';
SET TimeZone TO 'UTC';
SET timezone_abbreviations TO 'Default';
SET trace_notify TO 'off';
SET trace_recovery_messages TO 'log';
SET trace_sort TO 'off';
SET track_activities TO 'on';
SET track_activity_query_size TO '1024';
SET track_commit_timestamp TO 'off';
SET track_counts TO 'on';
SET track_functions TO 'none';
SET track_io_timing TO 'off';
SET track_wal_io_timing TO 'off';
SET transaction_deferrable TO 'off';
SET transaction_isolation TO 'read committed';
SET transaction_read_only TO 'off';
SET transform_null_equals TO 'off';
SET unix_socket_directories TO '/var/run/postgresql';
SET unix_socket_group TO '';
SET unix_socket_permissions TO '0777';
SET update_process_title TO 'on';
SET vacuum_cost_delay TO '0';
SET vacuum_cost_limit TO '200';
SET vacuum_cost_page_dirty TO '20';
SET vacuum_cost_page_hit TO '1';
SET vacuum_cost_page_miss TO '2';
SET vacuum_defer_cleanup_age TO '0';
SET vacuum_failsafe_age TO '1600000000';
SET vacuum_freeze_min_age TO '50000000';
SET vacuum_freeze_table_age TO '150000000';
SET vacuum_multixact_failsafe_age TO '1600000000';
SET vacuum_multixact_freeze_min_age TO '5000000';
SET vacuum_multixact_freeze_table_age TO '150000000';
SET wal_block_size TO '8192';
SET wal_buffers TO '512';
SET wal_compression TO 'off';
SET wal_consistency_checking TO '';
SET wal_init_zero TO 'on';
SET wal_keep_size TO '0';
SET wal_level TO 'logical';
SET wal_log_hints TO 'off';
SET wal_receiver_create_temp_slot TO 'off';
SET wal_receiver_status_interval TO '10';
SET wal_receiver_timeout TO '60000';
SET wal_recycle TO 'on';
SET wal_retrieve_retry_interval TO '5000';
SET wal_segment_size TO '16777216';
SET wal_sender_timeout TO '60000';
SET wal_skip_threshold TO '2048';
SET wal_sync_method TO 'fdatasync';
SET wal_writer_delay TO '200';
SET wal_writer_flush_after TO '128';
SET work_mem TO '4096';
SET xmlbinary TO 'base64';
SET xmloption TO 'content';
SET zero_damaged_pages TO 'off';

DROP TYPE graphql.comparison_op;

CREATE TYPE graphql.comparison_op AS ENUM
    ( '=' , '<' , '<=' , '<>' , '>=' , '>' );

DROP TYPE graphql.field_meta_kind;

CREATE TYPE graphql.field_meta_kind AS ENUM
    ( 'Constant' , 'Query.collection' , 'Column' , 'Relationship.toMany' , 'Relationship.toOne' , 'OrderBy.Column' , 'Filter.Column' , 'Function' , 'Mutation.insert' , 'Mutation.delete' , 'Mutation.update' , 'UpdateSetArg' , 'ObjectsArg' , 'AtMostArg' , 'Query.heartbeat' , '__Typename' );

ALTER TABLE public.messages
    ADD COLUMN room_id uuid NOT NULL;

CREATE TABLE public.rooms
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT rooms_pkey PRIMARY KEY ( id )
);

COMMENT ON TABLE public.rooms IS 'Holds chat rooms' ;

ALTER TABLE public.messages
    ADD CONSTRAINT messages_room_id_fkey FOREIGN KEY ( room_id ) REFERENCES public.rooms ( id ) ON DELETE CASCADE;

ALTER TABLE public.messages
    ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE public.messages
    IS 'Holds individual messages within a chat room.' ;

ALTER TABLE public.profiles
    ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE public.profiles
    IS NULL ;

CREATE TABLE public.room_participants
(
    profile_id uuid NOT NULL,
    room_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT room_participants_pkey PRIMARY KEY ( profile_id, room_id )
);

COMMENT ON TABLE public.room_participants IS 'Relational table of users and rooms.' ;

ALTER TABLE public.room_participants
    ADD CONSTRAINT room_participants_profile_id_fkey FOREIGN KEY ( profile_id ) REFERENCES public.profiles ( id ) ON DELETE CASCADE,
    ADD CONSTRAINT room_participants_room_id_fkey FOREIGN KEY ( room_id ) REFERENCES public.rooms ( id ) ON DELETE CASCADE;

ALTER TABLE public.profiles
    ADD CONSTRAINT profiles_id_key UNIQUE ( id ) USING INDEX TABLESPACE pg_default;

CREATE FUNCTION public.create_new_room ( other_user_id uuid ) RETURNS uuid AS $func$ 
    declare
        new_room_id uuid;
    begin
        -- Check if room with both participants already exist
        with rooms_with_profiles as (
            select room_id, array_agg(profile_id) as participants
            from room_participants
            group by room_id
        )
        select room_id
        into new_room_id
        from rooms_with_profiles
        where create_new_room.other_user_id=any(participants)
        and auth.uid()=any(participants);


        if not found then
            -- Create a new room
            insert into public.rooms default values
            returning id into new_room_id;

            -- Insert the caller user into the new room
            insert into public.room_participants (profile_id, room_id)
            values (auth.uid(), new_room_id);

            -- Insert the other_user user into the new room
            insert into public.room_participants (profile_id, room_id)
            values (other_user_id, new_room_id);
        end if;

        return new_room_id;
    end
 $func$
LANGUAGE plpgsql
SECURITY DEFINER;

CREATE FUNCTION public.is_room_participant ( room_id uuid ) RETURNS bool AS $func$ 
  select exists(
    select 1
    from room_participants
    where room_id = is_room_participant.room_id and profile_id = auth.uid()
  );
 $func$
LANGUAGE sql
SECURITY DEFINER;

CREATE POLICY "Users can view messages on rooms they are in." ON public.messages FOR SELECT USING ( is_room_participant(room_id) );

CREATE POLICY "Users can insert messages on rooms they are in." ON public.messages FOR INSERT WITH CHECK ( (is_room_participant(room_id) AND (profile_id = auth.uid())) );

CREATE POLICY "Participants of the room can view other participants." ON public.room_participants FOR SELECT USING ( is_room_participant(room_id) );

CREATE POLICY "Users can view rooms that they have joined" ON public.rooms FOR SELECT USING ( is_room_participant(id) );

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING ( true );

COMMIT TRANSACTION;

