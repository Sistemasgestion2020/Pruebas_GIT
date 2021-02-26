CREATE OR REPLACE PACKAGE RCACT.PQCRACTUALIZA
/**********************************************************************************
  Programa  PACKAGE Actualizador 
  Autor     Juan Antonio Morales Ramirez 
  Fecha     07/09/2009 
  *********************************************************************************/
AS

    FUNCTION GetParameter ( paParametro IN RCREDITO.PARAMETROS.FIPARMID%TYPE)
      RETURN VARCHAR2;

    PROCEDURE SetParameter ( paValor     IN RCREDITO.PARAMETROS.FCPARMVAL%TYPE 
                            ,paParametro IN RCREDITO.PARAMETROS.FIPARMID%TYPE); 
    
    FUNCTION GetSucursal ( paPais     IN RCACT.CTRLSUC.FIPAISID%TYPE
                          ,paCanal    IN RCACT.CTRLSUC.FICANAL%TYPE
                          ,paSuc      IN RCACT.CTRLSUC.FISUCURSAL%TYPE)
      RETURN RCACT.CTRLSUC.FISTATADN%TYPE;
    
    FUNCTION GetSucursal ( paPais     IN RCACT.TRANCRECAB.FIPAISID%TYPE
                          ,paCanal    IN RCACT.TRANCRECAB.FICANAL%TYPE
                          ,paSuc      IN RCACT.TRANCRECAB.FISUCURSAL%TYPE
                          ,paTranno   IN RCACT.TRANCRECAB.FITRANNO%TYPE)
      RETURN NUMBER;
    
    PROCEDURE SetSucursal ( paStatus     IN RCACT.CTRLSUC.FISTATADN%TYPE ); 
    
    PROCEDURE SetSucursal (paPais     IN RCACT.CTRLSUC.FIPAISID%TYPE
                          ,paCanal    IN RCACT.CTRLSUC.FICANAL%TYPE
                          ,paSuc      IN RCACT.CTRLSUC.FISUCURSAL%TYPE
                          ,paStatus   IN RCACT.CTRLSUC.FISTATADN%TYPE
                          ,paTranno   IN RCACT.TRANCRECAB.FITRANNO%TYPE
                          ,paDescribe IN RCACT.CTRLSUC.FCDESCERR%TYPE
                          ,paTipoErr  IN RCACT.CTRLSUC.FCTIPOERR%TYPE);
    
    PROCEDURE SetSucursal (paPais     IN RCACT.CTRLSUC.FIPAISID%TYPE
                          ,paCanal    IN RCACT.CTRLSUC.FICANAL%TYPE
                          ,paSuc      IN RCACT.CTRLSUC.FISUCURSAL%TYPE
                          ,paStatus   IN RCACT.CTRLSUC.FISTATADN%TYPE);
    
    FUNCTION GetCadena ( paTipo IN NUMBER ,paCadena IN VARCHAR2)
    RETURN VARCHAR2;
       
    PROCEDURE GetJob (paConsec   IN OUT RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paInstance IN OUT RCACT.CTRLDESPJOBS.FIINSTANCE %TYPE);
    
    PROCEDURE SetJob (paStatus   IN RCACT.CTRLDESPJOBS.FISTATUS %TYPE);   
    
    PROCEDURE SetJob (paInicio   IN RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paFin      IN RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paStatus   IN RCACT.CTRLDESPJOBS.FISTATUS %TYPE);
    
    PROCEDURE SetJob (paConsec   IN RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paStatus   IN RCACT.CTRLDESPJOBS.FISTATUS %TYPE);
    
    PROCEDURE SetCabeceroHist (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                              ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                              ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                              ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                              ,paStatus IN OUT NUMBER);
    
    PROCEDURE SetDetalleHist (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                             ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                             ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                             ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                             ,paStatus IN OUT NUMBER);
    
    PROCEDURE SetCabeceroDel (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                             ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                             ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                             ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                             ,paStatus IN OUT NUMBER);
    
    PROCEDURE SetDetalleDel (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                            ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                            ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                            ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                            ,paStatus IN OUT NUMBER);
    
    PROCEDURE SetHistoricos (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                            ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                            ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                            ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                            ,paStatus IN OUT NUMBER);
    
    PROCEDURE SetInvalid (paPais     IN USRRCACT.TACRINVALID.FIPAIS%TYPE
                         ,paTipoReg  IN USRRCACT.TACRINVALID.FITIPOREG%TYPE);
    
    PROCEDURE SetInvalid (paPais     IN RCACT.TRANCRECAB.FIPAISID%TYPE
                         ,paCanal    IN RCACT.TRANCRECAB.FICANAL%TYPE
                         ,paTiporeg  IN RCACT.TRANCREDET.FITIPOREG%TYPE
                         ,paStore    IN OUT VARCHAR2
                         ,paStatus   IN OUT VARCHAR2
                         ,paActiva   IN NUMBER);
    
END PQCRACTUALIZA;
/



CREATE OR REPLACE PACKAGE BODY RCACT.PQCRACTUALIZA
/************************************************************
  Programa  PACKAGE Actualizador 
  Autor     Juan Antonio Morales Ramirez 
  Fecha     07/09/2009   
*********************************************************/
AS

vlResult      VARCHAR2(200);
vlEspera      CONSTANT PLS_INTEGER := 0;
vlTrabajo     CONSTANT PLS_INTEGER := 1;
vlError       CONSTANT PLS_INTEGER := 2;
vlNot         CONSTANT PLS_INTEGER := 3;
vlNulo        VARCHAR2(1):= ' ';
vlCero        VARCHAR2(1):= '0';
vlDate        DATE := TO_DATE('1901-01-01-00.00.00','YYYY-MM-DD HH24:MI:SS');

   
    FUNCTION GetParameter ( paParametro IN RCREDITO.PARAMETROS.FIPARMID%TYPE)
      RETURN VARCHAR2
    IS
    BEGIN
        SELECT TRIM(FCPARMVAL) 
          INTO vlResult
          FROM RCREDITO.PARAMETROS
         WHERE FIPARMID = paParametro;

        RETURN vlResult; 
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              RETURN vlCero;
    END;
    
    PROCEDURE SetParameter ( paValor     IN RCREDITO.PARAMETROS.FCPARMVAL%TYPE 
                            ,paParametro IN RCREDITO.PARAMETROS.FIPARMID%TYPE)
    IS
    BEGIN
         UPDATE RCREDITO.PARAMETROS
            SET FCPARMVAL = paValor
          WHERE FIPARMID  = paParametro;
    END; 
    
    FUNCTION GetSucursal ( paPais     IN RCACT.CTRLSUC.FIPAISID%TYPE
                          ,paCanal    IN RCACT.CTRLSUC.FICANAL%TYPE
                          ,paSuc      IN RCACT.CTRLSUC.FISUCURSAL%TYPE)
      RETURN RCACT.CTRLSUC.FISTATADN%TYPE
    IS
       paStatus   RCACT.CTRLSUC.FISTATADN%TYPE;
       
    BEGIN
        SELECT FISTATADN 
          INTO paStatus
          FROM RCACT.CTRLSUC
         WHERE FIPAISID   = paPais
           AND FICANAL    = paCanal
           AND FISUCURSAL = paSuc;

        RETURN paStatus; 
        
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              RETURN vlNot;
    END;
    
    FUNCTION GetSucursal ( paPais     IN RCACT.TRANCRECAB.FIPAISID%TYPE
                          ,paCanal    IN RCACT.TRANCRECAB.FICANAL%TYPE
                          ,paSuc      IN RCACT.TRANCRECAB.FISUCURSAL%TYPE
                          ,paTranno   IN RCACT.TRANCRECAB.FITRANNO%TYPE)
      RETURN NUMBER
    IS
       vlCuenta   NUMBER;
       
    BEGIN
        SELECT COUNT(1) 
          INTO vlCuenta
          FROM RCACT.TRANCRECAB
         WHERE FIPAISID   = paPais
           AND FICANAL    = paCanal
           AND FISUCURSAL = paSuc
           AND FITRANNO   = paTranno;

        RETURN vlCuenta; 
        
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              RETURN vlEspera;
    END;
    
    PROCEDURE SetSucursal ( paStatus     IN RCACT.CTRLSUC.FISTATADN%TYPE )
    IS
    
    BEGIN
         UPDATE RCACT.CTRLSUC
            SET FISTATADN = paStatus
               ,FCTIPOERR = vlNulo
               ,FCDESCERR = vlNulo;
    END; 
    
    PROCEDURE SetSucursal (paPais     IN RCACT.CTRLSUC.FIPAISID%TYPE
                          ,paCanal    IN RCACT.CTRLSUC.FICANAL%TYPE
                          ,paSuc      IN RCACT.CTRLSUC.FISUCURSAL%TYPE
                          ,paStatus   IN RCACT.CTRLSUC.FISTATADN%TYPE
                          ,paTranno   IN RCACT.TRANCRECAB.FITRANNO%TYPE
                          ,paDescribe IN RCACT.CTRLSUC.FCDESCERR%TYPE
                          ,paTipoErr  IN RCACT.CTRLSUC.FCTIPOERR%TYPE)
    IS
    
    BEGIN
         UPDATE RCACT.CTRLSUC 
            SET FISTATADN = paStatus
               ,FCDESCERR = paDescribe
               ,FCTIPOERR = paTipoErr
               ,FIULTTRANS  = (CASE WHEN paTranno = 0 THEN FIULTTRANS ELSE paTranno END)
          WHERE FIPAISID   = paPais
            AND FICANAL    = paCanal
            AND FISUCURSAL = paSuc;

           IF SQL%NOTFOUND THEN
              INSERT INTO RCACT.CTRLSUC  
                   VALUES (paPais
                          ,paCanal
                          ,paSuc
                          ,vlEspera
                          ,paTranno
                          ,vlDate
                          ,SYSDATE
                          ,vlNulo
                          ,vlNulo
                          ,vlEspera
                          ,vlEspera
                          ,vlDate);

           END IF; 
    END;
    
    PROCEDURE SetSucursal (paPais     IN RCACT.CTRLSUC.FIPAISID%TYPE
                          ,paCanal    IN RCACT.CTRLSUC.FICANAL%TYPE
                          ,paSuc      IN RCACT.CTRLSUC.FISUCURSAL%TYPE
                          ,paStatus   IN RCACT.CTRLSUC.FISTATADN%TYPE)
    IS
    
    BEGIN
         UPDATE RCACT.CTRLSUC 
            SET FISTATADN  = paStatus
          WHERE FIPAISID   = paPais
            AND FICANAL    = paCanal
            AND FISUCURSAL = paSuc;

           IF SQL%NOTFOUND THEN
              INSERT INTO RCACT.CTRLSUC  
                   VALUES (paPais
                          ,paCanal
                          ,paSuc
                          ,vlEspera
                          ,vlEspera
                          ,vlDate
                          ,SYSDATE
                          ,vlNulo
                          ,vlNulo
                          ,vlEspera
                          ,vlEspera
                          ,vlDate);

           END IF; 
    END;
    
    FUNCTION GetCadena ( paTipo IN NUMBER 
                        ,paCadena IN VARCHAR2)
    RETURN VARCHAR2
    IS

    BEGIN
    
        CASE paTipo
            WHEN 1 THEN
                 vlResult := 'RCACT.SPORGANIZA('||GetParameter(203)||','||GetParameter(200)||','||GetParameter(100)||');';
            WHEN 2 THEN
                 vlResult := 'RCACT.SPORGANIZAS('||GetParameter(203)||','||GetParameter(200)||','||GetParameter(100)||');';
            WHEN 3 THEN
                 vlResult := 'RCACT.DESPACHADOR('|| paCadena || ');';
            WHEN 4 THEN
                 vlResult := 'RCACT.SPORGANIZA('||GetParameter(203)||','||GetParameter(200)||','||GetParameter(100)||');';
            ELSE
                 vlResult := 'RCACT.ORGANIZADOR();';
        END CASE;
        
        RETURN vlResult;
            
    EXCEPTION
         WHEN OTHERS THEN
              RETURN vlNulo;
    END;
       
    PROCEDURE GetJob (paConsec   IN OUT RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paInstance IN OUT RCACT.CTRLDESPJOBS.FIINSTANCE %TYPE)
    IS
       
    BEGIN
        SELECT FICONSEC
             , FIINSTANCE
          INTO paConsec
             , paInstance
          FROM RCACT.CTRLDESPJOBS
         WHERE FISTATUS = vlTrabajo
           AND ROWNUM < vlError; 
       
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              paConsec:=vlEspera;
    END;
    
    PROCEDURE SetJob (paStatus   IN RCACT.CTRLDESPJOBS.FISTATUS %TYPE)
    IS
    
    BEGIN
         UPDATE RCACT.CTRLDESPJOBS
            SET FISTATUS   = paStatus
               ,FIJOBNUM   = vlEspera;
    END;   
    
    PROCEDURE SetJob (paInicio   IN RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paFin      IN RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paStatus   IN RCACT.CTRLDESPJOBS.FISTATUS %TYPE)
    IS
    
    BEGIN
         UPDATE RCACT.CTRLDESPJOBS
            SET FISTATUS   = paStatus
               ,FIJOBNUM   = vlEspera
          WHERE FICONSEC  BETWEEN paInicio AND paFin;
    END;
    
    PROCEDURE SetJob (paConsec   IN RCACT.CTRLDESPJOBS.FICONSEC%TYPE
                     ,paStatus   IN RCACT.CTRLDESPJOBS.FISTATUS %TYPE)
    IS
    
    BEGIN
         UPDATE RCACT.CTRLDESPJOBS
            SET FISTATUS   = paStatus
          WHERE FICONSEC   = paConsec;
    END;
    
    PROCEDURE SetCabeceroHist (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                              ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                              ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                              ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                              ,paStatus IN OUT NUMBER)
    IS
    
    BEGIN
         INSERT INTO RCACT.TRANCRECABHIST SELECT FIPAISID
                                             , FICANAL
                                             , FISUCURSAL
                                             , FITRANNO
                                             , FITRANTIPO
                                             , FICONSECTIPO
                                             , FDTRANSFECHR
                                             , FCTRANWS
                                             , FCTRANUSR
                                             , FITRANNOREG
                                             , FLTRANSMIT
                                             , TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')) FIANIOPROC
                                             , TO_NUMBER(TO_CHAR(SYSDATE,'Q')) FITRIMPROC
                                             , FDFECRECIBIDO
                                          FROM RCACT.TRANCRECAB 
                                         WHERE FIPAISID   = paPais
                                           AND FICANAL    = paCanal
                                           AND FISUCURSAL = paSuc
                                           AND FITRANNO   = paTranno;
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
              paStatus := 1;
    END;
    
    PROCEDURE SetDetalleHist (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                             ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                             ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                             ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                             ,paStatus IN OUT NUMBER)
    IS
    vlInicioProceso TIMESTAMP := CURRENT_TIMESTAMP;
    
    BEGIN
         INSERT INTO RCACT.TRANCREDETHIST SELECT FIPAISID
                                             , FICANAL
                                             , FISUCURSAL
                                             , FITRANNO
                                             , FICONSDETA
                                             , FITIPOREG
                                             , FCDATODETA 
                                             , TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')) FIANIOPROC
                                             , TO_NUMBER(TO_CHAR(SYSDATE,'Q')) FITRIMPROC
                                             , (CURRENT_TIMESTAMP - vlInicioProceso) FDFECRECIBIDO
                                          FROM RCACT.TRANCREDET 
                                         WHERE FIPAISID   = paPais
                                           AND FICANAL    = paCanal
                                           AND FISUCURSAL = paSuc
                                           AND FITRANNO   = paTranno;
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
              paStatus := 1;
    END;
    
    PROCEDURE SetCabeceroDel (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                             ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                             ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                             ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                             ,paStatus IN OUT NUMBER)
    IS
    
    BEGIN
         DELETE RCACT.TRANCRECAB 
          WHERE FIPAISID   = paPais
            AND FICANAL    = paCanal
            AND FISUCURSAL = paSuc
            AND FITRANNO   = paTranno;
          
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
              paStatus := 1;
    END;
    
    PROCEDURE SetDetalleDel (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                            ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                            ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                            ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                            ,paStatus IN OUT NUMBER)
    IS
    
    BEGIN
         DELETE RCACT.TRANCREDET 
          WHERE FIPAISID   = paPais
            AND FICANAL    = paCanal
            AND FISUCURSAL = paSuc
            AND FITRANNO   = paTranno;
          
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
              paStatus := 1;
    END;
    
    PROCEDURE SetHistoricos (paPais   IN RCACT.TRANCRECAB.FIPAISID%TYPE
                            ,paCanal  IN RCACT.TRANCRECAB.FICANAL %TYPE
                            ,paSuc    IN RCACT.TRANCRECAB.FISUCURSAL %TYPE
                            ,paTranno IN RCACT.TRANCRECAB.FITRANNO %TYPE
                            ,paStatus IN OUT NUMBER)
    IS
    
    BEGIN
         SetCabeceroHist(paPais,paCanal,paSuc,paTranno,paStatus);
         SetDetalleHist(paPais,paCanal,paSuc,paTranno,paStatus);
         SetCabeceroDel(paPais,paCanal,paSuc,paTranno,paStatus);
         SetDetalleDel(paPais,paCanal,paSuc,paTranno,paStatus);
          
    EXCEPTION
         WHEN OTHERS THEN
              paStatus := 1;
    END;
    
    PROCEDURE SetInvalid (paPais     IN USRRCACT.TACRINVALID.FIPAIS%TYPE
                         ,paTipoReg  IN USRRCACT.TACRINVALID.FITIPOREG%TYPE)
    IS
    
    BEGIN
         INSERT INTO USRRCACT.TACRINVALID(FIPAIS
                                        , FITIPOREG
                                        , FICONSEC
                                        , FDFCEHA)
                                  VALUES (paPais
                                        , paTipoReg
                                        , vlTrabajo
                                        , SYSDATE);
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
              vlResult := 'Ya existe registro';
              
    END;
    
    PROCEDURE SetInvalid (paPais     IN RCACT.TRANCRECAB.FIPAISID%TYPE
                         ,paCanal    IN RCACT.TRANCRECAB.FICANAL%TYPE
                         ,paTiporeg  IN RCACT.TRANCREDET.FITIPOREG%TYPE
                         ,paStore    IN OUT VARCHAR2
                         ,paStatus   IN OUT VARCHAR2
                         ,paActiva   IN NUMBER)
    IS
    
    BEGIN
          IF paActiva = 1 THEN
                  SELECT FCNAMESP, FISTATUSP 
                    INTO paStore,paStatus
                    FROM (SELECT FCNAMESP, FISTATUSP 
                            FROM USRRCACT.TACRREGISTRO
                           WHERE ((FIPAISID = paPais AND FICANAL = paCanal) 
                              OR (FIPAISID = vlTrabajo AND FICANAL = vlTrabajo))
                             AND FITIPOREG = paTiporeg
                           ORDER BY FIPAISID DESC , FICANAL DESC)
                   WHERE ROWNUM < vlError;
          ELSE
                  SELECT FCNAMESP, FISTATUSP 
                    INTO paStore,paStatus
                    FROM (SELECT FCNAMESP, FISTATUSP 
                            FROM RCACT.TAREGISTROS
                           WHERE ((FIPAISID = paPais AND FICANAL = paCanal) 
                              OR (FIPAISID = vlTrabajo AND FICANAL = vlTrabajo))
                             AND FITIPOREG = paTiporeg
                           ORDER BY FIPAISID DESC , FICANAL DESC)
                   WHERE ROWNUM < vlError;
          END IF;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              paStore:='0';
    END;
        
END PQCRACTUALIZA;
/

GRANT EXECUTE ON RCACT.PQCRACTUALIZA TO USRRCACT;





