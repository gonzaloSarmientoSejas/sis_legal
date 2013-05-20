CREATE OR REPLACE FUNCTION saj.f_testado_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.ft_estado_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'saj.testado'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_estado	integer;
			    
BEGIN

    v_nombre_funcion = 'saj.f_testado_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SA_ESTAD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 09:35:55
	***********************************/

	if(p_transaccion='SA_ESTAD_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into saj.testado(
			estado_reg,
			admite_boleta,
			orden,
			codigo,
			admite_anexo,
			nombre,
			dias,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.admite_boleta,
			v_parametros.orden,
			v_parametros.codigo,
			v_parametros.admite_anexo,
			v_parametros.nombre,
			v_parametros.dias,
			p_id_usuario,
			now(),
			null,
			null
			)RETURNING id_estado into v_id_estado;
               
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estado almacenado(a) con exito (id_estado'||v_id_estado||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estado',v_id_estado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'SA_ESTAD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 09:35:55
	***********************************/

	elsif(p_transaccion='SA_ESTAD_MOD')then

		begin
			--Sentencia de la modificacion
			update saj.testado set
			admite_boleta = v_parametros.admite_boleta,
			orden = v_parametros.orden,
			codigo = v_parametros.codigo,
			admite_anexo = v_parametros.admite_anexo,
			nombre = v_parametros.nombre,
			dias = v_parametros.dias,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_estado=v_parametros.id_estado;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estado modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estado',v_parametros.id_estado::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'SA_ESTAD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 09:35:55
	***********************************/

	elsif(p_transaccion='SA_ESTAD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from saj.testado
            where id_estado=v_parametros.id_estado;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estado eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_estado',v_parametros.id_estado::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

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