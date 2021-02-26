CREATE OR REPLACE FUNCTION RCREDITO.FNAUTSP019 (
   pa_Fiedoid    IN RCREDITO.ESTADO.FIEDOID%TYPE)
   RETURN SYS_REFCURSOR
IS

rcl_refcursor  SYS_REFCURSOR;
exc_Error     EXCEPTION;
vl_Fcedodesc  RCREDITO.ESTADO.FCEDODESC%TYPE;
csl_0         CONSTANT PLS_INTEGER := 0;
csl_1         CONSTANT PLS_INTEGER := 1;
vl_Esp        VARCHAR2(1) := ' ';

BEGIN
BEGIN
  SELECT FCEDODESC
    INTO vl_Fcedodesc
    FROM RCREDITO.ESTADO
   WHERE FIPAISID = csl_1
    AND FIEDOID = pa_Fiedoid;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE exc_Error;
  WHEN TOO_MANY_ROWS THEN
    RAISE exc_Error;
END;
  OPEN rcl_refcursor  FOR
    SELECT FIAGENCIAID AS IDAGENCIA,
           FCCONTAGENCIA AS CONTAGENCIA,
           FCNOMAGENCIA AS NOMAGENCIA,
           FCRAZONSOCIAL AS RAZONSOC,
           FCRFC AS RFC,
           FCCALLE AS CALLE,
           FCNOEXTERIOR AS EXTERIOR,
           FCNOINTERIOR AS INTERIOR,
           FNCODIGOPOSTAL AS CODIGOPOS,
           FCCOLONIA AS COLONIA,
           FIPOBLACION AS IDPOBLACION,
           FIESTADO AS IDESTADO,
           FCLADA AS LADA,
           FCTELEFONO AS TELEFONO,
           FCEMAIL AS EMAIL,
           FCCTABANCO AS CTABANCO,
           FIIDMARCA AS IDMARCA,
           FISTATUS AS STATUS,
           FIIDBANCO AS IDBANCO,
           FIIDNEGOCIO AS IDNEGOCIO,
           FIIDMATRIZ AS DMATRIZ,
           FIISANCA AS IISANCA,
           FIISMATRIZ AS IMATRIZ
      FROM RCREDITO.TAAUTOAGENCIA
     WHERE FIESTADO = vl_Fcedodesc;
  RETURN rcl_refcursor ;
EXCEPTION 
  WHEN exc_Error THEN
    OPEN rcl_refcursor  FOR
    SELECT csl_0 AS IDAGENCIA,
           vl_Esp AS CONTAGENCIA,
           vl_Esp AS NOMAGENCIA,
           vl_Esp AS RAZONSOC,
           vl_Esp AS RFC,
           vl_Esp AS CALLE,
           vl_Esp AS EXTERIOR,
           vl_Esp AS INTERIOR,
           csl_0 AS CODIGOPOS,
           vl_Esp AS COLONIA,
           csl_0 AS IDPOBLACION,
           csl_0 AS IDESTADO,
           vl_Esp AS LADA,
           vl_Esp AS TELEFONO,
           vl_Esp AS EMAIL,
           vl_Esp AS CTABANCO,
           csl_0 AS IDMARCA,
           csl_0 AS STATUS,
           csl_0 AS IDBANCO,
           csl_0 AS IDNEGOCIO,
           csl_0 AS DMATRIZ,
           csl_0 AS IISANCA,
           csl_0 AS IMATRIZ
      FROM DUAL;     
  RETURN rcl_refcursor ;
  WHEN OTHERS THEN
    OPEN rcl_refcursor  FOR
    SELECT csl_0 AS IDAGENCIA,
           vl_Esp AS CONTAGENCIA,
           vl_Esp AS NOMAGENCIA,
           vl_Esp AS RAZONSOC,
           vl_Esp AS RFC,
           vl_Esp AS CALLE,
           vl_Esp AS EXTERIOR,
           vl_Esp AS INTERIOR,
           csl_0 AS CODIGOPOS,
           vl_Esp AS COLONIA,
           csl_0 AS IDPOBLACION,
           csl_0 AS IDESTADO,
           vl_Esp AS LADA,
           vl_Esp AS TELEFONO,
           vl_Esp AS EMAIL,
           vl_Esp AS CTABANCO,
           csl_0 AS IDMARCA,
           csl_0 AS STATUS,
           csl_0 AS IDBANCO,
           csl_0 AS IDNEGOCIO,
           csl_0 AS DMATRIZ,
           csl_0 AS IISANCA,
           csl_0 AS IMATRIZ
      FROM DUAL;    
  RETURN rcl_refcursor ;
END FNAUTSP019;
/

GRANT EXECUTE ON RCREDITO.FNAUTSP019 TO RCACT, USRRCACT, USRWEB;