CREATE OR REPLACE FUNCTION saj.f_testado_proceso_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_testado_proceso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas 
 				relacionadas con la tabla 'saj.testado_proceso'
 AUTOR: 		(mflores)
 FECHA:	        13-12-2011 18:30
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
			    
BEGIN

	v_nombre_funcion = 'saj.f_testado_proceso_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'AJ_ESTPRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			mflores	
 	#FECHA:			13-12-2011 18:30
	***********************************/

	if(p_transaccion='AJ_ESTPRO_SEL')then
    
    	begin
    		--Sentencia de la consulta
			v_consulta:='select estpro.id_estado_proceso,
                                 estpro.id_proceso_contrato,
                                 estpro.observaciones,
                                 estpro.fecha_ini,
                                 COALESCE(pers.nombre || '' '' || pers.apellido_paterno || '' '' || pers.apellido_materno) as responsable,
                                 estpro.fecha_fin,
                                 est.nombre as vigente,
                                 --est1.nombre as anterior,
                                 estpro.estado_reg,
                                 estpro.fecha_reg,
                                 estpro.id_usuario_reg,
                                 estpro.fecha_mod,
                                 estpro.id_usuario_mod,
                                 usu1.cuenta as usr_reg,
                                 usu2.cuenta as usr_mod
                          from saj.testado_proceso estpro
                          left join saj.testado est
                          on est.codigo = estpro.estado_vigente
                          --left join saj.testado est1
                          --on est1.codigo = estpro.estado_anterior
                          left join saj.tresponsable_proceso resp
                          on estpro.id_responsable_proceso = resp.id_responsable_proceso
                          left join orga.tfuncionario func
                          on resp.id_funcionario = func.id_funcionario
                          left join segu.tpersona pers
                          on func.id_persona = pers.id_persona
                          inner join segu.tusuario usu1 on usu1.id_usuario = estpro.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = estpro.id_usuario_mod
                          where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion; -- || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
            raise notice 'consulta: %',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'AJ_ESTPRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:			mflores	
 	#FECHA:			13-12-2011 18:40
	***********************************/

	elsif(p_transaccion='AJ_ESTPRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_estado_proceso)
					    from saj.testado_proceso estpro                        
						inner join segu.tusuario usu1 on usu1.id_usuario = estpro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = estpro.id_usuario_mod
				        where estpro.estado_reg = ''activo'' and ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:  'AJ_EPDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			mflores	
 	#FECHA:			13-01-2011 15:53
	***********************************/

	elsif(p_transaccion='AJ_EPDET_SEL')then
    
    	begin
    		--Sentencia de la consulta
			v_consulta:='select est.nombre as vigente,
                          estad.nombre as anterior,
                          estcon.observaciones,
                          estcon.fecha_ini,
                          estcon.fecha_fin
                          from saj.testado_proceso estcon
                          left join saj.testado est
                          on est.codigo = estcon.estado_vigente
                          left join saj.testado estad
                          on estad.codigo = estcon.estado_anterior
                          where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion;
            
            raise notice 'consulta: %',v_consulta;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'AJ_EPDET_CONT'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			mflores	
 	#FECHA:			13-01-2011 17:00
	***********************************/

	elsif(p_transaccion='AJ_EPDET_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_estado_proceso)
			 			  from saj.testado_proceso estcon
                          left join saj.testado est
                          on est.codigo = estcon.estado_vigente
                          left join saj.testado estad
                          on estad.codigo = estcon.estado_anterior
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