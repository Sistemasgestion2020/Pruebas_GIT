CREATE OR REPLACE PROCEDURE RCACT.Sp01001_5195
   (precTRANCRECAB IN RCACT.typTrancrecab
   ,precTRANCREDET IN RCACT.typTrancredet
   ,paErrCod IN OUT NOCOPY RCACT.Pavariablesglobales.vgCodigoError%TYPE
   ,paErrMsg IN OUT NOCOPY RCACT.Pavariablesglobales.vgMsgError%TYPE
   ,paTipoErr IN OUT NOCOPY RCACT.Pavariablesglobales.vgTipoError%TYPE
   ,parrEstructuras IN RCACT.arrEstructuras)
IS

/*************************************************************
Proyecto:                     Sistema Regional de Crédito - Actualizador.
Descripción:                  Actualiza TELDETVENTAPOSPAGO
Parámetros de entrada:        precTRANCRECAB:  Datos del cabecero.
                              precTRANCREDET:  Datos del detalle.
                              parrEstructuras: Estructuras que se pasan entre programas.
Parámetros de salida:
Parámetros de entrada-salida: paErrCod:        Informar sobre el código de error al tiburón.
                              paErrMsg:        Informar sobre el mensaje de error al tiburón.
                              paTipoErr:       Tipo de error. (S) Sistema (C) Catálogo.
Precondiciones:
Creador:                      Armando Ravelo Robles
Fecha de creación:            05/01/2005

Modifico                      Miriam Alvarado López
                              11/Jun/2008  Actualizar campo  FCCVEPROM
*************************************************************/

   vlProceso RCACT.Pavariablesglobales.vgProceso%TYPE; -- Descripción del tipo de RCREDITO.REGISTRO a procesar.
   recTAEST01001_5195 RCACT.TAEST01001_5195%ROWTYPE; -- RCREDITO.REGISTRO con la est. 5195
   excUpdateError EXCEPTION; --maneja exception en el Update
   vlUno NUMBER(1) := 1;

BEGIN --BEGIN PRINCIPAL

   vlProceso := 'Est. 5195';
   EXECUTE IMMEDIATE RCACT.Fngetestructurasql (vlUno
                                              ,vlUno
                                              ,PRECTRANCREDET
                                              ,'TAEST01001_5195')
                                         INTO recTAEST01001_5195;

   vlProceso := 'UPDATE TELDETVENTAPOSPAGO';
   UPDATE RCREDITO.TELDETVENTAPOSPAGO
      SET FNSALDO       = recTAEST01001_5195.DSALDO
         ,FNIMPCGOREQ   = recTAEST01001_5195.DCARGOS
         ,FNIMPCGOMORAT = recTAEST01001_5195.DMORAT
         ,FDSURTIMIENTO = recTAEST01001_5195.DFECHASUR
         ,FIDIASGRACIA  = recTAEST01001_5195.DIASGRACIA
         ,FDINICIOPER   = recTAEST01001_5195.DFECHAINI
         ,FDVENCIMIENTO = recTAEST01001_5195.DFECHAVEN
         ,FIATRASOS     = recTAEST01001_5195.DNUMATRA
         ,FIPERIODOACT  = recTAEST01001_5195.DACTUAL
         ,FIPERIODOCOR  = recTAEST01001_5195.DCORRIDO
         ,FNIMPPAGADO   = recTAEST01001_5195.DPAGADO
         ,FNIMPDEVENG   = recTAEST01001_5195.DEVENGA
         ,FISTATUS      = recTAEST01001_5195.DSTATUS
         ,FCCVEPROM     = recTAEST01001_5195.DCVEPROMO
    WHERE FIPAIS        = precTRANCRECAB.FIPAISID
      AND FICANAL       = precTRANCRECAB.FICANAL
      AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
      AND FIIDVENTA     = recTAEST01001_5195.DIDVENTA
      AND FIIDNEGOCIO   = recTAEST01001_5195.DIDNEGOCIO
      AND FINOTIENDA    = recTAEST01001_5195.DSUCURORI
      AND FICONSECLINEA = recTAEST01001_5195.DLINEAVTA
      AND FIIDSERVADN   = recTAEST01001_5195.DIDSERVADN;

   IF -- valida el Update
      SQL%NOTFOUND = TRUE
   THEN
      RAISE excUpdateError;
   END IF;-- valida el Update

EXCEPTION
   WHEN excUpdateError THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;
      paErrMsg := vlProceso|| ' Det, ' ||precTrancredet.FICONSDETA;
   WHEN OTHERS THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;
      paErrMsg := vlProceso|| ' Det, ' ||precTrancredet.FICONSDETA;

END Sp01001_5195;--BEGIN PRINCIPAL
/



