CREATE OR REPLACE FUNCTION saj.f_tdocumento_anexo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.ft_documento_anexo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'saj.tdocumento_anexo'
 AUTOR: 		 (fprudencio)
 FECHA:	        17-11-2011 10:24:34
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
	v_id_documento_anexo	integer;
			    
BEGIN

    v_nombre_funcion = 'saj.f_tdocumento_anexo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SA_DOCANEX_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 10:24:34
	***********************************/

	if(p_transaccion='SA_DOCANEX_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into saj.tdocumento_anexo(
			estado_reg,
			id_proceso_contrato,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_proceso_contrato,
			p_id_usuario,
			now(),
			null,
			null
			)RETURNING id_documento_anexo into v_id_documento_anexo;
               
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento Anexo almacenado(a) con exito (id_documento_anexo'||v_id_documento_anexo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_anexo',v_id_documento_anexo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'SA_DOCANEX_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 10:24:34
	***********************************/

	elsif(p_transaccion='SA_DOCANEX_MOD')then

		begin
			--Sentencia de la modificacion
			update saj.tdocumento_anexo set
			id_proceso_contrato = v_parametros.id_proceso_contrato,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_documento_anexo=v_parametros.id_documento_anexo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento Anexo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_anexo',v_parametros.id_documento_anexo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'SA_DOCANEX_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		fprudencio	
 	#FECHA:		17-11-2011 10:24:34
	***********************************/

	elsif(p_transaccion='SA_DOCANEX_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from saj.tdocumento_anexo
            where id_documento_anexo=v_parametros.id_documento_anexo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento Anexo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_anexo',v_parametros.id_documento_anexo::varchar);
              
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