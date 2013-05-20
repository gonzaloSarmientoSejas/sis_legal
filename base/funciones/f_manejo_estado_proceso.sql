CREATE OR REPLACE FUNCTION saj.f_manejo_estado_proceso (
  p_id integer,
  p_tipo character varying,
  p_observaciones character varying,
  p_id_usuario integer,
  p_id_responsable integer
)
RETURNS varchar
AS 
$body$
/**************************************************************************
 FUNCION: 		f_manejo_estado_proceso
 DESCRIPCION:   maneja el estado del proceso de contratacion avanzando o retrocediendo
 
 AUTOR: 	    ENDE Mercedes Zambrana Meneces
 FECHA:	        
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES  
 DESCRIPCION:        en ves de utlizar id_Estado comollave foranea con la tabla estado se utiliza el codigo
 AUTOR:		ENDE Rensi Arteaga Copari
 FECHA:		5/12/2011
 ***********************************************************************************************/

DECLARE
  /*
  id: id_proceso_contrato
  tipo: avanzar/retroceder
  */
  v_estado_actual   varchar;
  v_estado_anterior varchar;
  v_num_orden       integer;  
  v_id_estado_nuevo integer;
  v_nombre_estado varchar;
  v_id_alarmas integer[];
  
BEGIN
       --0) obtenemos el estado actual del proceso_contrato
       SELECT 
          coalesce(e.orden,0) , ep.estado_vigente
       into 
          v_num_orden,         v_estado_anterior
       FROM saj.testado_proceso ep
       INNER JOIN saj.testado e ON e.codigo=ep.estado_vigente
       WHERE id_proceso_contrato=p_id 
             and ep.estado_reg='activo';
     
       v_num_orden:=coalesce(v_num_orden,0);
       
       --1)  si buscamos el estado siguiente
       if(p_tipo='siguiente') then
             --1.1) si el proceso no tiene estados obtenemos el primero
             if v_estado_anterior is NULL THEN
             
                     select id_estado,codigo , nombre
                        into 
                       v_id_estado_nuevo,v_estado_actual,v_nombre_estado
                     from saj.testado 
                     where orden=1
                     and estado_reg='activo';
                     
                     --raise exception 'anterior...........';
             

             ELSE
              --1.2) si es un estado mayor al primero
                    select id_estado ,codigo,nombre
                      into 
                          v_id_estado_nuevo,v_estado_actual,v_nombre_estado
                     from saj.testado 
                     where orden=v_num_orden+1 
                     and estado_reg='activo';
                         
                     if(v_id_estado_nuevo is null) then
                        raise exception 'No existe un estado siguiente';
                     end if;
                     
                --    raise exception 'auuuuuunterior...........  %  % % %',v_num_orden,v_estado_actual,v_estado_anterior,p_id;
               
             END IF;

        --2)  si buscamos el estado anterior 
       elsif(p_tipo='anterior') then

           if(v_num_orden=0 or  v_estado_anterior is NULL ) then
                raise exception 'Estado anterior inexistente';
           else    
                select 
                   id_estado,codigo, nombre
                into 
                   v_id_estado_nuevo,v_estado_actual,v_nombre_estado
                from saj.testado 
                where orden=v_num_orden-1 and orden>0
                and estado_reg='activo'; 
           end if;
           
     --3)  si buscamos un estado especial
       else --(p_tipo='anulado') then  
       
                select 
                   id_estado,codigo,nombre 
                into 
                   v_id_estado_nuevo,v_estado_actual,v_nombre_estado
                from saj.testado 
                where 
                  lower(codigo)=lower(p_tipo)  
                and
                  estado_reg='activo' limit 1;           
            
                if(v_id_estado_nuevo is null) then
                     raise exception 'Cambio de Estado no permitido';
                end if;
       end if;
        
    --4) inactivamos los estados anteriores
        
       update  saj.testado_proceso set 
         fecha_fin=now()::date ,
         observaciones= 'cambio estado de:'||v_estado_anterior||' a '|| v_estado_actual || ' - OBS: '||coalesce(p_observaciones,'NINGUNA'),
         id_usuario_mod=p_id_usuario,
         fecha_mod=now(),
       estado_reg='inactivo'       
       where estado_reg='activo'
       and id_proceso_contrato=p_id; 
       
       
      --5) insertamos un nuevo estado proceso      
       insert into saj.testado_proceso (estado_anterior,   estado_vigente,fecha_ini, fecha_reg, id_proceso_contrato, observaciones,    id_responsable_proceso, id_usuario_reg) 
       values                          (v_estado_anterior, v_estado_actual, now(),    now(),    p_id,                 p_observaciones, p_id_responsable,       p_id_usuario);
       
      
       
       
     
 
     
     -- 6) si el nuevo estado concluye el cotrato revisamos si tienes alarmas y  las desatvamos
     
     IF ( v_estado_actual='FINCON' and v_estado_anterior='REGCON')THEN
     
      --6.1 )  si el estado es de finalizacion del contrato 
      --      revisamos si tiene alarmas y las
      --      cambiamos a notificaciones  resetamos el id_alarma
                           
           select pc.id_alarma into v_id_alarmas 
           from saj.tproceso_contrato pc
           where pc.id_proceso_contrato=p_id;
                           
           update param.talarma set
           tipo ='notificacion',
           fecha = now(),
           descripcion ='El contrato fue Finalizado ['||descripcion||']',
           id_usuario_mod = p_id_usuario,
           fecha_mod = now()
           where id_alarma = ANY (v_id_alarmas);
           
      --6.2) actualizamos el estado del proceso_contrato     
         update saj.tproceso_contrato pc set
         estado_proceso = v_estado_actual,
         id_usuario_mod = p_id_usuario,
         fecha_mod = now(),
         id_alarma = NULL
         where id_proceso_contrato = p_id;
         
     ELSE  
      
         update saj.tproceso_contrato pc set
         estado_proceso = v_estado_actual,
         id_usuario_mod = p_id_usuario,
         fecha_mod = now()
         where id_proceso_contrato = p_id;     
   
     
     END IF;
     
        
       return 'exito';

END;
$body$
LANGUAGE plpgsql;