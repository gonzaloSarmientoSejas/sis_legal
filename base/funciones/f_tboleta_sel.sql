CREATE OR REPLACE FUNCTION saj.f_tboleta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_tboleta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'saj.tboleta'
 AUTOR: 		 (fprudencio)
 FECHA:	        17-11-2011 11:23:54
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
    v_id_funcionario integer;
    v_id_responsable_proceso integer;
    v_filtro varchar;
			    
BEGIN

	v_nombre_funcion = 'saj.f_tboleta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
     #TRANSACCION:  'SA_BOLETA_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        fprudencio    
     #FECHA:        17-11-2011 11:23:54
    ***********************************/

    if(p_transaccion='SA_BOLETA_SEL')then
                     
        begin
       
        
            --Sentencia de la consulta
            v_consulta:='select
                        boleta.id_boleta,
                        boleta.extension,
                        boleta.doc_garantia,
                      --  boleta.id_alarma,
                        boleta.id_institucion_banco,
                        boleta.fecha_fin,
                        boleta.numero,
                        boleta.fecha_vencimiento,
                        boleta.fecha_suscripcion,
                        boleta.orden,
                        boleta.observaciones,
                        boleta.monto,
                        boleta.id_moneda,
                        boleta.tipo,
                        boleta.version,
                        boleta.estado_reg,
                        boleta.id_proceso_contrato,
                        boleta.fecha_ini,
                        boleta.estado,
                        boleta.id_usuario_reg,
                        boleta.fecha_reg,
                        boleta.id_usuario_mod,
                        boleta.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod ,
                        moneda.moneda as desc_moneda,
                        instit.nombre as nombre   
                        from saj.tboleta boleta                                                  
                        inner join param.tmoneda moneda on moneda.id_moneda=boleta.id_moneda
                        inner join param.tinstitucion instit on instit.id_institucion=boleta.id_institucion_banco
                        inner join segu.tusuario usu1 on usu1.id_usuario = boleta.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = boleta.id_usuario_mod
                        where  ';
            
            --Definicion de la respuesta                    
            v_consulta:=v_consulta||v_parametros.filtro;
            if(pxp.f_existe_parametro(p_tabla,'id_proceso_contrato')) then
               v_consulta:=v_consulta || ' and boleta.id_proceso_contrato='||v_parametros.id_proceso_contrato;
            end if;
            
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'SA_BOLETA_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        fprudencio    
     #FECHA:        17-11-2011 11:23:54
    ***********************************/

    elsif(p_transaccion='SA_BOLETA_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_boleta)
                        from saj.tboleta boleta 
                        inner join param.tmoneda moneda on moneda.id_moneda=boleta.id_moneda
                        inner join param.tinstitucion instit on instit.id_institucion=boleta.id_institucion_banco
                        inner join segu.tusuario usu1 on usu1.id_usuario = boleta.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = boleta.id_usuario_mod
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
        
    /*********************************    
     #TRANSACCION:  'SA_BOLETAPR_SEL'
     #DESCRIPCION:    Consulta de boletas y procesos
     #AUTOR:        fprudencio    
     #FECHA:        17-11-2011 11:23:54
    ***********************************/

    elseif(p_transaccion='SA_BOLETAPR_SEL')then
                     
        begin
        
         v_filtro='  0=0 '; 
        
         IF(pxp.f_existe_parametro(p_tabla,'id_usuario')) then

                IF(v_parametros.tipoFiltro!='solicitante')THEN
                
                       Select 
                         fun.id_funcionario, r.id_responsable_proceso
                       into 
                         v_id_funcionario,v_id_responsable_proceso
                       from rhum.tfuncionario fun
                       inner join segu.tusuario usu 
                       on usu.id_persona=fun.id_persona
                       inner join saj.tresponsable_proceso r
                       on r.id_funcionario = fun.id_funcionario and r.tipo = v_parametros.tipoFiltro
                       and r.estado_reg='activo'
                       where usu.id_usuario=v_parametros.id_usuario;
                   
                 ELSE
                 
                       Select 
                         fun.id_funcionario
                       into 
                         v_id_funcionario
                       from rhum.tfuncionario fun
                       inner join segu.tusuario usu 
                       on usu.id_persona=fun.id_persona
                       where usu.id_usuario=v_parametros.id_usuario and usu.estado_reg='activo';
                 
                 END IF;
                   --arma filtro
                 IF(v_parametros.tipoFiltro='rpc') THEN
                    v_filtro= ' pc.id_rpc = '||coalesce(v_id_responsable_proceso,0)::varchar;             

                 ELSEIF (v_parametros.tipoFiltro='supervisor') THEN
                    
                    v_filtro = ' pc.id_supervisor = '||coalesce(v_id_responsable_proceso,0)::varchar;
                
                 
                 ELSEIF (v_parametros.tipoFiltro='solicitante') THEN

                  v_filtro = ' pc.id_funcionario= '||coalesce(v_id_funcionario,0)::varchar;
                 
                 ELSE
                 
                  v_filtro='  0=0 '; 
                 END IF;
                 
                 
                -- raise exception 'xxxxxxx  %',v_parametros.tipoFiltro;
        
        end if;
        
         --raise exception 'xx zz %',v_filtro;
            --Sentencia de la consulta
            v_consulta:='select
                        boleta.id_boleta,
                        boleta.extension,
                        boleta.doc_garantia,
                      --  boleta.id_alarma,
                        boleta.id_institucion_banco,
                        boleta.fecha_fin,
                        boleta.numero,
                        boleta.fecha_vencimiento,
                        boleta.fecha_suscripcion,
                        boleta.orden,
                        boleta.observaciones,
                        boleta.monto,
                        boleta.id_moneda,
                        boleta.tipo,
                        boleta.version,
                        boleta.estado_reg,
                        boleta.id_proceso_contrato,
                        boleta.fecha_ini,
                        boleta.estado,
                        boleta.id_usuario_reg,
                        boleta.fecha_reg,
                        boleta.id_usuario_mod,
                        boleta.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod ,
                        moneda.moneda as desc_moneda,
                        instit.nombre as nombre,
                        pc.numero_contrato,
                        provee.desc_proveedor,
                        pc.doc_contrato,
                        pc.numero_requerimiento
                        from saj.tboleta boleta  
                        inner join saj.tproceso_contrato pc 
                        on pc.id_proceso_contrato = boleta.id_proceso_contrato 
                        and '||v_filtro||'                                                
                        INNER join param.vproveedor provee on provee.id_proveedor=pc.id_proveedor
                       
                        inner join param.tmoneda moneda on moneda.id_moneda=boleta.id_moneda
                        inner join param.tinstitucion instit on instit.id_institucion=boleta.id_institucion_banco
                        inner join segu.tusuario usu1 on usu1.id_usuario = boleta.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = boleta.id_usuario_mod
                        where  ';
            
            --Definicion de la respuesta                    
            v_consulta:=v_consulta||v_parametros.filtro;
            if(pxp.f_existe_parametro(p_tabla,'id_proceso_contrato')) then
               v_consulta:=v_consulta || ' and boleta.id_proceso_contrato='||v_parametros.id_proceso_contrato;
            end if;
            
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'SA_BOLETAPR_CONT'
     #DESCRIPCION:    Conteo de registros de boletas con proceso
     #AUTOR:        fprudencio    
     #FECHA:        17-11-2011 11:23:54
    ***********************************/

    elsif(p_transaccion='SA_BOLETAPR_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_boleta)
                        from saj.tboleta boleta 
                        inner join saj.tproceso_contrato pc on pc.id_proceso_contrato = boleta.id_proceso_contrato                                                
                        INNER join param.vproveedor provee on provee.id_proveedor=pc.id_proveedor
                       
                        inner join param.tmoneda moneda on moneda.id_moneda=boleta.id_moneda
                        inner join param.tinstitucion instit on instit.id_institucion=boleta.id_institucion_banco
                        inner join segu.tusuario usu1 on usu1.id_usuario = boleta.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = boleta.id_usuario_mod
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;    
                    
    else
                         
        raise exception 'Transaccion inexistente';
                             
    end if;
                    
EXCEPTION
                    
    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
            v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
            raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;