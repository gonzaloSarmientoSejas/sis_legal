CREATE OR REPLACE FUNCTION saj.f_tresponsable_proceso_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_tresponsable_proceso_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'saj.tresponsable_proceso'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_responsable_proceso	integer;
			    
BEGIN

    v_nombre_funcion = 'saj.f_tresponsable_proceso_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SA_RESPRO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 16:54:59
	***********************************/

	if(p_transaccion='SA_RESPRO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into saj.tresponsable_proceso(
			estado_reg,
			tipo,
			id_funcionario,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.tipo,
			v_parametros.id_funcionario,
			p_id_usuario,
			now(),
			null,
			null
			)RETURNING id_responsable_proceso into v_id_responsable_proceso;
               
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Responsable de Proceso almacenado(a) con exito (id_responsable_proceso'||v_id_responsable_proceso||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_responsable_proceso',v_id_responsable_proceso::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'SA_RESPRO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 16:54:59
	***********************************/

	elsif(p_transaccion='SA_RESPRO_MOD')then

		begin
			--Sentencia de la modificacion
            --05ene12: validamos si se trata de una asignacion de nuevo responsable para uno q esten dando de baja        
            if(pxp.f_existe_parametro(p_tabla,'id_funcionario_')) then  
            
                if(v_parametros.id_funcionario_>0) then    
                   --damos de baja(estado=inactivo) e insertamos otro registro q dependa del q estamos inactivando
                   update saj.tresponsable_proceso
                   set estado_reg='inactivo',      
                   fecha_mod=now()::date
                   where id_responsable_proceso=v_parametros.id_responsable_proceso;
               
                   insert into saj.tresponsable_proceso(
                       estado_reg,
                      tipo,
                      id_funcionario,
                      id_usuario_reg,
                      fecha_reg,
                      id_usuario_mod,
                      fecha_mod   ,
                      id_responsable_proceso_anterior
                      ) values(
                      'activo',
                      v_parametros.tipo,
                      v_parametros.id_funcionario_,
                      p_id_usuario,
                      now(),
                      null,
                      null   ,
                      v_parametros.id_responsable_proceso
                      )  ;        
    
                else   --modificacion simple de datos     
                    --verificar q no tenga procesos en los q esté con el tipo indicado 
                    if exists (select 1 from saj.tresponsable_proceso where id_responsable_proceso=v_parametros.id_responsable_proceso and tipo!=v_parametros.tipo) then
                    
                        if (v_parametros.tipo='abogado') then
                         --validamos en proceso_contrato 

                            if exists(select 1 from saj.testado_proceso where id_responsable_proceso=v_parametros.id_responsable_proceso) then
                                raise exception 'El responsable indicado tiene procesos en otro rol';
                            end if;
                        else                                    
                         --validamos en proceso_contrato_estado  
                            if exists (select 1 from saj.tproceso_contrato 
                                       where (id_supervisor=v_parametros.id_responsable_proceso
                                              or id_rpc=v_parametros.id_responsable_proceso 
                                              or id_representante_legal=v_parametros.id_responsable_proceso )
                            ) then
                                  raise exception 'El responsable indicado tiene procesos en otro rol';
                            end if;                      
                        end if;  
                    end if;
                    
                    
                    
                    update saj.tresponsable_proceso set
			            tipo = v_parametros.tipo,
                        id_funcionario = v_parametros.id_funcionario,
                        id_usuario_mod = p_id_usuario,
                        fecha_mod = now()
                        where id_responsable_proceso=v_parametros.id_responsable_proceso;
                end if;
            end if; 
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Responsable de Proceso modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_responsable_proceso',v_parametros.id_responsable_proceso::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'SA_RESPRO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 16:54:59
	***********************************/

	elsif(p_transaccion='SA_RESPRO_ELI')then

        begin
            
            --validamos q se pueda eliminar el registro
            if exists(select 1 from saj.tresponsable_proceso where id_responsable_proceso_anterior=v_parametros.id_responsable_proceso) then
            end if;
               
            --Sentencia de la eliminacion         
            delete from saj.tresponsable_proceso
            where id_responsable_proceso=v_parametros.id_responsable_proceso;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Responsable de Proceso eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_responsable_proceso',v_parametros.id_responsable_proceso::varchar);
              
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