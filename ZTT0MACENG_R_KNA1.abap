REPORT ztt0maceng_r_kna1 NO STANDARD PAGE HEADING LINE-SIZE 62.

TABLES: KNA1.

TOP-OF-PAGE.

  WRITE: / sy-uline,
             sy-vline,
             2(10)    'Cliente' COLOR COL_KEY,
             sy-vline,
             14(10)   'País',
             sy-vline,
             27(10)   'Nome',
             sy-vline,
             39(10)   'Cidade',
             sy-vline,
             51(10)   'Grp.Contas',
             sy-vline,
             sy-uline.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS s_KUNNR FOR kna1-kunnr.
SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.

  DATA: wl_KNA1 TYPE ztt0maceng_s_kna1.
  DATA: tl_KNA1 TYPE ztt0maceng_ct_kna1.

  SELECT kunnr land1 name1 ort01 ktokd
    FROM kna1
    INTO TABLE tl_kna1
    WHERE kunnr IN s_KUNNR.

  LOOP AT tl_kna1 INTO wl_kna1.
    WRITE: / sy-vline,
             2(10) wl_kna1-kunnr,
             sy-vline,
             14(10) wl_kna1-land1,
             sy-vline,
             27(10) wl_kna1-name1,
             sy-vline,
             39(10) wl_kna1-ort01,
             sy-vline,
             51(10) wl_kna1-ktokd,
             sy-vline,
             sy-uline.

  ENDLOOP.