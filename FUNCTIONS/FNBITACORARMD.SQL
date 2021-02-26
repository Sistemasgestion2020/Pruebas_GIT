CREATE OR REPLACE FUNCTION RCREDITO.FNBITACORARMD
(
  PA_PUESTO RCREDITO.TABITACORARMD.FIPUESTO%TYPE,
  PA_EMPLEADO RCREDITO.TABITACORARMD.FCEMPNUM%TYPE
)
RETURN SYS_REFCURSOR
IS

vl_msgConf VARCHAR2(20):='Registro insertado';
csl_0  constant pls_integer:=0;
csl_1  constant pls_integer:=1;
vl_msgErr      VARCHAR2(25):= 'Error al Registrar';
rcl_resultado SYS_REFCURSOR;
vl_User   VARCHAR2(25):='FNBITACORARMD';


BEGIN

begin
insert into RCREDITO.TABITACORARMD (FIPUESTO,
                                    FCEMPNUM,
                                    FDFECHA,
                                    FDULTIMA_MODIFICACION,
                                    FCUSUARIO_MODIFICO
                                   )
                                   values(
                                   PA_PUESTO,
                                   PA_EMPLEADO,
                                   sysdate,
                                   sysdate,
                                   vl_User
                                   );
 EXCEPTION 
         WHEN DUP_VAL_ON_INDEX THEN
                NULL;
    END;
    
    OPEN  rcl_resultado FOR
    
        SELECT csl_1  as Status
                  , vl_msgConf   as Descripcion 
        FROM DUAL;
        
     RETURN rcl_resultado;

EXCEPTION
       WHEN OTHERS THEN  
                ROLLBACK;

      RCREDITO.SPREGISTRAERROR (SYSDATE, SQLCODE, SQLERRM, 'FNBITACORARMD');
                
    OPEN  rcl_resultado FOR
    
        SELECT csl_0  as Status
             ,vl_msgErr   as Descripcion 
        FROM DUAL;
        
     RETURN rcl_resultado;
        


END FNBITACORARMD;
/

GRANT EXECUTE ON RCREDITO.FNBITACORARMD TO RCACT, USRRCACT, USRWEB