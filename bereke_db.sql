--
-- PostgreSQL database dump
--

\restrict daMcOP2EZbn5NsvyQD1glayCgKUmnoG9xGOWqtoxJSF3HvMZstuD8O9yWpVhW1L

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.reservations_smslog DROP CONSTRAINT IF EXISTS reservations_smslog_reservation_id_1f696248_fk_reservati;
ALTER TABLE IF EXISTS ONLY public.reservations_reservation DROP CONSTRAINT IF EXISTS reservations_reservation_hall_id_6994444d_fk_contacts_hall_id;
ALTER TABLE IF EXISTS ONLY public.reservations_reservation DROP CONSTRAINT IF EXISTS reservations_reserva_branch_id_6e0bb7fd_fk_contacts_;
ALTER TABLE IF EXISTS ONLY public.menu_menuitem DROP CONSTRAINT IF EXISTS menu_menuitem_category_id_af353a3b_fk_menu_category_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.contacts_hall DROP CONSTRAINT IF EXISTS contacts_hall_branch_id_ee7d56d6_fk_contacts_branch_id;
ALTER TABLE IF EXISTS ONLY public.contacts_branch DROP CONSTRAINT IF EXISTS contacts_branch_city_id_9bbd1617_fk_contacts_city_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_group_id_97559544_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
DROP INDEX IF EXISTS public.reservations_smslog_reservation_id_1f696248;
DROP INDEX IF EXISTS public.reservations_reservation_hall_id_6994444d;
DROP INDEX IF EXISTS public.reservations_reservation_branch_id_6e0bb7fd;
DROP INDEX IF EXISTS public.reservation_status_5e543d_idx;
DROP INDEX IF EXISTS public.reservation_branch__1ceefc_idx;
DROP INDEX IF EXISTS public.menu_menuitem_category_id_af353a3b;
DROP INDEX IF EXISTS public.menu_menuit_is_avai_74a54e_idx;
DROP INDEX IF EXISTS public.menu_category_slug_9da38891_like;
DROP INDEX IF EXISTS public.menu_category_name_3df82881_like;
DROP INDEX IF EXISTS public.gallery_gal_is_acti_96e6fe_idx;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.contacts_hall_branch_id_ee7d56d6;
DROP INDEX IF EXISTS public.contacts_city_slug_9cd6bc9b_like;
DROP INDEX IF EXISTS public.contacts_city_name_a9314230_like;
DROP INDEX IF EXISTS public.contacts_branch_city_id_9bbd1617;
DROP INDEX IF EXISTS public.auth_user_username_6821ab7c_like;
DROP INDEX IF EXISTS public.auth_user_user_permissions_user_id_a95ead1b;
DROP INDEX IF EXISTS public.auth_user_user_permissions_permission_id_1fbb5f2c;
DROP INDEX IF EXISTS public.auth_user_groups_user_id_6a12ed8b;
DROP INDEX IF EXISTS public.auth_user_groups_group_id_97559544;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
ALTER TABLE IF EXISTS ONLY public.menu_menuitem DROP CONSTRAINT IF EXISTS unique_item_per_category;
ALTER TABLE IF EXISTS ONLY public.contacts_hall DROP CONSTRAINT IF EXISTS unique_hall_name_per_branch;
ALTER TABLE IF EXISTS ONLY public.contacts_branch DROP CONSTRAINT IF EXISTS unique_branch_address_per_city;
ALTER TABLE IF EXISTS ONLY public.reservations_smslog DROP CONSTRAINT IF EXISTS reservations_smslog_pkey;
ALTER TABLE IF EXISTS ONLY public.reservations_reservation DROP CONSTRAINT IF EXISTS reservations_reservation_pkey;
ALTER TABLE IF EXISTS ONLY public.menu_menuitem DROP CONSTRAINT IF EXISTS menu_menuitem_pkey;
ALTER TABLE IF EXISTS ONLY public.menu_category DROP CONSTRAINT IF EXISTS menu_category_slug_key;
ALTER TABLE IF EXISTS ONLY public.menu_category DROP CONSTRAINT IF EXISTS menu_category_pkey;
ALTER TABLE IF EXISTS ONLY public.menu_category DROP CONSTRAINT IF EXISTS menu_category_name_key;
ALTER TABLE IF EXISTS ONLY public.gallery_galleryphoto DROP CONSTRAINT IF EXISTS gallery_galleryphoto_pkey;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.contacts_hall DROP CONSTRAINT IF EXISTS contacts_hall_pkey;
ALTER TABLE IF EXISTS ONLY public.contacts_city DROP CONSTRAINT IF EXISTS contacts_city_slug_key;
ALTER TABLE IF EXISTS ONLY public.contacts_city DROP CONSTRAINT IF EXISTS contacts_city_pkey;
ALTER TABLE IF EXISTS ONLY public.contacts_city DROP CONSTRAINT IF EXISTS contacts_city_name_key;
ALTER TABLE IF EXISTS ONLY public.contacts_branch DROP CONSTRAINT IF EXISTS contacts_branch_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_username_key;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_group_id_94350c0c_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
DROP TABLE IF EXISTS public.reservations_smslog;
DROP TABLE IF EXISTS public.reservations_reservation;
DROP TABLE IF EXISTS public.menu_menuitem;
DROP TABLE IF EXISTS public.menu_category;
DROP TABLE IF EXISTS public.gallery_galleryphoto;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP TABLE IF EXISTS public.contacts_hall;
DROP TABLE IF EXISTS public.contacts_city;
DROP TABLE IF EXISTS public.contacts_branch;
DROP TABLE IF EXISTS public.auth_user_user_permissions;
DROP TABLE IF EXISTS public.auth_user_groups;
DROP TABLE IF EXISTS public.auth_user;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contacts_branch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts_branch (
    id bigint NOT NULL,
    address character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(254) NOT NULL,
    working_hours character varying(120) NOT NULL,
    google_maps_link character varying(200) NOT NULL,
    is_active boolean NOT NULL,
    city_id bigint NOT NULL
);


--
-- Name: contacts_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.contacts_branch ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contacts_branch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contacts_city; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts_city (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(120) NOT NULL
);


--
-- Name: contacts_city_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.contacts_city ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contacts_city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contacts_hall; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts_hall (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    capacity integer NOT NULL,
    description text NOT NULL,
    image character varying(100),
    branch_id bigint NOT NULL,
    CONSTRAINT contacts_hall_capacity_check CHECK ((capacity >= 0))
);


--
-- Name: contacts_hall_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.contacts_hall ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contacts_hall_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: gallery_galleryphoto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gallery_galleryphoto (
    id bigint NOT NULL,
    image character varying(100) NOT NULL,
    caption character varying(200) NOT NULL,
    "order" integer NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT gallery_galleryphoto_order_check CHECK (("order" >= 0))
);


--
-- Name: gallery_galleryphoto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.gallery_galleryphoto ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.gallery_galleryphoto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: menu_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.menu_category (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(140) NOT NULL,
    "order" integer NOT NULL,
    image character varying(100),
    CONSTRAINT menu_category_order_check CHECK (("order" >= 0))
);


--
-- Name: menu_category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.menu_category ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.menu_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: menu_menuitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.menu_menuitem (
    id bigint NOT NULL,
    name character varying(160) NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    weight integer,
    image character varying(100),
    is_available boolean NOT NULL,
    is_featured boolean NOT NULL,
    category_id bigint NOT NULL,
    CONSTRAINT menu_menuitem_weight_check CHECK ((weight >= 0))
);


--
-- Name: menu_menuitem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.menu_menuitem ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.menu_menuitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reservations_reservation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservations_reservation (
    id bigint NOT NULL,
    first_name character varying(80) NOT NULL,
    last_name character varying(80) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(254) NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    guests_count smallint NOT NULL,
    comment text NOT NULL,
    status character varying(10) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    branch_id bigint NOT NULL,
    hall_id bigint NOT NULL,
    CONSTRAINT reservations_reservation_guests_count_check CHECK ((guests_count >= 0))
);


--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.reservations_reservation ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.reservations_reservation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reservations_smslog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservations_smslog (
    id bigint NOT NULL,
    phone character varying(20) NOT NULL,
    message text NOT NULL,
    status character varying(10) NOT NULL,
    provider_response text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    reservation_id bigint
);


--
-- Name: reservations_smslog_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.reservations_smslog ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.reservations_smslog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add Категория	7	add_category
26	Can change Категория	7	change_category
27	Can delete Категория	7	delete_category
28	Can view Категория	7	view_category
29	Can add Блюдо	8	add_menuitem
30	Can change Блюдо	8	change_menuitem
31	Can delete Блюдо	8	delete_menuitem
32	Can view Блюдо	8	view_menuitem
33	Can add Бронирование	9	add_reservation
34	Can change Бронирование	9	change_reservation
35	Can delete Бронирование	9	delete_reservation
36	Can view Бронирование	9	view_reservation
37	Can add Фото галереи	10	add_galleryphoto
38	Can change Фото галереи	10	change_galleryphoto
39	Can delete Фото галереи	10	delete_galleryphoto
40	Can view Фото галереи	10	view_galleryphoto
41	Can add Филиал	11	add_branch
42	Can change Филиал	11	change_branch
43	Can delete Филиал	11	delete_branch
44	Can view Филиал	11	view_branch
45	Can add Город	12	add_city
46	Can change Город	12	change_city
47	Can delete Город	12	delete_city
48	Can view Город	12	view_city
49	Can add Зал	13	add_hall
50	Can change Зал	13	change_hall
51	Can delete Зал	13	delete_hall
52	Can view Зал	13	view_hall
53	Can add SMS-лог	14	add_smslog
54	Can change SMS-лог	14	change_smslog
55	Can delete SMS-лог	14	delete_smslog
56	Can view SMS-лог	14	view_smslog
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$600000$RaH48E3og17yi47Yl3CBZ7$pqSTKn67gpwanWpPwafghAWLLwfJAtJtx6J0bUku6gQ=	2026-05-16 18:48:36.944931+05	t	admin			berik20010720@gmail.com	t	t	2026-05-15 19:18:53.945835+05
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: contacts_branch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contacts_branch (id, address, phone, email, working_hours, google_maps_link, is_active, city_id) FROM stdin;
1	пр. Достык 1	+77001234567		11:00-22:00		t	1
2	пр. Мәңгілік Ел 18	+77010000002		11:00-22:00		t	2
3	пр. Тауке хана 25	+77010000003		11:00-22:00		t	3
\.


--
-- Data for Name: contacts_city; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contacts_city (id, name, slug) FROM stdin;
1	Алматы	алматы
2	Астана	астана
3	Шымкент	шымкент
\.


--
-- Data for Name: contacts_hall; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contacts_hall (id, name, capacity, description, image, branch_id) FROM stdin;
1	Основной зал	8			1
2	Основной зал	8			2
3	Основной зал	8			3
4	VIP зал	10			2
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2026-05-16 19:48:21.427458+05	4	VIP зал — Астана, пр. Мәңгілік Ел 18	1	[{"added": {}}]	13	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	menu	category
8	menu	menuitem
9	reservations	reservation
10	gallery	galleryphoto
11	contacts	branch
12	contacts	city
13	contacts	hall
14	reservations	smslog
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-05-15 18:52:17.295888+05
2	auth	0001_initial	2026-05-15 18:52:17.384463+05
3	admin	0001_initial	2026-05-15 18:52:17.403399+05
4	admin	0002_logentry_remove_auto_add	2026-05-15 18:52:17.408743+05
5	admin	0003_logentry_add_action_flag_choices	2026-05-15 18:52:17.416009+05
6	contenttypes	0002_remove_content_type_name	2026-05-15 18:52:17.427929+05
7	auth	0002_alter_permission_name_max_length	2026-05-15 18:52:17.434533+05
8	auth	0003_alter_user_email_max_length	2026-05-15 18:52:17.441622+05
9	auth	0004_alter_user_username_opts	2026-05-15 18:52:17.447571+05
10	auth	0005_alter_user_last_login_null	2026-05-15 18:52:17.456624+05
11	auth	0006_require_contenttypes_0002	2026-05-15 18:52:17.463021+05
12	auth	0007_alter_validators_add_error_messages	2026-05-15 18:52:17.4683+05
13	auth	0008_alter_user_username_max_length	2026-05-15 18:52:17.480018+05
14	auth	0009_alter_user_last_name_max_length	2026-05-15 18:52:17.485877+05
15	auth	0010_alter_group_name_max_length	2026-05-15 18:52:17.493258+05
16	auth	0011_update_proxy_permissions	2026-05-15 18:52:17.498271+05
17	auth	0012_alter_user_first_name_max_length	2026-05-15 18:52:17.504062+05
18	contacts	0001_initial	2026-05-15 18:52:17.576786+05
19	gallery	0001_initial	2026-05-15 18:52:17.588241+05
20	menu	0001_initial	2026-05-15 18:52:17.61835+05
21	reservations	0001_initial	2026-05-15 18:52:17.671427+05
22	sessions	0001_initial	2026-05-15 18:52:17.692281+05
23	gallery	0002_alter_galleryphoto_options	2026-05-15 19:29:43.584423+05
24	reservations	0002_smslog	2026-05-15 19:57:16.21718+05
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
qdtwqh6n94w0qckyn5hihewmq2gioke9	.eJxVjEEOwiAQRe_C2hCnQwu4dN8zkGEYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXBer0u0Xih9QdpDvV26x5rusyRb0r-qBNj3OS5_Vw_w4KtfKtvbeYyXmTDBgWAecgDcKEkLKVyH12-YzOWPbYMQyReiTuMLPNJpJ6fwDw-zie:1wNtNn:D73JU9LcuNKIIDH8H_p4HOi75o-McOisusZ5FkTpBGA	2026-05-29 19:19:19.19237+05
r11s95uxnqy5p93qj2qmu69fgma0nroa	.eJxVjEEOwiAQRe_C2hCnQwu4dN8zkGEYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXBer0u0Xih9QdpDvV26x5rusyRb0r-qBNj3OS5_Vw_w4KtfKtvbeYyXmTDBgWAecgDcKEkLKVyH12-YzOWPbYMQyReiTuMLPNJpJ6fwDw-zie:1wNtY8:9iFkrvezEaPv3n3Vm_aspUbabpezUjHTQqmh2gQyibE	2026-05-29 19:30:00.8852+05
eqogy1cd5qj4iw0bww6w1riz523m6wl0	.eJxVjEEOwiAQRe_C2hCnQwu4dN8zkGEYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXBer0u0Xih9QdpDvV26x5rusyRb0r-qBNj3OS5_Vw_w4KtfKtvbeYyXmTDBgWAecgDcKEkLKVyH12-YzOWPbYMQyReiTuMLPNJpJ6fwDw-zie:1wNtYz:K-8RMTQSjwTzV9noaEXoI8XG8TvJFgh5cRXKcp_fLMI	2026-05-29 19:30:53.414773+05
o3vr76aryr6bkyo213gav8goy4mqzfpo	.eJxVjEEOwiAQRe_C2hCnQwu4dN8zkGEYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXBer0u0Xih9QdpDvV26x5rusyRb0r-qBNj3OS5_Vw_w4KtfKtvbeYyXmTDBgWAecgDcKEkLKVyH12-YzOWPbYMQyReiTuMLPNJpJ6fwDw-zie:1wNtZj:EeBWkz-Ws0UxAV2BfRXKaG257qIsS6w4F7uRUElyoWM	2026-05-29 19:31:39.40921+05
d5ulw9evetmpmw9d6ptjn64wnphkxbsi	.eJxVjEEOwiAQRe_C2hCnQwu4dN8zkGEYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXBer0u0Xih9QdpDvV26x5rusyRb0r-qBNj3OS5_Vw_w4KtfKtvbeYyXmTDBgWAecgDcKEkLKVyH12-YzOWPbYMQyReiTuMLPNJpJ6fwDw-zie:1wNte8:cbLEiLhcF0dyQ6GvTXyP2H-H6CWgjDQaxP1ctljdFaI	2026-05-29 19:36:12.073729+05
q2zh27g437j1pus0qve6e28zk53eh0h2	.eJxVjEEOwiAQRe_C2hCnQwu4dN8zkGEYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXBer0u0Xih9QdpDvV26x5rusyRb0r-qBNj3OS5_Vw_w4KtfKtvbeYyXmTDBgWAecgDcKEkLKVyH12-YzOWPbYMQyReiTuMLPNJpJ6fwDw-zie:1wNu4a:FdvQG8Kvx5VagctduuXJr2kPd71onZIlj19HBfiBulU	2026-05-29 20:03:32.668699+05
204ytxdtrhrww5l6mupxgnmgmzg03ys2	.eJxVjMsOwiAQRf-FtSHAlJdL934DGQaQqoGktCvjv2uTLnR7zzn3xQJuaw3byEuYEzszyU6_W0R65LaDdMd265x6W5c58l3hBx382lN-Xg7376DiqN-ajNLFCp-yUU4kPYGDogEkCOlMwUxqMmRFQYsIEsmRFGCVB6Oj8ZK9P8InNtk:1wOF7Q:oN5i_0IIo89edqVRWZMWXtpY1b6exb3E-VGXiJxHiio	2026-05-30 18:31:52.931463+05
eg5y37i7uokfjiq6uios6l68iibzffmd	.eJxVjMsOwiAQRf-FtSHAlJdL934DGQaQqoGktCvjv2uTLnR7zzn3xQJuaw3byEuYEzszyU6_W0R65LaDdMd265x6W5c58l3hBx382lN-Xg7376DiqN-ajNLFCp-yUU4kPYGDogEkCOlMwUxqMmRFQYsIEsmRFGCVB6Oj8ZK9P8InNtk:1wOFJx:O_NLiRuYG9RORld3BdHa_AaVfEmnBKE0gTgfDhK_R2A	2026-05-30 18:44:49.525165+05
poy12ptiw4h63ynri7pf27j7c04v8f64	.eJxVjMsOwiAQRf-FtSHAlJdL934DGQaQqoGktCvjv2uTLnR7zzn3xQJuaw3byEuYEzszyU6_W0R65LaDdMd265x6W5c58l3hBx382lN-Xg7376DiqN-ajNLFCp-yUU4kPYGDogEkCOlMwUxqMmRFQYsIEsmRFGCVB6Oj8ZK9P8InNtk:1wOFKa:W5U2VqYZJ8u7SnC0rJs8LcmKsndHYb1UW1R6-7Dsun4	2026-05-30 18:45:28.688825+05
3ojnsshxpx2r45q81kpqc65eqxsewzvf	.eJxVjMsOwiAQRf-FtSHAlJdL934DGQaQqoGktCvjv2uTLnR7zzn3xQJuaw3byEuYEzszyU6_W0R65LaDdMd265x6W5c58l3hBx382lN-Xg7376DiqN-ajNLFCp-yUU4kPYGDogEkCOlMwUxqMmRFQYsIEsmRFGCVB6Oj8ZK9P8InNtk:1wOFNc:Xv6hDGNtupJo6VOdjtdo6gOWUQR1l83owHAv1jDYOiU	2026-05-30 18:48:36.945855+05
\.


--
-- Data for Name: gallery_galleryphoto; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.gallery_galleryphoto (id, image, caption, "order", is_active, created_at) FROM stdin;
2	gallery/2026/05/col-1-img-1.jpg		2	t	2026-05-16 17:45:27.483303+05
3	gallery/2026/05/col-1-img-2.jpg		3	t	2026-05-16 17:45:27.867974+05
4	gallery/2026/05/col-1-img-3.jpg		4	t	2026-05-16 17:45:28.29125+05
6	gallery/2026/05/col-1-img-5.jpg		6	t	2026-05-16 17:45:29.149622+05
7	gallery/2026/05/col-1-img-6.jpg		7	t	2026-05-16 17:45:29.57016+05
8	gallery/2026/05/col-1-img-7.jpg		8	t	2026-05-16 17:45:29.97156+05
9	gallery/2026/05/col-1-img-8.jpg		9	t	2026-05-16 17:45:30.355566+05
11	gallery/2026/05/col-2-img-2.jpg		11	t	2026-05-16 17:45:31.248795+05
12	gallery/2026/05/col-2-img-3.jpg		12	t	2026-05-16 17:45:31.559712+05
13	gallery/2026/05/col-2-img-4.jpg		13	t	2026-05-16 17:45:32.034344+05
14	gallery/2026/05/col-2-img-5.jpg		14	t	2026-05-16 17:45:32.498355+05
15	gallery/2026/05/col-2-img-6.jpg		15	t	2026-05-16 17:45:32.901581+05
16	gallery/2026/05/col-2-img-7.jpg		16	t	2026-05-16 17:45:33.395834+05
17	gallery/2026/05/col-2-img-8.jpg		17	t	2026-05-16 17:45:33.850941+05
18	gallery/2026/05/col-3-img-1.jpg		18	t	2026-05-16 17:45:34.497097+05
19	gallery/2026/05/col-3-img-3.jpg		19	t	2026-05-16 17:45:34.991886+05
20	gallery/2026/05/col-3-img-4.jpg		20	t	2026-05-16 17:45:35.364941+05
21	gallery/2026/05/col-3-img-5.jpg		21	t	2026-05-16 17:45:35.797998+05
22	gallery/2026/05/col-3-img-6.jpg		22	t	2026-05-16 17:45:36.227082+05
23	gallery/2026/05/col-3-img-7.jpg		23	t	2026-05-16 17:45:36.62066+05
24	gallery/2026/05/col-3-img-8.jpg		24	t	2026-05-16 17:45:36.929976+05
25	gallery/2026/05/col-3-img-9.jpg		25	t	2026-05-16 17:45:37.43281+05
\.


--
-- Data for Name: menu_category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.menu_category (id, name, slug, "order", image) FROM stdin;
2	Закуски	закуски	1	
3	Супы	супы	2	
1	Горячие блюда	горячие-блюда	3	
4	Десерты	десерты	4	
5	Напитки	напитки	5	
\.


--
-- Data for Name: menu_menuitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.menu_menuitem (id, name, description, price, weight, image, is_available, is_featured, category_id) FROM stdin;
2	Казы домашнее	Конская колбаса по семейному рецепту, тонкая нарезка	4200.00	90	menu/items/dish-2.jpg	t	t	2
3	Куырдак	Жаркое из печени и сердца с луком	2800.00	250	menu/items/dish-3.jpg	t	f	2
1	Бешбармак	Традиционное блюдо	3500.00	400	menu/items/dish-1.jpg	t	t	1
19	Шұбат	Кисломолочный напиток из верблюжьего молока	1500.00	300	menu/items/dish-19.jpg	t	f	5
20	Айран	Натуральный кисломолочный напиток	900.00	300	menu/items/dish-20.jpg	t	f	5
7	Шек-шек (чак-чак)	Медовое лакомство из теста	1500.00	150	menu/items/dish-7.jpg	t	f	4
11	Жая	Вяленая конина из верхней части бедра, тонкая нарезка	3800.00	90		t	f	2
5	Кеспе	Домашняя лапша на бульоне из баранины	2200.00	350	menu/items/dish-5.jpg	t	f	3
4	Сорпа	Наваристый мясной бульон с зеленью	1900.00	350	menu/items/dish-4.jpg	t	f	3
16	Сырне	Жаркое из молодого барашка, томлёное с овощами	4900.00	320		t	f	1
18	Жент	Старинная сладость из обжаренного пшена, масла и мёда	1600.00	120		t	f	4
9	Қымыз	Кобылье молоко, традиционный напиток	1200.00	300	menu/items/dish-9_aBdSpcz.jpg	t	f	5
10	Шай по-казахски	Чай с молоком и солью в большой пиале	900.00	250	menu/items/dish-10_58hs2iD.jpg	t	f	5
21	Травяной чай	Сбор степных трав: чабрец, душица, мята	1100.00	400		t	f	5
8	Балқаймақ	Топлёные сливки с мёдом степных трав	1700.00	120	menu/items/dish-8.jpg	t	t	4
6	Қуырдак	Молодая баранина, томлённая в казане	4600.00	380	menu/items/dish-6.jpg	t	f	1
12	Курт	Сушёный солёный сыр из овечьего молока	1200.00	60	menu/items/dish-12.jpg	t	f	2
13	Көже	Кисломолочный крупяной суп с пшеницей и айраном	1900.00	350	menu/items/dish-13.jpg	t	f	3
14	Палау	Казахский плов с бараниной, морковью и зирой	3200.00	320	menu/items/dish-14.jpg	t	f	1
15	Манты	Паровые манты с рубленой бараниной и луком (4 шт.)	2600.00	280	menu/items/dish-15.jpg	t	f	1
17	Бауырсақ	Пышные жареные пончики к чаю, по-домашнему	1400.00	150	menu/items/dish-17.jpg	t	f	4
\.


--
-- Data for Name: reservations_reservation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reservations_reservation (id, first_name, last_name, phone, email, date, "time", guests_count, comment, status, created_at, branch_id, hall_id) FROM stdin;
1	Тест	Гость	+77011112233		2026-05-16	14:00:00	4		confirmed	2026-05-15 19:08:57.724293+05	1	1
3	Айгуль	Сапарова	+77018889900		2026-05-20	19:00:00	3		confirmed	2026-05-15 19:31:39.652745+05	1	1
4	Дамир	Касымов	+77017654321		2026-05-22	20:00:00	2		confirmed	2026-05-15 19:36:12.281066+05	1	1
5	Нурлан	Абдиров	+77019998877	guest@example.com	2026-05-25	19:30:00	2		confirmed	2026-05-15 19:57:48.448142+05	1	1
2	Иван	Петров	+77011112233		2026-06-01	18:00:00	4		confirmed	2026-05-15 19:10:32.161316+05	1	1
6	Тест	Чеклист	+77001234567	guest@mail.com	2026-05-27	18:00:00	2		confirmed	2026-05-15 20:02:57.993158+05	1	1
7	Админ	Экшен	+77005556677	a@mail.com	2026-05-30	17:00:00	2		confirmed	2026-05-15 20:03:32.684193+05	1	1
10	Berik	Sapargaliyev	+77083277860	dfssd@gmai.com	2026-05-16	18:30:00	6		confirmed	2026-05-16 18:22:48.127503+05	2	2
9	Прод	Запуск	+77000000099	prod@example.com	2026-07-01	11:00:00	2		confirmed	2026-05-15 21:00:05.003273+05	1	1
8	Сайт	Гость	+77001112233	site@example.com	2026-06-15	11:00:00	2		confirmed	2026-05-15 20:11:01.673374+05	1	1
11	Арман	Тордыев	+77086754532	dfssd@gmai.com	2026-05-17	11:15:00	2		confirmed	2026-05-16 19:46:58.223539+05	3	3
12	vgjvjv	nk n	+77087866790	jvjvhvhj@gmail.com	2026-05-21	11:30:00	2		confirmed	2026-05-16 21:15:14.459792+05	2	2
\.


--
-- Data for Name: reservations_smslog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reservations_smslog (id, phone, message, status, provider_response, created_at, reservation_id) FROM stdin;
1	+77019998877	Здравствуйте, Нурлан! Бронь в «Алматы, пр. Достык 1» подтверждена: 25.05.2026 в 19:30, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-15 19:57:48.507405+05	5
2	+77011112233	Здравствуйте, Иван! Бронь в «Алматы, пр. Достык 1» подтверждена: 01.06.2026 в 18:00, зал «Основной зал», гостей: 4. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-15 20:01:34.539699+05	2
3	+77011112233	Здравствуйте, Иван! Бронь в «Алматы, пр. Достык 1» подтверждена: 01.06.2026 в 18:00, зал «Основной зал», гостей: 4. Ждём вас!	failed	HTTPConnectionPool(host='127.0.0.1', port=59999): Max retries exceeded with url: /send (Caused by NewConnectionError("HTTPConnection(host='127.0.0.1', port=59999): Failed to establish a new connection: [Errno 61] Connection refused"))	2026-05-15 20:01:34.556374+05	2
4	+77011112233	Здравствуйте, Иван! Бронь в «Алматы, пр. Достык 1» подтверждена: 01.06.2026 в 18:00, зал «Основной зал», гостей: 4. Ждём вас!	sent	{\n  "args": {}, \n  "data": "{\\"api_key\\": \\"\\", \\"sender\\": \\"Restaurant\\", \\"phone\\": \\"+77011112233\\", \\"text\\": \\"\\\\u0417\\\\u0434\\\\u0440\\\\u0430\\\\u0432\\\\u0441\\\\u0442\\\\u0432\\\\u0443\\\\u0439\\\\u0442\\\\u0435, \\\\u0418\\\\u0432\\\\u0430\\\\u043d! \\\\u0411\\\\u0440\\\\u043e\\\\u043d\\\\u044c \\\\u0432 \\\\u00ab\\\\u0410\\\\u043b\\\\u043c\\\\u0430\\\\u0442\\\\u044b, \\\\u043f\\\\u0440. \\\\u0414\\\\u043e\\\\u0441\\\\u0442\\\\u044b\\\\u043a 1\\\\u00bb \\\\u043f\\\\u043e\\\\u0434\\\\u0442\\\\u0432\\\\u0435\\\\u0440\\\\u0436\\\\u0434\\\\u0435\\\\u043d\\\\u0430: 01.06.2026 \\\\u0432 18:00, \\\\u0437\\\\u0430\\\\u043b \\\\u00ab\\\\u041e\\\\u0441\\\\u043d\\\\u043e\\\\u0432\\\\u043d\\\\u043e\\\\u0439 \\\\u0437\\\\u0430\\\\u043b\\\\u00bb, \\\\u0433\\\\u043e\\\\u0441\\\\u0442\\\\u0435\\\\u0439: 4. \\\\u0416\\\\u0434\\\\u0451\\\\u043c \\\\u0432\\\\u0430\\\\u0441!\\"}", \n  "files": {}, \n  "form": {}, \n  "headers": {\n    "Accept": "*/*", \n    "Accept-Encoding": "gzip, deflate", \n    "Content-Length": "601", \n    "Content-Type": "application/json", \n    "Host": "httpbin.org", \n    "User-Agent": "python-requests/2.32.3", \n    "X-Amzn-Trace-	2026-05-15 20:01:36.47139+05	2
5	+77011112233	Здравствуйте, Иван! Бронь в «Алматы, пр. Достык 1» подтверждена: 01.06.2026 в 18:00, зал «Основной зал», гостей: 4. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-15 20:01:36.479513+05	2
6	+77001234567	Здравствуйте, Тест! Бронь в «Алматы, пр. Достык 1» подтверждена: 27.05.2026 в 18:00, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-15 20:02:58.051161+05	6
7	+77001234567	Здравствуйте, Тест! Бронь в «Алматы, пр. Достык 1» подтверждена: 27.05.2026 в 18:00, зал «Основной зал», гостей: 2. Ждём вас!	failed	HTTPConnectionPool(host='127.0.0.1', port=59999): Max retries exceeded with url: /send (Caused by NewConnectionError("HTTPConnection(host='127.0.0.1', port=59999): Failed to establish a new connection: [Errno 61] Connection refused"))	2026-05-15 20:02:58.065229+05	6
8	+77001234567	Здравствуйте, Тест! Бронь в «Алматы, пр. Достык 1» подтверждена: 27.05.2026 в 18:00, зал «Основной зал», гостей: 2. Ждём вас!	sent	{\n  "args": {}, \n  "data": "{\\"api_key\\": \\"\\", \\"sender\\": \\"Restaurant\\", \\"phone\\": \\"+77001234567\\", \\"text\\": \\"\\\\u0417\\\\u0434\\\\u0440\\\\u0430\\\\u0432\\\\u0441\\\\u0442\\\\u0432\\\\u0443\\\\u0439\\\\u0442\\\\u0435, \\\\u0422\\\\u0435\\\\u0441\\\\u0442! \\\\u0411\\\\u0440\\\\u043e\\\\u043d\\\\u044c \\\\u0432 \\\\u00ab\\\\u0410\\\\u043b\\\\u043c\\\\u0430\\\\u0442\\\\u044b, \\\\u043f\\\\u0440. \\\\u0414\\\\u043e\\\\u0441\\\\u0442\\\\u044b\\\\u043a 1\\\\u00bb \\\\u043f\\\\u043e\\\\u0434\\\\u0442\\\\u0432\\\\u0435\\\\u0440\\\\u0436\\\\u0434\\\\u0435\\\\u043d\\\\u0430: 27.05.2026 \\\\u0432 18:00, \\\\u0437\\\\u0430\\\\u043b \\\\u00ab\\\\u041e\\\\u0441\\\\u043d\\\\u043e\\\\u0432\\\\u043d\\\\u043e\\\\u0439 \\\\u0437\\\\u0430\\\\u043b\\\\u00bb, \\\\u0433\\\\u043e\\\\u0441\\\\u0442\\\\u0435\\\\u0439: 2. \\\\u0416\\\\u0434\\\\u0451\\\\u043c \\\\u0432\\\\u0430\\\\u0441!\\"}", \n  "files": {}, \n  "form": {}, \n  "headers": {\n    "Accept": "*/*", \n    "Accept-Encoding": "gzip, deflate", \n    "Content-Length": "601", \n    "Content-Type": "application/json", \n    "Host": "httpbin.org", \n    "User-Agent": "python-requests/2.32.3", \n    "X-Amzn-Trace-	2026-05-15 20:03:00.497029+05	6
9	+77001234567	Здравствуйте, Тест! Бронь в «Алматы, пр. Достык 1» подтверждена: 27.05.2026 в 18:00, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-15 20:03:00.520271+05	6
10	+77005556677	Здравствуйте, Админ! Бронь в «Алматы, пр. Достык 1» подтверждена: 30.05.2026 в 17:00, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-15 20:03:32.783405+05	7
11	+77083277860	Здравствуйте, Berik! Бронь в «Астана, пр. Мәңгілік Ел 18» подтверждена: 16.05.2026 в 18:30, зал «Основной зал», гостей: 6. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-16 18:45:28.890091+05	10
12	+77000000099	Здравствуйте, Прод! Бронь в «Алматы, пр. Достык 1» подтверждена: 01.07.2026 в 11:00, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-16 18:46:32.720075+05	9
13	+77001112233	Здравствуйте, Сайт! Бронь в «Алматы, пр. Достык 1» подтверждена: 15.06.2026 в 11:00, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-16 18:48:37.04473+05	8
14	+77086754532	Здравствуйте, Арман! Бронь в «Шымкент, пр. Тауке хана 25» подтверждена: 17.05.2026 в 11:15, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-16 19:47:12.328115+05	11
15	+77087866790	Здравствуйте, vgjvjv! Бронь в «Астана, пр. Мәңгілік Ел 18» подтверждена: 21.05.2026 в 11:30, зал «Основной зал», гостей: 2. Ждём вас!	skipped	SMS_ENABLED=False или SMS_API_URL пуст	2026-05-16 21:15:46.225156+05	12
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 56, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: contacts_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contacts_branch_id_seq', 3, true);


--
-- Name: contacts_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contacts_city_id_seq', 3, true);


--
-- Name: contacts_hall_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contacts_hall_id_seq', 4, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 14, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 24, true);


--
-- Name: gallery_galleryphoto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gallery_galleryphoto_id_seq', 25, true);


--
-- Name: menu_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.menu_category_id_seq', 5, true);


--
-- Name: menu_menuitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.menu_menuitem_id_seq', 21, true);


--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reservations_reservation_id_seq', 12, true);


--
-- Name: reservations_smslog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reservations_smslog_id_seq', 15, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: contacts_branch contacts_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_branch
    ADD CONSTRAINT contacts_branch_pkey PRIMARY KEY (id);


--
-- Name: contacts_city contacts_city_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_city
    ADD CONSTRAINT contacts_city_name_key UNIQUE (name);


--
-- Name: contacts_city contacts_city_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_city
    ADD CONSTRAINT contacts_city_pkey PRIMARY KEY (id);


--
-- Name: contacts_city contacts_city_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_city
    ADD CONSTRAINT contacts_city_slug_key UNIQUE (slug);


--
-- Name: contacts_hall contacts_hall_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_hall
    ADD CONSTRAINT contacts_hall_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: gallery_galleryphoto gallery_galleryphoto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gallery_galleryphoto
    ADD CONSTRAINT gallery_galleryphoto_pkey PRIMARY KEY (id);


--
-- Name: menu_category menu_category_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_category
    ADD CONSTRAINT menu_category_name_key UNIQUE (name);


--
-- Name: menu_category menu_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_category
    ADD CONSTRAINT menu_category_pkey PRIMARY KEY (id);


--
-- Name: menu_category menu_category_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_category
    ADD CONSTRAINT menu_category_slug_key UNIQUE (slug);


--
-- Name: menu_menuitem menu_menuitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_pkey PRIMARY KEY (id);


--
-- Name: reservations_reservation reservations_reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations_reservation
    ADD CONSTRAINT reservations_reservation_pkey PRIMARY KEY (id);


--
-- Name: reservations_smslog reservations_smslog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations_smslog
    ADD CONSTRAINT reservations_smslog_pkey PRIMARY KEY (id);


--
-- Name: contacts_branch unique_branch_address_per_city; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_branch
    ADD CONSTRAINT unique_branch_address_per_city UNIQUE (city_id, address);


--
-- Name: contacts_hall unique_hall_name_per_branch; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_hall
    ADD CONSTRAINT unique_hall_name_per_branch UNIQUE (branch_id, name);


--
-- Name: menu_menuitem unique_item_per_category; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT unique_item_per_category UNIQUE (category_id, name);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: contacts_branch_city_id_9bbd1617; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contacts_branch_city_id_9bbd1617 ON public.contacts_branch USING btree (city_id);


--
-- Name: contacts_city_name_a9314230_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contacts_city_name_a9314230_like ON public.contacts_city USING btree (name varchar_pattern_ops);


--
-- Name: contacts_city_slug_9cd6bc9b_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contacts_city_slug_9cd6bc9b_like ON public.contacts_city USING btree (slug varchar_pattern_ops);


--
-- Name: contacts_hall_branch_id_ee7d56d6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contacts_hall_branch_id_ee7d56d6 ON public.contacts_hall USING btree (branch_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: gallery_gal_is_acti_96e6fe_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gallery_gal_is_acti_96e6fe_idx ON public.gallery_galleryphoto USING btree (is_active, "order");


--
-- Name: menu_category_name_3df82881_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_category_name_3df82881_like ON public.menu_category USING btree (name varchar_pattern_ops);


--
-- Name: menu_category_slug_9da38891_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_category_slug_9da38891_like ON public.menu_category USING btree (slug varchar_pattern_ops);


--
-- Name: menu_menuit_is_avai_74a54e_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_menuit_is_avai_74a54e_idx ON public.menu_menuitem USING btree (is_available, is_featured);


--
-- Name: menu_menuitem_category_id_af353a3b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_menuitem_category_id_af353a3b ON public.menu_menuitem USING btree (category_id);


--
-- Name: reservation_branch__1ceefc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reservation_branch__1ceefc_idx ON public.reservations_reservation USING btree (branch_id, date, status);


--
-- Name: reservation_status_5e543d_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reservation_status_5e543d_idx ON public.reservations_smslog USING btree (status, created_at);


--
-- Name: reservations_reservation_branch_id_6e0bb7fd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reservations_reservation_branch_id_6e0bb7fd ON public.reservations_reservation USING btree (branch_id);


--
-- Name: reservations_reservation_hall_id_6994444d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reservations_reservation_hall_id_6994444d ON public.reservations_reservation USING btree (hall_id);


--
-- Name: reservations_smslog_reservation_id_1f696248; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reservations_smslog_reservation_id_1f696248 ON public.reservations_smslog USING btree (reservation_id);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contacts_branch contacts_branch_city_id_9bbd1617_fk_contacts_city_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_branch
    ADD CONSTRAINT contacts_branch_city_id_9bbd1617_fk_contacts_city_id FOREIGN KEY (city_id) REFERENCES public.contacts_city(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contacts_hall contacts_hall_branch_id_ee7d56d6_fk_contacts_branch_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts_hall
    ADD CONSTRAINT contacts_hall_branch_id_ee7d56d6_fk_contacts_branch_id FOREIGN KEY (branch_id) REFERENCES public.contacts_branch(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: menu_menuitem menu_menuitem_category_id_af353a3b_fk_menu_category_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_category_id_af353a3b_fk_menu_category_id FOREIGN KEY (category_id) REFERENCES public.menu_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reservations_reservation reservations_reserva_branch_id_6e0bb7fd_fk_contacts_; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations_reservation
    ADD CONSTRAINT reservations_reserva_branch_id_6e0bb7fd_fk_contacts_ FOREIGN KEY (branch_id) REFERENCES public.contacts_branch(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reservations_reservation reservations_reservation_hall_id_6994444d_fk_contacts_hall_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations_reservation
    ADD CONSTRAINT reservations_reservation_hall_id_6994444d_fk_contacts_hall_id FOREIGN KEY (hall_id) REFERENCES public.contacts_hall(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reservations_smslog reservations_smslog_reservation_id_1f696248_fk_reservati; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservations_smslog
    ADD CONSTRAINT reservations_smslog_reservation_id_1f696248_fk_reservati FOREIGN KEY (reservation_id) REFERENCES public.reservations_reservation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict daMcOP2EZbn5NsvyQD1glayCgKUmnoG9xGOWqtoxJSF3HvMZstuD8O9yWpVhW1L

