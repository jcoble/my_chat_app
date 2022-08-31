BEGIN;
CREATE TABLE public.room_participants();
CREATE TABLE public.rooms();

ALTER TABLE public.messages DROP COLUMN IF EXISTS content;
ALTER TABLE public.messages ADD COLUMN room_id uuid NOT NULL;
ALTER TABLE public.messages ADD COLUMN content character varying(500) NOT NULL;
ALTER TABLE public.messages DROP COLUMN IF EXISTS created_at;
ALTER TABLE public.messages ADD COLUMN created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE public.room_participants ADD COLUMN profile_id uuid NOT NULL;
ALTER TABLE public.room_participants ADD COLUMN room_id uuid NOT NULL;
ALTER TABLE public.room_participants ADD COLUMN created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE public.rooms ADD COLUMN id uuid NOT NULL DEFAULT uuid_generate_v4();
ALTER TABLE public.rooms ADD COLUMN created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now());


CREATE UNIQUE INDEX profiles_id_key ON profiles USING btree (id);
ALTER TABLE public.profiles ADD CONSTRAINT profiles_id_key UNIQUE USING INDEX profiles_id_key; -- (2)
CREATE UNIQUE INDEX room_participants_pkey ON room_participants USING btree (profile_id, room_id);
ALTER TABLE public.room_participants ADD CONSTRAINT room_participants_pkey PRIMARY KEY USING INDEX room_participants_pkey; -- (1)
CREATE UNIQUE INDEX rooms_pkey ON rooms USING btree (id);
ALTER TABLE public.rooms ADD CONSTRAINT rooms_pkey PRIMARY KEY USING INDEX rooms_pkey; -- (1)


ALTER TABLE public.messages ADD CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;
ALTER TABLE public.room_participants ADD CONSTRAINT room_participants_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.room_participants ADD CONSTRAINT room_participants_room_id_fkey FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;


-- schemaType: GRANT_RELATIONSHIP
-- db1: {postgres 127.0.0.1 54322 postgres postgres * sslmode=disable}
-- db2: {postgres2 127.0.0.1 54322 postgres postgres * sslmode=disable}
-- Run the following SQL against db2:
REVOKE DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON extensions.pg_stat_statements FROM postgres; -- Drop
REVOKE SELECT ON extensions.pg_stat_statements FROM public; -- Drop
-- REVOKE DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON extensions.pg_stat_statements FROM user; -- Drop
REVOKE DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON extensions.pg_stat_statements_info FROM postgres; -- Drop
REVOKE SELECT ON extensions.pg_stat_statements_info FROM public; -- Drop
-- REVOKE DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON extensions.pg_stat_statements_info FROM user; -- Drop
GRANT SELECT, UPDATE, USAGE ON graphql._field_id_seq TO anon; -- Add
GRANT SELECT, UPDATE, USAGE ON graphql._field_id_seq TO authenticated; -- Add
GRANT SELECT, UPDATE, USAGE ON graphql._field_id_seq TO postgres; -- Add
-- GRANT SELECT, UPDATE, USAGE ON graphql._field_id_seq TO role; -- Add
GRANT SELECT, UPDATE, USAGE ON graphql._type_id_seq TO anon; -- Add
GRANT SELECT, UPDATE, USAGE ON graphql._type_id_seq TO authenticated; -- Add
GRANT SELECT, UPDATE, USAGE ON graphql._type_id_seq TO postgres; -- Add
-- GRANT SELECT, UPDATE, USAGE ON graphql._type_id_seq TO role; -- Add
GRANT SELECT ON graphql._field TO anon; -- Add
GRANT SELECT ON graphql._field TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON graphql._field TO postgres; -- Add
-- GRANT SELECT ON graphql._field TO role; -- Add
GRANT SELECT ON graphql._type TO anon; -- Add
GRANT SELECT ON graphql._type TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON graphql._type TO postgres; -- Add
-- GRANT SELECT ON graphql._type TO role; -- Add
GRANT SELECT ON graphql.introspection_query_cache TO anon; -- Add
GRANT SELECT ON graphql.introspection_query_cache TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON graphql.introspection_query_cache TO postgres; -- Add
-- GRANT SELECT ON graphql.introspection_query_cache TO role; -- Add
GRANT SELECT ON graphql.enum_value TO anon; -- Add
GRANT SELECT ON graphql.enum_value TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON graphql.enum_value TO postgres; -- Add
-- GRANT SELECT ON graphql.enum_value TO role; -- Add
GRANT SELECT ON graphql.field TO anon; -- Add
GRANT SELECT ON graphql.field TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON graphql.field TO postgres; -- Add
-- GRANT SELECT ON graphql.field TO role; -- Add
GRANT SELECT ON graphql.type TO anon; -- Add
GRANT SELECT ON graphql.type TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON graphql.type TO postgres; -- Add
-- GRANT SELECT ON graphql.type TO role; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.room_participants TO anon; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.room_participants TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.room_participants TO postgres; -- Add
-- GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.room_participants TO role; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.rooms TO anon; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.rooms TO authenticated; -- Add
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.rooms TO postgres; -- Add
-- GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON public.rooms TO role; -- Add
COMMIT;
--  ROLLBACK;