CREATE OR REPLACE FUNCTION saj.f_tresponsable_proceso_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_tresponsable_proceso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'saj.tresponsable_proceso'
 AUTOR: 		 (mzm)
 FECHA:	        16-11-2011 16:54:59
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

	v_nombre_funcion = 'saj.f_tresponsable_proceso_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SA_RESPRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 16:54:59
	***********************************/

	if(p_transaccion='SA_RESPRO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						respro.id_responsable_proceso,
						respro.estado_reg,
						respro.tipo,
						respro.id_funcionario,
						respro.id_usuario_reg,
						respro.fecha_reg,
						respro.id_usuario_mod,
						respro.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                       -- person.nombre_completo1,
                       funcio.desc_funcionario1 as nombre_completo1,
                        coalesce((select distinct 1 from saj.tproceso_contrato where estado_proceso not in (''FINCON'',''ANULADO'')
                           and (
                                   (id_supervisor=respro.id_responsable_proceso and respro.tipo=''supervisor'') 
                                or (id_rpc=respro.id_responsable_proceso and respro.tipo=''rpc'') 
                                or (id_representante_legal=respro.id_responsable_proceso and respro.tipo=''rep_legal'')
                                or (id_proceso_contrato in (select id_proceso_contrato from saj.testado_proceso where estado_vigente not in (''FINCON'',''ANULADO'')
                                    and estado_reg=''activo'' and respro.id_responsable_proceso=id_responsable_proceso) and respro.tipo=''abogado'')
                           )
                        ),0)::integer as tiene_procesos_pendientes     ,
                        funcio_ant.desc_funcionario1 as desc_resp_ant
						from saj.tresponsable_proceso respro
						inner join segu.tusuario usu1 on usu1.id_usuario = respro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = respro.id_usuario_mod      
                        inner join orga.vfuncionario funcio on funcio.id_funcionario=respro.id_funcionario   
--                        inner join segu.persona person on person.id_persona=funcio.id_persona
                        left join saj.tresponsable_proceso respro_ant on respro_ant.id_responsable_proceso=respro.id_responsable_proceso_anterior
                        left join orga.vfuncionario  funcio_ant on funcio_ant.id_funcionario=respro_ant.id_funcionario
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;   
               -- raise exception '%', 'and respro.tipo like  '' '''||v_parametros.tipo||''' ';
            if(pxp.f_existe_parametro(p_tabla,'tipo')) then                        --        raise exception 'aa%',v_parametros.tipo;
               v_consulta:=v_consulta ||  ' and respro.tipo like ''' ||v_parametros.tipo ||'''';     
            end if;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
               
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'SA_RESPRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 16:54:59
	***********************************/

	elsif(p_transaccion='SA_RESPRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(respro.id_responsable_proceso)
					    from saj.tresponsable_proceso respro
						inner join segu.tusuario usu1 on usu1.id_usuario = respro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = respro.id_usuario_mod      
                        inner join orga.vfuncionario funcio on funcio.id_funcionario=respro.id_funcionario   
--                        inner join segu.persona person on person.id_persona=funcio.id_persona
                        left join saj.tresponsable_proceso respro_ant on respro_ant.id_responsable_proceso=respro.id_responsable_proceso_anterior
                        left join orga.vfuncionario  funcio_ant on funcio_ant.id_funcionario=respro_ant.id_funcionario
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;   
               -- raise exception '%', 'and respro.tipo like  '' '''||v_parametros.tipo||''' ';
            if(pxp.f_existe_parametro(p_tabla,'tipo')) then                        --        raise exception 'aa%',v_parametros.tipo;
               v_consulta:=v_consulta ||  ' and respro.tipo ilike ''' ||v_parametros.tipo ||'''';     
            end if;

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