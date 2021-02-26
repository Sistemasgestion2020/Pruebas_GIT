CREATE OR REPLACE PROCEDURE RCACT.SP01001_5241
  (precTRANCRECAB IN RCACT.typTRANCRECAB
  ,precTRANCREDET IN RCACT.typTRANCREDET
  ,paErrCod IN OUT NOCOPY RCACT.Pavariablesglobales.vgCodigoError%TYPE
  ,paErrMsg IN OUT NOCOPY RCACT.Pavariablesglobales.vgMsgError%TYPE
  ,paTipoErr IN OUT NOCOPY RCACT.Pavariablesglobales.vgTipoError%TYPE
  ,parrEstructuras IN RCACT.arrEstructuras)
IS
/*********************************************************************
Proyecto:                      SISTEMA REGIONAL DE CREDITO

Descripción:                   Actualiza Informacion de pedidos_credito de venta Credito

Parámetros de entrada:         precTRANCRECAB   - Cabecero del Registro
                               precTRANCREDET   - Detalle del Registro
                               parrEstructuras  - Estructuras que pasan entre Programas
Parámetros de salida:
Parámetros de entrada-salida:  paErrCod  - Codigo de Errror
                               paErrMsg  - Error general
                               paTipoErr - Error general

Precondiciones:
Creador:                       Miriam Alvarado López
Fecha de creación:             27/JUN/2007

Modificacion                   Validar el tipo de dpto a 4
                              
                               Modificacion para sucursal 3301 
                               6/sep/07
************************************************************************/

   excUpdateError EXCEPTION; --maneja exception en el Update
   recTAEST01001_5241 RCACT.TAEST01001_5241%ROWTYPE;
   vlProceso    RCACT.Pavariablesglobales.vgProceso%TYPE;
   vlCanal68 NUMBER := 68;

   vlFINGCIOID            RCREDITO.PEDIDOS_CREDITO.FINGCIOID%TYPE;
   vlFINOTIENDA           RCREDITO.PEDIDOS_CREDITO.FINOTIENDA%TYPE;
   vlFICTEID              RCREDITO.PEDIDOS_CREDITO.FICTEID%TYPE;
   vlFIDIGITOVER          RCREDITO.PEDIDOS_CREDITO.FIDIGITOVER%TYPE;
   vlFIPERIODO            RCREDITO.PEDIDOS_CREDITO.FIPERIODO%TYPE;
   vlFIPAISID             RCREDITO.CLIENTE_CR.FIPAISID%TYPE;
   vlFIIDCUADRANTE        RCREDITO.CLIENTE_CR.FIIDCUADRANTE%TYPE;
   vlFIIDZONAGEOGRAFICA   RCREDITO.CLIENTE_CR.FIIDZONAGEOGRAFICA%TYPE;
   vlFIDEPTOID            RCREDITO.ZONA_COBZAGEOGRAFIA.FIDEPTOID%TYPE;
   vlFIIDZONACOBZA        RCREDITO.ZONA_COBZAGEOGRAFIA.FIIDZONACOBZA%TYPE;
   vlFCEMPNUM             RCREDITO.ZONA_COBZAEMP.FCEMPNUM%TYPE;
   VLFITIPODEPTO          RCREDITO.PARAMCLASIFCARTERA.FITIPODEPTO%TYPE;


BEGIN
   vlProceso := 'Est.5241';
   EXECUTE IMMEDIATE RCACT.Fngetestructurasql
                            (1
                            ,1
                            ,PRECTRANCREDET
                            ,'TAEST01001_5241') INTO recTAEST01001_5241;


     IF precTRANCRECAB.FICANAL = vlCanal68 THEN


     IF  precTRANCRECAB.FIPAISID = 1 AND
         precTRANCRECAB.FISUCURSAL =3301    THEN

         BEGIN
             vlproceso := 'RCREDITO.PEDIDOS_CREDITO  SELECT';
             SELECT FINGCIOID, FINOTIENDA, FICTEID, FIDIGITOVER, FIPERIODO
               INTO  VLFINGCIOID,
                     VLFINOTIENDA,
                     VLFICTEID,
                     VLFIDIGITOVER,
                     VLFIPERIODO
               FROM  RCREDITO.PEDIDOS_CREDITO
               WHERE FIPAISID   =  PRECTRANCRECAB.FIPAISID
               AND   FICANAL    =  PRECTRANCRECAB.FICANAL
               AND   FISUCURSAL =  PRECTRANCRECAB.FISUCURSAL
               AND   FINOPEDIDO =  RECTAEST01001_5241.DNOPEDIDO;


               vlproceso := 'RCREDITO.CLIENTE_CR  SELECT';
               SELECT FIPAISID, FIIDCUADRANTE, FIIDZONAGEOGRAFICA
               INTO   VLFIPAISID,
                      VLFIIDCUADRANTE,
                      VLFIIDZONAGEOGRAFICA
               FROM RCREDITO.CLIENTE_CR
               WHERE FINGCIOID   = VLFINGCIOID
               AND   FINOTIENDA  = VLFINOTIENDA
               AND   FICTEID     = VLFICTEID
               AND   FIDIGITOVER = VLFIDIGITOVER;

               VLFITIPODEPTO := 4;

               vlproceso := 'RCREDITO.ZONA_COBZAGEOGRAFIA  SELECT';
               SELECT FIDEPTOID, FIIDZONACOBZA
               INTO   VLFIDEPTOID,
                      VLFIIDZONACOBZA
               FROM RCREDITO.ZONA_COBZAGEOGRAFIA
               WHERE FITIPODEPTO        = VLFITIPODEPTO
               AND   FIPAISID           = VLFIPAISID
               AND   FIIDCUADRANTE      = VLFIIDCUADRANTE
               AND   FIIDZONAGEOGRAFICA = VLFIIDZONAGEOGRAFICA;

               vlproceso := 'RCREDITO.ZONA_COBZAEMP  SELECT';
               SELECT FCEMPNUM
               INTO  VLFCEMPNUM
               FROM RCREDITO.ZONA_COBZAEMP
               WHERE FIDEPTOID = VLFIDEPTOID
               AND   FITIPODEPTO = VLFITIPODEPTO
               AND   FIIDZONACOBZA = VLFIIDZONACOBZA;

        EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  vlFIDEPTOID          := 0;
                  vlFIIDZONAGEOGRAFICA := 0;
                  VLFITIPODEPTO        := 0;
                  vlFIIDZONACOBZA      := 0;
                  vlFCEMPNUM           := '999999';
        END;

      BEGIN
         vlProceso := 'PEDIDOS_CREDITO UPDATE';
         UPDATE RCREDITO.PEDIDOS_CREDITO
            SET  FICLASIFCUENTA   = recTAEST01001_5241.DICLASIFCUENTA
                ,FISEMATRAS       = recTAEST01001_5241.DSEMATRA
                ,FIDEPTOID        = vlFIDEPTOID
                ,FIZONAID         = vlFIIDZONAGEOGRAFICA
                ,FCEMPNUM         = vlFCEMPNUM
                ,FITIPODEPTO      = VLFITIPODEPTO
                ,FIIDZONACOBZA    = vlFIIDZONACOBZA
             WHERE FIPAISID       = precTRANCRECAB.FIPAISID
                AND FICANAL       = precTRANCRECAB.FICANAL
                AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
                AND FINOPEDIDO    = recTAEST01001_5241.DNOPEDIDO;

      EXCEPTION
           WHEN NO_DATA_FOUND THEN
              NULL;
      END;

     ELSE

      BEGIN
        vlProceso := 'PEDIDOS_CREDITO UPDATE';
         UPDATE RCREDITO.PEDIDOS_CREDITO
            SET  FICLASIFCUENTA   = recTAEST01001_5241.DICLASIFCUENTA
                ,FISEMATRAS        = recTAEST01001_5241.DSEMATRA
             WHERE FIPAISID       = precTRANCRECAB.FIPAISID
                AND FICANAL       = precTRANCRECAB.FICANAL
                AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
                AND FINOPEDIDO    = recTAEST01001_5241.DNOPEDIDO;

      EXCEPTION
           WHEN NO_DATA_FOUND THEN
              NULL;
      END;


     END IF;

    END IF;


EXCEPTION
   WHEN excUpdateError THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;
      paErrMsg := vlProceso|| ' Det, ' ||precTrancredet.FICONSDETA;
   WHEN OTHERS THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;
      paErrMsg := vlProceso || ' Det. ' || precTRANCREDET.FICONSDETA;
END Sp01001_5241;
/