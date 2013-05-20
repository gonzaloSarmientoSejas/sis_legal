CREATE OR REPLACE FUNCTION saj.f_tproceso_contrato_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asesoria Juridica
 FUNCION: 		saj.f_tproceso_contrato_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'saj.tproceso_contrato'
 AUTOR: 		 (mzm)
 FECHA:	        16-11-2011 17:25:24
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
	v_id_proceso_contrato	integer;
	v_reg_estado_proceso    varchar;	
    v_accion                varchar; 
    v_num_req				varchar; 
    v_id_gestion 			integer;   
    v_id_abogado 			integer; 
    v_id_rep_legal 			integer; 
    v_id_alarmas integer[];        	    
BEGIN

    v_nombre_funcion = 'saj.f_tproceso_contrato_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SA_CONTRA_INS'
 	#DESCRIPCION:	Insercion de requerimeinto de contratos en estado borrador
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 17:25:24
   	#AUTOR_MOD:		mzm	
 	#DESCRIPCION_MOD:	obtiene numero de contrato
 	#FECHA_MOD:		1-12-2011 

	***********************************/

	if(p_transaccion='SA_CONTRA_INS')then
					
        begin 
        
        --0) Obtener numero de requerimiento en funcion del depto de legal
         v_num_req =  param.f_obtener_correlativo('RSAJ',NULL,NULL,v_parametros.id_depto,p_id_usuario,'SAJ',NULL);
                --raise exception 'aa%',v_num_req;
        --1)obtiene el identificador de la gestion 
        
         select g.id_gestion
         into v_id_gestion
         from param.tgestion g
         where g.estado_reg='activo' and g.gestion=to_char(now()::date,'YYYY')::integer;
          
        --2) obetner el reprsentante legal vigente   
        
        SELECT id_responsable_proceso
          into v_id_rep_legal  
        FROM  saj.tresponsable_proceso rp
        WHERE rp.estado_reg='activo' and rp.tipo ='rep_legal'
        LIMIT 1 OFFSET 0;
        

         
        --3) insertar solicitud de requerimietno en estado borrador
        	--Sentencia de la insercion
        	insert into saj.tproceso_contrato(
			--notario,
			--numero_oc,
			fecha_convocatoria,
			numero_requerimiento,
			--multas,
			id_modalidad,
			--fecha_aprobacion,
			fecha_fin,
			plazo,
			objeto_contrato,
			id_depto,
			--extension,
			--id_proyecto,
			forma_pago,
			--id_lugar_suscripcion,
			numero_cuce,
			--fecha_suscripcion,
			--testimonio,
			--monto_contrato,
			--numero_contrato,
			id_rpc,
			--id_alarma,
			--observaciones,
			id_proveedor,
			--origen_recursos,
			id_uo,
			id_representante_legal,
			id_tipo_contrato,
			--fecha_testimonio,
			--doc_contrato,
			id_supervisor,
			--beneficiario,
			--version,
			id_gestion,
			fecha_ini,
			--fecha_ap_acta,
			--id_oc,
			id_funcionario,
			id_moneda ,
            monto_contrato,
            id_usuario_reg,
			numero_licitacion
          	) values(
			--v_parametros.notario,
			--v_parametros.numero_oc,
			v_parametros.fecha_convocatoria,
			v_num_req,
			--v_parametros.multas,
			v_parametros.id_modalidad,
			--v_parametros.fecha_aprobacion,
			v_parametros.fecha_fin,
			v_parametros.plazo,
			v_parametros.objeto_contrato,
			v_parametros.id_depto,
			--v_parametros.extension,
			--v_parametros.id_proyecto,
			v_parametros.forma_pago,
			--v_parametros.id_lugar_suscripcion,
			v_parametros.numero_cuce,
			--v_parametros.fecha_suscripcion,
			--v_parametros.testimonio,
			--v_parametros.monto_contrato,
			--v_parametros.numero_contrato,
			v_parametros.id_rpc,
		--	v_parametros.id_alarma,
			--v_parametros.observaciones,
			v_parametros.id_proveedor,
			--v_parametros.origen_recursos,
			v_parametros.id_uo,
			v_id_rep_legal,
			v_parametros.id_tipo_contrato,
			--v_parametros.fecha_testimonio,
			--v_parametros.doc_contrato,
			v_parametros.id_supervisor,
			--v_parametros.beneficiario,
			--v_parametros.version,
			v_id_gestion,
			v_parametros.fecha_ini,
			--v_parametros.fecha_ap_acta,
			--v_parametros.id_oc,
			v_parametros.id_funcionario,
			v_parametros.id_moneda,
            v_parametros.monto_contrato,
            p_id_usuario,
			v_parametros.numero_licitacion
			)RETURNING id_proceso_contrato into v_id_proceso_contrato;
               
            
            --4) inserta el estado correpondiente al proceso es este caso el inicial
            raise notice 'actualiza el estado';
            v_reg_estado_proceso:=saj.f_manejo_estado_proceso(v_id_proceso_contrato,'siguiente','formulacion de requerimiento',p_id_usuario,null);
            
            
            if(v_reg_estado_proceso!='exito') then                 
	            raise exception 'Error con registro en estado proceso para id_proceso_contrato %', v_id_proceso_contrato;            
            end if;
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Contratacion almacenado(a) con exito (id_proceso_contrato'||v_id_proceso_contrato||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_contrato',v_id_proceso_contrato::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'SA_CONTRA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 17:25:24
	***********************************/

	elsif(p_transaccion='SA_CONTRA_MOD')then

		begin
			--Sentencia de la modificacion     
            
            if(pxp.f_existe_parametro(p_tabla,'operacion')) then      
              

              -- identificar el jefe de abogados vigente al entra al estado de asignacion
              --en otros casos agarra el id_abogado
              
              if(v_parametros.operacion!='anterior') then
                 v_accion:='siguiente';
              else            
                 v_accion:=v_parametros.operacion;
              end if;

            --operacion identifica al estado que se debe cambiar el proceso contrato       
            
            
              v_reg_estado_proceso:=saj.f_manejo_estado_proceso(v_parametros.id_proceso_contrato,v_accion,
              'cambio de estado a:'|| v_parametros.operacion,p_id_usuario,
              null);
              
              if(v_reg_estado_proceso!='exito') then
                 raise exception 'Problema con modificacion a registro';
              end if;
            
            else
            
            --raise exception 'xxxx';
               update saj.tproceso_contrato set
			        --  notario = v_parametros.notario,
			        --  numero_oc = v_parametros.numero_oc,
			          fecha_convocatoria = v_parametros.fecha_convocatoria,
			        --  numero_requerimiento = v_parametros.numero_requerimiento,
                    --  multas = v_parametros.multas,
                      id_modalidad = v_parametros.id_modalidad,
                    --  fecha_aprobacion = v_parametros.fecha_aprobacion,
                      fecha_fin = v_parametros.fecha_fin,
                      plazo = v_parametros.plazo,
                      objeto_contrato = v_parametros.objeto_contrato,
                      id_depto = v_parametros.id_depto,
                    --  extension = v_parametros.extension,
                    --  id_proyecto = v_parametros.id_proyecto,
                      forma_pago = v_parametros.forma_pago,
                    --  id_lugar_suscripcion = v_parametros.id_lugar_suscripcion,
                      numero_cuce = v_parametros.numero_cuce,
                    --  fecha_suscripcion = v_parametros.fecha_suscripcion,
                    --  testimonio = v_parametros.testimonio,
                      monto_contrato = v_parametros.monto_contrato,
                     -- numero_contrato = v_parametros.numero_contrato,
                      id_rpc = v_parametros.id_rpc,
                    --  id_alarma = v_parametros.id_alarma,
                   --   observaciones = v_parametros.observaciones,
                      id_proveedor = v_parametros.id_proveedor,
                    --  origen_recursos = v_parametros.origen_recursos,
                      id_uo = v_parametros.id_uo,
                     -- id_representante_legal = v_parametros.id_representante_legal,
                      id_tipo_contrato = v_parametros.id_tipo_contrato,
                    --  fecha_testimonio = v_parametros.fecha_testimonio,
                    --  doc_contrato = v_parametros.doc_contrato,
                      id_supervisor = v_parametros.id_supervisor,
                     -- beneficiario = v_parametros.beneficiario,
                     -- version = v_parametros.version,
                     -- id_gestion = v_parametros.id_gestion,
                      fecha_ini = v_parametros.fecha_ini,
                     -- fecha_ap_acta = v_parametros.fecha_ap_acta,
                     -- id_oc = v_parametros.id_oc,
                      id_funcionario = v_parametros.id_funcionario,
                      id_moneda = v_parametros.id_moneda,
                      numero_licitacion = v_parametros.numero_licitacion,
                       id_usuario_mod = p_id_usuario,
                       fecha_mod = now()
                      where id_proceso_contrato=v_parametros.id_proceso_contrato;
               end if;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Contratacion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_contrato',v_parametros.id_proceso_contrato::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;
        
    /*********************************    
 	#TRANSACCION:  'SA_CAMEST_MOD'
 	#DESCRIPCION:	Cambia estados del proceso contrato
 	#AUTOR:		mzm	
 	#FECHA:		16-11-2011 17:25:24
	***********************************/

	elsif(p_transaccion='SA_CAMEST_MOD')then

		begin
			-- identificar el jefe de abogados vigente al entra al estado de asignacion
              --en otros casos agarra el id_abogado
              
              if(v_parametros.operacion!='anterior') then
                 v_accion:='siguiente';
              else            
                 v_accion:=v_parametros.operacion;
              end if;
              
              
              
              IF(pxp.f_existe_parametro(p_tabla,'id_abogado')) then      
                   v_id_abogado=v_parametros.id_abogado;
              ELSE
	              v_id_abogado = NULL;
              END IF;
              
              --operacion identifica al estado que se debe cambiar el proceso contrato       
              v_reg_estado_proceso:=saj.f_manejo_estado_proceso(v_parametros.id_proceso_contrato,v_accion,
              'cambio de estado a:'|| v_parametros.operacion,p_id_usuario,
              v_id_abogado);
              
              if(v_reg_estado_proceso!='exito') then
                 raise exception 'Problema con el cambio de estado del proceso';
              end if;
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Contratacion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_contrato',v_parametros.id_proceso_contrato::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end; 
        
        
	/*********************************    
 	#TRANSACCION:  'SA_CONELA_MOD'
 	#DESCRIPCION:	Modificacionde contratos en elaboración
 	#AUTOR:		rac	
 	#FECHA:		20-12-2011 17:25:24
	***********************************/
        
        elsif(p_transaccion='SA_CONELA_MOD')then

		begin
			--Sentencia de la modificacion     
            
           
               update saj.tproceso_contrato set
			          notario = v_parametros.notario,
			          --numero_oc = v_parametros.numero_oc,
			          fecha_convocatoria = v_parametros.fecha_convocatoria,
			        --  numero_requerimiento = v_parametros.numero_requerimiento,
                    --  multas = v_parametros.multas,
                      id_modalidad = v_parametros.id_modalidad,
                    --  fecha_aprobacion = v_parametros.fecha_aprobacion,
                      fecha_fin = v_parametros.fecha_fin,
                      plazo = v_parametros.plazo,
                      objeto_contrato = v_parametros.objeto_contrato,
                    --  id_depto = v_parametros.id_depto,
                    --  extension = v_parametros.extension,
                    --  id_proyecto = v_parametros.id_proyecto,
                      forma_pago = v_parametros.forma_pago,
                    --  id_lugar_suscripcion = v_parametros.id_lugar_suscripcion,
                      numero_cuce = v_parametros.numero_cuce,
                      fecha_suscripcion = v_parametros.fecha_suscripcion,
                    --  testimonio = v_parametros.testimonio,
                      monto_contrato = v_parametros.monto_contrato,
                      numero_contrato = v_parametros.numero_contrato,
                      id_rpc = v_parametros.id_rpc,
                    --  id_alarma = v_parametros.id_alarma,
                      observaciones = v_parametros.observaciones,
                      id_proveedor = v_parametros.id_proveedor,
                    --  origen_recursos = v_parametros.origen_recursos,
                    --  id_uo = v_parametros.id_uo,
                      id_representante_legal = v_parametros.id_representante_legal,
                      id_tipo_contrato = v_parametros.id_tipo_contrato,
                    --  fecha_testimonio = v_parametros.fecha_testimonio,
                    --  doc_contrato = v_parametros.doc_contrato,
                      id_supervisor = v_parametros.id_supervisor,
                     -- beneficiario = v_parametros.beneficiario,
                     -- version = v_parametros.version,
                     -- id_gestion = v_parametros.id_gestion,
                      fecha_ini = v_parametros.fecha_ini,
                     -- fecha_ap_acta = v_parametros.fecha_ap_acta,
                     -- id_oc = v_parametros.id_oc,
                    -- id_funcionario = v_parametros.id_funcionario,
                      id_moneda = v_parametros.id_moneda,
                      numero_licitacion = v_parametros.numero_licitacion,
                       id_usuario_mod = p_id_usuario,
                        fecha_mod = now()::date
                      where id_proceso_contrato=v_parametros.id_proceso_contrato;
             
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Contratacion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_contrato',v_parametros.id_proceso_contrato::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end; 
        
        
     
     /*********************************    
 	#TRANSACCION:  'SA_ARCHCON_MOD'
 	#DESCRIPCION:	Actualiza datos del archivo escaneado
 	#AUTOR:		rac	
 	#FECHA:		16-12-2011 17:25:24
	***********************************/

	elsif(p_transaccion='SA_ARCHCON_MOD')then

		begin
        
        --raise exception 'VERSION %',v_parametros.version;
          
           update saj.tproceso_contrato set
           extension = v_parametros.extension,
           doc_contrato = v_parametros.doc_contrato,
           version = v_parametros.version,
           id_usuario_mod = p_id_usuario,
           fecha_mod = now()
           where id_proceso_contrato=v_parametros.id_proceso_contrato;
            
            --Definicion de la respuesta
           v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo escaneado de contrato modificado(a)'); 
           v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_contrato',v_parametros.id_proceso_contrato::varchar);
               
            --Devuelve la respuesta
           return v_resp;
            
        end; 
  
        
    /*********************************    
 	#TRANSACCION:  'SA_CONASIG_MOD'
 	#DESCRIPCION:	Modificacion de contratos desde la pantalla de asignacion
 	#AUTOR:		rac	
 	#FECHA:		13-12-2011 17:25:24
	***********************************/

	elsif(p_transaccion='SA_CONASIG_MOD')then

		begin
			--Sentencia de la modificacion   
            
            --raise exception 'v_parametros.numero_contrato %',v_parametros.numero_contrato;  
           
                   update saj.tproceso_contrato set
			          notario = v_parametros.notario,
			        --  numero_oc = v_parametros.numero_oc,
			          fecha_convocatoria = v_parametros.fecha_convocatoria,
			        --  numero_requerimiento = v_parametros.numero_requerimiento,
                    --  multas = v_parametros.multas,
                      id_modalidad = v_parametros.id_modalidad,
                    --  fecha_aprobacion = v_parametros.fecha_aprobacion,
                      fecha_fin = v_parametros.fecha_fin,
                      plazo = v_parametros.plazo,
                    --  objeto_contrato = v_parametros.objeto_contrato,
                    --  id_depto = v_parametros.id_depto,
                    --  extension = v_parametros.extension,
                    --  id_proyecto = v_parametros.id_proyecto,
                      forma_pago = v_parametros.forma_pago,
                    --  id_lugar_suscripcion = v_parametros.id_lugar_suscripcion,
                      numero_cuce = v_parametros.numero_cuce,
                     fecha_suscripcion = v_parametros.fecha_suscripcion,
                    --  testimonio = v_parametros.testimonio,
                      monto_contrato = v_parametros.monto_contrato,
                      numero_contrato = v_parametros.numero_contrato,
                      id_rpc = v_parametros.id_rpc,
                    --  id_alarma = v_parametros.id_alarma,
                      observaciones = v_parametros.observaciones,
                      id_proveedor = v_parametros.id_proveedor,
                    --  origen_recursos = v_parametros.origen_recursos,
                    --  id_uo = v_parametros.id_uo,
                     -- id_representante_legal = v_parametros.id_representante_legal,
                      id_tipo_contrato = v_parametros.id_tipo_contrato,
                    --  fecha_testimonio = v_parametros.fecha_testimonio,
                    --  doc_contrato = v_parametros.doc_contrato,
                      id_supervisor = v_parametros.id_supervisor,
                     -- beneficiario = v_parametros.beneficiario,
                     -- version = v_parametros.version,
                     -- id_gestion = v_parametros.id_gestion,
                      fecha_ini = v_parametros.fecha_ini,
                     -- fecha_ap_acta = v_parametros.fecha_ap_acta,
                     -- id_oc = v_parametros.id_oc,
                     -- id_funcionario = v_parametros.id_funcionario,
                      id_moneda = v_parametros.id_moneda,
                      numero_licitacion = v_parametros.numero_licitacion,
                       id_usuario_mod = p_id_usuario,
                       fecha_mod = now()
                      where id_proceso_contrato=v_parametros.id_proceso_contrato;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Contratacion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_contrato',v_parametros.id_proceso_contrato::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
          end; 
        

    /*********************************    
     #TRANSACCION:  'SA_CONTRA_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        mzm    
     #FECHA:        16-11-2011 17:25:24
    ***********************************/

    elsif(p_transaccion='SA_CONTRA_ELI')then

        begin               
            
             v_reg_estado_proceso:=saj.f_manejo_estado_proceso(v_parametros.id_proceso_contrato,'ANULADO','anulacion de proceso contrato',p_id_usuario,null);
              
            if(v_reg_estado_proceso!='exito') then
                 raise exception 'Error con anulacion de proceso';
            end if;
            
            --verifica si el contrato tiene alarmas
            
             select pc.id_alarma into v_id_alarmas 
             from saj.tproceso_contrato pc
             where pc.id_proceso_contrato=v_parametros.id_proceso_contrato;
                           
             update param.talarma set
             tipo ='notificacion',
             fecha = now(),
             descripcion ='El contrato fue Eliminado ['||descripcion||']',
             id_usuario_mod = p_id_usuario,
             fecha_mod = now()
             where id_alarma = ANY (v_id_alarmas);
           
        
              
            --Sentencia de la eliminacion
            update saj.tproceso_contrato
            set estado_reg='inactivo',
            fecha_mod=now(),
            id_alarma = NULL,
            id_usuario_mod=p_id_usuario
            where id_proceso_contrato=v_parametros.id_proceso_contrato;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Contratacion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_contrato',v_parametros.id_proceso_contrato::varchar);
              
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