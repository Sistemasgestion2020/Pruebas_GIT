-- *************************************************** TAEST *************************************************************

CREATE TABLE RCACT.TAEST01001_7018
( DPRODID            NUMBER(10) 
 ,DIDCAMPANHA        NUMBER(10) 
 ,DEXISTENCIA        NUMBER(10)         
 ,DCONPAGOID         NUMBER(10) 
 ,DSIGNO             CHAR(1)         
 ,DMONTOPAGOREQ      NUMBER(9,2)  
);

GRANT INSERT, SELECT, UPDATE, DELETE ON  RCACT.TAEST01001_7018 TO USRRCACT;

-- ******************************************************** TASPAEJECUTAR ********************************************************

-- Programa que utiliza cada registro

MERGE INTO RCACT.TASPAEJECUTAR D
   USING (SELECT DISTINCT FIPAISID,FICANALID,7018 FITIPOREG ,'SP01001_7018' FCNOMBRE_SP 
     FROM RCACT.TASPAEJECUTAR
    WHERE FITIPOREG=220) S
   ON (D.FIPAISID = S.FIPAISID
       and D.FICANALID = S.FICANALID
       and D.FITIPOREG = S.FITIPOREG)
   WHEN MATCHED THEN UPDATE SET D.FCNOMBRE_SP = S.FCNOMBRE_SP
   WHEN NOT MATCHED THEN INSERT (D.FIPAISID, D.FICANALID, D.FITIPOREG, D.FCNOMBRE_SP )
                         VALUES (S.FIPAISID, S.FICANALID, S.FITIPOREG, S.FCNOMBRE_SP);
                         
COMMIT;    
  
-- ***************************************************** REGISTRO ***********************************************************
-- Descripcion de registro

MERGE INTO RCACT.REGISTRO D
   USING (SELECT DISTINCT FIPAISID ,FICANAL ,0000 FITIPOREG 
        ,'Registro Existencia productos de promoción en CE' FCDESCREG 
        ,'SP01001_7018'  FCSTOREPROC ,' ' FCOBSERVA ,1 FISTATUSP ,0 FISTATUSE 
     FROM RCACT.REGISTRO
    WHERE FITIPOREG=220) S
   ON (D.FIPAISID = S.FIPAISID
       AND D.FICANAL = S.FICANAL
       AND D.FITIPOREG = S.FITIPOREG)
   WHEN MATCHED THEN UPDATE SET D.FCDESCREG = S.FCDESCREG
                               ,D.FCSTOREPROC = S.FCSTOREPROC
                               ,D.FISTATUSP = S.FISTATUSP
                               ,D.FISTATUSE = S.FISTATUSE
   WHEN NOT MATCHED THEN INSERT (D.FIPAISID, D.FICANAL, D.FITIPOREG, D.FCDESCREG, D.FCSTOREPROC, D.FCOBSERVA, D.FISTATUSP, D.FISTATUSE )
                         VALUES (S.FIPAISID, S.FICANAL, S.FITIPOREG, S.FCDESCREG, S.FCSTOREPROC, S.FCOBSERVA, S.FISTATUSP, S.FISTATUSE );   
   
COMMIT;   


-- **************************************************** REG X TRAN ************************************************************
-- Relacion entre el registro y la transaccion

MERGE INTO RCACT.REGXTRAN D
   USING (SELECT DISTINCT FIPAISID
            ,FICANAL
            ,2881 FITRANTIPO 
            ,7018 FITIPOREG 
            ,1    FIORDENREG 
            ,'O'  FCREQREG 
            ,0    FCNOREG 
     FROM RCACT.REGXTRAN
    WHERE FITIPOREG=220) S
   ON (D.FIPAISID = S.FIPAISID
       AND D.FICANAL = S.FICANAL
       AND D.FITRANTIPO = S.FITRANTIPO
       AND D.FITIPOREG = S.FITIPOREG)
   WHEN MATCHED THEN UPDATE SET D.FIORDENREG = S.FIORDENREG
                               ,D.FCREQREG = S.FCREQREG
                               ,D.FCNOREG = S.FCNOREG
   WHEN NOT MATCHED THEN INSERT (D.FIPAISID, D.FICANAL, D.FITRANTIPO, D.FITIPOREG, D.FIORDENREG, D.FCREQREG, D.FCNOREG  )
                         VALUES (S.FIPAISID, S.FICANAL, S.FITRANTIPO, S.FITIPOREG, S.FIORDENREG, S.FCREQREG, S.FCNOREG  );   
   
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
    WHERE TABLE_NAME LIKE 'TAEST01001_7018' AND OWNER = 'RCACT' ORDER BY 2,1) S
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



