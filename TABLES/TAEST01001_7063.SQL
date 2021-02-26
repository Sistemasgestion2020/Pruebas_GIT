-- *************************************************** TAEST *************************************************************

CREATE TABLE RCACT.TAEST01001_7063
( DSOLICITUDID         NUMBER(10)      
 ,DPAIS                NUMBER(3) 
 ,DCANAL               NUMBER(3) 
 ,DSUCURSAL            NUMBER(5) 
 ,DFOLIO               NUMBER(10) 
 ,DNGCIOID             NUMBER(3) 
 ,DNOTIENDA            NUMBER(5) 
 ,DCTEID               NUMBER(10) 
 ,DDIGITOVER           NUMBER(3) 
 ,DPAISGESTOR          NUMBER(3) 
 ,DCANALGESTOR         NUMBER(3) 
 ,DSUCGESTORA          NUMBER(5) 
 ,DALTA                DATE
 ,DINGRESO             NUMBER(3) 
 ,DAVAL                NUMBER(3) 
 ,DREFERENCIA          NUMBER(3)
);

GRANT INSERT, SELECT, UPDATE, DELETE ON  RCACT.TAEST01001_7063 TO USRRCACT;




 
-- ***************************************************** REGISTRO ***********************************************************
-- Descripcion de registro

Insert into RCACT.TAREGISTROS (FIPAISID, FICANAL, FITIPOREG, FCDESCREG, FCNAMESP, FCOBSERVA, FISTATUSP, FISTATUSE)
       Values (1, 1, 7063, 'Solicitudes foraneas generdas en agencias FAW', 'SP01001_7063',' ', 1, 0);       
 
COMMIT;


-- ************************************************** DATASTRUCT **************************************************************
-- Estructura de datos

MERGE INTO RCACT.DATASTRUCT D
   USING (SELECT COLUMN_ID, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_PRECISION   
          , (CASE 
             WHEN DATA_TYPE = 'DATE' THEN  19
             WHEN DATA_TYPE = 'TIMESTAMP(6)' THEN 11 
             ELSE
                DATA_LENGTH      
             END ) AS DATA_LENGTH 
          ,DATA_SCALE
     FROM ALL_TAB_COLUMNS     
    WHERE TABLE_NAME LIKE 'TAEST01001_7063' AND OWNER = 'RCACT' ORDER BY 2,1) S
   ON (D.TABLE_NAME = S.TABLE_NAME
       and D.COLUMN_ID = S.COLUMN_ID)
   WHEN MATCHED THEN UPDATE SET D.COLUMN_NAME = S.COLUMN_NAME
                               ,D.DATA_TYPE = S.DATA_TYPE
                               ,D.DATA_PRECISION = S.DATA_PRECISION
                               ,D.DATA_LENGTH  = S.DATA_LENGTH 
                               ,D.DATA_SCALE = S.DATA_SCALE
   WHEN NOT MATCHED THEN INSERT (D.COLUMN_ID, D.TABLE_NAME, D.COLUMN_NAME, D.DATA_TYPE, D.DATA_PRECISION, D.DATA_LENGTH, D.DATA_SCALE )
     VALUES (S.COLUMN_ID, S.TABLE_NAME, S.COLUMN_NAME, S.DATA_TYPE, S.DATA_PRECISION, S.DATA_LENGTH,S.DATA_SCALE);
     
COMMIT;    


