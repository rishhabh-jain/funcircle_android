
CREATE TABLE public.Orderitems (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  order_id bigint,
  ticket_id bigint,
  quantity bigint,
  sub_price text,
  userid text,
  status text DEFAULT 'confirmed'::text,
  used_premium_discount boolean,
  userequipments jsonb,
  CONSTRAINT Orderitems_pkey PRIMARY KEY (id),
  CONSTRAINT Orderitems_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id),
  CONSTRAINT Orderitems_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(user_id),
  CONSTRAINT Orderitems_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id)
);
CREATE TABLE public.connections (
  connection_id integer NOT NULL DEFAULT nextval('connections_connection_id_seq'::regclass),
  user_id1 text,
  user_id2 text,
  status character varying CHECK (status::text = ANY (ARRAY['requested'::character varying::text, 'accepted'::character varying::text])),
  CONSTRAINT connections_pkey PRIMARY KEY (connection_id),
  CONSTRAINT connections_user_id1_fkey FOREIGN KEY (user_id1) REFERENCES public.users(user_id),
  CONSTRAINT connections_user_id2_fkey FOREIGN KEY (user_id2) REFERENCES public.users(user_id)
);
CREATE TABLE public.discount_table (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  description text,
  type USER-DEFINED NOT NULL,
  value numeric NOT NULL,
  meta_fields jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT discount_table_pkey PRIMARY KEY (id)
);
CREATE TABLE public.duos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  requester_id text NOT NULL,
  partner_id text NOT NULL,
  status character varying NOT NULL DEFAULT 'pending'::character varying,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT duos_pkey PRIMARY KEY (id),
  CONSTRAINT fk_requester FOREIGN KEY (requester_id) REFERENCES public.users(user_id),
  CONSTRAINT fk_partner FOREIGN KEY (partner_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.game_requests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  sender text NOT NULL,
  reciever text NOT NULL,
  type text NOT NULL,
  data jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT game_requests_pkey PRIMARY KEY (id),
  CONSTRAINT fk_sender FOREIGN KEY (sender) REFERENCES public.users(user_id),
  CONSTRAINT fk_reciever FOREIGN KEY (reciever) REFERENCES public.users(user_id)
);
CREATE TABLE public.glitches (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  description text,
  images ARRAY,
  user_id text,
  CONSTRAINT glitches_pkey PRIMARY KEY (id),
  CONSTRAINT glitches_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.groupcategories (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  category text,
  CONSTRAINT groupcategories_pkey PRIMARY KEY (id)
);
CREATE TABLE public.groups (
  group_id integer NOT NULL DEFAULT nextval('groups_group_id_seq'::regclass),
  name text,
  location text,
  joined_members integer,
  description text,
  exclusive boolean,
  profile_image text,
  interests ARRAY,
  images ARRAY,
  top_events boolean,
  group_type text,
  category text,
  city text,
  startdatetime timestamp with time zone,
  enddatetime timestamp with time zone,
  event_status text,
  hidden boolean,
  iftickets boolean,
  userid text,
  videos text,
  premiumtype text,
  CONSTRAINT groups_pkey PRIMARY KEY (group_id),
  CONSTRAINT groups_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(user_id)
);
CREATE TABLE public.interested_requests (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  status text,
  other_user_id text,
  request_id bigint,
  CONSTRAINT interested_requests_pkey PRIMARY KEY (id),
  CONSTRAINT interested_requests_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.requests(id),
  CONSTRAINT interested_requests_other_user_id_fkey FOREIGN KEY (other_user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.interests (
  interest_id integer NOT NULL DEFAULT nextval('interests_interest_id_seq'::regclass),
  category character varying,
  interest_name character varying,
  CONSTRAINT interests_pkey PRIMARY KEY (interest_id)
);
CREATE TABLE public.message_reactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  user_id text NOT NULL,
  emoji character varying NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT message_reactions_pkey PRIMARY KEY (id),
  CONSTRAINT message_reactions_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id),
  CONSTRAINT message_reactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.message_read_status (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  user_id text NOT NULL,
  read_at timestamp with time zone DEFAULT now(),
  CONSTRAINT message_read_status_pkey PRIMARY KEY (id),
  CONSTRAINT message_read_status_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id),
  CONSTRAINT message_read_status_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  sender_id text NOT NULL,
  content text,
  message_type character varying DEFAULT 'text'::character varying CHECK (message_type::text = ANY (ARRAY['text'::character varying, 'image'::character varying, 'video'::character varying, 'file'::character varying, 'match_share'::character varying, 'ticket_share'::character varying, 'system'::character varying]::text[])),
  media_url text,
  media_type character varying,
  media_size bigint,
  thumbnail_url text,
  shared_match_id uuid,
  shared_ticket_id uuid,
  shared_content_preview jsonb,
  reply_to_message_id uuid,
  is_edited boolean DEFAULT false,
  edited_at timestamp with time zone,
  is_deleted boolean DEFAULT false,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(user_id),
  CONSTRAINT messages_reply_to_message_id_fkey FOREIGN KEY (reply_to_message_id) REFERENCES public.messages(id)
);
CREATE TABLE public.orders (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  user_id text,
  total_price text,
  status USER-DEFINED DEFAULT 'confirmed'::orderstatustype,
  paymentid text UNIQUE,
  type text NOT NULL DEFAULT 'online-payment'::text,
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.prompts (
  prompt_id integer NOT NULL DEFAULT nextval('prompts_prompt_id_seq'::regclass),
  question_text text,
  CONSTRAINT prompts_pkey PRIMARY KEY (prompt_id)
);
CREATE TABLE public.requests (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  description text,
  group_id integer,
  user_id text,
  status text,
  members_needed smallint,
  CONSTRAINT requests_pkey PRIMARY KEY (id),
  CONSTRAINT requests_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_id),
  CONSTRAINT requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.reviews (
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  to_user_id text NOT NULL,
  from_user_id text NOT NULL,
  ticket_id bigint NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT reviews_pkey PRIMARY KEY (id),
  CONSTRAINT reviews_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(user_id),
  CONSTRAINT reviews_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(user_id),
  CONSTRAINT reviews_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id)
);
CREATE TABLE public.room_members (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  user_id text NOT NULL,
  role character varying DEFAULT 'member'::character varying CHECK (role::text = ANY (ARRAY['admin'::character varying, 'moderator'::character varying, 'member'::character varying]::text[])),
  joined_at timestamp with time zone DEFAULT now(),
  last_seen_at timestamp with time zone DEFAULT now(),
  is_muted boolean DEFAULT false,
  is_banned boolean DEFAULT false,
  CONSTRAINT room_members_pkey PRIMARY KEY (id),
  CONSTRAINT room_members_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id),
  CONSTRAINT room_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.rooms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying,
  description text,
  type character varying NOT NULL CHECK (type::text = ANY (ARRAY['single'::character varying, 'group'::character varying]::text[])),
  sport_type character varying,
  avatar_url text,
  max_members integer DEFAULT 50,
  is_active boolean DEFAULT true,
  created_by text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT rooms_pkey PRIMARY KEY (id),
  CONSTRAINT rooms_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id)
);
CREATE TABLE public.squads (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  squad_name character varying NOT NULL,
  squad_members jsonb NOT NULL CHECK (jsonb_array_length(squad_members) >= 2 AND jsonb_array_length(squad_members) <= 8),
  created_at timestamp with time zone DEFAULT now(),
  squad_admin text NOT NULL,
  CONSTRAINT squads_pkey PRIMARY KEY (id)
);
CREATE TABLE public.subscription (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  venue_id bigint NOT NULL,
  playing_date_and_time jsonb NOT NULL,
  type text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  end_date timestamp with time zone NOT NULL DEFAULT (now() + '1 mon'::interval),
  CONSTRAINT subscription_pkey PRIMARY KEY (id),
  CONSTRAINT subscription_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT subscription_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(id)
);
CREATE TABLE public.support_tickets (
  ticket_id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  subject text NOT NULL,
  description text NOT NULL,
  category text NOT NULL DEFAULT 'other'::text CHECK (category = ANY (ARRAY['bug'::text, 'feature_request'::text, 'help'::text, 'other'::text])),
  status text NOT NULL DEFAULT 'open'::text CHECK (status = ANY (ARRAY['open'::text, 'in_progress'::text, 'resolved'::text, 'closed'::text])),
  priority text NOT NULL DEFAULT 'medium'::text CHECK (priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  resolved_at timestamp with time zone,
  CONSTRAINT support_tickets_pkey PRIMARY KEY (ticket_id),
  CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE
);
CREATE TABLE public.tags (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  ticket_id bigint NOT NULL,
  tag text NOT NULL,
  CONSTRAINT tags_pkey PRIMARY KEY (id),
  CONSTRAINT tags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT tags_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id)
);
CREATE TABLE public.tickets (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  group_id integer,
  type text,
  title text,
  description text,
  capacity bigint,
  startdatetime timestamp with time zone,
  enddatetime timestamp with time zone,
  ticketstatus text,
  price text,
  priceincludinggst boolean,
  ticketpergroup text,
  sku text,
  bookedtickets bigint DEFAULT '0'::bigint,
  location text,
  wooid bigint,
  venueid bigint,
  images ARRAY,
  servicecharge text,
  ticket_type USER-DEFINED DEFAULT 'single'::ticket_type_enum,
  CONSTRAINT tickets_pkey PRIMARY KEY (id),
  CONSTRAINT tickets_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_id),
  CONSTRAINT tickets_venueid_fkey FOREIGN KEY (venueid) REFERENCES public.venues(id)
);
CREATE TABLE public.typing_indicators (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  user_id text NOT NULL,
  started_at timestamp with time zone DEFAULT now(),
  expires_at timestamp with time zone DEFAULT (now() + '00:00:10'::interval),
  CONSTRAINT typing_indicators_pkey PRIMARY KEY (id),
  CONSTRAINT typing_indicators_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id),
  CONSTRAINT typing_indicators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.userlikes (
  like_id integer NOT NULL DEFAULT nextval('userlikes_like_id_seq'::regclass),
  liker_user_id text,
  liked_user_id text,
  timestamp timestamp with time zone,
  fromrecommended boolean DEFAULT false,
  CONSTRAINT userlikes_pkey PRIMARY KEY (like_id),
  CONSTRAINT userlikes_liker_user_id_fkey FOREIGN KEY (liker_user_id) REFERENCES public.users(user_id),
  CONSTRAINT userlikes_liked_user_id_fkey FOREIGN KEY (liked_user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.userprofilecompletionstatus (
  name_completed boolean DEFAULT false,
  images_completed boolean DEFAULT false,
  religion_completed boolean DEFAULT false,
  education_work_completed boolean DEFAULT false,
  drink_completed boolean DEFAULT false,
  smoke_completed boolean DEFAULT false,
  looking_for_completed boolean DEFAULT false,
  completionstatus boolean NOT NULL DEFAULT false,
  current_step integer NOT NULL DEFAULT 1,
  user_id text NOT NULL,
  CONSTRAINT userprofilecompletionstatus_pkey PRIMARY KEY (user_id),
  CONSTRAINT userprofilecompletionstatus_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE public.user_settings (
  user_id text NOT NULL,
  push_notifications boolean DEFAULT true,
  email_notifications boolean DEFAULT true,
  game_request_notifications boolean DEFAULT true,
  booking_notifications boolean DEFAULT true,
  chat_notifications boolean DEFAULT true,
  friend_request_notifications boolean DEFAULT true,
  theme text DEFAULT 'system'::text CHECK (theme = ANY (ARRAY['light'::text, 'dark'::text, 'system'::text])),
  language text DEFAULT 'en'::text,
  profile_visible boolean DEFAULT true,
  show_online_status boolean DEFAULT true,
  show_location boolean DEFAULT true,
  allow_friend_requests boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_settings_pkey PRIMARY KEY (user_id),
  CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE
);
CREATE TABLE public.userprompts (
  user_prompt_id integer NOT NULL DEFAULT nextval('userprompts_user_prompt_id_seq'::regclass),
  user_id text,
  prompt_id integer,
  answer_text text,
  CONSTRAINT userprompts_pkey PRIMARY KEY (user_prompt_id),
  CONSTRAINT userprompts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT userprompts_prompt_id_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts(prompt_id)
);
CREATE TABLE public.users (
  age text,
  images ARRAY,
  location text,
  faith text,
  drink text,
  smoke text,
  college character varying,
  work character varying,
  interests ARRAY,
  zodiac character varying,
  political_leaning character varying,
  hometown character varying,
  mother_tongue ARRAY,
  recommended_users ARRAY,
  last_updated timestamp without time zone,
  liked_users ARRAY,
  first_name character varying,
  email character varying UNIQUE,
  birthday date,
  gender text CHECK (gender = ANY (ARRAY['male'::character varying::text, 'female'::character varying::text])),
  looking_for text CHECK (looking_for = ANY (ARRAY['relationship'::character varying::text, 'casual'::character varying::text, 'dont know yet'::character varying::text])),
  height text,
  workout_status character varying CHECK (workout_status::text = ANY (ARRAY['regularly'::character varying::text, 'sometimes'::character varying::text, 'not active'::character varying::text])),
  pets character varying CHECK (pets::text = ANY (ARRAY['want'::character varying::text, 'dogs'::character varying::text, 'want cats'::character varying::text, 'no thanks'::character varying::text])),
  bio text,
  is_premium boolean DEFAULT false,
  profile_completion bigint,
  user_id text NOT NULL UNIQUE,
  graduation_year character varying,
  company character varying,
  recommendationtimedays smallint,
  openfordating boolean DEFAULT true,
  premiumtype text,
  premiumvalidtill timestamp with time zone,
  secrets ARRAY,
  created timestamp with time zone DEFAULT now(),
  usersetlevel text,
  adminsetlevel text,
  lastactive timestamp with time zone,
  isOnline boolean,
  profile_picture text,
  skill_level_badminton integer CHECK (skill_level_badminton >= 1 AND skill_level_badminton <= 5),
  skill_level_pickleball integer CHECK (skill_level_pickleball >= 1 AND skill_level_pickleball <= 5),
  preferred_sports ARRAY,
  CONSTRAINT users_pkey PRIMARY KEY (user_id)
);
CREATE TABLE public.userstogroups (
  user_id text NOT NULL,
  group_id integer NOT NULL,
  invitation_status USER-DEFINED,
  mobile_number text,
  usertogroupid smallint GENERATED ALWAYS AS IDENTITY NOT NULL,
  CONSTRAINT userstogroups_pkey PRIMARY KEY (usertogroupid),
  CONSTRAINT userstogroups_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT userstogroups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_id)
);
CREATE TABLE public.venues (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  venue_name text,
  images ARRAY,
  maps_link text,
  description text,
  location text,
  lat numeric,
  lng numeric,
  group_id integer,
  sport_type text CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text, 'both'::text])),
  city text,
  state text,
  amenities ARRAY,
  court_count integer DEFAULT 1,
  price_per_hour numeric,
  is_featured boolean DEFAULT false,
  CONSTRAINT venues_pkey PRIMARY KEY (id),
  CONSTRAINT venues_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_id)
);
CREATE TABLE public.waitlist (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  order_id bigint NOT NULL,
  user_id text,
  ticket_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  status text DEFAULT 'waitlisted'::text,
  CONSTRAINT waitlist_pkey PRIMARY KEY (id),
  CONSTRAINT waitlist_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id),
  CONSTRAINT waitlist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT waitlist_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id)
);




-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE chat.message_reactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  user_id text NOT NULL,
  emoji character varying NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT message_reactions_pkey PRIMARY KEY (id),
  CONSTRAINT message_reactions_message_id_fkey FOREIGN KEY (message_id) REFERENCES chat.messages(id),
  CONSTRAINT message_reactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE chat.message_read_status (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  user_id text NOT NULL,
  read_at timestamp with time zone DEFAULT now(),
  CONSTRAINT message_read_status_pkey PRIMARY KEY (id),
  CONSTRAINT message_read_status_message_id_fkey FOREIGN KEY (message_id) REFERENCES chat.messages(id),
  CONSTRAINT message_read_status_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE chat.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  sender_id text NOT NULL,
  content text,
  message_type character varying DEFAULT 'text'::character varying CHECK (message_type::text = ANY (ARRAY['text'::character varying, 'image'::character varying, 'video'::character varying, 'file'::character varying, 'match_share'::character varying, 'ticket_share'::character varying, 'system'::character varying]::text[])),
  media_url text,
  media_type character varying,
  media_size bigint,
  thumbnail_url text,
  shared_group_id integer,
  shared_ticket_id bigint,
  shared_content_preview jsonb,
  reply_to_message_id uuid,
  is_edited boolean DEFAULT false,
  edited_at timestamp with time zone,
  is_deleted boolean DEFAULT false,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  sender_name text,
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES chat.rooms(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(user_id),
  CONSTRAINT messages_shared_group_id_fkey FOREIGN KEY (shared_group_id) REFERENCES public.groups(group_id),
  CONSTRAINT messages_shared_ticket_id_fkey FOREIGN KEY (shared_ticket_id) REFERENCES public.tickets(id),
  CONSTRAINT messages_reply_to_message_id_fkey FOREIGN KEY (reply_to_message_id) REFERENCES chat.messages(id)
);
CREATE TABLE chat.room_members (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  user_id text NOT NULL,
  role character varying DEFAULT 'member'::character varying CHECK (role::text = ANY (ARRAY['admin'::character varying, 'moderator'::character varying, 'member'::character varying]::text[])),
  joined_at timestamp with time zone DEFAULT now(),
  last_seen_at timestamp with time zone DEFAULT now(),
  is_muted boolean DEFAULT false,
  is_banned boolean DEFAULT false,
  CONSTRAINT room_members_pkey PRIMARY KEY (id),
  CONSTRAINT room_members_room_id_fkey FOREIGN KEY (room_id) REFERENCES chat.rooms(id),
  CONSTRAINT room_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE chat.rooms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying,
  description text,
  type character varying NOT NULL CHECK (type::text = ANY (ARRAY['single'::character varying, 'group'::character varying]::text[])),
  sport_type character varying,
  avatar_url text,
  max_members integer DEFAULT 50,
  is_active boolean DEFAULT true,
  created_by text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  meta_data jsonb DEFAULT '{}'::jsonb,
  venue_id bigint,
  CONSTRAINT rooms_pkey PRIMARY KEY (id),
  CONSTRAINT rooms_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id),
  CONSTRAINT rooms_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(id)
);
CREATE TABLE chat.typing_indicators (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  user_id text NOT NULL,
  started_at timestamp with time zone DEFAULT now(),
  expires_at timestamp with time zone DEFAULT (now() + '00:00:10'::interval),
  CONSTRAINT typing_indicators_pkey PRIMARY KEY (id),
  CONSTRAINT typing_indicators_room_id_fkey FOREIGN KEY (room_id) REFERENCES chat.rooms(id),
  CONSTRAINT typing_indicators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);





-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE findplayers.game_session_joins (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL,
  user_id text NOT NULL,
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text, 'left'::text])),
  requested_at timestamp with time zone NOT NULL DEFAULT now(),
  responded_at timestamp with time zone,
  CONSTRAINT game_session_joins_pkey PRIMARY KEY (id),
  CONSTRAINT game_session_joins_session_fkey FOREIGN KEY (session_id) REFERENCES findplayers.game_sessions(id),
  CONSTRAINT game_session_joins_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE findplayers.game_sessions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  creator_id text NOT NULL,
  sport_type text NOT NULL CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text])),
  venue_id bigint,
  session_type text NOT NULL CHECK (session_type = ANY (ARRAY['singles'::text, 'doubles'::text, 'group'::text])),
  max_players integer NOT NULL,
  current_players jsonb NOT NULL DEFAULT '[]'::jsonb,
  scheduled_time timestamp with time zone NOT NULL,
  duration_minutes integer NOT NULL DEFAULT 60,
  skill_level_required integer CHECK (skill_level_required >= 1 AND skill_level_required <= 5),
  is_private boolean DEFAULT false,
  session_code text,
  status text NOT NULL DEFAULT 'open'::text CHECK (status = ANY (ARRAY['open'::text, 'full'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text])),
  latitude numeric,
  longitude numeric,
  cost_per_player numeric,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT game_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT game_sessions_creator_fkey FOREIGN KEY (creator_id) REFERENCES public.users(user_id),
  CONSTRAINT game_sessions_venue_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(id)
);
CREATE TABLE findplayers.match_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user1_id text NOT NULL,
  user2_id text NOT NULL,
  sport_type text NOT NULL,
  match_quality_score numeric,
  user1_feedback text CHECK ((user1_feedback = ANY (ARRAY['positive'::text, 'neutral'::text, 'negative'::text])) OR user1_feedback IS NULL),
  user2_feedback text CHECK ((user2_feedback = ANY (ARRAY['positive'::text, 'neutral'::text, 'negative'::text])) OR user2_feedback IS NULL),
  played_together boolean DEFAULT false,
  game_session_id uuid,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT match_history_pkey PRIMARY KEY (id),
  CONSTRAINT match_history_user1_fkey FOREIGN KEY (user1_id) REFERENCES public.users(user_id),
  CONSTRAINT match_history_user2_fkey FOREIGN KEY (user2_id) REFERENCES public.users(user_id),
  CONSTRAINT match_history_session_fkey FOREIGN KEY (game_session_id) REFERENCES findplayers.game_sessions(id)
);
CREATE TABLE findplayers.match_preferences (
  user_id text NOT NULL,
  sport_type text NOT NULL CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text])),
  max_distance_km numeric DEFAULT 10.0,
  preferred_times jsonb,
  skill_level_range ARRAY,
  preferred_venues ARRAY,
  auto_match_enabled boolean DEFAULT false,
  notification_enabled boolean DEFAULT true,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT match_preferences_pkey PRIMARY KEY (user_id, sport_type),
  CONSTRAINT match_preferences_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE findplayers.player_request_responses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  request_id uuid NOT NULL,
  responder_id text NOT NULL,
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text])),
  message text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT player_request_responses_pkey PRIMARY KEY (id),
  CONSTRAINT player_request_responses_request_fkey FOREIGN KEY (request_id) REFERENCES findplayers.player_requests(id),
  CONSTRAINT player_request_responses_responder_fkey FOREIGN KEY (responder_id) REFERENCES public.users(user_id)
);
CREATE TABLE findplayers.player_requests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  sport_type text NOT NULL CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text])),
  venue_id bigint,
  custom_location text,
  latitude numeric,
  longitude numeric,
  players_needed integer NOT NULL DEFAULT 1,
  scheduled_time timestamp with time zone NOT NULL,
  skill_level integer CHECK (skill_level >= 1 AND skill_level <= 5),
  description text,
  status text NOT NULL DEFAULT 'active'::text CHECK (status = ANY (ARRAY['active'::text, 'fulfilled'::text, 'expired'::text, 'cancelled'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  expires_at timestamp with time zone NOT NULL,
  CONSTRAINT player_requests_pkey PRIMARY KEY (id),
  CONSTRAINT player_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT player_requests_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(id)
);
CREATE TABLE findplayers.user_locations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL UNIQUE,
  latitude numeric NOT NULL,
  longitude numeric NOT NULL,
  is_available boolean NOT NULL DEFAULT false,
  sport_type text CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text])),
  skill_level integer CHECK (skill_level >= 1 AND skill_level <= 5),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT user_locations_pkey PRIMARY KEY (id),
  CONSTRAINT user_locations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);



-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE playnow.court_bookings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  venue_id bigint NOT NULL,
  user_id text NOT NULL,
  game_id uuid,
  booking_date date NOT NULL,
  start_time time without time zone NOT NULL,
  end_time time without time zone NOT NULL,
  court_number integer,
  status text NOT NULL DEFAULT 'confirmed'::text CHECK (status = ANY (ARRAY['confirmed'::text, 'cancelled'::text, 'completed'::text])),
  total_amount numeric NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT court_bookings_pkey PRIMARY KEY (id),
  CONSTRAINT court_bookings_venue_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(id),
  CONSTRAINT court_bookings_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT court_bookings_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id)
);
CREATE TABLE playnow.game_invite_usage (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  invite_id uuid NOT NULL,
  user_id text NOT NULL,
  used_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT game_invite_usage_pkey PRIMARY KEY (id),
  CONSTRAINT game_invite_usage_invite_fkey FOREIGN KEY (invite_id) REFERENCES playnow.game_invites(id),
  CONSTRAINT game_invite_usage_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.game_invites (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL,
  created_by text NOT NULL,
  invite_code text NOT NULL UNIQUE,
  invite_link text NOT NULL,
  max_uses integer,
  current_uses integer DEFAULT 0,
  expires_at timestamp with time zone,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT game_invites_pkey PRIMARY KEY (id),
  CONSTRAINT game_invites_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT game_invites_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.game_join_requests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL,
  user_id text NOT NULL,
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text, 'cancelled'::text])),
  message text,
  requested_at timestamp with time zone NOT NULL DEFAULT now(),
  responded_at timestamp with time zone,
  responded_by text,
  CONSTRAINT game_join_requests_pkey PRIMARY KEY (id),
  CONSTRAINT game_join_requests_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT game_join_requests_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT game_join_requests_responder_fkey FOREIGN KEY (responded_by) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.game_participants (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL,
  user_id text NOT NULL,
  joined_at timestamp with time zone NOT NULL DEFAULT now(),
  join_type text NOT NULL DEFAULT 'creator'::text CHECK (join_type = ANY (ARRAY['creator'::text, 'auto_join'::text, 'accepted_request'::text])),
  payment_status text DEFAULT 'pending'::text CHECK (payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'waived'::text])),
  payment_amount numeric,
  CONSTRAINT game_participants_pkey PRIMARY KEY (id),
  CONSTRAINT game_participants_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT game_participants_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.game_player_tags (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL,
  tagged_user_id text NOT NULL,
  tagged_by_user_id text NOT NULL,
  tag text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT game_player_tags_pkey PRIMARY KEY (id),
  CONSTRAINT game_player_tags_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT game_player_tags_tagged_user_fkey FOREIGN KEY (tagged_user_id) REFERENCES public.users(user_id),
  CONSTRAINT game_player_tags_tagged_by_fkey FOREIGN KEY (tagged_by_user_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.game_ratings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL,
  rated_user_id text NOT NULL,
  rated_by_user_id text NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  skill_rating integer CHECK (skill_rating >= 1 AND skill_rating <= 5 OR skill_rating IS NULL),
  sportsmanship_rating integer CHECK (sportsmanship_rating >= 1 AND sportsmanship_rating <= 5 OR sportsmanship_rating IS NULL),
  comment text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT game_ratings_pkey PRIMARY KEY (id),
  CONSTRAINT game_ratings_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT game_ratings_rated_user_fkey FOREIGN KEY (rated_user_id) REFERENCES public.users(user_id),
  CONSTRAINT game_ratings_rated_by_fkey FOREIGN KEY (rated_by_user_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.game_results (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL,
  submitted_by text NOT NULL,
  set1_team1_score integer,
  set1_team2_score integer,
  set2_team1_score integer,
  set2_team2_score integer,
  set3_team1_score integer,
  set3_team2_score integer,
  team1_players ARRAY NOT NULL,
  team2_players ARRAY NOT NULL,
  winning_team integer,
  is_verified boolean DEFAULT false,
  verified_by text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT game_results_pkey PRIMARY KEY (id),
  CONSTRAINT game_results_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT game_results_submitted_by_fkey FOREIGN KEY (submitted_by) REFERENCES public.users(user_id),
  CONSTRAINT game_results_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.games (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_by text NOT NULL,
  sport_type text NOT NULL CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text])),
  game_date date NOT NULL,
  start_time time without time zone NOT NULL,
  end_time time without time zone,
  venue_id bigint,
  custom_location text,
  players_needed integer NOT NULL,
  current_players_count integer NOT NULL DEFAULT 1,
  game_type text NOT NULL CHECK (game_type = ANY (ARRAY['singles'::text, 'doubles'::text, 'mixed_doubles'::text])),
  skill_level integer CHECK (skill_level >= 1 AND skill_level <= 5),
  cost_per_player numeric,
  is_free boolean NOT NULL DEFAULT false,
  payment_split_type text DEFAULT 'equal'::text,
  join_type text NOT NULL DEFAULT 'request'::text CHECK (join_type = ANY (ARRAY['auto'::text, 'request'::text])),
  is_venue_booked boolean DEFAULT false,
  is_women_only boolean DEFAULT false,
  is_mixed_only boolean DEFAULT false,
  description text,
  status text NOT NULL DEFAULT 'open'::text CHECK (status = ANY (ARRAY['open'::text, 'full'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text])),
  chat_room_id uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT games_pkey PRIMARY KEY (id),
  CONSTRAINT games_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id),
  CONSTRAINT games_venue_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(id),
  CONSTRAINT games_chat_room_fkey FOREIGN KEY (chat_room_id) REFERENCES chat.rooms(id)
);
CREATE TABLE playnow.notification_preferences (
  user_id text NOT NULL,
  chat_messages boolean DEFAULT true,
  post_game boolean DEFAULT true,
  game_reminders boolean DEFAULT true,
  friend_activity boolean DEFAULT true,
  booking_confirmations boolean DEFAULT true,
  spot_alerts boolean DEFAULT true,
  game_updates boolean DEFAULT true,
  marketing boolean DEFAULT false,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT notification_preferences_pkey PRIMARY KEY (user_id),
  CONSTRAINT notification_preferences_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.notifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  notification_type text NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  game_id uuid,
  chat_room_id uuid,
  from_user_id text,
  data jsonb,
  is_read boolean DEFAULT false,
  is_sent boolean DEFAULT false,
  sent_at timestamp with time zone,
  read_at timestamp with time zone,
  scheduled_for timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT notifications_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT notifications_chat_room_fkey FOREIGN KEY (chat_room_id) REFERENCES chat.rooms(id),
  CONSTRAINT notifications_from_user_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.play_pals (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  partner_id text NOT NULL,
  sport_type text NOT NULL CHECK (sport_type = ANY (ARRAY['badminton'::text, 'pickleball'::text])),
  games_played_together integer DEFAULT 0,
  last_played_at timestamp with time zone,
  is_favorite boolean DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT play_pals_pkey PRIMARY KEY (id),
  CONSTRAINT play_pals_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT play_pals_partner_fkey FOREIGN KEY (partner_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.referrals (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  referrer_id text NOT NULL,
  referred_id text NOT NULL,
  referral_code text NOT NULL,
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'completed'::text, 'expired'::text])),
  reward_amount numeric DEFAULT 50.00,
  reward_claimed boolean DEFAULT false,
  claimed_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  expires_at timestamp with time zone,
  CONSTRAINT referrals_pkey PRIMARY KEY (id),
  CONSTRAINT referrals_referrer_fkey FOREIGN KEY (referrer_id) REFERENCES public.users(user_id),
  CONSTRAINT referrals_referred_fkey FOREIGN KEY (referred_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.user_offers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  offer_type text NOT NULL,
  offer_code text,
  discount_amount numeric,
  discount_percentage integer,
  is_used boolean DEFAULT false,
  used_at timestamp with time zone,
  game_id uuid,
  order_id bigint,
  expires_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT user_offers_pkey PRIMARY KEY (id),
  CONSTRAINT user_offers_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT user_offers_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT user_offers_order_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id)
);
CREATE TABLE playnow.user_wallet (
  user_id text NOT NULL,
  balance numeric NOT NULL DEFAULT 0.00 CHECK (balance >= 0::numeric),
  total_earned numeric NOT NULL DEFAULT 0.00,
  total_spent numeric NOT NULL DEFAULT 0.00,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT user_wallet_pkey PRIMARY KEY (user_id),
  CONSTRAINT user_wallet_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);
CREATE TABLE playnow.wallet_transactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL,
  transaction_type text NOT NULL CHECK (transaction_type = ANY (ARRAY['credit'::text, 'debit'::text])),
  amount numeric NOT NULL,
  source text NOT NULL,
  description text,
  game_id uuid,
  order_id bigint,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT wallet_transactions_pkey PRIMARY KEY (id),
  CONSTRAINT wallet_transactions_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
  CONSTRAINT wallet_transactions_game_fkey FOREIGN KEY (game_id) REFERENCES playnow.games(id),
  CONSTRAINT wallet_transactions_order_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id)
);