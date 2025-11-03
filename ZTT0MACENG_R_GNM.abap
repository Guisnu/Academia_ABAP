REPORT ztt0maceng_r_gnm.

TABLES: KNA1, LFA1.

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME.
  SELECT-OPTIONS: s_land FOR kna1-land1.
SELECTION-SCREEN  END OF BLOCK B01.

TYPES: BEGIN OF ty_s_participante,
         tipo   TYPE char10,
         codigo TYPE char10,
         nome   TYPE name1,
         pais   TYPE land1,
       END OF ty_s_participante.

DATA: tg_participantes TYPE TABLE OF ty_s_participante,
      wg_participante TYPE ty_s_participante.

START-OF-SELECTION.

SELECT a~kunnr,
         a~name1 AS nome_cliente,
         a~land1 AS pais,
         b~lifnr,
         b~name1 AS nome_fornecedor
    FROM kna1 AS a
    INNER JOIN lfa1 AS b
      ON a~land1 = b~land1
    INTO TABLE @DATA(tg_resultado)
    WHERE a~land1 IN @s_land.

  LOOP AT tg_resultado INTO DATA(wg_linha).
    WRITE: / 'Cliente:', wg_linha-kunnr, wg_linha-nome_cliente,
             'Fornecedor:', wg_linha-lifnr, wg_linha-nome_fornecedor,
             'País:', wg_linha-pais.
  ENDLOOP.