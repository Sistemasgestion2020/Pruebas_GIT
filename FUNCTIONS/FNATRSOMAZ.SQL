CREATE OR REPLACE FUNCTION RCREDITO.FNATRSOMAZ(
  pa_Pais      NUMBER,
  pa_Canal     NUMBER,
  pa_Sucursal  NUMBER,
  pa_Folio     NUMBER)
  
RETURN SYS_REFCURSOR
IS

rcl_resultado  SYS_REFCURSOR;

vl_CanPed  NUMBER:=0;
vl_SucPed  NUMBER:=0;
vl_Pedido  NUMBER:=0;
vl_FlagMaz NUMBER:=0;

csl_0    CONSTANT NUMBER:=0;
csl_1    CONSTANT NUMBER:=1;
csl_2    CONSTANT NUMBER:=2;
csl_51   CONSTANT NUMBER:=51;


CURSOR cur_BuscaPed
IS
SELECT ped.FICANAL, ped.FISUCURSAL, ped.FINOPEDIDO,
        ped.FNSALDO
FROM RCREDITO.CENCLIENTETIENDA cen
INNER JOIN RCREDITO.PEDIDOS_CREDITO ped
 ON ped.FINGCIOID  = cen.FINGCIOID
AND ped.FINOTIENDA = cen.FINOTIENDA
AND ped.FICTEID    = cen.FICTEID
AND ped.FIDIGITOVER= cen.FIDIGITOVER
WHERE cen.FIPAIS    = pa_Pais
  AND cen.FICANAL   = pa_Canal
  AND cen.FISUCURSAL= pa_Sucursal
  AND cen.FIFOLIO   = pa_folio
  AND ped.FICANAL = csl_51 
  AND ped.FIPEDSTATUS = csl_1;


BEGIN
    
 FOR pd IN cur_BuscaPed LOOP
   IF pd.FNSALDO > csl_0 THEN
       vl_FlagMaz:= csl_2;
       vl_CanPed:=pd.FICANAL;
       vl_SucPed:=pd.FISUCURSAL;
       vl_Pedido:=pd.FINOPEDIDO;
       EXIT;
   ELSIF pd.FNSALDO = csl_0 THEN
       vl_FlagMaz:= csl_1;
   END IF;
 END LOOP;


 OPEN rcl_resultado FOR
    
    SELECT vl_FlagMaz AS Flag,
           vl_CanPed  AS Canal,
           vl_SucPed  AS Sucursal,
           vl_Pedido  AS pedido
      FROM DUAL;
 
  RETURN rcl_resultado;     
  
END FNATRSOMAZ;


GRANT EXECUTE ON RCREDITO.FNATRSOMAZ TO USRWEB,USRCREDITO;