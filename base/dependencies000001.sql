/********************************************I-DEP-GSS-LEGAL-0-16/05/2013********************************************/

--
-- Definition for index fk_testado_proceso__id_proceso_contrato
--

ALTER TABLE saj.testado_proceso
  ADD CONSTRAINT fk_testado_proceso__id_proceso_contrato FOREIGN KEY (id_proceso_contrato)
    REFERENCES saj.tproceso_contrato(id_proceso_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tproceso_contrato__id_funcionario
--
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tproceso_contrato__id_gestion
--
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tproceso_contrato__id_modalidad
--

ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_modalidad FOREIGN KEY (id_modalidad)
    REFERENCES saj.tmodalidad(id_modalidad)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
--
-- Definition for index fk_tproceso_contrato__id_moneda
--
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tproceso_contrato__id_proveedor
--
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_proveedor FOREIGN KEY (id_proveedor)
    REFERENCES param.tproveedor(id_proveedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tproceso_contrato__id_proveedor
--   
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES param.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tproceso_contrato__id_representante_legal
--     

ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_representante_legal FOREIGN KEY (id_representante_legal)
    REFERENCES saj.tresponsable_proceso(id_responsable_proceso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
--
-- Definition for index fk_tproceso_contrato__id_rpc
--
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_rpc FOREIGN KEY (id_rpc)
    REFERENCES saj.tresponsable_proceso(id_responsable_proceso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tproceso_contrato__id_supervisor
--
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_supervisor FOREIGN KEY (id_supervisor)
    REFERENCES saj.tresponsable_proceso(id_responsable_proceso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tproceso_contrato__id_tipo_contrato
--

ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_tipo_contrato FOREIGN KEY (id_tipo_contrato)
    REFERENCES saj.ttipo_contrato(id_tipo_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tproceso_contrato__id_uo
--    
    
ALTER TABLE saj.tproceso_contrato
  ADD CONSTRAINT fk_tproceso_contrato__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tresponsable_proceso__id_funcionario
--  

ALTER TABLE saj.tresponsable_proceso
  ADD CONSTRAINT fk_tresponsable_proceso__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tresponsable_proceso__id_responsable_proceso_anterior
--  

ALTER TABLE saj.tresponsable_proceso
  ADD CONSTRAINT fk_tresponsable_proceso__id_responsable_proceso_anterior FOREIGN KEY (id_responsable_proceso_anterior)
    REFERENCES saj.tresponsable_proceso(id_responsable_proceso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tboleta__id_institucion_banco
--   
   
ALTER TABLE saj.tboleta
  ADD CONSTRAINT fk_tboleta__id_institucion_banco FOREIGN KEY (id_institucion_banco)
    REFERENCES param.tinstitucion(id_institucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tboleta__id_moneda
-- 

ALTER TABLE saj.tboleta
  ADD CONSTRAINT fk_tboleta__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tboleta__id_proceso_contrato
-- 
    
ALTER TABLE saj.tboleta
  ADD CONSTRAINT fk_tboleta__id_proceso_contrato FOREIGN KEY (id_proceso_contrato)
    REFERENCES saj.tproceso_contrato(id_proceso_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tboleta__id_boleta_fk
--
   
ALTER TABLE saj.tboleta
  ADD CONSTRAINT fk_tboleta__id_boleta_fk FOREIGN KEY (id_boleta_fk)
    REFERENCES saj.tboleta(id_boleta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_testado_proceso__estado_anterior
--

ALTER TABLE saj.testado_proceso
  ADD CONSTRAINT fk_testado_proceso__estado_anterior FOREIGN KEY (estado_anterior)
    REFERENCES saj.testado(codigo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_testado_proceso__estado_vigente
--

ALTER TABLE saj.testado_proceso
  ADD CONSTRAINT fk_testado_proceso__estado_vigente FOREIGN KEY (estado_vigente)
    REFERENCES saj.testado(codigo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_testado_proceso__id_responsable_proceso
--
    
ALTER TABLE saj.testado_proceso
  ADD CONSTRAINT fk_testado_proceso__id_responsable_proceso FOREIGN KEY (id_responsable_proceso)
    REFERENCES saj.tresponsable_proceso(id_responsable_proceso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for view vresponsable_proceso
--

CREATE VIEW saj.vresponsable_proceso AS
SELECT respro.id_responsable_proceso, respro.tipo, respro.id_funcionario,
    person.nombre_completo1 AS desc_responsable_proceso
FROM ((saj.tresponsable_proceso respro JOIN orga.tfuncionario funcio ON
    ((funcio.id_funcionario = respro.id_funcionario))) JOIN segu.vpersona
    person ON ((person.id_persona = funcio.id_persona)));
    
/********************************************F-DEP-GSS-LEGAL-0-16/05/2013********************************************/

/********************************************I-DEP-GSS-LEGAL-1-16/05/2013********************************************/

--
-- Definition for index fk_tcontratista__id_persona
--

ALTER TABLE legal.tcontratista
  ADD CONSTRAINT fk_tcontratista__id_persona FOREIGN KEY (id_persona)
    REFERENCES segu.tpersona(id_persona)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tcontratista__id_persona_juridica
--  
    
ALTER TABLE legal.tcontratista
  ADD CONSTRAINT fk_tcontratista__id_persona_juridica FOREIGN KEY (id_persona_juridica)
    REFERENCES legal.tpersona_juridica(id_persona_juridica)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tcontrato__id_representante
--
    
ALTER TABLE legal.tcontrato
  ADD CONSTRAINT fk_tcontrato__id_representante FOREIGN KEY (id_representante)
    REFERENCES legal.trepresentante(id_representante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tcontrato__id_funcionario_responsable
--
    
ALTER TABLE legal.tcontrato
  ADD CONSTRAINT fk_tcontrato__id_funcionario_responsable FOREIGN KEY (id_funcionario_responsable)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tcontrato__id_proyecto
--
  
ALTER TABLE legal.tcontrato
  ADD CONSTRAINT fk_tcontrato__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES param.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    

--
-- Definition for index fk_tcontrato__id_requerimiento
--

ALTER TABLE legal.tcontrato
  ADD CONSTRAINT fk_tcontrato__id_requerimiento FOREIGN KEY (id_requerimiento)
    REFERENCES legal.trequerimiento(id_requerimiento)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for index fk_tcontrato__id_funcionario_abogado
--

ALTER TABLE legal.tcontrato
  ADD CONSTRAINT fk_tcontrato__id_funcionario_abogado FOREIGN KEY (id_funcionario_abogado)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tcorrespondencia__id_contrato
--

ALTER TABLE legal.tcorrespondencia
  ADD CONSTRAINT fk_tcorrespondencia__id_contrato FOREIGN KEY (id_contrato)
    REFERENCES legal.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tdoc_anexo__id_contrato
--

ALTER TABLE legal.tdoc_anexo
  ADD CONSTRAINT fk_tdoc_anexo__id_contrato FOREIGN KEY (id_contrato)
    REFERENCES legal.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_testado_requerimiento__id_estado
--
    
ALTER TABLE legal.testado_requerimiento
  ADD CONSTRAINT fk_testado_requerimiento__id_estado FOREIGN KEY (id_estado)
    REFERENCES legal.testado(id_estado)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_testado_requerimiento__id_requerimiento
--

ALTER TABLE legal.testado_requerimiento
  ADD CONSTRAINT fk_testado_requerimiento__id_requerimiento FOREIGN KEY (id_requerimiento)
    REFERENCES legal.trequerimiento(id_requerimiento)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tgarantia__id_contrato
--
    
ALTER TABLE legal.tgarantia
  ADD CONSTRAINT fk_tgarantia__id_contrato FOREIGN KEY (id_contrato)
    REFERENCES legal.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_tinforme__id_contrato
--    
    
ALTER TABLE legal.tinforme
  ADD CONSTRAINT fk_tinforme__id_contrato FOREIGN KEY (id_contrato)
    REFERENCES legal.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_talarma__id_proyecto
-- 
  
ALTER TABLE legal.talarma
  ADD CONSTRAINT fk_talarma__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES param.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 

--
-- Definition for index fk_toferta__id_contrato
-- 

ALTER TABLE legal.toferta
  ADD CONSTRAINT fk_toferta__id_contrato FOREIGN KEY (id_contrato)
    REFERENCES legal.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_trepresentante__id_contratista
-- 
    
ALTER TABLE legal.trepresentante
  ADD CONSTRAINT fk_trepresentante__id_contratista FOREIGN KEY (id_contratista)
    REFERENCES legal.tcontratista(id_contratista)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;   

--
-- Definition for index fk_trepresentante__id_persona
--  

ALTER TABLE legal.trepresentante
  ADD CONSTRAINT fk_trepresentante__id_persona FOREIGN KEY (id_persona)
    REFERENCES segu.tpersona(id_persona)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_trequerimiento__id_funcionario
-- 
    
ALTER TABLE legal.trequerimiento
  ADD CONSTRAINT fk_trequerimiento__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_trequerimiento__id_funcionario_solicitante
-- 
    
ALTER TABLE legal.trequerimiento
  ADD CONSTRAINT fk_trequerimiento__id_funcionario_solicitante FOREIGN KEY (id_funcionario_solicitante)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--
-- Definition for index fk_trequerimiento__id_funcionario_solicitante
-- 
   
ALTER TABLE legal.trequerimiento
  ADD CONSTRAINT fk_trequerimiento__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    

--
-- Definition for index fk_tresolucion__id_contrato
-- 

ALTER TABLE legal.tresolucion
  ADD CONSTRAINT fk_tresolucion__id_contrato FOREIGN KEY (id_contrato)
    REFERENCES legal.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--
-- Definition for view vcontratista
--
CREATE VIEW legal.vcontratista AS
SELECT c.id_contratista, c.id_persona_juridica, c.id_persona, c.nit,
    c.tipo, c.obs, c.estado_reg, (CASE WHEN (c.tipo =
    'Persona Natural'::text) THEN (p.nombre_completo1)::character varying
    ELSE pj.nombre END)::text AS nombre, pj.nombre AS nombre_institucion,
    p.nombre_completo1 AS nombre_persona
FROM ((legal.tcontratista c LEFT JOIN legal.tpersona_juridica pj ON
    ((pj.id_persona_juridica = c.id_persona_juridica))) LEFT JOIN
    segu.vpersona p ON ((c.id_persona = p.id_persona)));
    
--
-- Definition for view vestado_requerimiento
--
CREATE VIEW legal.vestado_requerimiento AS
SELECT er.id_estado_requerimiento, er.id_requerimiento, e.nombre_estado,
    er.fecha_ini, er.fecha_fin, er.observaciones, er.estado_reg
FROM (legal.testado_requerimiento er JOIN legal.testado e ON ((er.id_estado = e.id_estado)))
ORDER BY er.id_requerimiento, er.id_estado_requerimiento DESC;


--
-- Definition for view vrequerimiento (OID = 4903020) : 
--
CREATE VIEW legal.vrequerimiento AS
SELECT req.id_requerimiento, req.fecha_requerimiento, req.estado_reg,
    req.descripcion, req.num_contrato, abo.id_funcionario AS id_funcionario_abo,
    --abo.id_persona AS id_persona_abo, 
    abo.desc_funcionario1 AS nombre_completo_abo, sol.id_funcionario AS id_personal_sol,
     --sol.id_persona AS id_persona_sol,
      sol.desc_funcionario1 AS nombre_completo_sol,
    uni.id_uo, uni.nombre_unidad, er.fecha_ini, er.id_estado,
    e.nombre_estado, e.orden, er.observaciones, req.nro_requerimiento
FROM (((((legal.trequerimiento req JOIN orga.vfuncionario sol ON ((sol.id_funcionario =
    req.id_funcionario))) LEFT JOIN orga.vfuncionario abo ON ((abo.id_funcionario =
    req.id_funcionario))) JOIN orga.tuo uni ON ((uni.id_uo =
    req.id_uo))) JOIN legal.testado_requerimiento er ON (((er.id_requerimiento
    = req.id_requerimiento) AND ((er.estado_reg)::text = 'activo'::text))))
    JOIN legal.testado e ON ((e.id_estado = er.id_estado)));
   
/********************************************F-DEP-GSS-LEGAL-1-16/05/2013********************************************/