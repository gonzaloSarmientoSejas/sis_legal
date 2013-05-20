CREATE OR REPLACE FUNCTION saj.f_tboleta_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_tboleta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'saj.tboleta'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp                    varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_boleta    integer;
    v_id_boleta_fk integer;
    v_id_alarmas integer[];
    v_estado varchar;
                
BEGIN
           
    v_nombre_funcion = 'saj.f_tboleta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'SA_BOLETA_INS'
     #DESCRIPCION:  Insercion de registros
     #AUTOR:        Mercedes Zambrana Meneses
     #FECHA:        17-11-2011 11:23:54
    ***********************************/

    if(p_transaccion='SA_BOLETA_INS')then
                    
        begin
        
        IF(pxp.f_existe_parametro(p_tabla,'id_boleta_fk')) then
        
           v_id_boleta_fk = v_parametros.id_boleta_fk;
        else
           v_id_boleta_fk = NULL;
        END IF;
        
       -- veirifico si la institucion es del tipo banco
       
       IF (not exists (select 1 from param.tinstitucion i 
                  where i.id_institucion = v_parametros.id_institucion_banco
                  and i.es_banco='SI'))THEN
                  
              raise exception 'La institución seleccionada no esta señalada como un banco';
                  
       END IF;
        
        
        
            --Sentencia de la insercion
            insert into saj.tboleta(
            --extension,
           -- doc_garantia,
           -- id_alarma,
            id_institucion_banco,
           -- fecha_fin,
            numero,
            fecha_vencimiento,
            fecha_suscripcion,
            orden,
            observaciones,
            monto,
            id_moneda,
            tipo,
           -- version,
            estado_reg,
            id_proceso_contrato,
          --  fecha_ini,
            estado,
            id_usuario_reg,
            fecha_reg,
            id_usuario_mod,
            fecha_mod,
            id_boleta_fk
              ) values(
           -- v_parametros.extension,
          --  v_parametros.doc_garantia,
           -- v_parametros.id_alarma,
            v_parametros.id_institucion_banco,
          --  v_parametros.fecha_fin,
            v_parametros.numero,
            v_parametros.fecha_vencimiento,
            v_parametros.fecha_suscripcion,
            v_parametros.orden,
            v_parametros.observaciones,
            v_parametros.monto,
            v_parametros.id_moneda,
            v_parametros.tipo,
          --  v_parametros.version,
            'activo',
            v_parametros.id_proceso_contrato,
           -- v_parametros.fecha_ini,
            'borrador',
            p_id_usuario,
            now(),
            null,
            null,
            v_id_boleta_fk
            )RETURNING id_boleta into v_id_boleta;
            
            
            --cambiamos el estado de la boelta renovada si existe
            
             
                  if(v_id_boleta_fk is not NULL)THEN
                     
                     update saj.tboleta set
                      id_alarma = NULL,
                      estado = 'renovada',
                      id_usuario_mod = p_id_usuario,
                      fecha_mod = now()
                      where id_boleta=v_id_boleta_fk;
                    
                   	   -- si el estado es renovada, cobrada, finalizada
                       -- quitamos las alertas relacionadas
                       
                     
                           --cambiamos el tipo de alerta a notificacion
                           --las notificaciones pueden ser borradas por lo susuarios
                           --mostramos la solucion
                           
                           select id_alarma into v_id_alarmas 
                           from saj.tboleta b
                           where id_boleta=v_id_boleta_fk;
                           
                           update param.talarma set
                           tipo ='notificacion',
                           fecha = now(),
                           descripcion ='La boleta fue renovada  ['||descripcion||']',
                           id_usuario_mod = p_id_usuario,
                           fecha_mod = now()
                           where id_alarma = ANY (v_id_alarmas); 
                           
             
                  END IF;
           
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Boleta almacenado(a) con exito (id_boleta'||v_id_boleta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_boleta',v_id_boleta::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'SA_BOLETA_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        Mercedes Zambrana Meneses
     #FECHA:        17-11-2011 11:23:54
    ***********************************/

    elsif(p_transaccion='SA_BOLETA_MOD')then

        begin
        
            if (NOT EXISTS (select 1 from saj.tboleta b 
                 where b.id_boleta =v_parametros.id_boleta 
                 and estado_reg='activo')) then
               raise exception 'La boleta se encuentra eliminada (actualice su grilla)';            
 			end if;
            
            
             --obtener etado de bolea antes de modificar
            
            select estado into v_estado from saj.tboleta b where  b.id_boleta =v_parametros.id_boleta ;
            --si la boleta no esta en estado borrado o registrada no pueden hacerce cambios
            if(v_estado not in ('borrador','resgistrada')) then
            
              raise exception 'Solo se pueden editar boletas en estado borrador o registradas';
            
            end if;
            
             -- veirifico si la institucion es del tipo banco
       
           IF (not exists (select 1 from param.tinstitucion i 
                      where i.id_institucion = v_parametros.id_institucion_banco
                      and i.es_banco='SI'))THEN
                      
                  raise exception 'La institución seleccionada no esta señalada como un banco';
                      
           END IF;
            
            
            --Sentencia de la modificacion
            update saj.tboleta set
           -- extension = v_parametros.extension,
           -- doc_garantia = v_parametros.doc_garantia,
           -- id_alarma = v_parametros.id_alarma,
            id_institucion_banco = v_parametros.id_institucion_banco,
           -- fecha_fin = v_parametros.fecha_fin,
            numero = v_parametros.numero,
            fecha_vencimiento = v_parametros.fecha_vencimiento,
            fecha_suscripcion = v_parametros.fecha_suscripcion,
            orden = v_parametros.orden,
            observaciones = v_parametros.observaciones,
            monto = v_parametros.monto,
            id_moneda = v_parametros.id_moneda,
            tipo = v_parametros.tipo,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
           
           -- version = v_parametros.version,
          --  id_proceso_contrato = v_parametros.id_proceso_contrato,
           -- fecha_ini = v_parametros.fecha_ini
          --  estado = v_parametros.estado,
           
            where id_boleta=v_parametros.id_boleta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Boleta modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_boleta',v_parametros.id_boleta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;
    /*********************************    
 	#TRANSACCION:  'SA_ARCHBOL_MOD'
 	#DESCRIPCION:	Actualiza datos de la boleta  escaneada
 	#AUTOR:		rac	
 	#FECHA:		16-12-2011 17:25:24
	***********************************/

	elsif(p_transaccion='SA_ARCHBOL_MOD')then

		begin
        
          if (NOT EXISTS (select 1 from saj.tboleta b 
                 where b.id_boleta =v_parametros.id_boleta 
                 and estado_reg='activo')) then
               raise exception 'La boleta se encuentra eliminada (actualice su grilla)';            
 			end if;
            
            
             --obtener etado de bolea antes de modificar
            
            select estado into v_estado from saj.tboleta b where  b.id_boleta =v_parametros.id_boleta ;
           -- raise exception '%',v_estado;
            --si la boleta no esta en estado borrado o registrada no pueden hacerce cambios
            if(v_estado not in ('borrador','registrada')) then
            
              raise exception 'Solo se pueden editar boletas en estado borrador o registradas';
            
            end if;
            
            
            --obtener etado de bolea antes de modificar
            
            select estado into v_estado from saj.tboleta b where  b.id_boleta =v_parametros.id_boleta ;
            --si la boleta no esta en estado borrado o registrada no pueden hacerce cambios
            if(v_estado not in ('borrador','resgistrada')) then
            
              raise exception 'Solo se pueden editar boletas en estado borrador o registradas';
            
            end if;
            
        
           --raise exception 'VERSION %',v_parametros.version;
          
           update saj.tboleta set
           extension = v_parametros.extension,
           doc_garantia = v_parametros.doc_garantia,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
           version = v_parametros.version
           where id_boleta=v_parametros.id_boleta;
            
            --Definicion de la respuesta
           v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo escaneado de boleta modificado(a)'); 
           v_resp = pxp.f_agrega_clave(v_resp,'id_boleta',v_parametros.id_boleta::varchar);
               
            --Devuelve la respuesta
           return v_resp;
           
     end;        
    /*********************************    
 	#TRANSACCION:  'SA_CMBEST_MOD'
 	#DESCRIPCION:	Cambia de estados la boleta
 	#AUTOR:		rac	
 	#FECHA:		16-12-2011 17:25:24
	***********************************/

	elsif(p_transaccion='SA_CMBEST_MOD')then

		begin
          --verificar que boleta existe 
          
          if (NOT EXISTS (select 1 from saj.tboleta b 
                 where b.id_boleta =v_parametros.id_boleta 
                 and estado_reg='activo')) then
               raise exception 'La boleta se encuentra eliminada (actualice su grilla)';            
 			end if;
            
            
             --obtener etado de bolea antes de modificar
            
            select estado into v_estado from saj.tboleta b where  b.id_boleta =v_parametros.id_boleta ;
            --si la boleta no esta en estado borrado o registrada no pueden hacerce cambios
          /*  if(v_estado !=v_parametros.estado) then
            
              raise exception 'La boleta ya se encuentra en el estado % (Posiblemente otro usuario esta modificando simultaneamente esta boleta)',v_parametros.estado;
            
            end if;*/
        
                  
          --modifica estado boleta 
           update saj.tboleta set
           estado = v_parametros.estado,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
           where id_boleta=v_parametros.id_boleta;
        
           
           -- si el estado es renovada, cobrada, finalizada
           -- quitamos las alertas relacionadas
           
           if(v_parametros.estado  in ('renovada','cobrada','anulada','finalizada')) THEN
           
         
               --cambiamos el tipo de alerta a notificacion
               --las notificaciones pueden ser borradas por lo susuarios
               --mostramos la solucion
               
               select id_alarma into v_id_alarmas 
               from saj.tboleta b
               where id_boleta=v_parametros.id_boleta;
               
               update param.talarma set
               tipo ='notificacion',
               fecha = now(),
               descripcion ='La boleta fue '||v_parametros.estado||'  ['||descripcion||']',
               id_usuario_mod = p_id_usuario,
               fecha_mod = now()
               where id_alarma = ANY (v_id_alarmas); 
               
               --eliminamos la relacion con las boletas
               update saj.tboleta set
               id_alarma = NULL
               where id_boleta=v_parametros.id_boleta;
               
               
         
           END IF;
           
           --raise exception 'VERSION %',v_parametros.version;
          
          
           
            
            --Definicion de la respuesta
           v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo escaneado de boleta modificado(a)'); 
           v_resp = pxp.f_agrega_clave(v_resp,'id_boleta',v_parametros.id_boleta::varchar);
               
            --Devuelve la respuesta
           return v_resp;      
           
            
        end; 
    /*********************************    
     #TRANSACCION:  'SA_BOLETA_ELI'
     #DESCRIPCION:  Eliminacion de registros
     #AUTOR:        Mercedes Zambrana Meneses  
     #FECHA:        17-11-2011 11:23:54
    ***********************************/

    elsif(p_transaccion='SA_BOLETA_ELI')then

        begin
            
            
            /*si la boleta eliminada tiene alarmas*/
            
            --cambiamos el tipo de alerta a notificacion
               --las notificaciones pueden ser borradas por lo susuarios
               --mostramos la solucion
               
               select id_alarma into v_id_alarmas 
               from saj.tboleta b
               where id_boleta=v_parametros.id_boleta;
               
               update param.talarma set
               tipo ='notificacion',
               fecha = now(),
               descripcion ='La boleta fue ELIMINADA  ['||descripcion||']',
               id_usuario_mod = p_id_usuario,
               fecha_mod = now()
               where id_alarma = ANY (v_id_alarmas); 
               
           
               
           
            
            
            /* fin alarmas*/
            
            --verifica que no tengas boeltas renovadas
            
            if(select 1 from saj.tboleta b where b.id_boleta_fk =v_parametros.id_boleta) then
				raise exception 'La boleta que quiere eliminar ha sido renovada con anterioridad, no puede realizar esta acción';            
 			end if;
            
            
             --Sentencia de la eliminacion
             
             --eliminamos la relacion con las boletas
             /*update saj.tboleta set
             id_alarma = NULL
           --  estado_reg='inactiva'
             where id_boleta=v_parametros.id_boleta;*/
               
               
            delete from saj.tboleta
            where id_boleta=v_parametros.id_boleta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Boleta eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_boleta',v_parametros.id_boleta::varchar);
              
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