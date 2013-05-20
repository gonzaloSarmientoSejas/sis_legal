/***********************************I-SCP-GSS-LEGAL-0-17/05/2013****************************************/

--
-- Structure for table tboleta
--
CREATE TABLE saj.tboleta (
    id_boleta serial NOT NULL,
    id_proceso_contrato integer,
    id_moneda integer,
    id_institucion_banco integer,
    doc_garantia varchar,
    extension varchar,
    version integer DEFAULT 0 NOT NULL,
    tipo varchar,
    fecha_ini date,
    fecha_fin date,
    estado varchar,
    numero varchar(40),
    monto numeric(18,2),
    fecha_suscripcion date,
    fecha_vencimiento date,
    observaciones varchar,
    orden integer,
    id_alarma integer[],
    id_boleta_fk integer,
    "aA" bigint,
    CONSTRAINT pk_tboleta__id_boleta PRIMARY KEY(id_boleta) 
) INHERITS (pxp.tbase)
WITH OIDS;

ALTER TABLE ONLY saj.tboleta ALTER COLUMN id_moneda SET STATISTICS 0;

--
-- Structure for table tdocumento_anexo
--
CREATE TABLE saj.tdocumento_anexo (
    id_documento_anexo serial NOT NULL,
    id_proceso_contrato integer,
    CONSTRAINT pk_tdocumento_anexo__id_documento_anexo PRIMARY KEY(id_documento_anexo)
) INHERITS (pxp.tbase)
WITH OIDS;

ALTER TABLE ONLY saj.tdocumento_anexo ALTER COLUMN id_proceso_contrato SET STATISTICS 0;

--
-- Structure for table testado 
--
CREATE TABLE saj.testado (
    id_estado serial NOT NULL,
    codigo varchar(20) NOT NULL,
    nombre varchar(255) NOT NULL,
    orden integer NOT NULL,
    dias numeric(18,2),
    admite_boleta varchar(2),
    admite_anexo varchar(2),
    CONSTRAINT pk_testado__id_estado PRIMARY KEY(id_estado),    
    CONSTRAINT uq_testado__codigo UNIQUE(codigo), 
    CONSTRAINT uq_testado__nombre UNIQUE(nombre), 
    CONSTRAINT uq_testado__orden UNIQUE(orden)
) INHERITS (pxp.tbase)
WITH OIDS;


--
-- Structure for table testado_proceso
--
CREATE TABLE saj.testado_proceso (
    id_estado_proceso serial NOT NULL,
    id_proceso_contrato integer,
    observaciones varchar,
    fecha_ini date DEFAULT now(),
    id_responsable_proceso integer,
    fecha_fin date,
    estado_vigente varchar(30),
    estado_anterior varchar(30),
    hora time(0) without time zone DEFAULT now() NOT NULL,
    CONSTRAINT pk_testado_proceso__id_estado_proceso PRIMARY KEY(id_estado_proceso)
) INHERITS (pxp.tbase)
WITH OIDS;

--
-- Structure for table ttipo_contrato 
--
CREATE TABLE saj.ttipo_contrato (
    id_tipo_contrato serial NOT NULL,
    nombre varchar,
    CONSTRAINT pk_ttipo_contrato__id_tipo_contrato PRIMARY KEY(id_tipo_contrato)
) INHERITS (pxp.tbase)
WITH OIDS;

ALTER TABLE ONLY saj.ttipo_contrato ALTER COLUMN id_tipo_contrato SET STATISTICS 0;

--
-- Structure for table tmodalidad
--
CREATE TABLE saj.tmodalidad (
    id_modalidad serial NOT NULL,
    nombre varchar,
    CONSTRAINT pk_tmodalidad__id_modalidad PRIMARY KEY(id_modalidad)
) INHERITS (pxp.tbase)
WITH OIDS;

--
-- Structure for table tproceso_contrato
--
CREATE TABLE saj.tproceso_contrato (
    id_proceso_contrato serial NOT NULL,
    id_funcionario integer,
    id_uo integer,
    id_proyecto integer,
    id_modalidad integer,
    id_proveedor integer,
    id_rpc integer,
    id_supervisor integer,
    id_representante_legal integer,
    id_moneda integer,
    id_gestion integer,
    id_depto integer,
    id_lugar_suscripcion integer,
    id_tipo_contrato integer,
    doc_contrato varchar(500),
    extension varchar(100),
    version integer DEFAULT 0 NOT NULL,
    numero_contrato varchar,
    numero_cuce varchar(300),
    numero_licitacion varchar,
    numero_oc varchar(50),
    id_oc integer,
    beneficiario varchar,
    fecha_ini date,
    fecha_fin date,
    fecha_suscripcion date,
    objeto_contrato varchar,
    numero_requerimiento varchar,
    multas varchar,
    plazo varchar,
    testimonio varchar,
    fecha_testimonio date,
    origen_recursos varchar,
    forma_pago varchar,
    notario varchar,
    fecha_convocatoria date,
    fecha_aprobacion date,
    fecha_ap_acta date,
    observaciones varchar,
    estado_proceso varchar(30),
    monto_contrato numeric(18,2),
    id_alarma integer[],
    CONSTRAINT pk_tproceso_contrato__id_proceso_contrato PRIMARY KEY(id_proceso_contrato)
) INHERITS (pxp.tbase)
WITH OIDS;

ALTER TABLE ONLY saj.tproceso_contrato ALTER COLUMN id_funcionario SET STATISTICS 0;

--
-- Structure for table tresponsable_proceso
--
CREATE TABLE saj.tresponsable_proceso (
    id_responsable_proceso serial NOT NULL,
    tipo varchar(30),
    id_funcionario integer,
    id_responsable_proceso_anterior integer,
    CONSTRAINT pk_tresponsable_proceso__id_responsable_proceso PRIMARY KEY(id_responsable_proceso)
) INHERITS (pxp.tbase)
WITH OIDS;

--
-- Comments
--

COMMENT ON COLUMN saj.tproceso_contrato.doc_contrato IS 'ruta url del archivo';

/***********************************F-SCP-GSS-LEGAL-0-17/05/2013****************************************/
