CREATE OR REPLACE FUNCTION RCREDITO.FNSTCENCRE (pa_pais NUMBER,
                                                pa_canal NUMBER,
                                                pa_sucursal NUMBER,
                                                pa_folio NUMBER)
                                                 
return sys_refcursor
IS
rcl_refcursor sys_refcursor;
csl_0 number(5) := 0;
csl_2 number(5) := 2;
csl_200 number(5) := 200;
VL_ERRORES   NUMBER;
vl_proceso VARCHAR2(30) := 'FNSTCENCRE';

BEGIN

OPEN rcl_refcursor FOR 

    SELECT B.FISTATUS AS STATUSCENLINEA
        , A.FISTATUS AS STATUSCREDLINEA
        , A.FILISTANEGRA
        , A.FILOCALIZACION
        , A.FIRMD
        , A.FILEGAL
        , A.FIDIFICILCOBRO
        , A.FIACEPTAPP
        , A.FIDIAPAGOUNICO
        , A.FIPCJ
        FROM RCREDITO.CREDLINEADECREDITO A 
        JOIN RCREDITO.CENLINEADECREDITO B
           ON A.FIPAIS     = B.FIPAIS
          AND A.FICANAL    = B.FICANAL
          AND A.FISUCURSAL = B.FISUCURSAL
          AND A.FIFOLIO    = B.FIFOLIO
        WHERE A.FIPAIS     = PA_PAIS
          AND A.FICANAL    = PA_CANAL
          AND A.FISUCURSAL = PA_SUCURSAL
          AND A.FIFOLIO    = PA_FOLIO ;

        RETURN rcl_refcursor;
     
   EXCEPTION
   WHEN OTHERS THEN
     VL_ERRORES := RCREDITO.FNLOGERROR_CREDITO(TRUNC(SYSDATE),
                                                  TO_CHAR(SYSDATE,'HH:MI:SS'),
                                                  TO_CHAR(SYSDATE,'HH:MI:SS'),
                                                  vl_proceso,
                                                  sqlcode, 
                                                  SUBSTR(SQLERRM,csl_0,csl_200),
                                                  csl_2,
                                                  csl_0,
                                                  csl_2); 

END FNSTCENCRE;