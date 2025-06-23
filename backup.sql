--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6
-- Dumped by pg_dump version 16.6

-- Started on 2025-06-23 13:28:31

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 18312)
-- Name: applicants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicants (
    applicant_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    phone character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    university_id integer,
    specialization_id integer
);


ALTER TABLE public.applicants OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 18311)
-- Name: applicants_applicant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applicants_applicant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applicants_applicant_id_seq OWNER TO postgres;

--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 229
-- Name: applicants_applicant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applicants_applicant_id_seq OWNED BY public.applicants.applicant_id;


--
-- TOC entry 220 (class 1259 OID 18215)
-- Name: education_requirements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.education_requirements (
    requirement_id integer NOT NULL,
    vacancy_id integer,
    degree_level character varying(50),
    CONSTRAINT education_requirements_degree_level_check CHECK (((degree_level)::text = ANY ((ARRAY['Бакалавр'::character varying, 'Магистр'::character varying, 'Специалитет'::character varying])::text[])))
);


ALTER TABLE public.education_requirements OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 18214)
-- Name: education_requirements_requirement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.education_requirements_requirement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.education_requirements_requirement_id_seq OWNER TO postgres;

--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 219
-- Name: education_requirements_requirement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.education_requirements_requirement_id_seq OWNED BY public.education_requirements.requirement_id;


--
-- TOC entry 232 (class 1259 OID 18334)
-- Name: employer_university_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employer_university_messages (
    message_id integer NOT NULL,
    employer_id integer,
    university_id integer,
    message text NOT NULL,
    status character varying(50) DEFAULT 'sent'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employer_university_messages OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 18333)
-- Name: employer_university_messages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employer_university_messages_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employer_university_messages_message_id_seq OWNER TO postgres;

--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 231
-- Name: employer_university_messages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employer_university_messages_message_id_seq OWNED BY public.employer_university_messages.message_id;


--
-- TOC entry 228 (class 1259 OID 18283)
-- Name: employer_university_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employer_university_requests (
    request_id integer NOT NULL,
    employer_id integer,
    university_id integer,
    message text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employer_university_requests OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 18282)
-- Name: employer_university_requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employer_university_requests_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employer_university_requests_request_id_seq OWNER TO postgres;

--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 227
-- Name: employer_university_requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employer_university_requests_request_id_seq OWNED BY public.employer_university_requests.request_id;


--
-- TOC entry 216 (class 1259 OID 18188)
-- Name: employers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employers (
    employer_id integer NOT NULL,
    company_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    contact_phone character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employers OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 18187)
-- Name: employers_employer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employers_employer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employers_employer_id_seq OWNER TO postgres;

--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 215
-- Name: employers_employer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employers_employer_id_seq OWNED BY public.employers.employer_id;


--
-- TOC entry 224 (class 1259 OID 18258)
-- Name: graduate_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.graduate_skills (
    graduate_id integer NOT NULL,
    skill_id integer NOT NULL
);


ALTER TABLE public.graduate_skills OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 18427)
-- Name: graduates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.graduates (
    graduate_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    specialty character varying(255),
    university_id integer NOT NULL,
    contact_email character varying(255),
    contact_phone character varying(64)
);


ALTER TABLE public.graduates OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 18426)
-- Name: graduates_graduate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.graduates_graduate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.graduates_graduate_id_seq OWNER TO postgres;

--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 236
-- Name: graduates_graduate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.graduates_graduate_id_seq OWNED BY public.graduates.graduate_id;


--
-- TOC entry 222 (class 1259 OID 18228)
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    skill_id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 18227)
-- Name: skills_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skills_skill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skills_skill_id_seq OWNER TO postgres;

--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 221
-- Name: skills_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skills_skill_id_seq OWNED BY public.skills.skill_id;


--
-- TOC entry 234 (class 1259 OID 18358)
-- Name: specializations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specializations (
    specialization_id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.specializations OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 18357)
-- Name: specializations_specialization_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specializations_specialization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specializations_specialization_id_seq OWNER TO postgres;

--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 233
-- Name: specializations_specialization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specializations_specialization_id_seq OWNED BY public.specializations.specialization_id;


--
-- TOC entry 226 (class 1259 OID 18274)
-- Name: universities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.universities (
    university_id integer NOT NULL,
    name character varying(255) NOT NULL,
    contact_email character varying(255),
    password_hash character varying(255) NOT NULL
);


ALTER TABLE public.universities OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 18273)
-- Name: universities_university_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.universities_university_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.universities_university_id_seq OWNER TO postgres;

--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 225
-- Name: universities_university_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.universities_university_id_seq OWNED BY public.universities.university_id;


--
-- TOC entry 235 (class 1259 OID 18406)
-- Name: university_specializations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.university_specializations (
    university_id integer NOT NULL,
    specialization_id integer NOT NULL,
    exam_name character varying(100) NOT NULL,
    pass_mark integer NOT NULL
);


ALTER TABLE public.university_specializations OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 18200)
-- Name: vacancies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vacancies (
    vacancy_id integer NOT NULL,
    employer_id integer,
    title character varying(255) NOT NULL,
    description text,
    min_salary integer,
    max_salary integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    specialty character varying(255),
    requirements text
);


ALTER TABLE public.vacancies OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 18199)
-- Name: vacancies_vacancy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vacancies_vacancy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vacancies_vacancy_id_seq OWNER TO postgres;

--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 217
-- Name: vacancies_vacancy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vacancies_vacancy_id_seq OWNED BY public.vacancies.vacancy_id;


--
-- TOC entry 223 (class 1259 OID 18236)
-- Name: vacancy_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vacancy_skills (
    vacancy_id integer NOT NULL,
    skill_id integer NOT NULL
);


ALTER TABLE public.vacancy_skills OWNER TO postgres;

--
-- TOC entry 4700 (class 2604 OID 18315)
-- Name: applicants applicant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants ALTER COLUMN applicant_id SET DEFAULT nextval('public.applicants_applicant_id_seq'::regclass);


--
-- TOC entry 4695 (class 2604 OID 18218)
-- Name: education_requirements requirement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education_requirements ALTER COLUMN requirement_id SET DEFAULT nextval('public.education_requirements_requirement_id_seq'::regclass);


--
-- TOC entry 4702 (class 2604 OID 18337)
-- Name: employer_university_messages message_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_messages ALTER COLUMN message_id SET DEFAULT nextval('public.employer_university_messages_message_id_seq'::regclass);


--
-- TOC entry 4698 (class 2604 OID 18286)
-- Name: employer_university_requests request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_requests ALTER COLUMN request_id SET DEFAULT nextval('public.employer_university_requests_request_id_seq'::regclass);


--
-- TOC entry 4691 (class 2604 OID 18191)
-- Name: employers employer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employers ALTER COLUMN employer_id SET DEFAULT nextval('public.employers_employer_id_seq'::regclass);


--
-- TOC entry 4706 (class 2604 OID 18430)
-- Name: graduates graduate_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduates ALTER COLUMN graduate_id SET DEFAULT nextval('public.graduates_graduate_id_seq'::regclass);


--
-- TOC entry 4696 (class 2604 OID 18231)
-- Name: skills skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills ALTER COLUMN skill_id SET DEFAULT nextval('public.skills_skill_id_seq'::regclass);


--
-- TOC entry 4705 (class 2604 OID 18361)
-- Name: specializations specialization_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializations ALTER COLUMN specialization_id SET DEFAULT nextval('public.specializations_specialization_id_seq'::regclass);


--
-- TOC entry 4697 (class 2604 OID 18277)
-- Name: universities university_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities ALTER COLUMN university_id SET DEFAULT nextval('public.universities_university_id_seq'::regclass);


--
-- TOC entry 4693 (class 2604 OID 18203)
-- Name: vacancies vacancy_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancies ALTER COLUMN vacancy_id SET DEFAULT nextval('public.vacancies_vacancy_id_seq'::regclass);


--
-- TOC entry 4914 (class 0 OID 18312)
-- Dependencies: 230
-- Data for Name: applicants; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.applicants (applicant_id, full_name, email, password_hash, phone, created_at, university_id, specialization_id) VALUES (2, 'DSFFFFFFFFFFFF', 'career@itmo.ru', '$2b$10$M6Xia9eTHERV/4J1PZuysOXu2jJ7isOHh9j.NoZUG3/G46MEr9feC', '435445443', '2025-06-06 13:50:44.504', 3, 3);


--
-- TOC entry 4904 (class 0 OID 18215)
-- Dependencies: 220
-- Data for Name: education_requirements; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.education_requirements (requirement_id, vacancy_id, degree_level) VALUES (1, 1, 'Бакалавр');
INSERT INTO public.education_requirements (requirement_id, vacancy_id, degree_level) VALUES (2, 2, 'Магистр');
INSERT INTO public.education_requirements (requirement_id, vacancy_id, degree_level) VALUES (3, 3, 'Магистр');
INSERT INTO public.education_requirements (requirement_id, vacancy_id, degree_level) VALUES (4, 4, 'Специалитет');
INSERT INTO public.education_requirements (requirement_id, vacancy_id, degree_level) VALUES (12, 20, 'Магистр');


--
-- TOC entry 4916 (class 0 OID 18334)
-- Dependencies: 232
-- Data for Name: employer_university_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employer_university_messages (message_id, employer_id, university_id, message, status, created_at) VALUES (1, 6, 3, 'выав', 'sent', '2025-06-11 15:03:06.557');


--
-- TOC entry 4912 (class 0 OID 18283)
-- Dependencies: 228
-- Data for Name: employer_university_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employer_university_requests (request_id, employer_id, university_id, message, created_at) VALUES (1, 1, 1, 'Ищем талантливых выпускников для стажировки в области фронтенд-разработки', '2025-06-02 12:39:04.461854');
INSERT INTO public.employer_university_requests (request_id, employer_id, university_id, message, created_at) VALUES (2, 2, 2, 'Предложение о сотрудничестве в подготовке специалистов по анализу данных', '2025-06-02 12:39:04.461854');
INSERT INTO public.employer_university_requests (request_id, employer_id, university_id, message, created_at) VALUES (3, 3, 3, 'Приглашаем студентов на экскурсию в наш технологический центр', '2025-06-02 12:39:04.461854');


--
-- TOC entry 4900 (class 0 OID 18188)
-- Dependencies: 216
-- Data for Name: employers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employers (employer_id, company_name, email, password_hash, contact_phone, created_at) VALUES (1, 'ТехноПрогресс', 'hr@technoprogress.ru', '$2a$10$xJwL5v5Jz7U6QZoYcYvWw.6XJf6Zk9T0rN1oYd2vW3c4g5h6j7k8l', '+79161234567', '2025-06-02 12:39:04.461854');
INSERT INTO public.employers (employer_id, company_name, email, password_hash, contact_phone, created_at) VALUES (2, 'СофтДев', 'career@softdev.com', '$2a$10$yJwL5v5Jz7U6QZoYcYvWw.6XJf6Zk9T0rN1oYd2vW3c4g5h6j7k8l', '+79262345678', '2025-06-02 12:39:04.461854');
INSERT INTO public.employers (employer_id, company_name, email, password_hash, contact_phone, created_at) VALUES (3, 'АйТиРешения', 'info@it-solutions.org', '$2a$10$zJwL5v5Jz7U6QZoYcYvWw.6XJf6Zk9T0rN1oYd2vW3c4g5h6j7k8l', '+79373456789', '2025-06-02 12:39:04.461854');
INSERT INTO public.employers (employer_id, company_name, email, password_hash, contact_phone, created_at) VALUES (6, 'ыфвфы', 'chebu8461@gmail.com', '$2b$10$IDniNWURcVsGAsDK/Uyj4uKujVBYLmsppIp1yujAOdZ78.U6.eCT.', '89027654756', '2025-06-04 10:32:41.137');
INSERT INTO public.employers (employer_id, company_name, email, password_hash, contact_phone, created_at) VALUES (7, 'Омега', 'career@itmo.ru', '$2b$10$22sJmSgdsS8ro58qL2Un6OkCaDszYRRDhq/TfLtek7g/SH4uPU2gG', '89027654756', '2025-06-09 11:04:33.82');


--
-- TOC entry 4908 (class 0 OID 18258)
-- Dependencies: 224
-- Data for Name: graduate_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (1, 1);
INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (1, 5);
INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (2, 2);
INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (2, 4);
INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (3, 9);
INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (3, 10);
INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (4, 7);
INSERT INTO public.graduate_skills (graduate_id, skill_id) VALUES (4, 8);


--
-- TOC entry 4921 (class 0 OID 18427)
-- Dependencies: 237
-- Data for Name: graduates; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.graduates (graduate_id, full_name, specialty, university_id, contact_email, contact_phone) VALUES (1, 'Иванов Иван Иванович', 'Информатика', 1, 'ivanov@mgu.ru', '+7-999-111-22-33');
INSERT INTO public.graduates (graduate_id, full_name, specialty, university_id, contact_email, contact_phone) VALUES (2, 'Петрова Светлана Сергеевна', 'Экономика', 2, 'petrova@spbu.ru', '+7-999-222-33-44');
INSERT INTO public.graduates (graduate_id, full_name, specialty, university_id, contact_email, contact_phone) VALUES (3, 'Сидоров Алексей Павлович', 'Юриспруденция', 3, 'sidorov@hse.ru', '+7-999-333-44-55');
INSERT INTO public.graduates (graduate_id, full_name, specialty, university_id, contact_email, contact_phone) VALUES (4, 'Кузнецова Мария Владимировна', 'Математика', 4, 'kuznetsova@mipt.ru', '+7-999-444-55-66');
INSERT INTO public.graduates (graduate_id, full_name, specialty, university_id, contact_email, contact_phone) VALUES (5, 'Волков Дмитрий Андреевич', 'Физика', 1, 'volkov@mgu.ru', '+7-999-555-66-77');


--
-- TOC entry 4906 (class 0 OID 18228)
-- Dependencies: 222
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.skills (skill_id, name) VALUES (1, 'JavaScript');
INSERT INTO public.skills (skill_id, name) VALUES (2, 'Python');
INSERT INTO public.skills (skill_id, name) VALUES (3, 'Java');
INSERT INTO public.skills (skill_id, name) VALUES (4, 'SQL');
INSERT INTO public.skills (skill_id, name) VALUES (5, 'React');
INSERT INTO public.skills (skill_id, name) VALUES (6, 'Node.js');
INSERT INTO public.skills (skill_id, name) VALUES (7, 'Docker');
INSERT INTO public.skills (skill_id, name) VALUES (8, 'Kubernetes');
INSERT INTO public.skills (skill_id, name) VALUES (9, 'Machine Learning');
INSERT INTO public.skills (skill_id, name) VALUES (10, 'Data Analysis');


--
-- TOC entry 4918 (class 0 OID 18358)
-- Dependencies: 234
-- Data for Name: specializations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.specializations (specialization_id, name) VALUES (1, 'Программирование');
INSERT INTO public.specializations (specialization_id, name) VALUES (2, 'Структуры данных');
INSERT INTO public.specializations (specialization_id, name) VALUES (3, 'Управление памятью');
INSERT INTO public.specializations (specialization_id, name) VALUES (4, 'Веб-разработка');


--
-- TOC entry 4910 (class 0 OID 18274)
-- Dependencies: 226
-- Data for Name: universities; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.universities (university_id, name, contact_email, password_hash) VALUES (1, 'Национальный Исследовательский Университет ИТМО', 'career@itmo.ru', '121212');
INSERT INTO public.universities (university_id, name, contact_email, password_hash) VALUES (2, 'Санкт-Петербургский Политехнический Университет', 'hr@spbstu.ru', '222222');
INSERT INTO public.universities (university_id, name, contact_email, password_hash) VALUES (3, 'Московский Физико-Технический Институт', 'recruitment@mipt.ru', '333333');
INSERT INTO public.universities (university_id, name, contact_email, password_hash) VALUES (4, 'ывфывфы', 'sdfsdf@dsfsdfsd.com', '444444');
INSERT INTO public.universities (university_id, name, contact_email, password_hash) VALUES (8, '1емчстрпапис', 'chebu@gmail.com', '$2b$10$9i6jWk9oTrxFl4w/Gm.1bu.KlpmeD/lJZX0QH7EXFiTaPQbtW1NRS');


--
-- TOC entry 4919 (class 0 OID 18406)
-- Dependencies: 235
-- Data for Name: university_specializations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.university_specializations (university_id, specialization_id, exam_name, pass_mark) VALUES (1, 2, 'Математика', 45);
INSERT INTO public.university_specializations (university_id, specialization_id, exam_name, pass_mark) VALUES (1, 2, 'Русский язык', 40);
INSERT INTO public.university_specializations (university_id, specialization_id, exam_name, pass_mark) VALUES (1, 2, 'Физика', 39);
INSERT INTO public.university_specializations (university_id, specialization_id, exam_name, pass_mark) VALUES (1, 3, 'История', 42);
INSERT INTO public.university_specializations (university_id, specialization_id, exam_name, pass_mark) VALUES (2, 1, 'Математика', 37);
INSERT INTO public.university_specializations (university_id, specialization_id, exam_name, pass_mark) VALUES (8, 1, 'Физика', 40);


--
-- TOC entry 4902 (class 0 OID 18200)
-- Dependencies: 218
-- Data for Name: vacancies; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vacancies (vacancy_id, employer_id, title, description, min_salary, max_salary, created_at, specialty, requirements) VALUES (1, 1, 'Frontend Developer', 'Разработка пользовательских интерфейсов на React', 120000, 180000, '2025-06-02 12:39:04.461854', NULL, NULL);
INSERT INTO public.vacancies (vacancy_id, employer_id, title, description, min_salary, max_salary, created_at, specialty, requirements) VALUES (2, 1, 'Backend Developer', 'Разработка серверной части на Node.js и Python', 140000, 200000, '2025-06-02 12:39:04.461854', NULL, NULL);
INSERT INTO public.vacancies (vacancy_id, employer_id, title, description, min_salary, max_salary, created_at, specialty, requirements) VALUES (3, 2, 'Data Scientist', 'Анализ данных и построение ML-моделей', 150000, 250000, '2025-06-02 12:39:04.461854', NULL, NULL);
INSERT INTO public.vacancies (vacancy_id, employer_id, title, description, min_salary, max_salary, created_at, specialty, requirements) VALUES (4, 3, 'DevOps Engineer', 'Настройка CI/CD и облачной инфраструктуры', 160000, 220000, '2025-06-02 12:39:04.461854', NULL, NULL);
INSERT INTO public.vacancies (vacancy_id, employer_id, title, description, min_salary, max_salary, created_at, specialty, requirements) VALUES (20, 6, 'ЫФВВВВВВВВ', 'ававыпывапывапывапы', 11111111, 222222222, '2025-06-09 11:59:19.079', 'Магистр', NULL);


--
-- TOC entry 4907 (class 0 OID 18236)
-- Dependencies: 223
-- Data for Name: vacancy_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (1, 1);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (1, 5);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (1, 6);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (2, 2);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (2, 4);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (2, 6);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (3, 2);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (3, 9);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (3, 10);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (4, 7);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (4, 8);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (4, 4);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (20, 1);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (20, 4);
INSERT INTO public.vacancy_skills (vacancy_id, skill_id) VALUES (20, 8);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 229
-- Name: applicants_applicant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicants_applicant_id_seq', 2, true);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 219
-- Name: education_requirements_requirement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.education_requirements_requirement_id_seq', 12, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 231
-- Name: employer_university_messages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employer_university_messages_message_id_seq', 4, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 227
-- Name: employer_university_requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employer_university_requests_request_id_seq', 3, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 215
-- Name: employers_employer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employers_employer_id_seq', 7, true);


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 236
-- Name: graduates_graduate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.graduates_graduate_id_seq', 7, true);


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 221
-- Name: skills_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skills_skill_id_seq', 10, true);


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 233
-- Name: specializations_specialization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specializations_specialization_id_seq', 4, true);


--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 225
-- Name: universities_university_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.universities_university_id_seq', 8, true);


--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 217
-- Name: vacancies_vacancy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vacancies_vacancy_id_seq', 20, true);


--
-- TOC entry 4729 (class 2606 OID 18322)
-- Name: applicants applicants_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_email_key UNIQUE (email);


--
-- TOC entry 4731 (class 2606 OID 18320)
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (applicant_id);


--
-- TOC entry 4715 (class 2606 OID 18221)
-- Name: education_requirements education_requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education_requirements
    ADD CONSTRAINT education_requirements_pkey PRIMARY KEY (requirement_id);


--
-- TOC entry 4733 (class 2606 OID 18343)
-- Name: employer_university_messages employer_university_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_messages
    ADD CONSTRAINT employer_university_messages_pkey PRIMARY KEY (message_id);


--
-- TOC entry 4727 (class 2606 OID 18291)
-- Name: employer_university_requests employer_university_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_requests
    ADD CONSTRAINT employer_university_requests_pkey PRIMARY KEY (request_id);


--
-- TOC entry 4709 (class 2606 OID 18198)
-- Name: employers employers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employers
    ADD CONSTRAINT employers_email_key UNIQUE (email);


--
-- TOC entry 4711 (class 2606 OID 18196)
-- Name: employers employers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employers
    ADD CONSTRAINT employers_pkey PRIMARY KEY (employer_id);


--
-- TOC entry 4723 (class 2606 OID 18262)
-- Name: graduate_skills graduate_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduate_skills
    ADD CONSTRAINT graduate_skills_pkey PRIMARY KEY (graduate_id, skill_id);


--
-- TOC entry 4741 (class 2606 OID 18434)
-- Name: graduates graduates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduates
    ADD CONSTRAINT graduates_pkey PRIMARY KEY (graduate_id);


--
-- TOC entry 4717 (class 2606 OID 18235)
-- Name: skills skills_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_name_key UNIQUE (name);


--
-- TOC entry 4719 (class 2606 OID 18233)
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (skill_id);


--
-- TOC entry 4735 (class 2606 OID 18365)
-- Name: specializations specializations_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializations
    ADD CONSTRAINT specializations_name_key UNIQUE (name);


--
-- TOC entry 4737 (class 2606 OID 18363)
-- Name: specializations specializations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializations
    ADD CONSTRAINT specializations_pkey PRIMARY KEY (specialization_id);


--
-- TOC entry 4725 (class 2606 OID 18281)
-- Name: universities universities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (university_id);


--
-- TOC entry 4739 (class 2606 OID 18410)
-- Name: university_specializations university_specializations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_specializations
    ADD CONSTRAINT university_specializations_pkey PRIMARY KEY (university_id, specialization_id, exam_name);


--
-- TOC entry 4713 (class 2606 OID 18208)
-- Name: vacancies vacancies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancies
    ADD CONSTRAINT vacancies_pkey PRIMARY KEY (vacancy_id);


--
-- TOC entry 4721 (class 2606 OID 18240)
-- Name: vacancy_skills vacancy_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_skills
    ADD CONSTRAINT vacancy_skills_pkey PRIMARY KEY (vacancy_id, skill_id);


--
-- TOC entry 4749 (class 2606 OID 18386)
-- Name: applicants applicants_specialization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_specialization_id_fkey FOREIGN KEY (specialization_id) REFERENCES public.specializations(specialization_id);


--
-- TOC entry 4750 (class 2606 OID 18381)
-- Name: applicants applicants_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(university_id);


--
-- TOC entry 4743 (class 2606 OID 18222)
-- Name: education_requirements education_requirements_vacancy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education_requirements
    ADD CONSTRAINT education_requirements_vacancy_id_fkey FOREIGN KEY (vacancy_id) REFERENCES public.vacancies(vacancy_id) ON DELETE CASCADE;


--
-- TOC entry 4751 (class 2606 OID 18344)
-- Name: employer_university_messages employer_university_messages_employer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_messages
    ADD CONSTRAINT employer_university_messages_employer_id_fkey FOREIGN KEY (employer_id) REFERENCES public.employers(employer_id) ON DELETE CASCADE;


--
-- TOC entry 4752 (class 2606 OID 18349)
-- Name: employer_university_messages employer_university_messages_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_messages
    ADD CONSTRAINT employer_university_messages_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(university_id) ON DELETE CASCADE;


--
-- TOC entry 4747 (class 2606 OID 18292)
-- Name: employer_university_requests employer_university_requests_employer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_requests
    ADD CONSTRAINT employer_university_requests_employer_id_fkey FOREIGN KEY (employer_id) REFERENCES public.employers(employer_id);


--
-- TOC entry 4748 (class 2606 OID 18297)
-- Name: employer_university_requests employer_university_requests_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employer_university_requests
    ADD CONSTRAINT employer_university_requests_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(university_id);


--
-- TOC entry 4746 (class 2606 OID 18268)
-- Name: graduate_skills graduate_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduate_skills
    ADD CONSTRAINT graduate_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id);


--
-- TOC entry 4755 (class 2606 OID 18435)
-- Name: graduates graduates_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduates
    ADD CONSTRAINT graduates_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(university_id);


--
-- TOC entry 4753 (class 2606 OID 18416)
-- Name: university_specializations university_specializations_specialization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_specializations
    ADD CONSTRAINT university_specializations_specialization_id_fkey FOREIGN KEY (specialization_id) REFERENCES public.specializations(specialization_id);


--
-- TOC entry 4754 (class 2606 OID 18411)
-- Name: university_specializations university_specializations_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.university_specializations
    ADD CONSTRAINT university_specializations_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(university_id);


--
-- TOC entry 4742 (class 2606 OID 18209)
-- Name: vacancies vacancies_employer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancies
    ADD CONSTRAINT vacancies_employer_id_fkey FOREIGN KEY (employer_id) REFERENCES public.employers(employer_id) ON DELETE CASCADE;


--
-- TOC entry 4744 (class 2606 OID 18246)
-- Name: vacancy_skills vacancy_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_skills
    ADD CONSTRAINT vacancy_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id);


--
-- TOC entry 4745 (class 2606 OID 18241)
-- Name: vacancy_skills vacancy_skills_vacancy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_skills
    ADD CONSTRAINT vacancy_skills_vacancy_id_fkey FOREIGN KEY (vacancy_id) REFERENCES public.vacancies(vacancy_id) ON DELETE CASCADE;


-- Completed on 2025-06-23 13:28:32

--
-- PostgreSQL database dump complete
--

