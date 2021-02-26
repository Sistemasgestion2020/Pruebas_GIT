CREATE OR REPLACE function RCREDITO.sp01001_6596E  (pa_paisant    number ,
                                                                       pa_canalant   number ,
                                                                       pa_sucursalant number ,
                                                                       pa_folioant   number ,
                                                                       pa_paisnvo  number , 
                                                                       pa_canalnvo number , 
                                                                       pa_sucursalnvo number ,
                                                                       pa_folionvo number ,
                                                                       Pa_suctran number,
                                                                       pa_tranno number
                                                                       )
return number 
is
/*************************************************************************************************************
Proyecto:  Sistema Regional de Crédito - Actualizador.
Descripcion:  REFUNDICION DE CLIENTES MAZ  -- actualiza RCREDITO.CREDCLIENTETIENDA 
 

rcredito.tarecencteunico_pcj
rcredito.tarecenlineacre_pcj

rcredito.tarecredcteuped_pcj
rcredito.tarecredlineacr_pcj
rcredito.tarefundircumaz_pcj
*************************************************************************************************************/
vl_1     number := 1 ;     
vl_error number := 0 ;
vl_user  varchar2(10) := '6596e';


begin


  FOR cur_reg IN (

        SELECT FIPAISID,
                    FICANALID,
                    FISUCURSALID,
                    FIIDNEGOCIO,
                    FIIDTIENDA,
                    FIIDCLIENTE,
                    FIPAIS,
                    FICANAL,
                    FISUCURSAL,
                    FIFOLIO
           FROM RCREDITO.CREDCLIENTETIENDA
          WHERE FIPAIS         = pa_paisant
              AND FICANAL       = pa_canalant
              AND FISUCURSAL = pa_sucursalant
              AND FIFOLIO        = pa_folioant   )
              
     LOOP 
     
            insert into rcredito.tarecredctetda  (FIPAISID, FICANALID, FISUCURSALID, 
                                                                    FIIDNEGOCIO, FIIDTIENDA, FIIDCLIENTE, 
                                                                    FIPAIS, FICANAL, FISUCURSAL, FIFOLIO, 
                                                                    FISUCURSALTRANF, FITRANNOF, 
                                                                    FECULTACT, EMPULTACT)
                                                    values     ( cur_reg.FIPAISID,
                                                                    cur_reg.FICANALID,
                                                                    cur_reg.FISUCURSALID,
                                                                    cur_reg.FIIDNEGOCIO,
                                                                    cur_reg.FIIDTIENDA,
                                                                    cur_reg.FIIDCLIENTE,
                                                                    cur_reg.FIPAIS,
                                                                    cur_reg.FICANAL,
                                                                    cur_reg.FISUCURSAL,
                                                                    cur_reg.FIFOLIO,
                                                                    Pa_suctran,  pa_tranno,
                                                                    sysdate,  vl_user       
                                                                    );
     
            update RCREDITO.CREDCLIENTETIENDA
                set   fipais       = pa_paisnvo,
                       ficanal      = pa_canalnvo,
                       fisucursal  =  pa_sucursalnvo,
                       fifolio       =  pa_folionvo
             where FIPAISID         = cur_reg.FIPAISID
                and FICANALID       =  cur_reg.FICANALID 
                and FISUCURSALID = cur_reg.FISUCURSALID
                and FIIDNEGOCIO    =  cur_reg.FIIDNEGOCIO
                and FIIDTIENDA      = cur_reg.FIIDTIENDA
                and FIIDCLIENTE     = cur_reg.FIIDCLIENTE   ;    
     
     
     END LOOP ;         
              
              return  vl_error;
                               
                       
exception when others then 

RCREDITO.SPREGISTRAERROR (SYSDATE,SQLCODE,SQLERRM,vl_user); 

vl_error := vl_1;

return  vl_error;                                   

end;
/

GRANT EXECUTE ON  RCREDITO.sp01001_6596E  TO USRBATCH, USRRCACT;
