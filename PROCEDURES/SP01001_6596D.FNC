CREATE OR REPLACE function RCREDITO.sp01001_6596d  (pa_paisant    number ,
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
Descripcion:  REFUNDICION DE CLIENTES MAZ  -- actualiza CENLINEADECREDITO 
 



rcredito.tarecredctetda_pcj
rcredito.tarecredcteuped_pcj
rcredito.tarecredlineacr_pcj
rcredito.tarefundircumaz_pcj
*************************************************************************************************************/
vl_0     number := 0 ;
vl_1     number := 1 ;     
vl_error number := 0 ;
vl_valid number;
vl_user  varchar2(10) := '6596d';


begin


          select count (1)
              into vl_valid
             from RCREDITO.CENLINEADECREDITO  
             where  fipais        =  pa_paisnvo
                 and  ficanal      =  pa_canalnvo
                 and  fisucursal  =  pa_sucursalnvo
                 and  fifolio        =  pa_folionvo ;
                 
    if vl_valid > vl_0 then  --  si existe nuevo cu 


          for cur_reg in (

                    select FIPAIS           ,
                              FICANAL        ,
                              FISUCURSAL      ,
                              FIFOLIO          ,
                              FIPAISGESTOR     ,
                              FICANALGESTOR     ,
                              FISUCURSALGESTORA  ,
                              FISTATUS           ,
                              FDFECHAALTA        ,
                              FDFECHAACT         ,
                              FINGCIOID          ,
                              FINOTIENDA         ,
                              FICTEID            ,
                              FIDIGITOVER        ,
                              FISTSCU                    
                   from rcredito.CENLINEADECREDITO ct
                  where fipais         = pa_paisant
                      and ficanal       = pa_canalant
                      and fisucursal   = pa_sucursalant
                      and fifolio         = pa_folioant  )
                      
             loop
             
                 
                  
                INSERT INTO rcredito.tarecenlineacre
                                                            (FIPAIS,
                                                              FICANAL,
                                                              FISUCURSAL,
                                                              FIFOLIO,
                                                              FIPAISGESTOR,
                                                              FICANALGESTOR,
                                                              FISUCURSALGESTORA,
                                                              FISTATUS,
                                                              FDFECHAALTA,
                                                              FDFECHAACT,
                                                              FINGCIOID,
                                                              FINOTIENDA,
                                                              FICTEID,
                                                              FIDIGITOVER,
                                                              FISTSCU,
                                                              FISUCURSALTRANF,
                                                              FITRANNOF,
                                                              FECULTACT,
                                                              EMPULTACT)
                                               VALUES ( cur_reg.FIPAIS,
                                                             cur_reg.FICANAL,
                                                             cur_reg.FISUCURSAL,
                                                             cur_reg.FIFOLIO,
                                                             cur_reg.FIPAISGESTOR,
                                                             cur_reg.FICANALGESTOR,
                                                             cur_reg.FISUCURSALGESTORA,
                                                             cur_reg.FISTATUS,
                                                             cur_reg.FDFECHAALTA,
                                                             cur_reg.FDFECHAACT,
                                                             cur_reg.FINGCIOID,
                                                             cur_reg.FINOTIENDA,
                                                             cur_reg.FICTEID,
                                                             cur_reg.FIDIGITOVER,
                                                             cur_reg.FISTSCU,
                                                             pa_suctran,  
                                                             pa_tranno,
                                                             sysdate,  
                                                             vl_user);
             
                        delete
                         from  rcredito.CENLINEADECREDITO
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


GRANT EXECUTE ON  RCREDITO.sp01001_6596D  TO USRBATCH, USRRCACT;