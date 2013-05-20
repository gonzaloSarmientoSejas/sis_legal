/***********************************I-DAT-GSS-LEGAL-0-17/05/2013*****************************************/

INSERT INTO segu.tsubsistema ("id_subsistema", "codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta", "id_subsis_orig")
VALUES (12, E'SAJ', E'Sistema Legal', E'2013-05-16', E'LEGAL', E'activo', E'legal', NULL);

----------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select pxp.f_insert_tgui ('SISTEMA LEGAL', '', 'LEGAL', 'si', NULL, '', 1, '', '', 'LEGAL');
select pxp.f_insert_tgui ('Parametros', 'Parametros', 'LEGPAR', 'si', 1, '', 2, '', '', 'LEGAL');
select pxp.f_insert_tgui ('Procesos', '', 'LEGPR', 'si', 2, '', 2, '', '', 'LEGAL');
select pxp.f_insert_tgui ('Responsables de Proceso', 'Responsables de Proceso', 'RESPRO', 'si', 8, 'sis_legal/vista/responsable_proceso/ResponsableProceso.php', 3, '', 'ResponsableProceso', 'LEGAL');
select pxp.f_insert_tgui ('Definicion de Modalidades', 'Modalidades de Contratacion', 'MODALI', 'si', 9, 'sis_legal/vista/modalidad/Modalidad.php', 3, '', 'modalidad', 'LEGAL');
select pxp.f_insert_tgui ('Estados', 'Definicion de los estados de los documentos', 'ESTAD', 'si', 10, 'sis_legal/vista/estado/Estado.php', 3, '', 'Estado', 'LEGAL');
select pxp.f_insert_tgui ('Definicion Tipo Contrato', 'Definicion Tipo Contrato', 'TIPCON', 'si', 15, 'sis_legal/vista/tipo_contrato/TipoContrato.php', 3, '', 'tipo_contrato', 'LEGAL');
select pxp.f_insert_tgui ('Elaboracion de Requerimiento', 'SeguimiElaboracion de Requerimiento de Documento', 'CONTRA', 'si', 1, 'sis_legal/vista/proceso_contrato/ProcesoRequerimiento.php', 3, '', 'ProcesoRequerimiento', 'LEGAL');
select pxp.f_insert_tgui ('Procesos Pendientes', 'Procesos Pendientes para elaboracion', 'PROPEN', 'si', 2, 'sis_legal/vista/proceso_contrato/ProcesoParaAsignacion.php', 3, '', 'ProcesoParaAsignacion', 'LEGAL');
select pxp.f_insert_tgui ('Elaboración de Contratos', 'Elaboración de Contratos', 'SA_ELAPRO', 'si', 3, 'sis_legal/vista/proceso_contrato/ProcesoParaElaboracion.php', 3, '', 'ProcesoParaElaboracion', 'LEGAL');
select pxp.f_insert_tgui ('Contratos Vigentes', 'Contratos actualmente vigentes', 'CONVIG', 'si', 5, 'sis_legal/vista/proceso_contrato/ProcesoVigente.php', 3, '', 'ProcesoVigente', 'LEGAL');
select pxp.f_insert_tgui ('Contratos Concluidos', 'Contratos Concluidos', 'CONCLU', 'si', 6, 'sis_legal/vista/proceso_contrato/ProcesoConcluido.php', 3, '', 'ProcesoConcluido', 'LEGAL');
select pxp.f_insert_tgui ('Administracion de Boletas', 'Administracion de Boletas', 'ADMBOL', 'si', 8, 'sis_legal/vista/boleta/AdministracionBoleta.php', 3, '', 'AdministracionBoleta', 'LEGAL');
select pxp.f_insert_tgui ('Administrar Procesos', 'Permite administrar procesos en todos los estados', 'ADMPROC', 'si', 11, 'sis_legal/vista/proceso_contrato/ProcesoAdmin.php', 3, '', 'ProcesoAdmin', 'LEGAL');
select pxp.f_insert_tgui ('Búsqueda de Contratos', 'Búsqueda de Contratos', 'BC', 'si', 14, 'sis_legal/vista/proceso_contrato/ProcesoBusqueda.php', 3, '', 'ProcesoBusqueda', 'LEGAL');

select pxp.f_insert_testructura_gui ('LEGAL', 'SISTEMA');
select pxp.f_insert_testructura_gui ('LEGPAR', 'LEGAL');
select pxp.f_insert_testructura_gui ('LEGPR', 'LEGAL');
select pxp.f_insert_testructura_gui ('RESPRO', 'LEGPAR');
select pxp.f_insert_testructura_gui ('MODALI', 'LEGPAR');
select pxp.f_insert_testructura_gui ('ESTAD', 'LEGPAR');
select pxp.f_insert_testructura_gui ('TIPCON', 'LEGPAR');
select pxp.f_insert_testructura_gui ('CONTRA', 'LEGPR');
select pxp.f_insert_testructura_gui ('PROPEN', 'LEGPR');
select pxp.f_insert_testructura_gui ('SA_ELAPRO', 'LEGPR');
select pxp.f_insert_testructura_gui ('CONVIG', 'LEGPR');
select pxp.f_insert_testructura_gui ('CONCLU', 'LEGPR');
select pxp.f_insert_testructura_gui ('ADMBOL', 'LEGPR');
select pxp.f_insert_testructura_gui ('ADMPROC', 'LEGPR');
select pxp.f_insert_testructura_gui ('BC', 'LEGPR');


/***********************************F-DAT-GSS-LEGAL-0-17/05/2013*****************************************/