*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_LISTAGEM01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_listagem01 NO STANDARD PAGE HEADING LINE-COUNT 33 LINE-SIZE 103.

TOP-OF-PAGE.
  WRITE: / sy-uline,
           sy-vline,
           2(10) 'chassi',
           sy-vline,
           14(10) 'marca',
           sy-vline,
           27(10) 'modelo',
           sy-vline,
           39(10) 'ano',
           sy-vline,
           51(10) 'cor',
           sy-vline,
           63(15) 'kilometragem',
           sy-vline,
           80(10) 'moeda',
           sy-vline,
           92(10) 'valor',
           sy-vline,
           sy-uline.

START-OF-SELECTION.

DATA: wl_carros TYPE ztt0maceng_s_car.

DATA: tl_carros TYPE ztt0maceng_ct_car.

  SELECT chassi marca modelo ano cor kilometragem moeda valor
    FROM ztt0maceng_tm_cr
    INTO TABLE tl_carros.

  LOOP AT tl_carros INTO wl_carros.
    WRITE: / sy-vline,
           2(10) wl_carros-chassi COLOR COL_KEY,
           sy-vline,
           14(10) wl_carros-marca,
           sy-vline,
           27(10) wl_carros-modelo,
           sy-vline,
           39(10) wl_carros-ano,
           sy-vline,
           51(10) wl_carros-cor,
           sy-vline,
           63(15) wl_carros-kilometragem,
           sy-vline,
           80(10) wl_carros-moeda,
           sy-vline,
           92(10) wl_carros-valor,
           sy-vline,
           sy-uline.

  ENDLOOP.