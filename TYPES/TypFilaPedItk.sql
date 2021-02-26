CREATE OR REPLACE TYPE RCREDITO.TypFilaPedItk AS OBJECT
 (fipaiscu   NUMBER(5)
, ficanalcu  NUMBER(5)
, fisucursalcu NUMBER(10)
, fifolio   NUMBER(10)
, ficanal  NUMBER(5)
, fisucursal NUMBER(10)
, finopedido NUMBER(10)
, fipedstatus   NUMBER(5)
, fnenganche  NUMBER(15,2)
, fnsaldo   NUMBER(15,2)
, fdcsaldocapital  NUMBER(15,2)
, fdcintxfinanciar  NUMBER(15,2)
, fdfechasurt  DATE
, fiplazo   NUMBER(5)
, fiunidadnegocio  NUMBER(5)
, fitipocliente  NUMBER(5));


CREATE OR REPLACE TYPE RCREDITO.TypTabPedItk IS TABLE OF RCREDITO.TypFilaPedItk;


GRANT EXECUTE ON RCREDITO.TypFilaPedItk TO RCACT,USRRCACT,USRWEB,USRBATCH;
GRANT EXECUTE ON RCREDITO.TypTabPedItk TO RCACT,USRRCACT,USRWEB,USRBATCH;