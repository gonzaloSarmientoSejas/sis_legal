CREATE OR REPLACE FUNCTION saj.f_verifica_alarma (
  p_id_usuario integer
)
RETURNS varchar
AS 
$body$
/**************************************************************************
 FUNCION: 		f_verifica_alarma
 DESCRIPCION:   Verifica las alarmas correspondientes al subsistema enviado desde el control si no existe la alarma la inserta,
                para los casos que se tengan alarmas con tiempo de vencimiento
 
 AUTOR: 	    Fernando Prudencio Cardona
 FECHA:	        
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES  
 DESCRIPCION:  TErmino la funcion que quedo a medias
 AUTOR:		Rensi Artega Copari
 FECHA:		14/01/2012
 ***********************************************************************************************/

DECLARE
 
    v_dif_dias				integer;
    v_id_subsistema			integer;
    v_id_rpc				integer;
    v_id_sup    			integer;
    v_id_rep_legal			integer; 
    v_id_sup_boleta			integer;  
    v_dias_boleta			integer;
    v_dias_contrato			integer;
    v_descrip_boleta		varchar;
    v_descrip_contrato		varchar;
    v_registros				record;  
    v_alarmas				integer[];
    v_alarmas_con			integer[];
    v_id_funcionario		integer;
    v_id_alarma				integer; 
    v_funcionarios			integer[];
    v_funcionarios_cargo	varchar[];
    v_funcionarios_con		integer[]; 
    v_funcionarios_url      varchar[]; 
	v_funcionarios_class	varchar[];
    v_indice				integer;
    
    v_desc_alarma           varchar;
    v_num_cotrato varchar;
    v_contratista varchar;
BEGIN       
         v_indice:=0;
       --0) obtenemos el id_subsistema
          SELECT id_subsistema INTO v_id_subsistema
          FROM segu.tsubsistema 
          WHERE codigo='SAJ';
       
       --1)  obtenemos los datos de configuracion de boleta y contratos
       
       SELECT descripcion,dias INTO v_descrip_boleta,v_dias_boleta
       FROM param.tconfig_alarma 
       WHERE codigo='tboleta' AND id_subsistema=v_id_subsistema;
       
       SELECT descripcion,dias INTO v_descrip_contrato,v_dias_contrato
       FROM param.tconfig_alarma 
       WHERE codigo='tproceso_contrato' AND id_subsistema=v_id_subsistema; 
       
       
    --2) iniciamos el recorrido para boleta solo para las boletas que no tienen alarmas
         FOR v_registros IN (SELECT b.id_boleta,
                                    b.id_proceso_contrato,
                                    b.fecha_vencimiento,
                                    b.monto,
                                    b.id_moneda,
                                    b.numero,
                                    m.codigo
                             FROM saj.tboleta b
                             INNER JOIN param.tmoneda m on m.id_moneda = b.id_moneda
                             WHERE id_alarma IS NULL
                             and ((fecha_vencimiento-now()::date)<=v_dias_boleta)
                             and b.estado not in ('finalizada','renovada','anulada','cobrada') 
                          )LOOP
                             
                             
                           
                             
                              --falta filtro de boleas ya finalizadas, renovadas y cobradas  
             
             --calculo cuanto de cuantos dias falta para vencer
             --numero negativo indica que ya vencio
             v_dif_dias= v_registros.fecha_vencimiento-now()::date;
             
             --VERIFICA SI CUMPLE LA DIFERENCIA DE DIAS PARA CREAR UNA ALARMA
             if(v_dif_dias <= v_dias_boleta)THEN
              
              --  crea alarmas para:
              --   rpc,supervisor,representante legal,funcionario solicitante
              
                 SELECT c.id_rpc,c.id_supervisor,c.id_representante_legal,
                        c.id_funcionario 		,c.numero_contrato,desc_proveedor
                 INTO   v_id_rpc,v_id_sup,v_id_rep_legal,
                        v_id_funcionario,v_num_cotrato, v_contratista
                 FROM saj.tproceso_contrato c
                 INNER JOIN param.vproveedor provee 
                 on provee.id_proveedor=c.id_proveedor
                 WHERE id_proceso_contrato=v_registros.id_proceso_contrato;
                 
                 --obtiene el identificador de los funcionario
                 v_id_rpc:=id_funcionario FROM saj.tresponsable_proceso 
                                          WHERE id_responsable_proceso=v_id_rpc;
                 
                 v_id_sup:=id_funcionario FROM saj.tresponsable_proceso 
                                          WHERE id_responsable_proceso=v_id_sup;
                 
                 v_id_rep_legal:=id_funcionario FROM saj.tresponsable_proceso 
                                                WHERE id_responsable_proceso=v_id_rep_legal;

                 --obtiene el usuario responsable de las boletas para el departamento correspondiente
                 v_id_sup_boleta:=  fun.id_funcionario 
                                          FROM rhum.tfuncionario fun
                                          inner join segu.tusuario usu 
                                                 on usu.id_persona=fun.id_persona
                                          inner join param.tdepto_usuario dusu 
                                                 on dusu.id_usuario=usu.id_usuario and dusu.estado_reg='activo'
                                          where dusu.cargo='resp_bolet';


                   raise NOTICE 'FUNCIONARIO %',v_id_funcionario;   
                   
                 
                  v_funcionarios=NULL;
                     v_funcionarios_cargo=NULL;
                     
                     
                     v_funcionarios[1] =v_id_funcionario;
                     v_funcionarios_cargo[1] ='solicitante';
                     v_funcionarios[2] =v_id_rpc;
                     v_funcionarios_cargo[2] ='rpc';
                     v_funcionarios[3] =v_id_sup;
                     v_funcionarios_cargo[3] ='supervisor';
                     v_funcionarios[4] =v_id_sup_boleta;
                     v_funcionarios_cargo[4] ='encargadobol';
                 
                  raise NOTICE '>>>>> dias % , % % % % ',v_dias_boleta,v_funcionarios[1],v_funcionarios[2],v_funcionarios[3],v_funcionarios[4];
                  
                   
                   --inserta alarmas
                  v_indice:=1;
                   
                 --arma la descripcion de la alarma
                 v_desc_alarma='Se esta cumpliendo la Boleta de garantia Nº '||coalesce(v_registros.numero::varchar,'NR') ||' por '||coalesce(v_registros.monto::varchar,'NR')||' '||coalesce(v_registros.codigo,'NR') ||'  del contraro Nº '||coalesce(v_num_cotrato,'NR')||' del Contratista '||coalesce(v_contratista,'NR');
                   
              --  raise notice '%',v_desc_alarma;
                   
                   WHILE (v_indice <= 4)Loop
                   
                   --raise notice '%, %',v_funcionarios_cargo[v_indice],v_registros.id_boleta;
                   
                      v_id_alarma:=param.f_inserta_alarma(
                                     v_funcionarios[v_indice],
                                     v_desc_alarma,
                                     '../../../sis_legal/vista/boleta/AdministracionBoleta.php',
                                     v_registros.fecha_vencimiento,
                                     'alarma',
                                     'SAJ-Boletas',
                                     p_id_usuario,
                                     'AdministracionBoleta',
                                     'Boletas',
                                     '{tipoFiltro:'''||v_funcionarios_cargo[v_indice]::varchar||''',filtrar:true,id_boleta:'||v_registros.id_boleta::varchar||'}'
                                     ); 
                       
                      v_alarmas[v_indice]:=v_id_alarma;                        
                      v_indice:=v_indice+1;
                   End Loop;                                          
                   
                   --Actualizamos la tabla boleta con el array de alarmas
                   Update saj.tboleta SET
                      id_alarma=v_alarmas
                   WHERE id_boleta=v_registros.id_boleta;
                                            
                                          
             end if;
         END LOOP; 
       --3) iniciamos el recorrido para contrato solo para los que no tienen alarmas
      
       
       FOR v_registros IN (SELECT c.id_proceso_contrato,c.fecha_fin,c.id_funcionario,
                                  c.id_rpc,id_supervisor,c.id_representante_legal,
                                  provee.desc_proveedor,c.numero_contrato
                           FROM saj.tproceso_contrato c 
                           INNER JOIN param.vproveedor provee 
                           on provee.id_proveedor=c.id_proveedor
                           WHERE id_alarma IS NULL
                           and ((c.fecha_fin-now()::date)<=v_dias_contrato)
                           and c.estado_reg='activo' and c.estado_proceso in ('REGCON','REVCON','BORCON')
                           )LOOP 
                               
                 v_dif_dias= v_registros.fecha_fin-now()::date;
                 
                 If (v_dif_dias<=v_dias_contrato)then
             
                 
                 v_id_rpc:=id_funcionario FROM saj.tresponsable_proceso 
                                          WHERE id_responsable_proceso=v_registros.id_rpc;
                 
                 v_id_sup:=id_funcionario FROM saj.tresponsable_proceso 
                                          WHERE id_responsable_proceso=v_registros.id_supervisor;
                 
                 v_id_rep_legal:=id_funcionario FROM saj.tresponsable_proceso 
                                                WHERE id_responsable_proceso=v_registros.id_representante_legal; 
                 
                 
                 
                     v_funcionarios_con[1] =v_registros.id_funcionario;
                     v_funcionarios_cargo[1] ='solicitante';
  
					 v_funcionarios_url[1] ='../../../sis_legal/vista/proceso_contrato/ProcesoRequerimiento.php';
                     v_funcionarios_class[1] = 'ProcesoRequerimiento';
                     v_funcionarios_con[2] =v_id_rpc;
                     v_funcionarios_cargo[2] ='rpc';
					 v_funcionarios_url[2] ='../../../sis_legal/vista/proceso_contrato/ProcesoBusqueda.php';
					 v_funcionarios_class[2] = 'ProcesoBusqueda';
                     v_funcionarios_con[3] =v_id_sup;
                     v_funcionarios_cargo[3] ='supervisor';
  					 v_funcionarios_url[3] ='../../../sis_legal/vista/proceso_contrato/ProcesoBusqueda.php';
                     v_funcionarios_class[3] = 'ProcesoBusqueda';
            
                 
                 -- arma la descripcion de la alarma
                 v_desc_alarma='Se esta cumpliendo el contrato Nº '||coalesce(v_registros.numero_contrato,'NR')||' del Contratista '||coalesce(v_registros.desc_proveedor,'NR');
                 v_indice:=1;
                 
                   WHILE (v_indice <= 3)Loop
                      v_id_alarma:=param.f_inserta_alarma(
                      v_funcionarios_con[v_indice],
                      v_desc_alarma,
                      v_funcionarios_url[v_indice],
                      v_registros.fecha_fin,
                      'alarma',
                      'SAJ - Contratos',
                      p_id_usuario,
                      v_funcionarios_class[v_indice],--clase
                      'Contratos - '||v_funcionarios_cargo[v_indice],--titulo
                      '{tipoFiltro:'''||v_funcionarios_cargo[v_indice]::varchar||''',filtrar:true,id_proceso_contrato:'||v_registros.id_proceso_contrato::varchar||'}'
                     );
                                      
                         
                      v_alarmas_con[v_indice]:=v_id_alarma;                        
                      v_indice:=v_indice+1;
                   End Loop;  
                                                           
                   --Actualizamos la tabla contrato con el array de alarmas
                   Update saj.tproceso_contrato SET
                      id_alarma=v_alarmas_con
                   WHERE id_proceso_contrato=v_registros.id_proceso_contrato;
                   
                 end if;
                 
       END Loop;
           
       return 'exito';

END;
$body$
    LANGUAGE plpgsql SECURITY DEFINER;