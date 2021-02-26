CREATE OR REPLACE PACKAGE BODY RCREDITO.PQADUTLG0019
/*******************************************************************************
DESCRIPCION: Paquete que rgistra si un proceso bach se ejecuta correcta o incorrectamente
CREADO POR: Jose Alejandro Caricio Palacios
FECHA: 30/05/2013
MODIFICADO: Jose Alejandro Caricio Palacios
DESCRIPCION: Se cambian parametros de la hora "MM" POR "MI"
FECHA: 11/06/2013
*******************************************************************************/
 IS
  vmoduleversion VARCHAR2(50) := '31/05/2013. rgm';
  /*-------------------------------------------------------------------------
   registro de inicio de proceso
  ---------------------------------------------------------------------------*/

  FUNCTION sfInicioProceso(pfcnombreproceso RCREDITO.CONTROL_M.FCNOMBREPROCESO%TYPE,
                           pfregional       RCREDITO.CONTROL_M.FIREGIONAL%TYPE)
    RETURN integer
  
   IS
    SEQ      PLS_INTEGER := 0;
    paIdProc PLS_INTEGER := 0;
    nexnum   pls_integer;
  
  BEGIN
    SELECT RCREDITO.CONTROL_M_SEQ_001.NEXTVAL INTO nexnum FROM DUAL;
  
    INSERT INTO RCREDITO.CONTROL_M
      (FIIDPROC,
       FIANIO,
       FIMES,
       FIDIA,
       FCHORAINI,
       FCHORAFIN,
       FCNOMBREPROCESO,
       FIREGIONAL,
       FCDESCERROR,
       FISTATUSEJEC)
    VALUES
      (nexnum,
       TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
       TO_NUMBER(TO_CHAR(SYSDATE, 'MM')),
       TO_NUMBER(TO_CHAR(SYSDATE, 'DD')),
       TO_CHAR(SYSDATE, 'HH24:MI:SS'),
       TO_CHAR(SYSDATE, 'HH24:MI:SS'),
       substr(pfcnombreproceso, 1, 15),
       pfregional,
       '',
       1);
    COMMIT;
    return nexnum;
  
  END;

  /*-------------------------------------------------------------------------
  registro de fin de proceso con éxito
  ---------------------------------------------------------------------------*/
  PROCEDURE spProcesoExito(pfiidproc    RCREDITO.CONTROL_M.FIIDPROC%TYPE,
                           pfcdescerror RCREDITO.CONTROL_M.FCDESCERROR%TYPE)
  
   IS
  
  BEGIN
  
    UPDATE RCREDITO.CONTROL_M
       SET FISTATUSEJEC = 2,
           FCHORAFIN    = TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           FCDESCERROR  = substr(pfcdescerror, 1, 100)
     WHERE FIIDPROC = pfiidproc;
    COMMIT;
  
  END;

  /*-------------------------------------------------------------------------
   registro de fin de proceso con error.
  ---------------------------------------------------------------------------*/
  PROCEDURE spProcesoError(pfiidproc    RCREDITO.CONTROL_M.FIIDPROC%TYPE,
                           pfcdescerror RCREDITO.CONTROL_M.FCDESCERROR%TYPE)
  
   IS
  BEGIN
  
    UPDATE RCREDITO.CONTROL_M
       SET FISTATUSEJEC = 0,
           FCHORAFIN    = TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           FCDESCERROR  = substr(pfcdescerror, 1, 100)
     WHERE FIIDPROC = pfiidproc;
    COMMIT;
  
  end;

  /*-------------------------------------------------------------------------
  Regresa la versión del módulo
  ---------------------------------------------------------------------------*/
  FUNCTION fnmoduleversion RETURN VARCHAR2 IS
  BEGIN
    RETURN(vmoduleversion);
  END fnmoduleversion;

END;
/