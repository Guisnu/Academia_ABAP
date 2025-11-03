REPORT ztt0maceng_r_bkp NO STANDARD PAGE HEADING.

TABLES: bkpf.

TOP-OF-PAGE.

  WRITE: / sy-uline,
             sy-vline,
             2(10)    'Num.DOC' COLOR COL_KEY,
             sy-vline,
             14(10)   'Empresa' COLOR COL_KEY,
             sy-vline,
             27(10)   'Ano.Fiscal' COLOR COL_KEY,
             sy-vline,
             39(10)   'Tipo.Doc',
             sy-vline,
             51(10)   'Publi.Doc',
             sy-vline,
             sy-uline.

  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
    SELECT-OPTIONS s_belnr FOR bkpf-belnr.
    SELECT-OPTIONS s_bukrs FOR bkpf-bukrs NO INTERVALS NO-EXTENSION.
    SELECT-OPTIONS s_gjahr FOR bkpf-gjahr.
  SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
*Construindo Estrutura Interna
*--------------------------------------------------------------------*
  TYPES:
    BEGIN OF ty_s_bkpf,
      belnr TYPE bkpf-belnr,
      bukrs TYPE bkpf-bukrs,
      gjahr TYPE bkpf-gjahr,
      blart TYPE bkpf-blart,
      budat TYPE bkpf-budat,
    END OF ty_s_bkpf.

*--------------------------------------------------------------------*
*Criando Categoria de Tabela com Base na Minha Estrutura
*--------------------------------------------------------------------*
  TYPES: ty_t_bkpf TYPE HASHED TABLE OF ty_s_bkpf WITH UNIQUE KEY belnr bukrs gjahr.

START-OF-SELECTION.

  DATA: tl_bkpf TYPE ty_t_bkpf.
  DATA: wl_bkpf TYPE ty_s_bkpf.


  SELECT belnr bukrs gjahr blart budat
    FROM bkpf
    INTO TABLE tl_bkpf
    WHERE belnr IN s_belnr
    AND   bukrs IN s_bukrs
    AND   gjahr IN s_gjahr.

*--------------------------------------------------------------------*
*Continuar com o write dos em Lista das colunas da tabela
*--------------------------------------------------------------------*

  LOOP AT tl_bkpf INTO wl_bkpf.
    WRITE: / sy-vline,
             2(10) wl_bkpf-belnr,
             sy-vline,
             14(10) wl_bkpf-bukrs,
             sy-vline,
             27(10) wl_bkpf-gjahr,
             sy-vline,
             39(10) wl_bkpf-blart,
             sy-vline,
             51(10) wl_bkpf-budat,
             sy-vline,
             sy-uline.

  ENDLOOP.