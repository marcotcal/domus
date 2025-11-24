--
-- PostgreSQL database dump
--

-- Dumped from database version 15.9 ( 15.9-0+deb12u1)
-- Dumped by pg_dump version 15.9 ( 15.9-0+deb12u1)

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

--
-- Name: area; Type: SCHEMA; Schema: -; Owner: marcotc
--

CREATE SCHEMA area;


ALTER SCHEMA area OWNER TO marcotc;

--
-- Name: relay_blocks; Type: SCHEMA; Schema: -; Owner: marcotc
--

CREATE SCHEMA relay_blocks;


ALTER SCHEMA relay_blocks OWNER TO marcotc;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: house_room; Type: TABLE; Schema: area; Owner: marcotc
--

CREATE TABLE area.house_room (
    code character varying(15) NOT NULL,
    description character varying(100) NOT NULL
);


ALTER TABLE area.house_room OWNER TO marcotc;

--
-- Name: light; Type: TABLE; Schema: area; Owner: marcotc
--

CREATE TABLE area.light (
    code character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    payload_on character varying(20) DEFAULT 'on'::character varying NOT NULL,
    payload_off character varying(20) DEFAULT 'off'::character varying NOT NULL,
    command_topic character varying(100),
    state_topic character varying(100),
    code_house_room character varying(15)
);


ALTER TABLE area.light OWNER TO marcotc;

--
-- Name: light_relay; Type: TABLE; Schema: area; Owner: marcotc
--

CREATE TABLE area.light_relay (
    code_light character varying(20) NOT NULL,
    code_relay character varying(20) NOT NULL
);


ALTER TABLE area.light_relay OWNER TO marcotc;

--
-- Name: outlet; Type: TABLE; Schema: area; Owner: marcotc
--

CREATE TABLE area.outlet (
    code character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    payload_on character varying(20) DEFAULT 'on'::character varying NOT NULL,
    payload_off character varying(20) DEFAULT 'off'::character varying NOT NULL,
    command_topic character varying(100),
    state_topic character varying(100),
    code_house_room character varying(15)
);


ALTER TABLE area.outlet OWNER TO marcotc;

--
-- Name: outlet_relay; Type: TABLE; Schema: area; Owner: marcotc
--

CREATE TABLE area.outlet_relay (
    code_outlet character varying(20) NOT NULL,
    code_relay character varying(20) NOT NULL
);


ALTER TABLE area.outlet_relay OWNER TO marcotc;

--
-- Name: switch; Type: TABLE; Schema: area; Owner: marcotc
--

CREATE TABLE area.switch (
    code character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    payload_on character varying(20) DEFAULT 'on'::character varying NOT NULL,
    payload_off character varying(20) DEFAULT 'off'::character varying NOT NULL,
    command_topic character varying(100),
    state_topic character varying(100),
    code_house_room character varying(15)
);


ALTER TABLE area.switch OWNER TO marcotc;

--
-- Name: switch_light; Type: TABLE; Schema: area; Owner: marcotc
--

CREATE TABLE area.switch_light (
    code_switch character varying(20) NOT NULL,
    code_light character varying(20) NOT NULL
);


ALTER TABLE area.switch_light OWNER TO marcotc;

--
-- Name: relay; Type: TABLE; Schema: relay_blocks; Owner: marcotc
--

CREATE TABLE relay_blocks.relay (
    code character varying(20) NOT NULL,
    relay_number smallint NOT NULL,
    is_outlet boolean DEFAULT false NOT NULL,
    is_normally_closed boolean DEFAULT false NOT NULL,
    description character varying(100) NOT NULL,
    code_relay_block character varying(15),
    payload_on character varying(20) DEFAULT 'on'::character varying NOT NULL,
    payload_off character varying(20) DEFAULT 'off'::character varying NOT NULL,
    command_topic character varying(100),
    state_topic character varying(100)
);


ALTER TABLE relay_blocks.relay OWNER TO marcotc;

--
-- Name: devices_relays_view; Type: VIEW; Schema: relay_blocks; Owner: marcotc
--

CREATE VIEW relay_blocks.devices_relays_view AS
 SELECT l.code_light AS device,
    l.code_relay,
    r.relay_number,
    r.is_outlet,
    r.is_normally_closed,
    r.description,
    r.code_relay_block,
    r.payload_on,
    r.payload_off,
    r.command_topic,
    r.state_topic
   FROM (area.light_relay l
     JOIN relay_blocks.relay r ON (((r.code)::text = (l.code_relay)::text)))
UNION
 SELECT o.code_outlet AS device,
    o.code_relay,
    r.relay_number,
    r.is_outlet,
    r.is_normally_closed,
    r.description,
    r.code_relay_block,
    r.payload_on,
    r.payload_off,
    r.command_topic,
    r.state_topic
   FROM (area.outlet_relay o
     JOIN relay_blocks.relay r ON (((r.code)::text = (o.code_relay)::text)));


ALTER TABLE relay_blocks.devices_relays_view OWNER TO marcotc;

--
-- Name: junction_box; Type: TABLE; Schema: relay_blocks; Owner: marcotc
--

CREATE TABLE relay_blocks.junction_box (
    code character varying(15) NOT NULL,
    description character varying(100) NOT NULL,
    code_house_room character varying(15)
);


ALTER TABLE relay_blocks.junction_box OWNER TO marcotc;

--
-- Name: relay_block; Type: TABLE; Schema: relay_blocks; Owner: marcotc
--

CREATE TABLE relay_blocks.relay_block (
    code character varying(15) NOT NULL,
    description character varying(100) NOT NULL,
    code_junction_box character varying(15),
    number_of_relays smallint DEFAULT 0 NOT NULL
);


ALTER TABLE relay_blocks.relay_block OWNER TO marcotc;

--
-- Name: switch_light_view; Type: VIEW; Schema: relay_blocks; Owner: marcotc
--

CREATE VIEW relay_blocks.switch_light_view AS
 SELECT sl.code_switch,
    sl.code_light,
    l.description,
    l.payload_on,
    l.payload_off,
    l.command_topic,
    l.state_topic,
    l.code_house_room
   FROM (area.switch_light sl
     JOIN area.light l ON (((l.code)::text = (sl.code_light)::text)));


ALTER TABLE relay_blocks.switch_light_view OWNER TO marcotc;

--
-- Data for Name: house_room; Type: TABLE DATA; Schema: area; Owner: marcotc
--

COPY area.house_room (code, description) FROM stdin;
ROOM01	Hall de Entrada
ROOM02	Sala de Estar
ROOM03	Cozinha
ROOM04	Dispensa
ROOM05	Área de Serviço
ROOM06	Corredor
ROOM07	Quarto da Frente
ROOM08	Casa de Banho Social
ROOM09	Quarto Suite
ROOM10	Casa de Banho Suite
\.


--
-- Data for Name: light; Type: TABLE DATA; Schema: area; Owner: marcotc
--

COPY area.light (code, description, payload_on, payload_off, command_topic, state_topic, code_house_room) FROM stdin;
light_001	Luz principal da sala	on	off	lights/light001	lights/state_light001	ROOM02
light_002	Luz da mesa de jantar	on	off	lights/light002	lights/state_light002	ROOM02
light_003	Spots da sala	on	off	lights/light003	lights/state_light003	ROOM02
light_004	Luz principal da cozinha	on	off	lights/light004	lights/state_light004	ROOM03
light_005	Luz da mesa e pia da cozinha	on	off	lights/light005	lights/state_light005	ROOM03
light_006	Luz da dispensa	on	off	lights/light006	lights/state_light006	ROOM04
light_007	Luz da área de serviço	on	off	lights/light007	lights/state_light007	ROOM05
light_008	Luzes do corredor	on	off	lights/light008	lights/state_light008	ROOM06
light_009	Luz do quarto da frente	on	off	lights/light009	lights/state_light009	ROOM07
light_010	Luz do banho social	on	off	lights/light010	lights/state_light010	ROOM08
light_011	Luz do espelho do banho social	on	off	lights/light011	lights/state_light011	ROOM08
light_012	Luz da área da cama suite	on	off	lights/light012	lights/state_light012	ROOM09
light_013	Luz da área da janela suite	on	off	lights/light013	lights/state_light013	ROOM09
light_014	Luz da cama lado direito	on	off	lights/light014	lights/state_light014	ROOM09
light_015	Luz da cama lado esquerdo	on	off	lights/light015	lights/state_light015	ROOM09
light_016	Luz da casa de banho da suite	on	off	lights/light016	lights/state_light016	ROOM10
light_017	Luz do espelho casa de banho da suite	on	off	lights/light017	lights/state_light017	ROOM10
light_018	Luz do Hall de Entrada	on	off	lights/light018	lights/state_light018	ROOM01
\.


--
-- Data for Name: light_relay; Type: TABLE DATA; Schema: area; Owner: marcotc
--

COPY area.light_relay (code_light, code_relay) FROM stdin;
light_001	relay_block_01_01
light_002	relay_block_01_02
light_003	relay_block_01_03
\.


--
-- Data for Name: outlet; Type: TABLE DATA; Schema: area; Owner: marcotc
--

COPY area.outlet (code, description, payload_on, payload_off, command_topic, state_topic, code_house_room) FROM stdin;
outlet001	Hall - Tomada Lateral	on	off	outlet001/outlet	outlet001/state_outlet	ROOM01
outlet002	Sala - Tomada da parede do hall	on	off	outlet002/outlet	outlet002/state_outlet	ROOM02
outlet003	Sala - Tomadas parede lateral e frente	on	off	outlet003/outlet	outlet003/state_outlet	ROOM02
outlet004	Sala - Tomada parede lareira	on	off	outlet004/outlet	outlet004/state_outlet	ROOM02
outlet005	Sala - Tomada lareira	on	off	outlet005/outlet	outlet005/state_outlet	ROOM02
outlet006	Sala - Tomada TV	on	off	outlet006/outlet	outlet006/state_outlet	ROOM02
outlet008	Hall - Tomanda parede sala	on	off	outlet008/outlet	outlet008/state_outlet	ROOM06
\.


--
-- Data for Name: outlet_relay; Type: TABLE DATA; Schema: area; Owner: marcotc
--

COPY area.outlet_relay (code_outlet, code_relay) FROM stdin;
outlet002	relay_block_01_04
outlet003	relay_block_01_05
outlet004	relay_block_01_06
outlet005	relay_block_01_07
outlet006	relay_block_01_08
\.


--
-- Data for Name: switch; Type: TABLE DATA; Schema: area; Owner: marcotc
--

COPY area.switch (code, description, payload_on, payload_off, command_topic, state_topic, code_house_room) FROM stdin;
switch002_A	Interruptor do Hall - 4 Botões	on	off	switch002/switchA	switch002/switch_statusA	ROOM01
switch002_B	Interruptor do Hall - 4 Botões	on	off	switch002/switchB	switch002/switch_statusB	ROOM01
switch002_C	Interruptor do Hall - 4 Botões	on	off	switch002/switchC	switch002/switch_statusC	ROOM01
switch002_D	Interruptor do Hall - 4 Botões	on	off	switch002/switchD	switch002/switch_statusD	ROOM01
switch003_A	Interruptor da Entrada da Sala - 4 Botões	on	off	switch003/switchA	switch003/switch_statusA	ROOM02
switch003_B	Interruptor da Entrada da Sala - 4 Botões	on	off	switch003/switchB	switch003/switch_statusB	ROOM02
switch003_C	Interruptor da Entrada da Sala - 4 Botões	on	off	switch003/switchC	switch003/switch_statusC	ROOM02
switch003_D	Interruptor da Entrada da Sala - 4 Botões	on	off	switch003/switchD	switch003/switch_statusD	ROOM02
switch006_A	Interruptor Cozinha Parede da Dispensa - 2 Botões	on	off	switch006/switchA	switch006/switch_statusA	ROOM03
switch006_B	Interruptor Cozinha Parede da Dispensa - 2 Botões	on	off	switch006/switchB	switch006/switch_statusB	ROOM03
switch007_A	Interruptor Cozinha Porta da Dispensa - 1 Botão	on	off	switch007/switchA	switch007/switch_statusA	ROOM03
switch008_A	Interruptor Cozinha Parede da Área - 2 Botões	on	off	switch008/switchA	switch008/switch_statusA	ROOM03
switch008_B	Interruptor Cozinha Parede da Área - 2 Botões	on	off	switch008/switchB	switch008/switch_statusB	ROOM03
switch005_A	Interruptor da Porta Janela Lateral Sala - 1 Botão	on	off	switch005/switchA	switch005/switch_statusA	ROOM02
switch004_A	Interruptor da Porta Janela da Frente Sala - 1 Botão	on	off	switch004/switchA	switch004/switch_statusA	ROOM02
switch001_A	Interruptor do Quarto da Frente	on	off	switch001/switchA	switch001/switch_statusA	ROOM07
\.


--
-- Data for Name: switch_light; Type: TABLE DATA; Schema: area; Owner: marcotc
--

COPY area.switch_light (code_switch, code_light) FROM stdin;
switch003_A	light_001
switch003_B	light_002
switch003_C	light_003
switch003_D	light_004
switch004_A	light_001
switch005_A	light_001
switch002_A	light_018
\.


--
-- Data for Name: junction_box; Type: TABLE DATA; Schema: relay_blocks; Owner: marcotc
--

COPY relay_blocks.junction_box (code, description, code_house_room) FROM stdin;
BOX001	Caixa de derivação direita da sala	ROOM02
BOX002	Caixa de derivação esquerda da sala	ROOM02
BOX003	Caixa de derivação da cozinha	ROOM03
BOX004	Caixa de derivação superior dispensa	ROOM04
BOX005	Caixa de derivação inferior dispensa	ROOM04
\.


--
-- Data for Name: relay; Type: TABLE DATA; Schema: relay_blocks; Owner: marcotc
--

COPY relay_blocks.relay (code, relay_number, is_outlet, is_normally_closed, description, code_relay_block, payload_on, payload_off, command_topic, state_topic) FROM stdin;
relay_block_02_01	1	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay1	relay_block_02/status_relay1
relay_block_02_02	2	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay2	relay_block_02/status_relay2
relay_block_02_03	3	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay3	relay_block_02/status_relay3
relay_block_02_04	4	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay4	relay_block_02/status_relay4
relay_block_02_07	7	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay7	relay_block_02/status_relay7
relay_block_02_05	5	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay5	relay_block_02/status_relay5
relay_block_02_08	8	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay8	relay_block_02/status_relay8
relay_block_01_08	8	f	f	Tomada da lareira	relay_block_01	on	off	relay_block_01/set_relay8	relay_block_01/status_relay8
relay_block_01_01	1	f	f	Luz principal da sala	relay_block_01	on	off	relay_block_01/set_relay1	relay_block_01/status_relay1
relay_block_01_02	2	f	f	Luz mesa de jantar	relay_block_01	on	off	relay_block_01/set_relay2	relay_block_01/status_relay2
relay_block_01_03	3	f	f	Spots da sala	relay_block_01	on	off	relay_block_01/set_relay3	relay_block_01/status_relay3
relay_block_01_04	4	t	f	Tomadas lateral e frente	relay_block_01	on	off	relay_block_01/set_relay4	relay_block_01/status_relay4
relay_block_01_05	5	t	f	Tomada lateral lareira	relay_block_01	on	off	relay_block_01/set_relay5	relay_block_01/status_relay5
relay_block_01_07	7	t	f	Tomada da TV	relay_block_01	on	off	relay_block_01/set_relay7	relay_block_01/status_relay7
relay_block_01_06	6	t	f	Tomadas da parede do hall	relay_block_01	on	off	relay_block_01/set_relay6	relay_block_01/status_relay6
relay_block_02_06	6	f	f	Vazio	relay_block_02	on	off	relay_block_02/set_relay6	relay_block_02/status_relay6
\.


--
-- Data for Name: relay_block; Type: TABLE DATA; Schema: relay_blocks; Owner: marcotc
--

COPY relay_blocks.relay_block (code, description, code_junction_box, number_of_relays) FROM stdin;
relay_block_01	Bloco de Relés da Caixa esquerda	BOX002	8
relay_block_02	Bloco de Relés da Caixa direita	BOX001	8
\.


--
-- Name: house_room house_room_pk; Type: CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.house_room
    ADD CONSTRAINT house_room_pk PRIMARY KEY (code);


--
-- Name: light light_pk; Type: CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.light
    ADD CONSTRAINT light_pk PRIMARY KEY (code);


--
-- Name: light_relay light_relay_pk; Type: CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.light_relay
    ADD CONSTRAINT light_relay_pk PRIMARY KEY (code_light, code_relay);


--
-- Name: outlet outlet_pk; Type: CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.outlet
    ADD CONSTRAINT outlet_pk PRIMARY KEY (code);


--
-- Name: outlet_relay outlet_relay_pk; Type: CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.outlet_relay
    ADD CONSTRAINT outlet_relay_pk PRIMARY KEY (code_outlet, code_relay);


--
-- Name: switch_light switch_light_pk; Type: CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.switch_light
    ADD CONSTRAINT switch_light_pk PRIMARY KEY (code_switch, code_light);


--
-- Name: switch switch_pk; Type: CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.switch
    ADD CONSTRAINT switch_pk PRIMARY KEY (code);


--
-- Name: junction_box junction_box_pk; Type: CONSTRAINT; Schema: relay_blocks; Owner: marcotc
--

ALTER TABLE ONLY relay_blocks.junction_box
    ADD CONSTRAINT junction_box_pk PRIMARY KEY (code);


--
-- Name: relay_block relay_block_pk; Type: CONSTRAINT; Schema: relay_blocks; Owner: marcotc
--

ALTER TABLE ONLY relay_blocks.relay_block
    ADD CONSTRAINT relay_block_pk PRIMARY KEY (code);


--
-- Name: relay relay_pk; Type: CONSTRAINT; Schema: relay_blocks; Owner: marcotc
--

ALTER TABLE ONLY relay_blocks.relay
    ADD CONSTRAINT relay_pk PRIMARY KEY (code);


--
-- Name: light house_room_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.light
    ADD CONSTRAINT house_room_fk FOREIGN KEY (code_house_room) REFERENCES area.house_room(code) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: outlet house_room_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.outlet
    ADD CONSTRAINT house_room_fk FOREIGN KEY (code_house_room) REFERENCES area.house_room(code) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: switch house_room_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.switch
    ADD CONSTRAINT house_room_fk FOREIGN KEY (code_house_room) REFERENCES area.house_room(code) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: light house_room_fk_cp; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.light
    ADD CONSTRAINT house_room_fk_cp FOREIGN KEY (code_house_room) REFERENCES area.house_room(code) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: light_relay light_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.light_relay
    ADD CONSTRAINT light_fk FOREIGN KEY (code_light) REFERENCES area.light(code) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: switch_light light_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.switch_light
    ADD CONSTRAINT light_fk FOREIGN KEY (code_light) REFERENCES area.light(code) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: outlet_relay outlet_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.outlet_relay
    ADD CONSTRAINT outlet_fk FOREIGN KEY (code_outlet) REFERENCES area.outlet(code) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: light_relay relay_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.light_relay
    ADD CONSTRAINT relay_fk FOREIGN KEY (code_relay) REFERENCES relay_blocks.relay(code) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: outlet_relay relay_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.outlet_relay
    ADD CONSTRAINT relay_fk FOREIGN KEY (code_relay) REFERENCES relay_blocks.relay(code) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: switch_light switch_fk; Type: FK CONSTRAINT; Schema: area; Owner: marcotc
--

ALTER TABLE ONLY area.switch_light
    ADD CONSTRAINT switch_fk FOREIGN KEY (code_switch) REFERENCES area.switch(code) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: junction_box house_room_fk; Type: FK CONSTRAINT; Schema: relay_blocks; Owner: marcotc
--

ALTER TABLE ONLY relay_blocks.junction_box
    ADD CONSTRAINT house_room_fk FOREIGN KEY (code_house_room) REFERENCES area.house_room(code) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: relay_block junction_box_fk; Type: FK CONSTRAINT; Schema: relay_blocks; Owner: marcotc
--

ALTER TABLE ONLY relay_blocks.relay_block
    ADD CONSTRAINT junction_box_fk FOREIGN KEY (code_junction_box) REFERENCES relay_blocks.junction_box(code) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: relay relay_block_fk; Type: FK CONSTRAINT; Schema: relay_blocks; Owner: marcotc
--

ALTER TABLE ONLY relay_blocks.relay
    ADD CONSTRAINT relay_block_fk FOREIGN KEY (code_relay_block) REFERENCES relay_blocks.relay_block(code) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

