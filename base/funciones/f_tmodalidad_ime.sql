CREATE OR REPLACE FUNCTION saj.f_tmodalidad_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_tmodalidad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'saj.tmodalidad'
 AUTOR: 		 (mzm)
 FECHA:	        11-11-2011 15:23:06
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
    v_parametros               record;
    v_id_requerimiento         integer;
    v_resp                    varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_modalidad    integer;
                
BEGIN

    v_nombre_funcion = 'saj.f_tmodalidad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'SAJ_MODALI_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        mzm    
     #FECHA:        11-11-2011 15:23:06
    ***********************************/

    if(p_transaccion='SAJ_MODALI_INS')then
                    
        begin
            --Sentencia de la insercion
            insert into saj.tmodalidad(
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
            )RETURNING id_modalidad into v_id_modalidad;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Modalidad almacenado(a) con exito (id_modalidad'||v_id_modalidad||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_modalidad',v_id_modalidad::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'SAJ_MODALI_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        mzm    
     #FECHA:        11-11-2011 15:23:06
    ***********************************/

    elsif(p_transaccion='SAJ_MODALI_MOD')then

        begin
            --Sentencia de la modificacion
            update saj.tmodalidad set
            nombre = v_parametros.nombre,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
            where id_modalidad=v_parametros.id_modalidad;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Modalidad modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_modalidad',v_parametros.id_modalidad::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'SAJ_MODALI_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        mzm    
     #FECHA:        11-11-2011 15:23:06
    ***********************************/

    elsif(p_transaccion='SAJ_MODALI_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from saj.tmodalidad
            where id_modalidad=v_parametros.id_modalidad;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Modalidad eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_modalidad',v_parametros.id_modalidad::varchar);
              
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