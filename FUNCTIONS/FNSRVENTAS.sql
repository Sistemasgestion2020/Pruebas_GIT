CREATE OR REPLACE FUNCTION RCREDITO.FNSRVENTAS (PA_TIPOMSG    IN VARCHAR2,
                                                PA_CODPROC    IN VARCHAR2,
                                                PA_MONTO      IN VARCHAR2,
                                                PA_NDCS       IN VARCHAR2,
                                                PA_HORLOCAL   IN VARCHAR2,
                                                PA_FECLOCAL   IN VARCHAR2,
                                                PA_FECCIERR   IN VARCHAR2,
                                                PA_MODOPOS    IN VARCHAR2,
                                                PA_TRACK2     IN VARCHAR2,
                                                PA_RRN        IN VARCHAR2,
                                                PA_NUMAUTOR   IN VARCHAR2,
                                                PA_CODRESP    IN VARCHAR2,
                                                PA_IDTERM     IN VARCHAR2,
                                                PA_IDCOMER    IN VARCHAR2,
                                                PA_TRACK1     IN VARCHAR2,
                                                PA_PAGPLAZO   IN VARCHAR2,
                                                PA_CODMONED   IN VARCHAR2,
                                                PA_MENSHOST   IN VARCHAR2)
   RETURN SYS_REFCURSOR
AS
   EXC_SRERROR EXCEPTION;
   VL_WFNVALOR1         NUMBER (12, 2) := 0;
   VL_WFNVALOR2         NUMBER (12, 2) := 0;
   VL_WKCAPUSADA        NUMBER (15, 2) := 0;
   CSL_0                CONSTANT NUMBER := 0;
   VL_FACTOR            NUMBER (7, 6) := 0;
   CSL_00               VARCHAR2 (2) := '00';
   CSL_ERR12            CONSTANT VARCHAR2 (2) := '12';
   CSL_1                CONSTANT NUMBER := 1;
   CSL_017              CONSTANT NUMBER := 1.17;
   CSL_2                CONSTANT NUMBER := 2;
   CSL_3                CONSTANT NUMBER := 3;
   CSL_4                CONSTANT NUMBER := 4;
   CSL_6                CONSTANT NUMBER := 6;
   CSL_8                CONSTANT NUMBER := 8;
   CSL_10               CONSTANT NUMBER := 10;
   CSL_9                CONSTANT NUMBER := 9;
   CSL_13               CONSTANT NUMBER := 13;
   CSL_14               CONSTANT NUMBER := 14;
   CSL_12               CONSTANT NUMBER := 12;
   CSL_18               CONSTANT NUMBER := 18;
   CSL_22               CONSTANT NUMBER := 22;
   CSL_25               CONSTANT NUMBER := 25;
   CSL_28               NUMBER := 28;
   CSL_45           CONSTANT VARCHAR2(2):='45';   
   CSL_47               CONSTANT NUMBER := 47;
   CSL_51               CONSTANT NUMBER := 51;
   CSL_57               CONSTANT NUMBER := 57;
   CSL_71               CONSTANT NUMBER := 71;
   CSL_72               CONSTANT NUMBER := 72;
   CSL_73               CONSTANT NUMBER := 73;
   CSL_74               CONSTANT NUMBER := 74;
   CSL_93               CONSTANT NUMBER := 93;
   CSL_97               CONSTANT NUMBER := 97;
   CSL_100              CONSTANT NUMBER := 100;
   CSL_214              CONSTANT NUMBER := 214;
   CSL_217              CONSTANT NUMBER := 217;
   CSL_223              CONSTANT NUMBER := 223;
   CSL_350              CONSTANT NUMBER := 350;
   CSL_395              CONSTANT NUMBER := 395;
   CSL_600              CONSTANT NUMBER := 600;
   CSL_1000             CONSTANT NUMBER := 1000;
   CSL_999999           CONSTANT NUMBER := 999999.99;
   CSL_MONTODEC         NUMBER (12, 2) := 0;
   VL_TIPOMSG           VARCHAR2 (4) := '0210';
   VL_OK                VARCHAR2 (2) := '00';
   VL_CODRESP           VARCHAR2 (2) := '';
   CSL_POS              CONSTANT VARCHAR2 (1) := '+';
   CSL_NEG              CONSTANT VARCHAR2 (1) := '-';
   CSL_PUNT             CONSTANT VARCHAR2 (1) := '.';
   CSL_FORMATN          VARCHAR2 (15) := 'fm999999999.00';
   CSL_CAD0             CONSTANT VARCHAR2 (1) := '0';
   CSL_CAD2             CONSTANT VARCHAR2 (1) := '2';
   CSL_COD01            CONSTANT VARCHAR2 (2) := '01';
   CSL_NVOESQUEMA       VARCHAR2 (2) := '00';
   CSL_WBLANCOS         CONSTANT VARCHAR2 (10) := '2000-01-01';
   VL_MONTOMIN          NUMBER (12, 2) := 0;
   VL_STATUSMONTO       NUMBER (5) := 0;
   CSL_BLANCO           VARCHAR2 (2) := ' ';
   CSL_ITALIKA          CONSTANT VARCHAR2 (7) := 'ITALIKA';
   VLREC_CURSORSALIDA   SYS_REFCURSOR;
   RCL_SRREGLASCAP      SYS_REFCURSOR;
   VL_WSCONSULTA        VARCHAR2 (990) := '0000';
   VL_0000              VARCHAR2 (4) := '0000';
   VL_TODAYTIME DATE
         := TO_DATE ('1901-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS');
   VL_FDATRZCTRL DATE
         := TO_DATE ('1901-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS');
   VL_FECCIERR          VARCHAR2 (4) := '';
   VL_HORLOCAL          VARCHAR2 (6) := '';
   VL_FECLOCAL          VARCHAR2 (4) := '';
   VL_RRN               VARCHAR2 (12) := '000000000000';
   VL_SOBREG            VARCHAR2 (12) := '000000000000';
   VL_NUMAUTOR          VARCHAR2 (6) := ' ';
   VL_ESQUEMA           CONSTANT VARCHAR2 (2) := '00';
   VL_WCAPINFLADA       NUMBER (15, 2) := 0;
   VL_WCAPDISPO         NUMBER (15, 2) := 0;
   VL_WSOBREGIRO        NUMBER (15, 2) := 0;
   VL_WSPAIS            NUMBER (5) := 0;
   VL_WSCANAL           NUMBER (5) := 0;
   VL_WSSUCURSAL        NUMBER (10) := 0;
   VL_WSFOLIO           NUMBER (10) := 0;
   VL_WPAIVEN           NUMBER (5) := 1;
   VL_WCANVEN           NUMBER (5) := 0;
   VL_WSUCVEN           RCREDITO.TIENDA_CR.FICANALID%TYPE;
   VL_WTDAVEN           NUMBER (10) := 0;
   VL_WEPRODUCTO        NUMBER (5) := 0;
   VL_CAPTOPE           NUMBER (10) := 0;
   VL_WCODERR           VARCHAR2 (2) := '00';
   vl_wsformaven        VARCHAR2 (4) := '0000';
   vl_wplazo            NUMBER (5) := 0;
   vl_cad0              VARCHAR2 (1) := '0';
   vl_CapPago28         NUMBER (12, 2) := 0;
   vl_CapPagoDisp28     NUMBER (12, 2) := 0;
   vl_Importe28         NUMBER (12, 2) := 0;
   vl_wplazodef         NUMBER (5) := 13;
   vl_wNumAutor         NUMBER (10) := 0;
   vl_wspedrev          VARCHAR2 (10) := '0000000000';
   vl_CapDispCredL      NUMBER (12, 2) := 0;
   vl_Montolcr          NUMBER (12, 2) := 0;
   vl_Plazomax          NUMBER (5) := 0;
   vl_FecNull DATE
         := TO_DATE ('1901-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss');
   vl_Monto             VARCHAR2 (12) := '';
   vl_wAbonoMile        NUMBER (12, 2) := 0;
   vl_wAbonoTotal       NUMBER (12, 2) := 0;
   vl_wclientenvo       VARCHAR2 (1) := '1';
   vl_wNuevaCapDs       NUMBER (12, 2) := 0;
   vl_wCapReque         NUMBER (12, 2) := 0;
   vl_wPorCtjSobC       NUMBER (12, 2) := 0.20;
   vl_wRequierPor       NUMBER (5) := 0;
   vl_wresult           NUMBER (12, 2) := 0;
   vl_wOcupaMile        NUMBER (5) := 0;
   vl_wsventa           VARCHAR2 (15) := ' ';
   vl_Modopos           VARCHAR2 (3) := '';
   vl_Track2            VARCHAR2 (37) := '';
   vl_Codproc           VARCHAR2 (6) := '';
   vl_Ndcs              VARCHAR2 (6) := '';
   vl_Idterm            VARCHAR2 (8) := '';
   vl_Idcomer           VARCHAR2 (15) := '';
   vl_Track1            VARCHAR2 (76) := '';
   vl_Pagplazo          VARCHAR2 (5) := '';
   vl_Codmoned          VARCHAR2 (3) := '';
   vl_Menshost          VARCHAR2 (999) := '';
   vl_SobreGiro         VARCHAR2 (12) := '';
   vl_NvoEsquema        VARCHAR2 (2) := '';
   vl_0000000           VARCHAR2 (12) := '000000000000';
   vl_wNvoEsquema       VARCHAR2 (2) := '00';
   vl_blanc             VARCHAR2 (2) := ' ';
   VL_WNOPRESPERAC      VARCHAR2 (1) := '0';
   vl_ResError        NUMBER (10) := 0;
   vl_ComError       VARCHAR2 (200) := '00';
   VL_COLORVERDE        VARCHAR2 (5) := 'VERDE';

   /*************************************************************************************************
   Proyecto: Migracion AS400
   Descripción: Funcion con todos los pasos para realizar la venta
   Parámetros de entrada: N/A
   Parámetros de salida: N/A
   Valor de retorno: Cursor con los datos

   Creador: Oscar Octavio
   Fecha de creación: 03 / Octubre / 2020.
   **************************************************************************************************/

   -- CURSOR 1: INGRESOS POR CU
   CURSOR CURINGRESOS (
      PA_PAIS        RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL       RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL    RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO       RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE,
      PA_CAPTOPE     NUMBER)
   IS
      SELECT INGRESOS,
             INGCOMP,
             INGMENS,
             INGNOCOMP,
             (INGRESOS * VL_WFNVALOR1) / VL_WFNVALOR2 AS WCAPACIDAD30
        FROM (  SELECT CASE
                          WHEN (  D.FNINGMES
                                + D.FNINGCYGMES
                                + D.FNINGMESNOCOMP
                                + D.FNINGDEUMES) >= PA_CAPTOPE
                          THEN
                               D.FNINGMES
                             + D.FNINGCYGMES
                             + D.FNINGMESNOCOMP
                             + D.FNINGDEUMES
                       END
                          AS INGRESOS,
                       CASE
                          WHEN D.FNINGMES > PA_CAPTOPE THEN CSL_1
                          ELSE CSL_0
                       END
                          AS INGCOMP,
                       D.FNINGMES AS INGMENS,
                       D.FNINGMESNOCOMP AS INGNOCOMP
                  FROM RCREDITO.CREDCLIENTETIENDA A
                       INNER JOIN RCREDITO.CREDCLIENTE B
                          ON     A.FIPAISID = B.FIPAISID
                             AND A.FICANALID = B.FICANALID
                             AND A.FISUCURSALID = B.FISUCURSALID
                             AND A.FIIDNEGOCIO = B.FIIDNEGOCIO
                             AND A.FIIDTIENDA = B.FIIDTIENDA
                             AND A.FIIDCLIENTE = B.FIIDCLIENTE
                             AND A.FICANALID <> CSL_51
                       INNER JOIN RCREDITO.CREDSOLICITUD C
                          ON     C.FIPAISID = B.FIPAISID
                             AND C.FICANALID = B.FICANALID
                             AND C.FISUCURSALID = B.FISUCURSALID
                             AND C.FIIDNEGOCIO = B.FIIDNEGOCIO
                             AND C.FIIDTIENDA = B.FIIDTIENDA
                             AND C.FIIDCLIENTE = B.FIIDCLIENTE
                       INNER JOIN RCREDITO.CREDDATOSECONOMICOS D
                          ON     D.FIPAISID = B.FIPAISID
                             AND D.FICANALID = B.FICANALID
                             AND D.FISUCURSALID = B.FISUCURSALID
                             AND D.FIIDPERSONA = B.FIIDPERSONA
                       INNER JOIN RCREDITO.CENLINEADECREDITO E
                          ON     E.FIPAIS = A.FIPAIS
                             AND E.FICANAL = A.FICANAL
                             AND E.FISUCURSAL = A.FISUCURSAL
                             AND E.FIFOLIO = A.FIFOLIO
                             AND E.FISUCURSALGESTORA = C.FISUCURSALID
                 WHERE     A.FIPAIS = PA_PAIS
                       AND A.FICANAL = PA_CANAL
                       AND A.FISUCURSAL = PA_SUCURSAL
                       AND A.FIFOLIO = PA_FOLIO
                       AND C.FISTAT = CSL_6
                       AND C.FITIPOSOLICITUD IN (SELECT FISUBITEMID
                                                   FROM RCREDITO.TACATALSRC
                                                  WHERE FIITEMID = CSL_73)
              ORDER BY C.FDFECSOL DESC FETCH
              FIRST CSL_1 ROWS ONLY );

   REC_INGRESOS         CURINGRESOS%ROWTYPE;



   --CURSOR 2: INGRESOS POR CU

   CURSOR CURCAPCONSUMO (
      PA_PAIS                     RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                    RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                 RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                    RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE,
      PA_IDTERM                   VARCHAR2)
   IS
      SELECT TCP.FIPAIS,
             TCP.FICANAL,
             TCP.FISUCURSAL,
             TCP.FIFOLIO,
             TCP.FNCONSUMO,
             TCP.FNITALIKA,
             CASE WHEN TCP.FNCONSUMO > CSL_0 THEN CSL_3 ELSE CSL_0 END
                AS WAPLICA,
             CASE
                WHEN TRIM (PA_IDTERM) = CSL_ITALIKA THEN TCP.FNITALIKA
                ELSE TCP.FNCONSUMO
             END
                AS WCAPTOTAL
        FROM RCREDITO.TACRCAPPRODUCTO TCP
       WHERE     FIPAIS = PA_PAIS
             AND FICANAL = PA_CANAL
             AND FISUCURSAL = PA_SUCURSAL
             AND FIFOLIO = PA_FOLIO;

   REC_CAPCONSUMO       CURCAPCONSUMO%ROWTYPE;

   -- CURSOR 2.1

   CURSOR CUR_CAPMAXPROD (
      PA_PAIS                      RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                     RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                  RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                     RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE,
      PA_IDTERM                    VARCHAR2,
      PA_FNCONSUMO                 RCREDITO.TACRCAPPRODUCTO.FNCONSUMO%TYPE,
      PA_WAPLICA                   NUMBER,
      PA_WCAPTOTAL                 NUMBER)
   IS
      WITH TAB2
              AS (SELECT PA_FNCONSUMO,
                         CASE
                            WHEN (PA_WAPLICA <> CSL_3) THEN TCAPM.FICAPACIDAD
                            ELSE PA_FNCONSUMO
                         END
                            AS CAPTOTCONSUMO,
                         CASE
                            WHEN (PA_WAPLICA <> CSL_3)
                                 AND (TCAPM.FICAPACIDAD > CSL_0)
                            THEN
                               CSL_2
                            ELSE
                               PA_WAPLICA
                         END
                            AS WAPLICA,
                         CASE
                            WHEN (PA_WAPLICA <> CSL_3)
                                 AND (TCAPM.FICAPACIDAD > CSL_0)
                            THEN
                               TCAPM.FICAPACIDAD
                            ELSE
                               PA_WCAPTOTAL
                         END
                            AS WCAPTOTAL,
                         CASE
                            WHEN (PA_WAPLICA <> CSL_3)
                                 AND (TCAPM.FICAPACIDAD > CSL_0)
                            THEN
                               TCAPM.FICAPACIDAD
                            ELSE
                               CSL_0
                         END
                            AS WCAPINFLADA
                    FROM RCREDITO.TACRCAPMAXPROD TCAPM
                   WHERE     TCAPM.FIPAIS = PA_PAIS
                         AND TCAPM.FICANAL = PA_CANAL
                         AND TCAPM.FISUCURSAL = PA_SUCURSAL
                         AND TCAPM.FIFOLIO = PA_FOLIO
                         AND TCAPM.FIORIGENID = CSL_1)
      SELECT TAB2.CAPTOTCONSUMO,
             CASE WHEN WAPLICA = CSL_0 THEN CSL_1 ELSE TAB2.WAPLICA END
                AS WAPLICA,
             TAB2.WCAPTOTAL,
             TAB2.WCAPINFLADA
        FROM TAB2;

   REC_CAPMAXPROD       CUR_CAPMAXPROD%ROWTYPE;

   --CURSOR 3: VALIDA CANAL DE LA SUCURSAL

   CURSOR CURVALCANAL (
      VL_WSUCVEN RCREDITO.TIENDA_CR.FISUCURSAL%TYPE)
   IS
      SELECT FICANALID,
             CASE WHEN FICANALID <> VL_WCANVEN THEN CSL_ERR12 ELSE CSL_00 END
                AS CODERROR,
             CASE
                WHEN FICANALID <> VL_WCANVEN THEN CSL_BLANCO
                ELSE VL_TIPOMSG
             END
                AS TIPOMSG
        FROM RCREDITO.TIENDA_CR
       WHERE FIPAISID = CSL_1 AND FISUCURSAL = VL_WSUCVEN;

   REC_VALIDACANAL      CURVALCANAL%ROWTYPE;

   --CURSOR 4: VALIDA PERIODO

   CURSOR CURVALPER (
      PA_PAIS                     RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                    RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                 RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                    RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE,
      PA_MONTODEC                 NUMBER)
   IS
      WITH TAB1
              AS (SELECT (CASE
                             WHEN FNPERIODO = CSL_14
                             THEN
                                ROUND ( (PA_MONTODEC / CSL_4), CSL_0)
                             WHEN FNPERIODO = CSL_13
                             THEN
                                ROUND ( (PA_MONTODEC / CSL_2), CSL_0)
                             ELSE
                                CSL_0
                          END)
                            AS PAGOQM
                    FROM RCREDITO.TADIAPAGOQM
                   WHERE     FIPAIS = PA_PAIS
                         AND FICANAL = PA_CANAL
                         AND FISUCURSAL = PA_SUCURSAL
                         AND FIFOLIO = PA_FOLIO)
      SELECT TAB1.PAGOQM,
             CASE WHEN TAB1.PAGOQM > 0 THEN TAB1.PAGOQM ELSE PA_MONTODEC END
                AS MONTODEC
        FROM TAB1;

   REC_VALIDAPERIODO    CURVALPER%ROWTYPE;

   --CURSOR 5

   CURSOR CURCAPPAG (
      PA_PAIS                      RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                     RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                  RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                     RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE,
      PA_WAPLICA                   NUMBER,
      PA_WCAPTOTAL                 NUMBER)
   IS
      WITH TAB1
              AS (SELECT FIPAIS,
                         FICANAL,
                         FISUCURSAL,
                         FIFOLIO,
                         (CASE
                             WHEN CR.FILOCALIZACION <> CSL_0 THEN CSL_71
                             WHEN CR.FIRMD <> CSL_0 THEN CSL_72
                             WHEN CR.FILEGAL <> CSL_0 THEN CSL_73
                             WHEN CR.FIDIFICILCOBRO <> CSL_0 THEN CSL_74
                             WHEN CR.FIPLAZOMAX = CSL_0 THEN CSL_47
                             WHEN CR.FIDIAPAGOUNICO = CSL_1 THEN CSL_57
                             WHEN CR.FISTATUS = CSL_3 THEN CSL_93
                             ELSE CSL_0
                          END)
                            AS CODERROR,
                         FILISTANEGRA,
                         FIACEPTAPP,
                         FNSUMSALDO,
                         FICOMPRAS,
                         FNMONTOLCR,
                         FNENGANCHE1COMPRA,
                         FNCAPACIDADPAGO,
                         FNCAPACIDADPAGODISP,
                         FIPLAZOMAX,
                         CASE
                            WHEN PA_WAPLICA NOT IN (CSL_2, CSL_3)
                            THEN
                               CR.FNCAPACIDADPAGO
                            ELSE
                               PA_WCAPTOTAL
                         END
                            AS WCAPTOTAL,
                         CASE
                            WHEN PA_WAPLICA IN (CSL_2, CSL_3)
                            THEN
                               PA_WCAPTOTAL
                               - (CR.FNCAPACIDADPAGO - CR.FNCAPACIDADPAGODISP)
                            ELSE
                               CSL_0
                         END
                            AS WCAPDISPO
                    FROM RCREDITO.CREDLINEADECREDITO CR
                   WHERE     FIPAIS = PA_PAIS
                         AND FICANAL = PA_CANAL
                         AND FISUCURSAL = PA_SUCURSAL
                         AND FIFOLIO = PA_FOLIO)
      SELECT CN.FISTATUS,
             TAB1.WCAPDISPO,
             TAB1.WCAPTOTAL,
             TAB1.FNMONTOLCR,
             TAB1.FNENGANCHE1COMPRA,
             TAB1.FIACEPTAPP,
             TAB1.FILISTANEGRA,
             TAB1.FNSUMSALDO,
             TAB1.CODERROR,
             TAB1.FICOMPRAS,
             TAB1.FIPLAZOMAX,
             TAB1.FNCAPACIDADPAGO,
             TAB1.FNCAPACIDADPAGODISP
        FROM    RCREDITO.CENLINEADECREDITO CN
             INNER JOIN
                TAB1
             ON     TAB1.FIPAIS = CN.FIPAIS
                AND TAB1.FICANAL = CN.FICANAL
                AND TAB1.FISUCURSAL = CN.FISUCURSAL
                AND TAB1.FIFOLIO = CN.FIFOLIO;

   REC_CAPPAGO          CURCAPPAG%ROWTYPE;

   --CURSOR 6
   CURSOR CURNUEVOESQ (
      PA_PAIS                     RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                    RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                 RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                    RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE)
   IS
      SELECT NVL (CSL_COD01, CSL_NVOESQUEMA) AS NVOESQUEMA
        FROM RCREDITO.CREDCLIENTETIENDA CTE
             INNER JOIN RCREDITO.CREDSOLICITUD SOL
                ON     SOL.FIPAISID = CTE.FIPAISID
                   AND SOL.FICANALID = CTE.FICANALID
                   AND SOL.FISUCURSALID = CTE.FISUCURSALID
                   AND SOL.FIIDNEGOCIO = CTE.FIIDNEGOCIO
                   AND SOL.FIIDTIENDA = CTE.FIIDTIENDA
                   AND SOL.FIIDCLIENTE = CTE.FIIDCLIENTE
             INNER JOIN RCREDITO.TACRCREDINVESTIGACION INV
                ON     INV.FIPAIS = SOL.FIPAISID
                   AND INV.FICANAL = SOL.FICANALID
                   AND INV.FISUCURSAL = SOL.FISUCURSALID
                   AND INV.FISOLICITUDID = SOL.FISOLICITUDID
                   AND INV.FIINVESTSTAT = CSL_214
       WHERE     CTE.FIPAIS = PA_PAIS
             AND CTE.FICANAL = PA_CANAL
             AND CTE.FISUCURSAL = PA_SUCURSAL
             AND CTE.FIFOLIO = PA_FOLIO
             AND SOL.FISTAT NOT IN (CSL_9, CSL_18)
      HAVING COUNT (CSL_1) > CSL_0;

   REC_NUEVOESQ         CURNUEVOESQ%ROWTYPE;

   --CURSOR 7
   CURSOR CUR_STATUSLCR (
      PA_PAIS                     RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                    RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                 RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                    RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE)
   IS
      SELECT FINOPRESPERACT AS WNOPRESPERACT
        FROM RCREDITO.CREDSTATUSLCR
       WHERE     FIPAIS = PA_PAIS
             AND FICANAL = PA_CANAL
             AND FISUCURSAL = PA_SUCURSAL
             AND FIFOLIO = PA_FOLIO;

   REC_STATUSLCR        CUR_STATUSLCR%ROWTYPE;


   --CURSOR 8
   CURSOR CUR_PRODUCTOLCR (
      PA_PAIS                     RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                    RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                 RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                    RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE,
      PA_TIPOOPS                  NUMBER)
   IS
      WITH TAB1
              AS (SELECT CASE
                            WHEN FNCAPACIDADPAGO < CSL_0 THEN CSL_NEG
                            ELSE CSL_POS
                         END
                            AS WSIGCAPPAGSG,
                         CASE
                            WHEN FNCAPACIDADPAGO < CSL_0
                            THEN
                               ABS (FNCAPACIDADPAGO)
                            ELSE
                               FNCAPACIDADPAGO
                         END
                            AS WSPRCAPPAG,
                         CASE
                            WHEN FNCAPACIDADPAGODISP < CSL_0 THEN CSL_NEG
                            ELSE CSL_POS
                         END
                            AS WSIGCAPDISSG,
                         CASE
                            WHEN FNCAPACIDADPAGODISP < CSL_0
                            THEN
                               ABS (FNCAPACIDADPAGODISP)
                            ELSE
                               FNCAPACIDADPAGODISP
                         END
                            AS WSPRCAPDIS,
                         CASE
                            WHEN FNIMPREVOLVENTE < CSL_0 THEN CSL_NEG
                            ELSE CSL_POS
                         END
                            AS WSIGIMPREVERSO,
                         CASE
                            WHEN FNIMPREVOLVENTE < CSL_0
                            THEN
                               ABS (FNIMPREVOLVENTE)
                            ELSE
                               FNIMPREVOLVENTE
                         END
                            AS WSPRIMPREV,
                         CASE
                            WHEN FNABONOSEM < CSL_0 THEN CSL_NEG
                            ELSE CSL_POS
                         END
                            AS WSIGABONOS,
                         CASE
                            WHEN FNABONOSEM < CSL_0 THEN ABS (FNABONOSEM)
                            ELSE FNABONOSEM
                         END
                            AS WSPRABONOS,
                         FINOPEDIDO AS WSPRPEDIDO,
                         FISTATUS AS WSPRSTATUS
                    FROM RCREDITO.CREDCAPPAGOPRODUCTOLCR
                   WHERE     FIPAIS = PA_PAIS
                         AND FICANAL = PA_CANAL
                         AND FISUCURSAL = PA_SUCURSAL
                         AND FIFOLIO = PA_FOLIO
                         AND FITIPOOPS = PA_TIPOOPS)
      SELECT WSIGCAPPAGSG,
             WSPRCAPPAG,
             WSIGCAPDISSG,
             WSPRCAPDIS,
             WSIGIMPREVERSO,
             LPAD (REPLACE (TO_CHAR (WSPRIMPREV, CSL_FORMATN), CSL_PUNT),
                   CSL_8,
                   CSL_CAD0)
                AS WSPRIMPREV,
             TAB1.WSIGABONOS,
             WSPRABONOS,
             TO_CHAR (LPAD (NVL (WSPRPEDIDO, CSL_0), CSL_10, CSL_CAD0))
                AS WSPRPEDIDO,
             WSPRSTATUS
        FROM TAB1;

   REC_PRODUCTOLCR      CUR_PRODUCTOLCR%ROWTYPE;

   --CURSOR 9

   CURSOR CUR_BUSCASOLIC (
      PA_PAIS                     RCREDITO.CREDCLIENTETIENDA.FIPAIS%TYPE,
      PA_CANAL                    RCREDITO.CREDCLIENTETIENDA.FICANAL%TYPE,
      PA_SUCURSAL                 RCREDITO.CREDCLIENTETIENDA.FISUCURSAL%TYPE,
      PA_FOLIO                    RCREDITO.CREDCLIENTETIENDA.FIFOLIO%TYPE)
   IS
      WITH TAB1
              AS (  SELECT B.FIPAISID,
                           B.FICANALID,
                           B.FISUCURSALID,
                           B.FISOLICITUDID,
                           B.FDFECSOL
                      FROM    RCREDITO.CREDCLIENTETIENDA A
                           INNER JOIN
                              RCREDITO.CREDSOLICITUD B
                           ON     B.FIPAISID = A.FIPAISID
                              AND B.FICANALID = A.FICANALID
                              AND B.FISUCURSALID = A.FISUCURSALID
                              AND B.FIIDNEGOCIO = A.FIIDNEGOCIO
                              AND B.FIIDTIENDA = A.FIIDTIENDA
                              AND B.FIIDCLIENTE = A.FIIDCLIENTE
                     WHERE     A.FIPAIS = PA_PAIS
                           AND A.FICANAL = PA_CANAL
                           AND A.FISUCURSAL = PA_SUCURSAL
                           AND A.FIFOLIO = PA_FOLIO
                           AND B.FITIPOSOLICITUD IN (CSL_8, CSL_217)
                           AND B.FISTAT = CSL_6
                  ORDER BY B.FDFECSOL DESC FETCH FIRST CSL_1 ROWS ONLY
                                          )
      SELECT TRIM (FCCARCOLOR) FCCARCOLOR
        FROM    RCREDITO.TACRMATRSCORBIT TC
             INNER JOIN
                TAB1
             ON     TC.FIPAIS = TAB1.FIPAISID
                AND TC.FICANAL = TAB1.FICANALID
                AND TC.FISUCURSAL = TAB1.FISUCURSALID
                AND TC.FISOLICITUD = TAB1.FISOLICITUDID
                AND TC.FIPRODUCTO = CSL_22;


   REC_BUSCASOLIC       CUR_BUSCASOLIC%ROWTYPE;

PRAGMA AUTONOMOUS_TRANSACTION;   

BEGIN
   CSL_MONTODEC := PA_MONTO / CSL_100;
   VL_WSPAIS := TO_NUMBER (SUBSTR (PA_TRACK1, CSL_2, CSL_2));
   VL_WSCANAL := TO_NUMBER (SUBSTR (PA_TRACK1, CSL_4, CSL_2));
   VL_WSSUCURSAL := TO_NUMBER (SUBSTR (PA_TRACK1, CSL_6, CSL_4));
   VL_WSFOLIO := TO_NUMBER (SUBSTR (PA_TRACK1, CSL_10, CSL_10));
   VL_WCANVEN := TO_NUMBER (SUBSTR (PA_IDCOMER, CSL_8, CSL_2));
   VL_WSUCVEN := TO_NUMBER (SUBSTR (PA_IDCOMER, CSL_10, CSL_4));
   VL_WTDAVEN := VL_WSUCVEN;
   VL_TODAYTIME := SYSDATE;
   VL_FECLOCAL := TO_CHAR (VL_TODAYTIME, 'MMDD');
   VL_HORLOCAL := TO_CHAR (VL_TODAYTIME, 'HH24MISS');
   
   BEGIN 
    RCREDITO.SPINSBITAUTORIZACNS(PA_TIPOMSG,
                                PA_CODPROC,
                                PA_MONTO,
                                PA_NDCS,
                                PA_HORLOCAL,
                                PA_FECLOCAL,
                                PA_FECCIERR,
                                PA_MODOPOS,
                                PA_TRACK2,
                                PA_RRN,
                                PA_NUMAUTOR,
                                PA_CODRESP,
                                PA_IDTERM,
                                PA_IDCOMER,
                                PA_TRACK1,
                                PA_PAGPLAZO,
                                PA_CODMONED,
                                PA_MENSHOST,
                                USER,
                                vl_ResError,
                                vl_ComError);
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;  

   IF PA_MENSHOST <> CSL_BLANCO
   THEN
      BEGIN
         VL_WEPRODUCTO := TO_NUMBER (TRIM (PA_MENSHOST));
      EXCEPTION
         WHEN OTHERS
         THEN
            VL_WEPRODUCTO := CSL_0;
      END;
   END IF;

   OPEN CURVALCANAL (VL_WSUCVEN);

   FETCH CURVALCANAL INTO REC_VALIDACANAL;

   CLOSE CURVALCANAL;

   IF NVL (REC_VALIDACANAL.CODERROR, CSL_ERR12) = CSL_ERR12
   THEN
      VL_WCODERR := CSL_ERR12;
      RAISE EXC_SRERROR;
   END IF;

   VL_CODRESP := VL_OK;

   OPEN CURVALPER (VL_WSPAIS,
                   VL_WSCANAL,
                   VL_WSSUCURSAL,
                   VL_WSFOLIO,
                   CSL_MONTODEC);

   FETCH CURVALPER INTO REC_VALIDAPERIODO;

   CLOSE CURVALPER;

   CSL_MONTODEC:=NVL(REC_VALIDAPERIODO.MONTODEC,CSL_MONTODEC);

   OPEN CURCAPCONSUMO (VL_WSPAIS,
                       VL_WSCANAL,
                       VL_WSSUCURSAL,
                       VL_WSFOLIO,
                       PA_IDTERM);

   FETCH CURCAPCONSUMO INTO REC_CAPCONSUMO;

   CLOSE CURCAPCONSUMO;

   IF NVL (REC_CAPCONSUMO.WAPLICA, CSL_0) <> CSL_3
   THEN
      OPEN CUR_CAPMAXPROD (VL_WSPAIS,
                           VL_WSCANAL,
                           VL_WSSUCURSAL,
                           VL_WSFOLIO,
                           PA_IDTERM,
                           NVL (REC_CAPCONSUMO.FNCONSUMO, CSL_0),
                           NVL (REC_CAPCONSUMO.WAPLICA, CSL_0),
                           NVL (REC_CAPCONSUMO.WCAPTOTAL, CSL_0));

      FETCH CUR_CAPMAXPROD INTO REC_CAPMAXPROD;

      CLOSE CUR_CAPMAXPROD;
   END IF;

   IF REC_CAPMAXPROD.WAPLICA IS NULL
   THEN
      REC_CAPMAXPROD.CAPTOTCONSUMO := NVL (REC_CAPCONSUMO.FNCONSUMO, CSL_0);
      REC_CAPMAXPROD.WAPLICA := NVL (REC_CAPCONSUMO.WAPLICA, CSL_0);
      REC_CAPMAXPROD.WCAPTOTAL := NVL (REC_CAPCONSUMO.WCAPTOTAL, CSL_0);
   END IF;


   IF REC_CAPCONSUMO.WAPLICA IS NULL AND REC_CAPMAXPROD.WAPLICA = CSL_0
   THEN
      REC_CAPMAXPROD.WAPLICA := CSL_1;
   END IF;

   OPEN CURCAPPAG (VL_WSPAIS,
                   VL_WSCANAL,
                   VL_WSSUCURSAL,
                   VL_WSFOLIO,
                   NVL (REC_CAPMAXPROD.WAPLICA, CSL_0),
                   NVL (REC_CAPMAXPROD.WCAPTOTAL, CSL_0));

   FETCH CURCAPPAG INTO REC_CAPPAGO;

   CLOSE CURCAPPAG;
   
    IF REC_CAPPAGO.CODERROR <> CSL_0 OR REC_CAPPAGO.CODERROR IS NULL THEN
          VL_WCODERR := NVL(REC_CAPPAGO.CODERROR, CSL_45);
        RAISE EXC_SRERROR;
    END IF;


   vl_CapDispCredL := REC_CAPPAGO.FNCAPACIDADPAGODISP;

   IF NVL (REC_CAPMAXPROD.WAPLICA, CSL_1) = CSL_1
   THEN
      IF NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0) < CSL_600
      THEN
         SELECT FNVALOR1, FNVALOR2
           INTO VL_WFNVALOR1, VL_WFNVALOR2
           FROM RCREDITO.TACONTROLPARM
          WHERE FIITEM = CSL_12 AND FISUBITEM = CSL_1;

         SELECT FISUBITEMID
           INTO VL_CAPTOPE
           FROM RCREDITO.TACATALSRC
          WHERE FIITEMID = CSL_223;

         OPEN CURINGRESOS (VL_WSPAIS,
                           VL_WSCANAL,
                           VL_WSSUCURSAL,
                           VL_WSFOLIO,
                           VL_CAPTOPE);

         FETCH CURINGRESOS INTO REC_INGRESOS;

         CLOSE CURINGRESOS;



         IF NVL (REC_INGRESOS.WCAPACIDAD30, CSL_0) > CSL_600
         THEN
            REC_CAPPAGO.WCAPTOTAL := CSL_600;
         ELSE
            REC_CAPPAGO.WCAPTOTAL := NVL (REC_INGRESOS.WCAPACIDAD30, CSL_0);
         END IF;

         REC_CAPPAGO.WCAPDISPO :=
            REC_CAPPAGO.WCAPTOTAL
            - (REC_CAPPAGO.FNCAPACIDADPAGO - REC_CAPPAGO.FNCAPACIDADPAGODISP);
      END IF;
   END IF;

   IF TRIM (PA_IDTERM) = CSL_ITALIKA
   THEN
      OPEN CUR_BUSCASOLIC (VL_WSPAIS,
                           VL_WSCANAL,
                           VL_WSSUCURSAL,
                           VL_WSFOLIO);

      FETCH CUR_BUSCASOLIC INTO REC_BUSCASOLIC;

      CLOSE CUR_BUSCASOLIC;

      IF NVL (REC_BUSCASOLIC.FCCARCOLOR, CSL_BLANCO) = VL_COLORVERDE
         AND NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0) <= CSL_395
      THEN
         VL_FACTOR := CSL_017;
      ELSIF NVL (REC_BUSCASOLIC.FCCARCOLOR, CSL_BLANCO) <> VL_COLORVERDE
            AND NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0) <= CSL_350
      THEN
         VL_FACTOR := CSL_017;
      END IF;

      IF VL_FACTOR > CSL_1
      THEN
         REC_CAPPAGO.WCAPTOTAL :=
            ROUND (NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0) * VL_FACTOR, CSL_0);

         IF NVL (REC_BUSCASOLIC.FCCARCOLOR, CSL_BLANCO) = VL_COLORVERDE
            AND NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0) > CSL_395
         THEN
            REC_CAPPAGO.WCAPTOTAL := CSL_395;
         ELSIF NVL (REC_BUSCASOLIC.FCCARCOLOR, CSL_BLANCO) <> VL_COLORVERDE
               AND NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0) > CSL_350
         THEN
            REC_CAPPAGO.WCAPTOTAL := CSL_350;
         END IF;

         REC_CAPPAGO.WCAPDISPO :=
            REC_CAPPAGO.WCAPTOTAL
            - (REC_CAPPAGO.FNCAPACIDADPAGO - REC_CAPPAGO.FNCAPACIDADPAGODISP);
      END IF;
   END IF;

   IF NVL (REC_CAPPAGO.WCAPDISPO, CSL_0) > NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0)
   THEN
      VL_WCODERR := CSL_97;
   ELSIF NVL (REC_CAPPAGO.WCAPDISPO, CSL_0) > CSL_0
   THEN
      VL_WKCAPUSADA :=
         NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0)
         - NVL (REC_CAPPAGO.WCAPDISPO, CSL_0);
   ELSIF NVL (REC_CAPPAGO.WCAPDISPO, CSL_0) = CSL_0
   THEN
      VL_WKCAPUSADA := NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0);
   ELSE
      VL_WKCAPUSADA :=
         NVL (REC_CAPPAGO.WCAPTOTAL, CSL_0)
         + (ABS (NVL (REC_CAPPAGO.WCAPDISPO, CSL_0)));
   END IF;

   OPEN CURNUEVOESQ (VL_WSPAIS,
                     VL_WSCANAL,
                     VL_WSSUCURSAL,
                     VL_WSFOLIO);

   FETCH CURNUEVOESQ INTO REC_NUEVOESQ;

   CLOSE CURNUEVOESQ;

   VL_SOBREG :=
      CASE
         WHEN VL_WSOBREGIRO > CSL_0
         THEN
            LPAD (
               REPLACE (TO_CHAR (NVL (VL_WSOBREGIRO, CSL_0), CSL_FORMATN),
                        CSL_PUNT),
               CSL_12,
               CSL_CAD0)
         ELSE
            VL_SOBREG
      END;

   VL_WKCAPUSADA := VL_WKCAPUSADA + CSL_MONTODEC;

   IF VL_WCODERR <> VL_OK
   THEN
      RAISE EXC_SRERROR;
   END IF;

   BEGIN
      SELECT FNVALOR1, FISTATUS
        INTO VL_MONTOMIN, VL_STATUSMONTO
        FROM RCREDITO.TACONTROLPARM
       WHERE FIITEM = CSL_12 AND FISUBITEM = CSL_2;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         VL_MONTOMIN := CSL_25;
   END;

   IF (VL_STATUSMONTO = CSL_1 AND VL_WKCAPUSADA < VL_MONTOMIN)
      OR (VL_STATUSMONTO = CSL_2 AND CSL_MONTODEC < VL_MONTOMIN)
   THEN
      VL_WCODERR := CSL_13;
      RAISE EXC_SRERROR;
   END IF;

   IF NVL (REC_CAPPAGO.WCAPDISPO, CSL_0) < CSL_0
   THEN
      VL_WCODERR := CSL_97;
      RAISE EXC_SRERROR;
   END IF;
   vl_wAbonoTotal := CSL_MONTODEC;
   IF vl_weproducto = csl_28
   THEN
      vl_wplazo := TO_NUMBER (NVL (SUBSTR (pa_pagplazo, csl_3, csl_2), csl_0));

      IF vl_wplazo = csl_0
      THEN
         vl_wcoderr := csl_47;
         RAISE exc_SrError;
      END IF;

      BEGIN
         SELECT FNCAPACIDADPAGO,
                FNCAPACIDADPAGODISP,
                FNIMPREVOLVENTE,
                TO_CHAR (LPAD (FINOPEDIDO, csl_10, vl_cad0))
           INTO vl_CapPago28,
                vl_CapPagoDisp28,
                vl_Importe28,
                vl_wspedrev
           FROM RCREDITO.CREDCAPPAGOPRODUCTOLCR
          WHERE     FIPAIS = vl_wspais
                AND FICANAL = vl_wscanal
                AND FISUCURSAL = vl_wssucursal
                AND FIFOLIO = vl_wsfolio
                AND FITIPOOPS = csl_28;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF vl_wcapDispo < vl_CapPagoDisp28
      THEN
         vl_CapPagoDisp28 := vl_wcapDispo;
      END IF;

      IF vl_CapPagoDisp28 * vl_wplazodef >= vl_Importe28
      THEN
         IF vl_wAbonoTotal > vl_CapPagoDisp28
         THEN
            vl_wcoderr := csl_51;
            RAISE exc_SrError;
         ELSE
            vl_CapDispCredL := vl_CapDispCredL - vl_wAbonoTotal;
            vl_CapPagoDisp28 := vl_CapPagoDisp28 - vl_wAbonoTotal;
            vl_Montolcr := vl_CapDispCredL * vl_Plazomax;
            vl_wsformaven := LPAD (TO_CHAR (csl_1), csl_4, vl_cad0);
         END IF;
      ELSE
         IF vl_wAbonoTotal > vl_Importe28
         THEN
            vl_wcoderr := csl_51;
            RAISE exc_SrError;
         ELSE
            vl_Importe28 := vl_Importe28 - (vl_wAbonoTotal * vl_wplazo);
            vl_wsformaven := LPAD (TO_CHAR (csl_2), csl_4, vl_cad0);
         END IF;
      END IF;

      UPDATE RCREDITO.CREDLINEADECREDITO
         SET FNCAPACIDADPAGODISP = vl_CapDispCredL,
             FNMONTOLCR = vl_Montolcr,
             FDFECHAALTACREDITO = vl_FecNull
       WHERE     FIPAIS = vl_wspais
             AND FICANAL = vl_wscanal
             AND FISUCURSAL = vl_wssucursal
             AND FIFOLIO = vl_wsfolio;

      UPDATE RCREDITO.CREDCAPPAGOPRODUCTOLCR
         SET FNCAPACIDADPAGODISP = vl_CapPagoDisp28,
             FNIMPREVOLVENTE = vl_Importe28
       WHERE     FIPAIS = vl_wspais
             AND FICANAL = vl_wscanal
             AND FISUCURSAL = vl_wssucursal
             AND FIFOLIO = vl_wsfolio
             AND FITIPOOPS = csl_28;

      vl_Monto := TO_CHAR (vl_wcapDispo);
   ELSE                                                      --weproducto = 28
     vl_wcapDispo:= rec_cappago.wcapdispo;
      IF TRIM (pa_rrn) <> vl_blanc
      THEN
         vl_wAbonoMile := TO_NUMBER (pa_rrn) / csl_100;
      END IF;

      IF vl_wAbonoMile > csl_1
      THEN
         IF vl_wcapDispo >= CSL_MONTODEC
         THEN
            vl_wAbonoTotal := CSL_MONTODEC + vl_wAbonoMile;
            vl_wNuevaCapDs := vl_wcapDispo;

            IF vl_wNuevaCapDs < vl_wAbonoTotal
            THEN
               SELECT FNVALOR1
                 INTO vl_wPorCtjSobC
                 FROM RCREDITO.TACONTROLPARM
                WHERE FIITEM = csl_12 AND FISUBITEM = csl_3;

               vl_wRequierPor := csl_1;
               vl_wNuevaCapDs :=
                  vl_wcapDispo + ROUND (vl_wcapDispo * vl_wPorCtjSobC, csl_0);
            END IF;

            IF vl_wNuevaCapDs >= vl_wAbonoTotal
            THEN
               vl_wresult := vl_wNuevaCapDs - vl_wAbonoTotal;
               CSL_MONTODEC := vl_wAbonoTotal;
               vl_wOcupaMile := csl_1;

               IF vl_wRequierPor = csl_1
               THEN
                  vl_wCapReque := vl_wAbonoTotal - vl_wcapDispo;
                  vl_Rrn :=
                     LPAD (
                        REPLACE (TO_CHAR (vl_wCapReque, CSL_FORMATN),
                                 CSL_PUNT),
                        csl_12,
                        vl_cad0);
               END IF;
            ELSE
               vl_wcoderr := csl_51;
               vl_Monto := pa_monto;
               RAISE exc_SrError;
            END IF;
         ELSE
            vl_wcoderr := csl_51;
            vl_Monto := pa_monto;
            RAISE exc_SrError;
         END IF;
      END IF;

      IF vl_wOcupaMile = csl_0
      THEN
            vl_wresult := rec_cappago.wcapdispo - vl_wAbonoTotal;
      END IF;

      IF NVL(vl_wresult,csl_0) >= csl_0
      THEN
         vl_Monto := TO_CHAR (vl_wresult);

         UPDATE RCREDITO.CREDLINEADECREDITO
            SET FNCAPACIDADPAGODISP = vl_CapDispCredL - vl_wAbonoTotal,
                FNMONTOLCR = vl_CapDispCredL * vl_Plazomax,
                FDFECHAULTAUT = SYSDATE,
                FDFECHAALTACREDITO = vl_FecNull
          WHERE     FIPAIS = vl_wspais
                AND FICANAL = vl_wscanal
                AND FISUCURSAL = vl_wssucursal
                AND FIFOLIO = vl_wsfolio;
      ELSE
         vl_wcoderr := csl_51;
         vl_Monto := pa_monto;
         RAISE exc_SrError;
      END IF;
   END IF;                                             --      weproducto = 28

   COMMIT;

   BEGIN
      SELECT TO_CHAR (csl_0)
        INTO vl_wclientenvo
        FROM    RCREDITO.CENCLIENTETIENDA cn
             INNER JOIN
                RCREDITO.PEDIDOS_CREDITO pc
             ON     pc.FINGCIOID = cn.FINGCIOID
                AND pc.FINOTIENDA = cn.FINOTIENDA
                AND pc.FICTEID = cn.FICTEID
                AND pc.FIDIGITOVER = cn.FIDIGITOVER
       WHERE     cn.FIPAIS = vl_wspais
             AND cn.FICANAL = vl_wscanal
             AND cn.FISUCURSAL = vl_wssucursal
             AND cn.FIFOLIO = vl_wsfolio
             AND pc.FIPEDSTATUS = csl_1
             AND pc.FDFECHASURT > vl_FecNull
   FETCH FIRST CSL_1 ROWS ONLY;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         vl_wclientenvo := TO_CHAR (csl_1);
   END;

   vl_wNumAutor := RCREDITO.senumautoriza.NEXTVAL;
   vl_wsventa := vl_wsformaven || vl_wspedrev || vl_wclientenvo;
   vl_Codresp := vl_wcoderr;
   vl_Numautor := LPAD (TO_CHAR (vl_wNumAutor), csl_6, vl_cad0);

   IF NVL(vl_Monto,csl_0) <> pa_monto
   THEN
      vl_Monto :=
         LPAD (REPLACE (TO_CHAR (vl_Monto, CSL_FORMATN), CSL_PUNT),
               csl_12,
               vl_cad0);
   END IF;

   vl_Codproc := pa_codproc;
   vl_Ndcs := pa_ndcs;
   vl_Feccierr := pa_feccierr;
   vl_Modopos := pa_modopos;
   vl_Track2 := pa_track2;
   vl_Idterm := pa_idterm;
   vl_Idcomer := pa_idcomer;
   vl_Track1 := pa_track1;
   vl_Pagplazo := pa_pagplazo;
   vl_Codmoned := pa_codmoned;
   vl_Menshost := vl_wsventa;

   vl_SobreGiro :=
      CASE
         WHEN vl_wsobreGiro > csl_0
         THEN
            LPAD (REPLACE (TO_CHAR (vl_wsobreGiro, CSL_FORMATN), CSL_PUNT),
                  csl_12,
                  vl_cad0)
         ELSE
            vl_0000000
      END;
   vl_NvoEsquema := NVL(REC_NUEVOESQ.NVOESQUEMA,CSL_00);
   vl_Feclocal := TO_CHAR (SYSDATE, 'MMDD');
   vl_Horlocal := TO_CHAR (SYSDATE, 'HH24MISS');
   -- REGISTRA EN LA TABLA ATRZ_CTRL Y BITACORAAUTORIZACIONES
      BEGIN
         rcredito.spinstaatrzctrl (NVL (vl_wspais, csl_0),
                                   NVL (vl_wcanven, csl_0),
                                   NVL (vl_wsucven, csl_0),
                                   vl_Numautor,
                                   vl_todaytime,
                                   csl_0,
                                   csl_0,
                                   csl_0,
                                   NVL (vl_wspais, csl_0),
                                   NVL (vl_wscanal, csl_0),
                                   NVL (vl_wssucursal, csl_0),
                                   NVL (vl_wsfolio, csl_0),
                                   csl_0,
                                   csl_0,
                                   csl_0,
                                   csl_0,
                                   csl_0,
                                   csl_0,
                                   pa_track2,
                                   PA_IDCOMER,
                                   vl_wCapReque,
                                   csl_0,
                                   NVL (TO_NUMBER(vl_wsformaven), csl_0),
                                   csl_0,
                                   NVL (vl_weproducto, csl_0),
                                   csl_0,
                                   csl_0,
                                   csl_1,
                                   NVL (CSL_MONTODEC, csl_0),
                                   csl_0,
                                   csl_0,
                                   VL_FDATRZCTRL,
                                   csl_0,
                                   csl_0,
                                   VL_FDATRZCTRL,
                                   csl_0,
                                   csl_1,
                                   NVL (vl_wabonototal, csl_0),
                                   csl_blanco,
                                   USER,
                                   SYSDATE,
                                   vl_ResError,
                                   vl_ComError);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

   BEGIN
      rcredito.spinsbitautorizacns (VL_TIPOMSG,
                                    pa_codproc,
                                    vl_Monto,
                                    pa_ndcs,
                                    vl_horlocal,
                                    vl_feclocal,
                                    pa_feccierr,
                                    pa_modopos,
                                    pa_track2,
                                    vl_rrn,
                                    vl_Numautor,
                                    vl_codresp,
                                    pa_idterm,
                                    pa_idcomer,
                                    pa_track1,
                                    pa_pagplazo,
                                    pa_codmoned,
                                    vl_Menshost,
                                    USER,
                                    vl_ResError,
                                    vl_ComError);
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   --SRBITACORA_S
   OPEN VLREC_CURSORSALIDA FOR
      SELECT vl_Tipomsg AS Tipomsg,
             vl_Codproc AS Codproc,
             vl_Monto AS Monto,
             vl_Ndcs AS Ndcs,
             vl_Horlocal AS Horlocal,
             vl_Feclocal AS Feclocal,
             vl_Feccierr AS Feccierr,
             vl_Modopos AS Modopos,
             vl_Track2 AS Track2,
             vl_Rrn AS Rrn,
             vl_Numautor AS Numautor,
             vl_Codresp AS Codresp,
             vl_Idterm AS Idterm,
             vl_Idcomer AS Idcomer,
             vl_Track1 AS Track1,
             vl_Pagplazo AS Pagplazo,
             vl_Codmoned AS Codmoned,
             vl_Menshost AS Menshost,
             vl_Esquema AS Esquema,
             vl_SobreGiro AS SobreGiro,
             vl_NvoEsquema AS NvoEsquema
        FROM DUAL;

   RETURN VLREC_CURSORSALIDA;
EXCEPTION
   WHEN exc_SrError
   THEN
      ROLLBACK;
      vl_Codresp := vl_wcoderr;
      vl_Numautor := vl_blanc;
      vl_Monto := pa_monto;
      vl_Codproc := pa_codproc;
      vl_Ndcs := pa_ndcs;
      vl_Feccierr := pa_feccierr;
      vl_Modopos := pa_modopos;
      vl_Track2 := pa_track2;
      vl_Idterm := pa_idterm;
      vl_Idcomer := pa_idcomer;
      vl_Track1 := pa_track1;
      vl_Pagplazo := pa_pagplazo;
      vl_Codmoned := pa_codmoned;

      IF vl_weproducto = csl_28
      THEN
         vl_Menshost := pa_menshost;
      ELSE
         vl_Menshost := vl_0000;
      END IF;

      vl_SobreGiro := vl_0000000;
      vl_NvoEsquema := NVL(REC_NUEVOESQ.NVOESQUEMA,CSL_00);
      vl_Feclocal := TO_CHAR (SYSDATE, 'MMDD');
      vl_Horlocal := TO_CHAR (SYSDATE, 'HH24MISS');

      BEGIN
         rcredito.spinsbitautorizacns (VL_TIPOMSG,
                                       pa_codproc,
                                       vl_Monto,
                                       pa_ndcs,
                                       vl_horlocal,
                                       vl_feclocal,
                                       pa_feccierr,
                                       pa_modopos,
                                       pa_track2,
                                       vl_rrn,
                                       pa_numautor,
                                       vl_codresp,
                                       pa_idterm,
                                       pa_idcomer,
                                       pa_track1,
                                       pa_pagplazo,
                                       pa_codmoned,
                                       vl_Menshost,
                                       USER,
                                       vl_ResError,
                                       vl_ComError);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      OPEN VLREC_CURSORSALIDA FOR
         SELECT vl_Tipomsg AS Tipomsg,
                vl_Codproc AS Codproc,
                vl_Monto AS Monto,
                vl_Ndcs AS Ndcs,
                vl_Horlocal AS Horlocal,
                vl_Feclocal AS Feclocal,
                vl_Feccierr AS Feccierr,
                vl_Modopos AS Modopos,
                vl_Track2 AS Track2,
                vl_Rrn AS Rrn,
                vl_Numautor AS Numautor,
                vl_Codresp AS Codresp,
                vl_Idterm AS Idterm,
                vl_Idcomer AS Idcomer,
                vl_Track1 AS Track1,
                vl_Pagplazo AS Pagplazo,
                vl_Codmoned AS Codmoned,
                vl_Menshost AS Menshost,
                vl_Esquema AS Esquema,
                vl_SobreGiro AS SobreGiro,
                vl_NvoEsquema AS NvoEsquema
           FROM DUAL;

      RETURN VLREC_CURSORSALIDA;
END FNSRVENTAS;
/
GRANT EXECUTE ON RCREDITO.FNSRVENTAS TO RCACT, USRWEB, USRCREDITO, USRINFCOBZA, USRBATCH;