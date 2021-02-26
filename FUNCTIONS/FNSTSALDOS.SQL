CREATE OR REPLACE FUNCTION RCREDITO.FNSTSALDOS(
  pa_Sucursal NUMBER,
  pa_Pedido   NUMBER)

RETURN SYS_REFCURSOR
IS

rcl_resultado  SYS_REFCURSOR;

vl_stat  NUMBER(5):=0;
vl_saldo NUMBER(12,2):=0;

vl_Pais NUMBER(4):=1;
vl_Canal NUMBER:=0;

csl_0    CONSTANT NUMBER:=0;

--Principal
BEGIN

 BEGIN
   SELECT FICANALID
      INTO vl_Canal
      FROM RCREDITO.TIENDA_CR
    WHERE FIPAISID = vl_Pais
     AND FISUCURSAL = pa_Sucursal;
 EXCEPTION 
   WHEN NO_DATA_FOUND THEN
          vl_Canal:=csl_0;
 END;

 IF vl_Canal > csl_0 THEN
   BEGIN
     SELECT FIPEDSTATUS, FNSALDO
        INTO vl_stat, vl_saldo
       FROM RCREDITO.PEDIDOS_CREDITO
      WHERE FIPAISID = vl_Pais
        AND FICANAL = vl_Canal
        AND FISUCURSAL = pa_Sucursal
        AND FINOPEDIDO = pa_Pedido;
   EXCEPTION 
     WHEN NO_DATA_FOUND THEN
         BEGIN
           SELECT FIPEDSTATUS, FNSALDO
              INTO vl_stat, vl_saldo
             FROM RCREDITO.PEDIDOS_CREDITO_HIST
            WHERE FIPAISID = vl_Pais
              AND FICANAL = vl_Canal
              AND FISUCURSAL = pa_Sucursal
              AND FINOPEDIDO = pa_Pedido;
         EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                   vl_stat:=csl_0;
                   vl_saldo:=csl_0;
         END;
   END;
 
 END IF;

 OPEN rcl_resultado FOR
    
    SELECT vl_stat AS stat,
           vl_saldo AS saldo
      FROM DUAL;

  RETURN rcl_resultado;     
  
END FNSTSALDOS;

GRANT EXECUTE ON RCREDITO.FNSTSALDOS TO RCACT,USRWEB,USRCREDITO;
