CREATE OR REPLACE function RCREDITO.sp01001_6596c  (pa_paisant    number ,
                                                                       pa_canalant   number ,
                                                                       pa_sucursalant number ,
                                                                       pa_folioant   number ,
                                                                       pa_paisnvo  number , 
                                                                       pa_canalnvo number , 
                                                                       pa_sucursalnvo number ,
                                                                       pa_folionvo number ,
                                                                       pa_suctran number,
                                                                       pa_tranno number
                                                                       )
return number 
is
/*************************************************************************************************************
Proyecto:  Sistema Regional de Crédito - Actualizador.
Descripcion:  REFUNDICION DE CLIENTES MAZ  -- actualiza cenclienteunico 
 


rcredito.tarecenlineacre_pcj
rcredito.tarecredctetda_pcj
rcredito.tarecredcteuped_pcj
rcredito.tarecredlineacr_pcj
rcredito.tarefundircumaz_pcj
*************************************************************************************************************/
vl_0     number := 0 ;
vl_1     number := 1 ;     
vl_error number := 0 ;
vl_valid number;
vl_user  varchar2(10) := '6596c';


begin


          select count (1)
              into vl_valid
             from rcredito.cenclienteunico  
             where  fipais        =  pa_paisnvo
                 and  ficanal      =  pa_canalnvo
                 and  fisucursal  =  pa_sucursalnvo
                 and  fifolio        =  pa_folionvo ;
                 
    if vl_valid > vl_0 then  --  si existe nuevo cu 


          for cur_reg in (

                    select  fipais                ,
                              ficanal           ,
                              fisucursal         ,
                              fifolio             ,
                              fcidbiometrico       ,
                              fctarjeta             ,
                              fitranno               ,
                              fitipotarjeta          ,
                              fdalta                ,
                              fistatus               ,
                              fcnombreentarjeta      ,
                              fipaisd                ,
                              ficanald               ,
                              fisucursald            ,
                              fitipoidentificacion  ,
                              fcfolioidentificacion  ,
                              fcclaveregistro        ,
                              fccurp                 ,
                              finacionalidad         ,
                              fcmail                 ,
                              fclada                 ,
                              fcextension            
                   from rcredito.cenclienteunico ct
                  where fipais         = pa_paisant
                      and ficanal       = pa_canalant
                      and fisucursal   = pa_sucursalant
                      and fifolio         = pa_folioant  )
                      
             loop
             
             
                  
             
                    insert into rcredito.tarecencteunico  (fipais, ficanal, fisucursal, fifolio, 
                                                                               fcidbiometrico, fctarjeta, fitranno, 
                                                                               fitipotarjeta, fdalta, fistatus, fcnombreentarjeta, 
                                                                               fipaisd, ficanald, fisucursald, fitipoidentificacion, 
                                                                               fcfolioidentificacion, fcclaveregistro, fccurp, 
                                                                               finacionalidad, fcmail, fclada, fcextension, 
                                                                               fisucursaltranf, fitrannof, fecultact, empultact)
                                                            values     (   cur_reg.fipais, cur_reg.ficanal, cur_reg.fisucursal, cur_reg.fifolio, 
                                                                               cur_reg.fcidbiometrico, cur_reg.fctarjeta, cur_reg.fitranno, 
                                                                               cur_reg.fitipotarjeta, cur_reg.fdalta, cur_reg.fistatus, cur_reg.fcnombreentarjeta, 
                                                                               cur_reg.fipaisd, cur_reg.ficanald, cur_reg.fisucursald, cur_reg.fitipoidentificacion, 
                                                                               cur_reg.fcfolioidentificacion, cur_reg.fcclaveregistro, cur_reg.fccurp, 
                                                                               cur_reg.finacionalidad, cur_reg.fcmail, cur_reg.fclada, cur_reg.fcextension, 
                                                                               pa_suctran,  pa_tranno,sysdate,  vl_user       
                                                                            );
             
                        delete
                         from  rcredito.cenclienteunico
                         where fipais           =  cur_reg.fipais
                            and  ficanal         =  cur_reg.ficanal 
                            and  fisucursal     =  cur_reg.fisucursal
                            and fifolio             = cur_reg.fifolio;
                        
             end loop ;       
                  
                  
    end if;                
              
              return  vl_error;
                               
                       
exception when others then

RCREDITO.SPREGISTRAERROR (SYSDATE,SQLCODE,SQLERRM,vl_user); 

vl_error := vl_1;

return  vl_error;                                   

end;
/


GRANT EXECUTE ON  RCREDITO.sp01001_6596C  TO USRBATCH, USRRCACT;