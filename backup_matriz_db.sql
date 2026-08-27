--
-- PostgreSQL database dump
--

\restrict nLRZYiF6mk9218cSajLu2gJRrVvRG0w6svqeOcz4M12b6x5XpiubDpwgZAbzFD5

-- Dumped from database version 15.19
-- Dumped by pg_dump version 15.19

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
-- Name: ventas_locales; Type: TABLE; Schema: public; Owner: ucom_admin
--

CREATE TABLE public.ventas_locales (
    id integer NOT NULL,
    invoice_no character varying(20) NOT NULL,
    stock_code character varying(20) NOT NULL,
    description text,
    quantity integer NOT NULL,
    invoice_date timestamp without time zone NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    customer_id character varying(20),
    sucursal character varying(100) NOT NULL,
    insertado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ventas_locales OWNER TO ucom_admin;

--
-- Name: ventas_locales_id_seq; Type: SEQUENCE; Schema: public; Owner: ucom_admin
--

CREATE SEQUENCE public.ventas_locales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ventas_locales_id_seq OWNER TO ucom_admin;

--
-- Name: ventas_locales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ucom_admin
--

ALTER SEQUENCE public.ventas_locales_id_seq OWNED BY public.ventas_locales.id;


--
-- Name: ventas_locales id; Type: DEFAULT; Schema: public; Owner: ucom_admin
--

ALTER TABLE ONLY public.ventas_locales ALTER COLUMN id SET DEFAULT nextval('public.ventas_locales_id_seq'::regclass);


--
-- Data for Name: ventas_locales; Type: TABLE DATA; Schema: public; Owner: ucom_admin
--

COPY public.ventas_locales (id, invoice_no, stock_code, description, quantity, invoice_date, unit_price, customer_id, sucursal, insertado_en) FROM stdin;
1	536365	85123A	WHITE HANGING HEART T-LIGHT HOLDER	6	2026-08-01 08:26:00	2.55	17850	Sucursal_Asuncion	2026-08-27 23:00:04.361827
2	536365	71053	WHITE METAL LANTERN	6	2026-08-01 08:26:00	3.39	17850	Sucursal_ENC	2026-08-27 23:00:06.376719
3	536366	22633	HAND WARMER UNION JACK	6	2026-08-01 08:28:00	1.85	17850	Sucursal_ENC	2026-08-27 23:00:08.3894
4	C536379	D	Discount	-1	2026-08-01 09:41:00	27.50	14527	Sucursal_ENC	2026-08-27 23:00:10.401257
5	536381	22411	JUMBO BAG TOYS	10	2026-08-01 09:44:00	1.95	15311	Sucursal_Asuncion	2026-08-27 23:00:12.41411
6	536382	22370	TRIANGLE PLAYING CARDS	12	2026-08-01 09:45:00	2.95	15311	Sucursal_COV	2026-08-27 23:00:14.425798
\.


--
-- Name: ventas_locales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ucom_admin
--

SELECT pg_catalog.setval('public.ventas_locales_id_seq', 6, true);


--
-- Name: ventas_locales ventas_locales_pkey; Type: CONSTRAINT; Schema: public; Owner: ucom_admin
--

ALTER TABLE ONLY public.ventas_locales
    ADD CONSTRAINT ventas_locales_pkey PRIMARY KEY (id);


--
-- Name: idx_ventas_locales_sucursal; Type: INDEX; Schema: public; Owner: ucom_admin
--

CREATE INDEX idx_ventas_locales_sucursal ON public.ventas_locales USING btree (sucursal);


--
-- PostgreSQL database dump complete
--

\unrestrict nLRZYiF6mk9218cSajLu2gJRrVvRG0w6svqeOcz4M12b6x5XpiubDpwgZAbzFD5

