
-- *** Table definitions ***

create table if not exists public.profiles (
    id uuid references auth.users on delete cascade not null primary key,
    username varchar(24) not null unique,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null,

    -- username should be 3 to 24 characters long containing alphabets, numbers and underscores
    constraint username_validation check (username ~* '^[A-Za-z0-9_]{3,24}$')
);
comment on table public.profiles is 'Holds all of users profile information';

create table if not exists public.rooms (
    id uuid not null primary key default uuid_generate_v4(),
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.rooms is 'Holds chat rooms';

create table if not exists public.room_participants (
    profile_id uuid references public.profiles(id) on delete cascade not null,
    room_id uuid references public.rooms(id) on delete cascade not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null,
    primary key (profile_id, room_id)
);
comment on table public.room_participants is 'Relational table of users and rooms.';

create table if not exists public.messages (
    id uuid not null primary key default uuid_generate_v4(),
    profile_id uuid default auth.uid() references public.profiles(id) on delete cascade not null,
    room_id uuid references public.rooms on delete cascade not null,
    content varchar(500) not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.messages is 'Holds individual messages within a chat room.';

-- *** Add tables to the publication to enable realtime ***

alter publication supabase_realtime add table public.room_participants;
alter publication supabase_realtime add table public.messages;


-- *** Security definer functions ***

-- Returns true if the signed in user is a participant of the room
create or replace function is_room_participant(room_id uuid)
returns boolean as $$
  select exists(
    select 1
    from room_participants
    where room_id = is_room_participant.room_id and profile_id = auth.uid()
  );
$$ language sql security definer;


-- *** Row level security polities ***


alter table public.profiles enable row level security;
create policy "Public profiles are viewable by everyone." on public.profiles for select using (true);


alter table public.rooms enable row level security;
create policy "Users can view rooms that they have joined" on public.rooms for select using (is_room_participant(id));


alter table public.room_participants enable row level security;
create policy "Participants of the room can view other participants." on public.room_participants for select using (is_room_participant(room_id));


alter table public.messages enable row level security;
create policy "Users can view messages on rooms they are in." on public.messages for select using (is_room_participant(room_id));
create policy "Users can insert messages on rooms they are in." on public.messages for insert with check (is_room_participant(room_id) and profile_id = auth.uid());


-- *** Views and functions ***



-- Creates a new room with the user and another user in it.
-- Will return the room_id of the created room
-- Will return a room_id if there were already a room with those participants
create or replace function create_new_room(other_user_id uuid) returns uuid as $$
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
$$ language plpgsql security definer;

-- Function to create a new row in profiles table upon signup
-- Also copies the username value from metadata
create or replace function handle_new_user() returns trigger as $$
    begin
        insert into public.profiles(id, username)
        values(new.id, new.raw_user_meta_data->>'username');

        return new;
    end;
$$ language plpgsql security definer;

-- Trigger to call `handle_new_user` when new user signs up
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function handle_new_user();

-- CREATE TABLE IF NOT EXISTS
--     profiles (
--         id uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
--         user_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT email VARCHAR(255) NOT NULL,
--         password VARCHAR(255) NOT NULL,
--         created_at DATETIME NOT NULL,
--         updated_at DATETIME NOT NULL
--     );
    

-- create table IF NOT EXISTS
--     "public"."profiles" (
--         "id" uuid NOT NULL UNIQUE,
--         "username" VARCHAR(24) NOT NULL,
--         "created_at" TIMESTAMP
--         WITH
--             TIME zone NOT NULL DEFAULT timezone('utc' :: TEXT, now()),
--             -- username should be 3 to 24 characters long containing alphabets, numbers and underscores
--             constraint "username_validation" check (
--                 username ~* '^[A-Za-z0-9_]{3,24}$'
--             )
--     );
-- EMD;

-- -- the rooms table where participants are show to be a member of a room

-- create table
--     if not exists public.rooms (
--         "id" uuid not null primary key default uuid_generate_v4(),
--         "created_at" timestamp
--         with
--             time zone default timezone('utc' :: text, now()) not null
--     )
--     else{
-- alter table rooms
-- add
--     constraint "username_validation" check (
--         username ~* '^[A-Za-z0-9_]{3,24}$'
--     );

-- }


-- create table
--     if not exists public.room_participants (
--         "id" uuid not null primary key default uuid_generate_v4(),
--         "profile_id" uuid references public.profiles(id) on delete cascade not null,
--         "room_id" uuid references public.rooms(id) on delete cascade not null,
--         "created_at",
--         "user_name" varchar(50) references public.profiles(user_name) on delete cascade not null,
--         primary key ("id"),
--         UNIQUE("profile_id", "room_id");

-- );

-- comment
--     on table public.room_participants is 'Relational table of users and rooms along with profiles';

-- create table
--     if not exists public.messages (
--         id uuid not null primary key default uuid_generate_v4(),
--         profile_id uuid default auth.uid() references public.profiles(id) on delete cascade not null,
--         room_id uuid references public.rooms on delete cascade not null,
--         content varchar(500) not null,
--         user_name varchar(50) not null,
--         created_at timestamp
--         with
--             time zone default timezone('utc' :: text, now()) not null
--     )else{
-- alter table public.messages
-- add
--     constraint "username_validation" check (
--         username ~* '^[A-Za-z0-9_]{3,24}$'
--     );

-- }

-- comment
--     on table public.messages is 'Holds individual messages within a chat room.';

-- -- *** Add tables to the publication to enable realtime ***

-- alter publication
--     supabase_realtime
-- add
--     table public.room_participants;

-- alter publication supabase_realtime add table public.messages;

-- alter publication supabase_realtime add table public.profiles;

-- -- *** Security definer functions ***

-- -- Returns true if the signed in user is a participant of the room

-- create or replace function is_room_participant(room_id 
-- uuid) returns boolean as 
-- $$ 
-- 	select exists(
-- 	        select 1
-- 	        from
-- 	            room_participants
-- 	        where
-- 	            room_id = is_room_participant.room_id
-- 	            and profile_id = auth.uid()
-- 	    );
-- 	$$ language 
-- sql security definer; 

-- -- *** Row level security polities ***

-- alter table public.profiles enable row level security;

-- create policy
--     "Public profiles are viewable by everyone." on public.profiles for
-- select using (true);

-- alter table public.rooms enable row level security;

-- create policy "Users can view rooms that they have joined" 
-- on 
-- 	public.rooms for select using (is_room_participant(id));

-- alter table public.room_participants enable row level security;

-- create policy "Participants of the room can view other participants." 
-- on 
-- 	public.room_participants for
-- 	select
-- 	    using (is_room_participant(room_id));

-- alter table public.messages enable row level security;

-- create policy "Users can view messages on rooms they are in." 
-- on 
-- 	public.messages for select using (is_room_participant(room_id));


-- create policy
--     "Users can insert messages on rooms they are in." on public.messages for
-- insert
-- with
--     check (
--         is_room_participant(room_id)
--         and profile_id = auth.uid()
--     );

-- -- *** Views and functions ***

-- -- Creates a new room with the user and another user in it.

-- -- Will return the room_id of the created room

-- -- Will return a room_id if there were already a room with those participants

-- create or replace function create_new_room(other_user_id uuid) returns uuid as 
-- $$ 
-- 	declare new_room_id uuid;
-- 	begin
-- 	    -- Check if room with both participants already exist
-- 	with rooms_with_profiles as (
-- 	        select
-- 	            room_id,
-- 	            array_agg(profile_id),
-- 	            user_name as participants
-- 	        from
-- 	            room_participants
-- 	        group by room_id
-- 	    )
-- 	select
-- 	    room_id into new_room_id
-- 	from rooms_with_profiles
-- 	where
-- 	    create_new_room.other_user_id = any(participants)
-- 	    and auth.uid() = any(participants);
-- 	if not found then -- Create a new room
-- 	insert into
-- 	    public.rooms default
-- 	values
-- 	returning id into new_room_id;
-- 	-- Insert the caller user into the new room
-- 	insert into
-- 	    public.room_participants (profile_id, room_id)
-- 	values (auth.uid(), new_room_id);
-- 	-- Insert the other_user user into the new room
-- 	insert into
-- 	    public.room_participants (profile_id, room_id)
-- 	values (other_user_id, new_room_id);
-- 	end if;
-- 	return new_room_id;
-- 	end $$ language 
-- plpgsql security definer; 

-- CREATE UNIQUE INDEX messages_pkey ON PUBLIC.messages USING btree (id);

-- CREATE UNIQUE INDEX messages_pkey ON PUBLIC.messages USING btree (id);

-- CREATE UNIQUE INDEX profiles_pkey ON PUBLIC.profiles USING btree (id);

-- CREATE UNIQUE INDEX rooms_pkey ON PUBLIC.rooms USING btree (id);

-- CREATE UNIQUE INDEX profiles_username_key ON PUBLIC.profiles USING btree (username);

-- ALTER TABLE
--     "public"."messages"
-- ADD
--     CONSTRAINT "messages_pkey" PRIMARY KEY using INDEX "messages_pkey";

-- ALTER TABLE
--     "public"."profiles"
-- ADD
--     CONSTRAINT "profiles_pkey" PRIMARY KEY using INDEX "profiles_pkey";

-- ALTER TABLE
--     "public"."messages"
-- ADD
--     CONSTRAINT "messages_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles (id) ON DELETE CASCADE NOT valid;

-- ALTER TABLE
--     "public"."messages" validate CONSTRAINT "messages_profile_id_fkey";



-- ALTER TABLE
--     "public"."profiles"
-- ADD
--     CONSTRAINT "profiles_id_fkey" FOREIGN KEY (profile_id) REFERENCES auth.users (id)
--     ON DELETE CASCADE NOT valid;
-- ALTER TABLE
--     "public"."profiles"
-- ADD
--     CONSTRAINT "profiles_id_fkey" FOREIGN KEY (profile_id) REFERENCES auth.users (id) ON DELETE CASCADE NOT valid;

-- ALTER TABLE
--     "public"."profiles"
-- ADD
--     CONSTRAINT "user_name_fkey" REFERENCES auth.users (user_name) ON DELETE CASCADE NOT valid;

-- ALTER TABLE
--     "public"."profiles" validate CONSTRAINT "profiles_id_fkey";

-- SET check_function_bodies = OFF;

-- -- CREATE OR REPLACE FUNCTION public.handle_new_user()

-- --  RETURNS trigger

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- --values(new.id, new.raw_user_meta_data->>'username');

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- --values(new.id, new.raw_user_meta_data->>'username');

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- --values(new.id, new.raw_user_meta_data->>'username');

-- -- LANGUAGE plpgsql SECURITY DEFINER AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- --values(new.id, new.raw_user_meta_data->>'username');
-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$ --     begin
-- --         insert into public.profiles(id, username)
-- --values(new.id, new.raw_user_meta_data->>'username');
-- --  LANGUAGE plpgsql
-- --  SECURITY DEFINER
-- -- AS $function$
-- --     begin
-- --         insert into public.profiles(id, username)
-- --values(new.id, new.raw_user_meta_data->>'username');
-- --  LANGUAGE plpgsql
-- --  SECURITY DEFINER
-- -- AS $function$
-- --     begin
-- --         insert into public.profiles(id, username)
-- --values(new.id, new.raw_user_meta_data->>'username');
-- --  LANGUAGE plpgsql
-- --  SECURITY DEFINER
-- -- AS $function$
-- --     begin
-- --         insert into public.profiles(id, username)
-- -- values(new.id, new.raw_user_meta_data->>'username');
-- --  LANGUAGE plpgsql
-- --  SECURITY DEFINER
-- -- AS $function$
-- --     begin
-- --         insert into public.profiles(id, username)
-- -- values(new.id, new.raw_user_meta_data->>'username');
-- --  LANGUAGE plpgsql
-- --  SECURITY DEFINER
-- -- AS $function$
-- --     begin
-- --         insert into public.profiles(id, username)
-- -- values(new.id, new.raw_user_meta_data->>'username');
-- --  LANGUAGE plpgsql
-- --  SECURITY DEFINER
-- -- AS $function$
-- --     begin
-- --         insert into public.profiles(id, username)
-- -- values
-- -- (
-- --         new.id,
-- --         new.raw_user_meta_data ->> 'username'
-- --     );

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- -- values(new.id, new.raw_user_meta_data->>'username');

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- -- values(new.id, new.raw_user_meta_data->>'username');

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- -- values(new.id, new.raw_user_meta_data->>'username');

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- -- values(new.id, new.raw_user_meta_data->>'username');

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- -- values(new.id, new.raw_user_meta_data->>'username');

-- --  LANGUAGE plpgsql

-- --  SECURITY DEFINER

-- -- AS $function$

-- --     begin

-- --         insert into public.profiles(id, username)

-- -- values(new.id, new.raw_user_meta_data->>'username');

-- --         return new;

-- --     end;

-- -- $function$

-- -- CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user()

-- -- Function to create a new row in profiles table upon signup

-- -- Also copies the username value from metadata

-- create or replace function handle_new_user() trigger 
-- as 
-- $$ 

-- begin; 

-- begin
-- insert into
--     public.profiles(id, username)
-- values (
--         new.id,
--         new.raw_user_meta_data ->> 'username'
--     );

-- return new;

-- end;

-- $$ language plpgsql security definer;

-- -- Trigger to call `handle_new_user` when new user signs up

-- create trigger
--     on_auth_user_created
-- after
-- insert on auth.users for each row
-- execute
--     function handle_new_user();