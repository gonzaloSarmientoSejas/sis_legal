CREATE OR REPLACE FUNCTION saj.f_ttipo_contrato_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_ttipo_contrato_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'saj.ttipo_contrato'
 AUTOR: 		 (mzm)
 FECHA:	        16-11-2011 16:54:07
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
    v_id_tipo_contrato    integer;
                
BEGIN

    v_nombre_funcion = 'saj.f_ttipo_contrato_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'SA_TIPCON_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        mzm    
     #FECHA:        16-11-2011 16:54:07
    ***********************************/

    if(p_transaccion='SA_TIPCON_INS')then
                    
        begin
            --Sentencia de la insercion
            insert into saj.ttipo_contrato(
            nombre,
            estado_reg,
            id_usuario_reg,
            fecha_reg,
            id_usuario_mod,
            fecha_mod
              ) values(
            v_parametros.nombre,
            'activo',
            p_id_usuario,
            now(),
            null,
            null
            )RETURNING id_tipo_contrato into v_id_tipo_contrato;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo de Contrato almacenado(a) con exito (id_tipo_contrato'||v_id_tipo_contrato||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_contrato',v_id_tipo_contrato::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'SA_TIPCON_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        mzm    
     #FECHA:        16-11-2011 16:54:07
    ***********************************/

    elsif(p_transaccion='SA_TIPCON_MOD')then

        begin
            --Sentencia de la modificacion
            update saj.ttipo_contrato set
            nombre = v_parametros.nombre,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
            where id_tipo_contrato=v_parametros.id_tipo_contrato;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo de Contrato modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_contrato',v_parametros.id_tipo_contrato::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'SA_TIPCON_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        mzm    
     #FECHA:        16-11-2011 16:54:07
    ***********************************/

    elsif(p_transaccion='SA_TIPCON_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from saj.ttipo_contrato
            where id_tipo_contrato=v_parametros.id_tipo_contrato;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo de Contrato eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_contrato',v_parametros.id_tipo_contrato::varchar);
              
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