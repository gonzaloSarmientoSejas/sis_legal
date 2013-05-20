CREATE OR REPLACE FUNCTION saj.f_tproceso_contrato_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_tproceso_contrato_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'saj.tproceso_contrato'
 AUTOR: 		 (mzm)
 FECHA:	        16-11-2011 17:25:24
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro            varchar;
    v_criterio_join     varchar;
    v_id_responsable integer;
    v_id_funcionario integer;
    v_id_responsable_proceso integer;
    v_id_supervidor integer;
    v_id_rpc integer;
			    
BEGIN

	v_nombre_funcion = 'saj.f_tproceso_contrato_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SA_CONTRA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 17:25:24
	***********************************/

	if(p_transaccion='SA_CONTRA_SEL')then
     				
    	begin
             v_criterio_join ='LEFT JOIN';
            
             
             IF(pxp.f_existe_parametro(p_tabla,'tipo_interfaz')) then
             
             
               
                     IF(v_parametros.tipo_interfaz='REQUER')THEN
                     --si es la interface de requerimiento se linstan los procesos en todos los
                     --estados 
                     
                    
                           
                           IF(pxp.f_existe_parametro(p_tabla,'id_funcionario') ) then
                               
                                     IF p_administrador =1 THEN
                                     
                                      v_filtro=' and 0=0 ';
                                     
                                     ELSEIF(v_parametros.id_funcionario is not null) then 
                                     v_filtro = ' and (contra.id_usuario_reg= '||p_id_usuario||' 
                                                  or contra.id_funcionario = '||v_parametros.id_funcionario::varchar||')  ';
                                     ELSE 
                                     raise exception 'el usuario no tiene funcionario relacionado (Registre al usuario como funcionario en el sistema de recursos humanos)';
                                     END IF;
                            END IF;
                     END IF;
                 
                     IF (v_parametros.tipo_interfaz='FINREQ') THEN
                        v_filtro:=' and (estpro.estado_vigente=''FINREQ'' or estpro.estado_vigente=''ASIGNA'')';
                     END IF;
               
               
                     IF (v_parametros.tipo_interfaz='ELABORACION') THEN
                           --raise exception 'LLEGA';
                   
                           v_criterio_join ='LEFT JOIN';
                           
                           IF p_administrador =1 THEN
                             v_filtro:=' and (estpro.estado_vigente in (''ASIGNA'',''BORCON'',''REVCON'',''REGCON''))';
                           ELSEIF(v_parametros.id_funcionario is not null ) then 
                         
                               select id_responsable_proceso
                                 into v_id_responsable
                               from saj.tresponsable_proceso rp
                               where rp.id_funcionario = v_parametros.id_funcionario::integer;
                                 v_filtro:=' and (estpro.estado_vigente in (''ASIGNA'',''BORCON'',''REVCON'',''REGCON'',''FINCON'') 
                                                   and abogado.id_responsable_proceso='||v_id_responsable::varchar||')';
                         
                           ELSE 
                                         raise exception 'el usuario no tiene funcionario relacionado';
                           END IF;
                     END IF;
            
             
                IF (v_parametros.tipo_interfaz='CONCLUIDO') THEN
                      v_filtro:=' and (estpro.estado_vigente=''FINCON'')';
                 END IF;
           
                 IF (v_parametros.tipo_interfaz='VIGENTE') THEN
                        v_filtro:=' and (estpro.estado_vigente=''REGCON'')';
                 END IF;
             
                 IF (v_parametros.tipo_interfaz='ADMIN') THEN
                        v_filtro:=' and (estpro.estado_vigente!=''REQUER'')';
                 END IF;
                 
                 
                 
                 IF (v_parametros.tipo_interfaz='BUSQUEDA') THEN
                 
                 
                    --TIPO FILTRO
                    IF(pxp.f_existe_parametro(p_tabla,'tipoFiltro') ) then 
                    
                     
                     --raise exception 'tipoFiltro = %',v_parametros.tipoFiltro;
                    
                     
                                 --SI TIPO FILTRO ESTA HABILITADO ACCEDE DESDE ALARMAS
                                 --puede ver todos los estados pero hace un filtro por el tipo 
                                 --de usuario  que revisa: solicitante, rpc, supervidor
                               IF(v_parametros.tipoFiltro!='solicitante')THEN
                              
                                         Select 
                                            r.id_responsable_proceso
                                         into 
                                           v_id_responsable_proceso
                                         from saj.tresponsable_proceso r
                                         where r.id_funcionario = v_parametros.id_funcionario 
                                         and r.estado_reg='activo' and r.tipo = v_parametros.tipoFiltro;
                                     
                               ELSEIF(v_parametros.id_funcionario is  null ) then 
                                    
                                    raise exception 'el usuario no tiene funcionario relacionado';
                               
                               END IF;
                          
                              IF (v_parametros.tipoFiltro='solicitante') THEN
                              
                                     v_filtro:=' and (contra.id_funcionario='||COALESCE(v_parametros.id_funcionario,0)||')';
                                
                              ELSEIF (v_parametros.tipoFiltro='rpc') THEN
                              
                                    v_filtro:=' and (contra.id_rpc='||COALESCE(v_id_responsable_proceso,0)||')';
                                
                                
                              ELSEIF (v_parametros.tipoFiltro='supervidor') THEN
                          
                                    v_filtro:=' and (contra.id_supervisor='||COALESCE(v_id_responsable_proceso,0)||')';
                            
                              ELSE
                                    v_filtro=' and 0=0 ';
                              END IF;
                   ELSE
                      --SIN TIPO FILTRO ACCEDE DIRECTO
                               --raise exception 'XXXXXXXX    11111111';
                               
                               Select 
                                  r.id_responsable_proceso
                               into 
                                 v_id_rpc                                 
                               from saj.tresponsable_proceso r
                               where r.id_funcionario::integer = v_parametros.id_funcionario::integer 
                               and r.estado_reg::varchar='activo' and r.tipo::varchar = 'rpc';
                               
                               
                               --raise notice 'zz  22222222';
                               
                               Select 
                                  r.id_responsable_proceso
                               into 
                                 v_id_supervidor
                               from saj.tresponsable_proceso r
                               where r.id_funcionario = v_parametros.id_funcionario::integer 
                               and r.estado_reg::Varchar='activo' and r.tipo::varchar = 'supervisor';
                              
                              
                              --raise notice '33333333333333';
                              
                              
                              
                          IF(p_administrador=1) then 
                          
                               v_filtro=' and 0=0 ';
                          
                          ELSE
                          
                                IF(v_parametros.id_funcionario is  null ) then 
                                  
                                  raise exception 'el usuario no tiene funcionario relacionado';
                               
                               ELSE
                                   --mflores: revisar el filtro para las busquedas porque no lista nada para el rol SAJ - abogado                  
                                 v_filtro:=' and (contra.id_supervisor='||COALESCE(v_id_supervidor,0)::varchar||' OR contra.id_rpc='||COALESCE(v_id_rpc,0)::varchar||' OR contra.id_funcionario='||COALESCE(v_parametros.id_funcionario,0)::varchar||')';
                               
                               END IF; 
                          
                          END IF;
                        
                          --raise exception 'v_filtro: %', v_filtro; --and (contra.id_supervisor=0 OR contra.id_rpc=0 OR contra.id_funcionario=518
                                                     --raise notice '5555555555'; 
                          
                   END IF;    
               END IF;
                 
              else
                     v_filtro=' and 0=0 ';
              end if;    
                 
        
    		--Sentencia de la consulta
			v_consulta:='select
						contra.id_proceso_contrato,
						contra.notario,
						contra.numero_oc,
						contra.fecha_convocatoria,
						contra.numero_requerimiento,
						contra.multas,
						contra.id_modalidad,
						contra.fecha_aprobacion,
						contra.fecha_fin,
						contra.plazo,
						contra.objeto_contrato,
						contra.id_depto,
						contra.extension,
						contra.id_proyecto,
						contra.forma_pago,
						contra.id_lugar_suscripcion,
						contra.numero_cuce,
						contra.fecha_suscripcion,
						contra.testimonio,
						contra.monto_contrato,
						contra.numero_contrato,
						contra.id_rpc,
						--contra.id_alarma,
						contra.observaciones,
						contra.id_proveedor,
						contra.origen_recursos,
						contra.id_uo,
						contra.id_representante_legal,
						contra.id_tipo_contrato,
						contra.fecha_testimonio,
						contra.doc_contrato,
						contra.id_supervisor,
						contra.beneficiario,
						contra.version,
						contra.id_gestion,
						contra.fecha_ini,
						contra.fecha_ap_acta,
						contra.id_oc,
						contra.id_funcionario,
						contra.id_moneda,
						contra.numero_licitacion,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	,
                        
                        modali.nombre as desc_modalidad,
                        depto.nombre as desc_depto,
                        rpc.desc_responsable_proceso as desc_rpc,
                        provee.desc_proveedor,
                        uo.nombre_unidad as desc_uo,
                        rep_legal.desc_responsable_proceso as desc_rep_legal,
                        tipcon.nombre as desc_tipo_contrato,
                        superv.desc_responsable_proceso as desc_supervisor,
                        gestio.gestion as desc_gestion ,
                        funcio.desc_funcionario1::varchar as desc_funcionario,
                        moneda.moneda as desc_moneda,
                        --alarma.descripcion as desc_alarma,
                        proyec.nombre_proyecto as desc_proyecto,
                        lugar.nombre as desc_lugar,
                        est.nombre as nombre_estado,
                        contra.estado_proceso,
                        abogado.id_responsable_proceso as id_abogado,
                        abogado.desc_responsable_proceso as abogado,
                        contra.fecha_reg,
                        contra.fecha_mod,
                        contra.estado_reg
                            
					from saj.tproceso_contrato contra
                        inner join saj.testado_proceso estpro 
                          on estpro.id_proceso_contrato=contra.id_proceso_contrato 
                          and estpro.estado_reg=''activo''
                        inner join saj.testado est on est.codigo = estpro.estado_vigente
						inner join orga.vfuncionario funcio on funcio.id_funcionario=contra.id_funcionario
                        inner join segu.tusuario usu1 on usu1.id_usuario = contra.id_usuario_reg
						inner join param.tdepto depto on depto.id_depto=contra.id_depto --inner
                        inner join orga.tuo uo on uo.id_uo=contra.id_uo
						INNER join param.tgestion gestio on gestio.id_gestion=contra.id_gestion           
                        INNER join param.tmoneda moneda on moneda.id_moneda=contra.id_moneda
                        INNER join saj.ttipo_contrato tipcon on tipcon.id_tipo_contrato=contra.id_tipo_contrato
                        INNER join saj.vresponsable_proceso rep_legal on rep_legal.id_responsable_proceso=contra.id_representante_legal
						INNER join param.vproveedor provee on provee.id_proveedor=contra.id_proveedor

                        
                        --inner join param.tdepto_usuario depto_usuario on depto_usuario.id_depto 
                        '||v_criterio_join||'  saj.vresponsable_proceso abogado on estpro.id_responsable_proceso=abogado.id_responsable_proceso  
                        left join saj.tmodalidad modali on modali.id_modalidad=contra.id_modalidad
                        left join segu.tusuario usu2 on usu2.id_usuario = contra.id_usuario_mod   

                        left join saj.vresponsable_proceso rpc on rpc.id_responsable_proceso=contra.id_rpc  
                        

                        left join saj.vresponsable_proceso superv on superv.id_responsable_proceso=contra.id_supervisor  

                        
                        --left join param.talarma alarma on alarma.id_alarma=contra.id_alarma
                        left join param.tproyecto proyec on proyec.id_proyecto=contra.id_proyecto
                        left join param.tlugar lugar on lugar.id_lugar=contra.id_lugar_suscripcion    
                       
                         
                        
                        
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;     
            		
            
             IF v_filtro is not null then
                v_consulta:=v_consulta || v_filtro;
             END IF;
            
           
   
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice  'cons: %',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'SA_CONTRA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 17:25:24
	***********************************/

	elsif(p_transaccion='SA_CONTRA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(contra.id_proceso_contrato)
					    from saj.tproceso_contrato contra
                        inner join saj.testado_proceso estpro 
                          on estpro.id_proceso_contrato=contra.id_proceso_contrato 
                          and estpro.estado_reg=''activo''
                        inner join saj.testado est on est.codigo = estpro.estado_vigente
						inner join orga.vfuncionario funcio on funcio.id_funcionario=contra.id_funcionario
                        inner join segu.tusuario usu1 on usu1.id_usuario = contra.id_usuario_reg
						inner join param.tdepto depto on depto.id_depto=contra.id_depto --inner
                        inner join orga.tuo uo on uo.id_uo=contra.id_uo
						INNER join param.tgestion gestio on gestio.id_gestion=contra.id_gestion           
                        INNER join param.tmoneda moneda on moneda.id_moneda=contra.id_moneda
                        INNER join saj.ttipo_contrato tipcon on tipcon.id_tipo_contrato=contra.id_tipo_contrato
                        INNER join saj.vresponsable_proceso rep_legal on rep_legal.id_responsable_proceso=contra.id_representante_legal
                        INNER join param.vproveedor provee on provee.id_proveedor=contra.id_proveedor
                       
                        
                        left join saj.tmodalidad modali on modali.id_modalidad=contra.id_modalidad
                        left join segu.tusuario usu2 on usu2.id_usuario = contra.id_usuario_mod   

                        left join saj.vresponsable_proceso rpc on rpc.id_responsable_proceso=contra.id_rpc  
                        
                        left join saj.vresponsable_proceso superv on superv.id_responsable_proceso=contra.id_supervisor  

                        
                        --left join param.talarma alarma on alarma.id_alarma=contra.id_alarma
                        left join param.tproyecto proyec on proyec.id_proyecto=contra.id_proyecto
                        left join param.tlugar lugar on lugar.id_lugar=contra.id_lugar_suscripcion    
                       
                        left join saj.vresponsable_proceso abogado on estpro.id_responsable_proceso=abogado.id_responsable_proceso  
                         
                        
                        where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
             IF(pxp.f_existe_parametro(p_tabla,'estado_proceso')) then
               v_consulta:=v_consulta || ' and estpro.estado_vigente='''||v_parametros.estado_proceso||'''';
            end if;
			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
/*					
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;*/
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;