CREATE OR REPLACE PROCEDURE RCACT.SP01001_5198
   (precTRANCRECAB IN RCACT.typTRANCRECAB
   ,precTRANCREDET IN RCACT.typTRANCREDET
   ,paErrCod IN OUT NOCOPY RCACT.PAVARIABLESGLOBALES.vgCodigoError%TYPE
   ,paErrMsg IN OUT NOCOPY RCACT.PAVARIABLESGLOBALES.vgMsgError%TYPE
   ,paTipoErr IN OUT NOCOPY RCACT.PAVARIABLESGLOBALES.vgTipoError%TYPE
   ,parrEstructuras IN RCACT.arrEstructuras)
IS
/*************************************************************************************************************
Proyecto:  Sistema Regional de Cr�dito - Actualizador.
Descripci�n:           Domiciliaci�n Productos de Facturas de LCR.
Par�metros de entrada: precTRANCRECAB: Datos del cabecero.
                       precTRANCREDET: Datos del detalle.
                       parrEstructuras: Estructuras que se pasan entre programas.
Par�metros de salida:
Par�metros de entrada-salida: paErrCod: Informar sobre el c�digo de error al tibur�n.
                              paErrMsg: Informar sobre el mensaje de error al tibur�n.
                              paTipoErr: Tipo de error. (S) Sistema (C) Cat�logo.
Fecha de modificaci�n         3 noviembre 09  
                              JAMDEITA 
*************************************************************************************************************/

   vlProceso RCACT.PAVARIABLESGLOBALES.vgProceso%TYPE;                  -- Descripci�n del c�digo a procesar.
   recTAEST01001_5198 RCACT.TAEST01001_5198%ROWTYPE;                    -- RCREDITO.REGISTRO con la est. 5198.
   excFallo EXCEPTION;
   vlUno  NUMBER(1) := 1;

BEGIN

   vlProceso := 'Est. 5198';
   EXECUTE IMMEDIATE RCACT.FNGETESTRUCTURASQL (vlUno
                                              ,vlUno
                                              ,PRECTRANCREDET
                                              ,'TAEST01001_5198')
                                         INTO recTAEST01001_5198;

   vlProceso := 'RCREDITO.TELDETVENTAPOSPAGO  UPDATE';
   UPDATE RCREDITO.TELDETVENTAPOSPAGO
      SET FNRENTAMENSUAL = recTAEST01001_5198.DRENTAMENS
         ,FNPAGOSEM      = recTAEST01001_5198.DPAGOSEM
         ,FNULTPAGOSEM   = recTAEST01001_5198.DULTPAGOSE
         ,FIIDSERVIUS    = recTAEST01001_5198.DIDSERVIUS
         ,FICANTIDAD     = recTAEST01001_5198.DCANTIDAD
         ,FIPLAZOADN     = recTAEST01001_5198.DPLAZOADN
         ,FIPLAZOIUS     = recTAEST01001_5198.DPLAZOIUS
         ,FIORIGEN       = recTAEST01001_5198.DORIGEN
    WHERE FIPAIS        = precTRANCREDET.FIPAISID
      AND FICANAL       = precTRANCREDET.FICANAL
      AND FISUCURSAL    = precTRANCREDET.FISUCURSAL
      AND FIIDVENTA     = recTAEST01001_5198.DIDVENTA
      AND FIIDNEGOCIO   = recTAEST01001_5198.DIDNEGOCIO
      AND FINOTIENDA    = recTAEST01001_5198.DSUCURORI
      AND FICONSECLINEA = recTAEST01001_5198.DLINEAVTA
      AND FIIDSERVADN   = recTAEST01001_5198.DIDSERVADN;

   IF
      SQL%NOTFOUND = TRUE
   THEN
      --RAISE excFallo;
      NULL;
   END IF;

EXCEPTION
   WHEN excFallo THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;      
      paErrMsg := vlProceso|| ' Det, ' ||precTrancredet.FICONSDETA;
   WHEN OTHERS THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;
     paErrMsg := vlProceso|| ' Det, ' ||precTrancredet.FICONSDETA;
END SP01001_5198;
/ 
