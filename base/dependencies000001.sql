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
