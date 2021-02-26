CREATE OR REPLACE FUNCTION RCREDITO.FNATRZTAZ(
  pa_pais        NUMBER,
  pa_canal       NUMBER,
  pa_sucursal    NUMBER,
  pa_folio       NUMBER)
  
RETURN SYS_REFCURSOR
IS

rcl_resultado SYS_REFCURSOR;

vl_Status    VARCHAR2(2):='00';

vl_wStatSol  NUMBER(5):=0;
vl_FitirVal  NUMBER(5):=0;
vl_CredInmd  NUMBER(5):=0;
vl_StatInv   NUMBER(5):=0;
vl_exis120   NUMBER(5):=0;

vl_c00       VARCHAR2(2):='00';
vl_c01       VARCHAR2(2):='01';
vl_c02       VARCHAR2(2):='02';
vl_c03       VARCHAR2(2):='03';
vl_c04       VARCHAR2(2):='04';
vl_c05       VARCHAR2(2):='05';

csl_0    CONSTANT NUMBER:=0;
csl_1    CONSTANT NUMBER:=1;
csl_2    CONSTANT NUMBER:=2;
csl_6    CONSTANT NUMBER:=6;
csl_9    CONSTANT NUMBER:=9;
csl_11   CONSTANT NUMBER:=11;
csl_120  CONSTANT NUMBER:=120;
csl_180  CONSTANT NUMBER:=180;
csl_186  CONSTANT NUMBER:=186;
csl_188  CONSTANT NUMBER:=188;
csl_238  CONSTANT NUMBER:=238;

CURSOR cur_SolicCte
IS
SELECT sol.FIPAISID, sol.FICANALID, sol.FISUCURSALID, sol.FISOLICITUDID,
       sol.FITIPOSOLICITUD, sol.FISTAT, 
       sol.FIIDNEGOCIO, sol.FIIDTIENDA, sol.FIIDCLIENTE,
       sol.FDFECSOL       
  FROM RCREDITO.CREDCLIENTETIENDA tda
 INNER JOIN RCREDITO.CREDSOLICITUD sol
  ON sol.FIPAISID   = tda.FIPAISID
 AND sol.FICANALID   = tda.FICANALID
 AND sol.FISUCURSALID= tda.FISUCURSALID
 AND sol.FIIDNEGOCIO = tda.FIIDNEGOCIO
 AND sol.FIIDTIENDA  = tda.FIIDTIENDA
 AND sol.FIIDCLIENTE = tda.FIIDCLIENTE
 WHERE tda.FIPAIS    = pa_pais
   AND tda.FICANAL   = pa_canal
   AND tda.FISUCURSAL= pa_sucursal
   AND tda.FIFOLIO   = pa_folio;
  
CURSOR cur_CredInv(
      pa_PaisS     NUMBER,
      pa_CanalS    NUMBER,
      pa_SucSol    NUMBER,
      pa_Solicitud NUMBER)
IS   
SELECT FIINVESTSTAT
FROM RCREDITO.TACRCREDINVESTIGACION
WHERE FIPAIS =  pa_PaisS
  AND FICANAL =  pa_CanalS
  AND FISUCURSAL = pa_SucSol
  AND FISOLICITUDID= pa_Solicitud
  AND FIINVESTSTAT IN (csl_180,csl_186,csl_188);

--Principal
BEGIN

 FOR sl IN cur_SolicCte LOOP
  vl_CredInmd:=csl_0;
  vl_FitirVal:=csl_0;
  
  IF sl.FITIPOSOLICITUD = csl_238 AND vl_wStatSol = csl_0 THEN
   IF sl.FISTAT = csl_6 THEN
     vl_wStatSol:= csl_1;
   ELSIF sl.FISTAT = csl_9 THEN
     vl_wStatSol:= csl_2;
   END IF;
  END IF;
  
   SELECT COUNT(csl_1)
       INTO vl_FitirVal
      FROM RCREDITO.TACONTROLPARM
    WHERE FIITEM=csl_11
      AND FISUBITEM =sl.FITIPOSOLICITUD;
  
  IF  vl_FitirVal > csl_0 THEN
  
     SELECT COUNT(csl_1)
       INTO vl_CredInmd
      FROM RCREDITO.TACRCREDINVESTIGACION
     WHERE FIPAIS = sl.FIPAISID
       AND FICANAL = sl.FICANALID
       AND FISUCURSAL = sl.FISUCURSALID
       AND FISOLICITUDID=sl.FISOLICITUDID
       AND FIINVESTSTAT= csl_120;

     IF vl_CredInmd > csl_0 THEN
        vl_exis120:= csl_1;
       FOR inv IN cur_CredInv (sl.FIPAISID,sl.FICANALID,sl.FISUCURSALID,sl.FISOLICITUDID) LOOP
         vl_StatInv:=inv.FIINVESTSTAT;
       END LOOP; 
     END IF;
     
  END IF;
 END LOOP; 

 IF vl_wStatSol = csl_1 THEN
    vl_Status:=vl_c00;
 ELSIF vl_wStatSol = csl_2 THEN
    vl_Status:=vl_c01;
 END IF;

 IF vl_wStatSol = csl_0 AND vl_exis120 > csl_0 THEN
   IF vl_StatInv = csl_188 THEN
     vl_Status:=vl_c02;
   ELSIF vl_StatInv = csl_186 THEN
     vl_Status:=vl_c03;
   ELSIF vl_StatInv = csl_180 THEN
     vl_Status:=vl_c04;
   ELSE
     vl_Status:=vl_c05;
   END IF;
 END IF;  
  
 OPEN rcl_resultado FOR
   SELECT vl_Status AS Status  FROM DUAL;

 RETURN rcl_resultado;
 
EXCEPTION
 WHEN OTHERS THEN
 
   OPEN rcl_resultado FOR
    SELECT vl_c00 AS Status  FROM DUAL;

   RETURN rcl_resultado;

END FNATRZTAZ;

