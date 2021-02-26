CREATE OR REPLACE PROCEDURE rcact.SP01001_5196
   (precTRANCRECAB IN RCACT.typTrancrecab
   ,precTRANCREDET IN RCACT.typTrancredet
   ,paErrCod IN OUT NOCOPY RCACT.Pavariablesglobales.vgCodigoError%TYPE
   ,paErrMsg IN OUT NOCOPY RCACT.Pavariablesglobales.vgMsgError%TYPE
   ,paTipoErr IN OUT NOCOPY RCACT.Pavariablesglobales.vgTipoError%TYPE
   ,parrEstructuras IN RCACT.arrEstructuras)
IS
/*************************************************************
Proyecto:                     Sistema Tarjeta Azteca - Actualizador.
Descripción:                  Actuzaliza TELVENTAPOSPAGO
Parámetros de entrada:        precTRANCRECAB:  Datos del cabecero.
                              precTRANCREDET:  Datos del detalle.
                              parrEstructuras: Estructuras que se pasan entre programas.
Modificacion:                 
                             6 AGOSTO 2009   Yran Arvizu  
                             24 sep 2009 JOSÉ ANTONIO MEDINA DE ITA   
*************************************************************/

   vlProceso RCACT.Pavariablesglobales.vgProceso%TYPE; -- Descripción del tipo de RCREDITO.REGISTRO a procesar.
   recTAEST01001_5196 RCACT.TAEST01001_5196%ROWTYPE; -- RCREDITO.REGISTRO con la est. 5196
   excFallo EXCEPTION; --maneja exception en el Update

   vlPSaldo      RCREDITO.PEDIDOS_CREDITO.FNSALDO%TYPE;
   vlPFultVista  RCREDITO.PEDIDOS_CREDITO.FDULTIMAVISITA%TYPE;
   vlPFultAbono  RCREDITO.PEDIDOS_CREDITO.FDULTIMOABONO%TYPE;
   vlPDigitoVerif RCREDITO.PEDIDOS_CREDITO.FIDIGITOVER%TYPE; 
   vlPTipoDepto  RCREDITO.PEDIDOS_CREDITO.FITIPODEPTO%TYPE;
   vlPZonaCobza  RCREDITO.PEDIDOS_CREDITO.FIIDZONACOBZA%TYPE;
   vlPUnidadNeg  RCREDITO.PEDIDOS_CREDITO.FIUNIDADNEGOCIO%TYPE;
   vlPEmpNum     RCREDITO.PEDIDOS_CREDITO.FCEMPNUM%TYPE;
   vlPZonaID     RCREDITO.PEDIDOS_CREDITO.FIZONAID%TYPE;
   vlPDeptoID    RCREDITO.PEDIDOS_CREDITO.FIDEPTOID%TYPE;
   vlPPeriodo    RCREDITO.PEDIDOS_CREDITO.FIPERIODO%TYPE;
   vlPCteID      RCREDITO.PEDIDOS_CREDITO.FICTEID%TYPE;
   vlPNoTienda   RCREDITO.PEDIDOS_CREDITO.FINOTIENDA%TYPE;
   vlPNgcioID    RCREDITO.PEDIDOS_CREDITO.FINGCIOID%TYPE;
   vlWReg        RCREDITO.REGIONAL_TIENDA.FIDEPTOID%TYPE;
   vlXTipoDepto  RCREDITO.PARAMCLASIFCARTERA.FITIPODEPTO%TYPE;
   vlXSdoCapital RCREDITO.PARAMCLASIFCARTERA.FNSDOCAPITAL%TYPE;
   vlWCuadrante  RCREDITO.CLIENTE_CR.FIIDCUADRANTE%TYPE;
   vlWZona       RCREDITO.CLIENTE_CR.FIIDZONAGEOGRAFICA %TYPE;
   vlWZonaCob    RCREDITO.ZONA_COBZAGEOGRAFIA.FIIDZONACOBZA%TYPE;
   vlWJpg        RCREDITO.ZONA_COBZAEMP.FCEMPNUM%TYPE;
   vlFCEMPNUM    RCREDITO.EMPLEADO_CR.FCEMPNUM%TYPE;
   vlFANIO       RCREDITO.FECHAS_SEMANAS.FIANIOPROCESO%TYPE;
   vlFSem        RCREDITO.FECHAS_SEMANAS.FISEMPROCESO%TYPE;
   vlNOMOVTO     RCREDITO.MOVIMIENTO_PEDIDO.FINOMOVTO%TYPE;
   vlMOVPIMP     RCREDITO.MOVIMIENTO_PEDIDO.FNMOVPIMP%TYPE;
   vlFECMOVTOPED RCREDITO.MOVIMIENTO_PEDIDO.FDFECMOVTOPED%TYPE;
   vlCONCEPMOV   RCREDITO.MOVIMIENTO_PEDIDO.FICONCEPMOV%TYPE;
   vlFITIPOOP    RCREDITO.MOVIMIENTO_PEDIDO.FITIPOOP%TYPE;
   vlNueves      RCREDITO.EMPLEADO_CR.FCEMPNUM%TYPE:='999999';
   vlFIPUESTOID  RCREDITO.EMPLEADO_CR.FIPUESTOID%TYPE;
   vl_cob_FCEMPNUM RCREDITO.EMPLEADO_CR.FCEMPNUM%TYPE;
   vlCTASTATUS NUMBER(2);
   vlFIATRSTATUS NUMBER(2):=0;
   vlValor0 NUMBER(1) :=0;
   vlValor1 NUMBER(1) :=1;
   vlUno NUMBER(1) := 1;
   vlExiste  INTEGER;

BEGIN

   vlProceso := 'Est. 5196';
   EXECUTE IMMEDIATE RCACT.Fngetestructurasql (vlUno
                                              ,vlUno
                                              ,PRECTRANCREDET
                                              ,'TAEST01001_5196')
                                         INTO recTAEST01001_5196;

   vlProceso := 'SELECT PEDIDOS_CREDITO';
   SELECT FNSALDO
         ,FDULTIMAVISITA
         ,FDULTIMOABONO
         ,FIDIGITOVER
         ,FITIPODEPTO
         ,FIIDZONACOBZA
         ,FIUNIDADNEGOCIO
         ,FINGCIOID
         ,FINOTIENDA
         ,FIZONAID
         ,FIDEPTOID
         ,FICTEID
         ,FIPERIODO
         ,FCEMPNUM
     INTO vlPSaldo
         ,vlPFultVista
         ,vlPFultAbono
         ,vlPDigitoVerif
         ,vlPTipoDepto
         ,vlPZonaCobza
         ,vlPUnidadNeg
         ,vlPNgcioID
         ,vlPNoTienda
         ,vlPZonaID
         ,vlPDeptoID
         ,vlPCteID
         ,vlPPeriodo
         ,vlPEmpNum
     FROM RCREDITO.PEDIDOS_CREDITO
    WHERE FIPAISID   = precTRANCRECAB.FIPAISID
      AND FICANAL    = precTRANCRECAB.FICANAL
      AND FISUCURSAL = precTRANCRECAB.FISUCURSAL
      AND FINOPEDIDO = recTAEST01001_5196.DNOPEDIDO;

   IF -- validando Saldo
      vlPSaldo <= 0
   THEN

      vlProceso := 'SELECT REGIONAL_TIENDA';
      SELECT MIN(FIDEPTOID)
        INTO vlWReg
        FROM RCREDITO.REGIONAL_TIENDA
       WHERE FIPAISID   = precTRANCRECAB.FIPAISID
         AND FICANALID  = precTRANCRECAB.FICANAL
         AND FISUCURSAL = precTRANCRECAB.FISUCURSAL;

      vlProceso := 'SELECT PARAMCLASIFCARTERA';
      SELECT FITIPODEPTO
            ,FNSDOCAPITAL
        INTO vlXTipoDepto
            ,vlXSdoCapital
        FROM RCREDITO.PARAMCLASIFCARTERA
       WHERE
         FIPERIODO = vlPPeriodo
         AND recTAEST01001_5196.DSEMATRASR >= FIATRASOINI
         AND recTAEST01001_5196.DSEMATRASR <= FIATRASOFIN;

      CASE -- Empieza validando tipo departamento
         WHEN vlXTipoDepto IN (3, 4) THEN
            vlProceso := 'SELECT CLIENTE_CR';
            SELECT FIIDCUADRANTE
                  ,FIIDZONAGEOGRAFICA
              INTO vlWCuadrante
                  ,vlWZona
              FROM RCREDITO.CLIENTE_CR
             WHERE FINGCIOID   = vlPNgcioID
               AND FINOTIENDA  = vlPNoTienda
               AND FICTEID     = vlPCteID
               AND FIDIGITOVER = vlPDigitoVerif;

            BEGIN
               vlProceso := 'SELECT ZONA_COBZAGEOGRAFIA';


            SELECT FIDEPTOID
                  ,FIIDZONACOBZA
              INTO vlWReg
                  ,vlWZonaCob
              FROM RCREDITO.ZONA_COBZAGEOGRAFIA A
             WHERE A.ROWID=(SELECT MAX(ROWID)
                              FROM RCREDITO.ZONA_COBZAGEOGRAFIA B
                             WHERE B.FIPAISID      =precTRANCRECAB.FIPAISID
                               AND B.FIIDCUADRANTE = vlWCuadrante
                               AND B.FIIDZONAGEOGRAFICA =vlWZona
                               AND B.FITIPODEPTO    = vlXTipoDepto);


            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  vlWZonaCob := 0;
            END;

            BEGIN
               vlProceso := 'SELECT ZONA_COBZAEMP';
               SELECT FCEMPNUM
                 INTO vlWJpg
                 FROM RCREDITO.ZONA_COBZAEMP
                WHERE FIDEPTOID     = vlWReg
                  AND FITIPODEPTO   = vlXTipoDepto
                  AND FIIDZONACOBZA = vlWZonaCob;

            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  vlWJpg := '999999';
            END;

            vlPDeptoID   := vlWReg;
            vlPZonaCobza := vlWZonaCob;
            vlPEmpNum    := vlWJpg;
            vlPTipoDepto := vlXTipoDepto;

         WHEN vlXTipoDepto = 5 THEN
            vlPTipoDepto := vlXTipoDepto;
            BEGIN --Begin Insertar en INSERT PEDCREDLEGAL
               vlProceso := 'INSERT PEDCREDLEGAL';
               INSERT INTO RCREDITO.PEDCREDLEGAL (FICANAL
                                        ,FISUCURSAL
                                        ,FINOPEDIDO
                                        ,FDFECCLASLEGAL
                                        ,FITRANNO
                                        ,FDFECCLASCENTRAL)
                                 VALUES (precTRANCRECAB.FICANAL
                                        ,precTRANCRECAB.FISUCURSAL
                                        ,recTAEST01001_5196.DNOPEDIDO
                                        ,precTRANCRECAB.FDTRANSFECHR
                                        ,precTRANCRECAB.FITRANNO
                                        ,SYSDATE);
            EXCEPTION
               WHEN OTHERS THEN
                  IF  -- Valida el tipo de error
                         SQLCODE <> 0
                     AND SQLCODE <> -1
                  THEN
                     RAISE excFallo;
                  END IF; -- Valida el tipo de error
            END;

         WHEN vlXTipoDepto = 6 THEN

            vlPTipoDepto := vlXTipoDepto;
      END CASE;-- Empieza validando tipo departamento
   END IF;

   vlProceso := 'UPDATE TELVENTAPOSPAGO';
   UPDATE RCREDITO.TELVENTAPOSPAGO
      SET FNSALDOTOT        = recTAEST01001_5196.DSALDOTOT
         ,FNIMPCGOSREQTOT   = recTAEST01001_5196.DIMPCGOSRQ
         ,FNIMPCGOSMORSERV  = recTAEST01001_5196.DIMPCGOSMR
         ,FISEMATRASERV     = recTAEST01001_5196.DSEMATRASR
         ,FNIMPATRASADOSERV = recTAEST01001_5196.DIMPATRASD
         ,FCTELEFONO        = recTAEST01001_5196.DTELEFONO
         ,FCNUMSERIE        = recTAEST01001_5196.DNUMSERIE
         ,FISOLICITUDIUS    = recTAEST01001_5196.DSOLICITUD
         ,FCNOCONTRATO      = recTAEST01001_5196.DNOCONTRAT
         ,FCCUENTAIUS       = recTAEST01001_5196.DCUENTAIUS
         ,FINOPEDIDO        = recTAEST01001_5196.DNOPEDIDO
         ,FICLASIFCUENTA    = recTAEST01001_5196.DCLASIFCUE
         ,FDULTIMOPAGO      = recTAEST01001_5196.DULTIMOPAG
         ,FDULTIMAVISITA    = recTAEST01001_5196.DULTIMAVIS
         ,FISTATUS          = recTAEST01001_5196.DSTATUS
         ,FINGCIOID         = vlPNgcioID
         ,FITIENDAID        = vlPNoTienda
         ,FICTEID           = vlPCteID
         ,FIDIGITOVER       = vlPDigitoVerif
         ,FIPERIODO         = vlPPeriodo
         ,FITIPODEPTO       = vlPTipoDepto
         ,FIUNIDADNEGOCIO   = vlPUnidadNeg
         ,FIDEPTOID         = vlPDeptoID
         ,FIZONAID          = vlPZonaID
         ,FIIDZONACOBZA     = vlPZonaCobza
         ,FCEMPNUM          = vlPEmpNum
   WHERE FIPAIS        = precTRANCRECAB.FIPAISID
     AND FICANAL       = precTRANCRECAB.FICANAL
     AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
     AND FIIDVENTA     = recTAEST01001_5196.DIDVENTA
     AND FIIDNEGOCIO   = recTAEST01001_5196.DIDNEGOCIO
     AND FINOTIENDA    = recTAEST01001_5196.DNOTIENDA
     AND FICONSECLINEA = recTAEST01001_5196.DCONSECLIN;

   IF 
      SQL%NOTFOUND = TRUE
   THEN
      RAISE excFallo;
   END IF;-- validadndo Update

   /*************************************************************************
         ****   AGREGADO PARA CUOTAS DE COBRANZA   02/08/2007 *****
    ************************************************************************/

    BEGIN
         vlProceso := 'FECHAS_SEMANAS SELECT';
      SELECT FIANIOPROCESO
            ,FISEMPROCESO
        INTO vlFAnio
            ,vlFSem
        FROM RCREDITO.FECHAS_SEMANAS
       WHERE TRUNC(FDFECINICIAL) <= TRUNC(precTRANCRECAB.FDTRANSFECHR)
         AND TRUNC(FDFECTERMINO) >= TRUNC(precTRANCRECAB.FDTRANSFECHR);


      vlProceso := 'MOVIMIENTO_PEDIDO CurMovPed SELECT';
      FOR CurMovPed IN (SELECT FINOMOVTO,FNMOVPIMP,FDFECMOVTOPED,FICONCEPMOV
                    FROM RCREDITO.MOVIMIENTO_PEDIDO
                   WHERE FIPAISID   = precTRANCRECAB.FIPAISID
                     AND FICANAL    = precTRANCRECAB.FICANAL
                     AND FISUCURSAL = precTRANCRECAB.FISUCURSAL
                     AND FINOPEDIDO = recTAEST01001_5196.DNOPEDIDO
                     ORDER BY FINOMOVTO DESC)
      LOOP
          vlNOMOVTO     := CurMovPed.FINOMOVTO;
          vlMOVPIMP     := CurMovPed.FNMOVPIMP;
          vlFECMOVTOPED := CurMovPed.FDFECMOVTOPED;
          vlCONCEPMOV   := CurMovPed.FICONCEPMOV;
          EXIT;
      END LOOP;

        vlProceso := 'TELMOVTOPOSPAGO SELECT';
        SELECT FITIPOOP
          INTO vlFITIPOOP
          FROM RCREDITO.TELMOVTOPOSPAGO
         WHERE FIPAIS        = precTRANCRECAB.FIPAISID
           AND FICANAL       = precTRANCRECAB.FICANAL
           AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
           AND FIIDVENTA     = recTAEST01001_5196.DIDVENTA
           AND FIIDNEGOCIO   = recTAEST01001_5196.DIDNEGOCIO
           AND FINOTIENDA    = recTAEST01001_5196.DNOTIENDA
           AND FICONSECLINEA = recTAEST01001_5196.DCONSECLIN
           AND FINOMOVTO     = vlNOMOVTO;

    --Valida si el tipo de transacción es atrasos de telefonia
    --tipoTransacción 2100,2150,2155,5398,5402
    --esto lo verificamos con Antonio Castañeda

      -- CICLO EN PEDIDOS CREDITO CON LOS DATOS DEL MOVIMIENTO

      IF vlFITIPOOP IN (7,8,9,10,16,17,18,29 )
         AND (
               precTRANCRECAB.FITRANTIPO NOT IN ( 2100, 2150, 2155,5398, 5402 )
             )
      THEN

             vlProceso := 'PEDIDOS_CREDITO cur_pc SELECT';
             FOR cur_pc IN
                  (SELECT /*+ INDEX_DESC (PEDIDOS_CREDITO)*/FCEMPNUM
                         ,FITIPODEPTO
                         ,FIDEPTOID
                         ,FIPERATRASO
                         ,FICLASIFCUENTA
                         ,FIPEDSTATUS
                         ,FNSALDO
                         ,FNSALDOATRASADO
                         ,FNMORATORIOS
                         ,FIUNIDADNEGOCIO
                         ,FIPERATRAACUM
                         ,FIEMISION
                         ,FISERIE
                         ,FISEMATRAS
                     FROM RCREDITO.PEDIDOS_CREDITO
                    WHERE FINOPEDIDO = recTAEST01001_5196.DNOPEDIDO
                      AND FISUCURSAL = precTRANCRECAB.FISUCURSAL
                      AND FICANAL    = precTRANCRECAB.FICANAL
                      AND FIPAISID   = precTRANCRECAB.FIPAISID)
            LOOP

               IF trim(cur_pc.FCEMPNUM) IS NULL  THEN
                  vlFCEMPNUM := vlNUEVES;
               ELSE
                  vlFCEMPNUM := cur_pc.FCEMPNUM;
               END IF;

               vlProceso := 'EMPLEADO_CR SELECT';
                     SELECT FIPUESTOID
                       INTO vlFIPUESTOID
                       FROM RCREDITO.EMPLEADO_CR
                      WHERE FCEMPNUM = vlFCEMPNUM;
   
               BEGIN

                   vlProceso := 'DETALLE_RECUPERACION SELECT';
                   --04/10/2006 Josè Antonio Medina
                   --Es query ha ocacionado muchos problemas al tratar de bajar los costos
                   SELECT /*+FIRST_ROWS INDEX_SS(DR,IXPK_DETALLE_RECUPERACION)*/
                          FCEMPNUM , COUNT(1)
                     INTO vl_cob_FCEMPNUM, vlExiste
                     FROM RCREDITO.DETALLE_RECUPERACION DR
                    WHERE FIANIOPROCESO = vlFAnio
                      AND FISEMPROCESO = vlFSem
                      AND FIPAIS       = precTRANCRECAB.FIPAISID
                      AND FICANAL      = precTRANCRECAB.FICANAL
                      AND FISUCURSAL   = precTRANCRECAB.FISUCURSAL
                      AND FINOPEDIDO   = recTAEST01001_5196.DNOPEDIDO
                      AND FINOMOVTO    = vlNOMOVTO
                      AND ROWNUM < 2
                      GROUP BY FCEMPNUM;

               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                         vlExiste :=0;
               END;


                IF cur_pc.FITIPODEPTO > 3  THEN 
                 --(cur_pc.FITIPODEPTO<6) OR (cur_pc.FITIPODEPTO = 15) THEN
                    IF vlExiste =0 THEN
                        BEGIN
                         vlProceso := 'CUOTAS_DE_COBRANZA SELECT';
                         SELECT /*+ INDEX (CUOTAS_DE_COBRANZA)*/
                                FIATRSTATUS
                           INTO vlFIATRSTATUS
                           FROM RCREDITO.CUOTAS_DE_COBRANZA CB
                          WHERE FIANIOPROCESO = vlFAnio
                            AND FISEMPROCESO  = vlFSem
                            AND FIPAISID      = precTRANCRECAB.FIPAISID
                            AND FICANAL       = precTRANCRECAB.FICANAL
                            AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
                            AND FINOPEDIDO    = recTAEST01001_5196.DNOPEDIDO;

                        EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                               vlFIATRSTATUS:=0;
                        END;

                        BEGIN
                               vlProceso := 'RECUPERACION_CUOTAS_COBRANZA INSERT';
                               INSERT INTO RCREDITO.RECUPERACION_CUOTAS_COBRANZA(FIANIOPROCESO
                                                                                ,FISEMPROCESO
                                                                                ,FDFECHARECEPCION
                                                                                ,FIPAIS
                                                                                ,FICANAL
                                                                                ,FISUCURSAL
                                                                                ,FCEMPNUM
                                                                                ,FINOPEDIDO
                                                                                ,FIEMISION
                                                                                ,FISERIE
                                                                                ,FIDESPACHO
                                                                                ,FDCRECCAPITAL
                                                                                ,FDCRECMORATORIO
                                                                                ,FDCRMD
                                                                                ,FITIPODEPTO
                                                                                ,FCEMPNUM_BALANCEO
                                                                                ,FITIPOCOBRANZA
                                                                                ,FIDEPTOID)
                                                                          VALUES(vlFAnio
                                                                                ,vlFSem
                                                                                ,SYSDATE
                                                                                ,precTRANCRECAB.FIPAISID
                                                                                ,precTRANCRECAB.FICANAL
                                                                                ,precTRANCRECAB.FISUCURSAL
                                                                                ,vlFCEMPNUM
                                                                                ,recTAEST01001_5196.DNOPEDIDO
                                                                                ,cur_pc.FIEMISION
                                                                                ,cur_pc.FISERIE
                                                                                ,vlValor0
                                                                                ,(CASE WHEN vlFITIPOOP  IN (7,9,16,17)
                                                                                       THEN vlMOVPIMP
                                                                                       ELSE vlValor0
                                                                                  END)
                                                                                ,(CASE WHEN vlFITIPOOP  IN (8,10,29,18)
                                                                                       THEN vlMOVPIMP
                                                                                       ELSE vlValor0
                                                                                  END)
                                                                                ,vlValor0
                                                                                ,cur_pc.FITIPODEPTO
                                                                                ,vlFCEMPNUM
                                                                                ,vlFIATRSTATUS
                                                                                ,cur_pc.FIDEPTOID);

                        EXCEPTION
                               WHEN DUP_VAL_ON_INDEX  THEN

                                 vlProceso := 'RECUPERACION_CUOTAS_COBRANZA UPDATE';
                                 UPDATE  /*+INDEX_ss_desc(RC,IXPK_RECUP_CUOTAS_COBR01)*/
                                        RCREDITO.RECUPERACION_CUOTAS_COBRANZA RC
                                    SET FDCRECCAPITAL = FDCRECCAPITAL +(CASE WHEN vlFITIPOOP  IN (7,9,16,17)
                                                                             THEN vlMOVPIMP
                                                                        ELSE 0
                                                                        END)
                                       ,FDCRECMORATORIO = FDCRECMORATORIO + (CASE WHEN vlFITIPOOP  IN (8,10,29,18)
                                                                                  THEN vlMOVPIMP
                                                                             ELSE 0
                                                                             END)
                                       ,FITIPOCOBRANZA= vlFIATRSTATUS
                                  WHERE FIANIOPROCESO = vlFAnio
                                    AND FISEMPROCESO  = vlFSem
                                    AND FIPAIS        = precTRANCRECAB.FIPAISID
                                    AND FICANAL       = precTRANCRECAB.FICANAL
                                    AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
                                    AND FCEMPNUM      = vlFCEMPNUM
                                    AND FINOPEDIDO    = recTAEST01001_5196.DNOPEDIDO;

                        END;
                    END IF;
                    
                END IF;

              IF cur_pc.FITIPODEPTO > 3  THEN
               -- (cur_pc.FITIPODEPTO<6) OR (cur_pc.FITIPODEPTO = 15)  THEN
                IF vlExiste =0 THEN

                    vlProceso := 'DETALLE_RECUPERACION INSERT';
                    INSERT INTO RCREDITO.DETALLE_RECUPERACION(FIANIOPROCESO
                                                             ,FISEMPROCESO
                                                             ,FDFECHARECEPCION
                                                             ,FIPAIS
                                                             ,FICANAL
                                                             ,FISUCURSAL
                                                             ,FINOPEDIDO
                                                             ,FCEMPNUM
                                                             ,FINOMOVTO
                                                             ,FINOTRANSACCION
                                                             ,FITIPOOP
                                                             ,FDFECHAMOVIMIENTO
                                                             ,FDCIMPORTE
                                                             ,FICONCEPTO
                                                             ,FITIPODEPTO
                                                             ,FCEMPNUM_BALANCEO
                                                             ,FITIPOCOBRANZA
                                                             ,FIDEPTOID)
                                                       VALUES(vlFAnio
                                                             ,vlFSem
                                                             ,SYSDATE
                                                             ,precTRANCRECAB.FIPAISID
                                                             ,precTRANCRECAB.FICANAL
                                                             ,precTRANCRECAB.FISUCURSAL
                                                             ,recTAEST01001_5196.DNOPEDIDO
                                                             ,vlFCEMPNUM
                                                             ,vlNOMOVTO
                                                             ,precTRANCRECAB.FITRANNO
                                                             ,vlFITIPOOP
                                                             ,vlFECMOVTOPED
                                                             ,vlMOVPIMP
                                                             ,vlCONCEPMOV
                                                             ,cur_pc.FITIPODEPTO
                                                             ,vlFCEMPNUM
                                                             ,vlFIATRSTATUS
                                                             ,cur_pc.FIDEPTOID);


                    IF cur_pc.FITIPODEPTO < 5  THEN

                    vlProceso := 'CUOTAS_DE_COBRANZA UPDATE';
                    UPDATE RCREDITO.CUOTAS_DE_COBRANZA
                       SET FDCRECCOBCAP  = FDCRECCOBCAP + (CASE WHEN vlFITIPOOP  IN (7,9,16,17)
                                                               THEN vlMOVPIMP
                                                               ELSE vlValor0
                                                          END)
                           ,FDCRECCOBMOR = FDCRECCOBMOR + (CASE WHEN vlFITIPOOP  IN (8,10,29,18)
                                                               THEN vlMOVPIMP
                                                               ELSE vlValor0
                                                          END)
                           ,FCEMPNUM      = vlFCEMPNUM
                           ,FIDEPTOID     = cur_pc.FIDEPTOID
                           ,FIPUESTOID    = vlFIPUESTOID
                      WHERE FIANIOPROCESO = vlFAnio
                        AND FISEMPROCESO  = vlFSem
                        AND FIPAISID      = precTRANCRECAB.FIPAISID
                        AND FICANAL       = precTRANCRECAB.FICANAL
                        AND FISUCURSAL    = precTRANCRECAB.FISUCURSAL
                        AND FINOPEDIDO    = recTAEST01001_5196.DNOPEDIDO;

                       IF SQL%NOTFOUND THEN  
                             IF
                                 cur_pc.FNSALDOATRASADO >= cur_pc.FNSALDO
                             THEN
                                 vlCTASTATUS := 0;
                             ELSE
                                IF
                                   cur_pc.FIPERATRAACUM < 0
                                THEN
                                    vlCTASTATUS := 2;
                                ELSE
                                   vlCTASTATUS := 1;
                                END IF;
                             END IF;

                            vlProceso := 'CUOTAS_DE_COBRANZA INSERT';
                             INSERT INTO RCREDITO.CUOTAS_DE_COBRANZA(FIANIOPROCESO
                                                           ,FISEMPROCESO
                                                           ,FIPAISID
                                                           ,FICANAL
                                                           ,FISUCURSAL
                                                           ,FINOPEDIDO
                                                           ,FIPERATRAACUM
                                                           ,FIDEPTOID
                                                           ,FCEMPNUM
                                                           ,FIPUESTOID
                                                           ,FDCIMPCOBCAP
                                                           ,FDCRECCOBCAP
                                                           ,FDCIMPCOBMOR
                                                           ,FDCRECCOBMOR
                                                           ,FICLASIFCUENTA
                                                           ,FIPEDSTATUS
                                                           ,FDCIMPCOBDEV
                                                           ,FICTASTATUS
                                                           ,FIATRSTATUS
                                                           ,FDCSDOCAPITAL
                                                           ,FDCSDOATRASADO
                                                           ,FDCIMPMORATORIOS
                                                           ,FNCIMPCOBCAPRDF
                                                           ,FNCIMPCOBMORRDF
                                                           ,FIUNIDADNEGOCIO
                                                           ,FNCIMPCOBCAPLGA
                                                           ,FNCIMPCOBMORLGA
                                                           ,FIVARDISPONIBLE)
                                                     VALUES(vlFAnio
                                                           ,vlFSem
                                                           ,precTRANCRECAB.FIPAISID
                                                           ,precTRANCRECAB.FICANAL
                                                           ,precTRANCRECAB.FISUCURSAL
                                                           ,recTAEST01001_5196.DNOPEDIDO
                                                           ,cur_pc.FIPERATRASO
                                                           ,cur_pc.FIDEPTOID
                                                           ,vlFCEMPNUM
                                                           ,vlFIPUESTOID
                                                           ,vlValor0
                                                           ,(CASE WHEN vlFITIPOOP IN (7,9,16,17)
                                                                  THEN vlMOVPIMP
                                                                  ELSE vlValor0
                                                             END)
                                                           ,vlValor0
                                                           ,(CASE WHEN vlFITIPOOP  IN (8,10,29,18)
                                                                  THEN vlMOVPIMP
                                                                  ELSE vlValor0
                                                             END)
                                                           ,cur_pc.FICLASIFCUENTA
                                                           ,cur_pc.FIPEDSTATUS
                                                           ,vlValor0
                                                           ,vlCTASTATUS
                                                           ,(CASE WHEN cur_pc.FIPERATRASO > 0
                                                                  THEN vlValor1 --con atraso
                                                                  ELSE vlValor0 --sin atraso
                                                             END)
                                                           ,cur_pc.FNSALDO
                                                           ,cur_pc.FNSALDOATRASADO
                                                           ,cur_pc.FNMORATORIOS
                                                           ,vlValor0
                                                           ,vlValor0
                                                           ,cur_pc.FIUNIDADNEGOCIO
                                                           ,vlValor0
                                                           ,vlValor0
                                                           ,vlValor0);
                        END IF;

                        vlExiste :=0;
                        vlProceso := 'TOTALES_CUOTASCOB UPDATE';
                        UPDATE RCREDITO.TOTALES_CUOTASCOB TC
                           SET FDCRECCOBCAP = FDCRECCOBCAP+
                                              (CASE WHEN vlFITIPOOP  IN (7,9,16,17)
                                                    THEN vlMOVPIMP
                                                    ELSE vlValor0
                                               END)
                                ,FDCRECCOBMOR = FDCRECCOBMOR+
                                               (CASE WHEN vlFITIPOOP  IN (8,10,29,18)
                                                     THEN vlMOVPIMP
                                                     ELSE vlValor0
                                                END)
                        WHERE FIANIOPROCESO = vlFAnio
                          AND FIMESPROCESO  = cur_pc.FIUNIDADNEGOCIO
                          AND FISEMPROCESO  = vlFSem
                          AND FIPAISID      = precTRANCRECAB.FIPAISID
                          AND FICANAL       = precTRANCRECAB.FICANAL
                          AND FIDEPTOID     = cur_pc.FIDEPTOID
                          AND FIPUESTOID    = vlFIPUESTOID
                         AND FCEMPNUM       = vlFCEMPNUM
                         AND FIATRSTATUS    = vlFIATRSTATUS;

                       IF --TOTALES_CUOTASCOB
                          SQL%NOTFOUND
                       THEN
                          vlProceso := 'TOTALES_CUOTASCOB INSERT';
                          INSERT INTO RCREDITO.TOTALES_CUOTASCOB(FIANIOPROCESO
                                                          ,FIMESPROCESO
                                                          ,FISEMPROCESO
                                                          ,FIPAISID
                                                          ,FICANAL
                                                          ,FIDEPTOID
                                                          ,FIPUESTOID
                                                          ,FCEMPNUM
                                                          ,FIATRSTATUS
                                                          ,FDCIMPCOBCAP
                                                          ,FDCRECCOBCAP
                                                          ,FDCIMPCOBMOR
                                                          ,FDCRECCOBMOR
                                                          ,FDIMPCOBDEV
                                                          ,FDCSDOCAPITAL
                                                          ,FDCSDOATRASADO
                                                          ,FDCIMPMORATORIOS
                                                          ,FDCIMPCOBCAPMER
                                                          ,FDCRECCOBCAPMER
                                                          ,FDCIMPCOBMORMER
                                                          ,FDCRECCOBMORMER
                                                          ,FDCSDOCAPITALMER
                                                          ,FDCSDOATRASADOMER
                                                          ,FDCIMPMORATORIOSMER )
                                                   VALUES(vlFAnio
                                                         ,cur_pc.FIUNIDADNEGOCIO
                                                         ,vlFSem
                                                         ,precTRANCRECAB.FIPAISID
                                                         ,precTRANCRECAB.FICANAL
                                                         ,cur_pc.FIDEPTOID
                                                         ,vlFIPUESTOID
                                                         ,vlFCEMPNUM
                                                         ,vlFIATRSTATUS
                                                         ,vlValor0
                                                         ,(CASE WHEN vlFITIPOOP  IN (7,9,16,17)
                                                                THEN vlMOVPIMP
                                                                ELSE vlValor0
                                                           END)
                                                         ,vlValor0
                                                         ,(CASE WHEN vlFITIPOOP  IN (8,10,29,18)
                                                                THEN vlMOVPIMP
                                                                ELSE vlValor0
                                                           END)
                                                         ,vlValor0
                                                         ,cur_pc.FNSALDO
                                                         ,cur_pc.FNSALDOATRASADO
                                                         ,cur_pc.FNMORATORIOS
                                                     ,vlValor0
                                                     ,vlValor0
                                                     ,vlValor0
                                                     ,vlValor0
                                                     ,vlValor0
                                                     ,vlValor0
                                                     ,vlValor0);
                   END IF; 
                END IF; 
             END IF;
          END IF;
        END LOOP;

      END IF;



    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            NULL;
       WHEN DUP_VAL_ON_INDEX THEN
            NULL;
    END;


EXCEPTION
   WHEN excFallo THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;
      paErrMsg := vlProceso|| ' Det. '  || precTRANCREDET.FICONSDETA;
   WHEN OTHERS THEN
      paTipoErr := 'S';
      paErrCod := SQLCODE;
      paErrMsg := vlProceso|| ' Det. '  || precTRANCREDET.FICONSDETA;
END Sp01001_5196;--BEGIN PRINCIPAL
/