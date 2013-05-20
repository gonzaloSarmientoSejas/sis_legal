CREATE OR REPLACE FUNCTION saj.f_testado_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_testado_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'saj.testado'
 AUTOR: 		 (fprudencio)
 FECHA:	        17-11-2011 09:35:55
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

	v_nombre_funcion = 'saj.f_testado_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SA_ESTAD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 09:35:55
	***********************************/

	if(p_transaccion='SA_ESTAD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						estad.id_estado,
						estad.estado_reg,
						estad.admite_boleta,
						estad.orden,
						estad.codigo,
						estad.admite_anexo,
						estad.nombre,
						estad.dias,
						estad.id_usuario_reg,
						estad.fecha_reg,
						estad.id_usuario_mod,
						estad.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from saj.testado estad
						inner join segu.tusuario usu1 on usu1.id_usuario = estad.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = estad.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice 'consulta: %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'SA_ESTAD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 09:35:55
	***********************************/

	elsif(p_transaccion='SA_ESTAD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_estado)
					    from saj.testado estad
					    inner join segu.tusuario usu1 on usu1.id_usuario = estad.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = estad.id_usuario_mod
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