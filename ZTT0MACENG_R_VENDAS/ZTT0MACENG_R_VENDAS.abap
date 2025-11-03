REPORT ztt0maceng_r_vendas NO STANDARD PAGE HEADING.

TABLES: ztt0maceng_tm_vd.

*--------------------------------------------------------------------*
*Interface de Blocos                                                 *
*--------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_bukrs       FOR ztt0maceng_tm_vd-bukrs      NO INTERVALS NO-EXTENSION.
  SELECT-OPTIONS: s_branch      FOR ztt0maceng_tm_vd-branch     NO INTERVALS.
  SELECT-OPTIONS: s_nro         FOR ztt0maceng_tm_vd-nro        NO INTERVALS.
  SELECT-OPTIONS: s_dt_vd       FOR ztt0maceng_tm_vd-data_venda.
  SELECT-OPTIONS: s_kunnr       FOR ztt0maceng_tm_vd-kunnr      NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  PARAMETERS: p_detal RADIOBUTTON GROUP grp1,
              p_flal  RADIOBUTTON GROUP grp1,
              p_mat   RADIOBUTTON GROUP grp1,
              p_clt   RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b02.

TOP-OF-PAGE.
  CASE 'X'.
    WHEN p_detal.
      WRITE: / sy-uline,
             sy-vline,
             2(10) 'NUM.PED' COLOR COL_KEY,
             sy-vline,
             14(3) 'Itm' COLOR COL_KEY,
             sy-vline,
             20(10) 'Material',
             sy-vline,
             32(10) 'Descrição',
             sy-vline,
             44(10) 'Data Vend.',
             sy-vline,
             56(10) 'Empresa',
             sy-vline,
             70(10) 'Filial',
             sy-vline,
             82(10) 'Cliente',
             sy-vline,
             94(10) 'Valor',
             sy-vline,
             106(3) 'Unv.',
             sy-vline,
             111(10) 'Quantidade',
             sy-vline,
             sy-uline.
    WHEN p_flal.
      WRITE: / sy-uline,
             sy-vline,
             2(10) 'Empresa' COLOR COL_GROUP,
             sy-vline,
             14(10) 'Filial' COLOR COL_GROUP,
             sy-vline,
             27(10) 'Valor',
             sy-vline,
             sy-uline.
    WHEN p_mat.
      WRITE: / sy-uline,
             sy-vline,
             2(10) 'Material' COLOR COL_GROUP,
             sy-vline,
             14(10) 'Descrição',
             sy-vline,
             27(10) 'Valor',
             sy-vline,
             sy-uline.
    WHEN p_clt.
      WRITE: / sy-uline,
             sy-vline,
             2(10) 'Cliente' COLOR COL_GROUP,
             sy-vline,
             14(10) 'Valor',
             sy-vline,
             sy-uline.
  ENDCASE.


*--------------------------------------------------------------------*
*Estruturas e categoria de tabelas                                   *
*--------------------------------------------------------------------*

  TYPES:
    BEGIN OF ty_s_detalhada,
      nro        TYPE ztt0maceng_tm_vd-nro,
      item       TYPE ztt0maceng_tm_vd-item,
      matnr      TYPE ztt0maceng_tm_vd-matnr,
      maktx      TYPE ztt0maceng_tm_vd-maktx,
      data_venda TYPE ztt0maceng_tm_vd-data_venda,
      bukrs      TYPE ztt0maceng_tm_vd-bukrs,
      branch     TYPE ztt0maceng_tm_vd-branch,
      kunnr      TYPE ztt0maceng_tm_vd-kunnr,
      valor      TYPE ztt0maceng_tm_vd-valor,
      unv        TYPE ztt0maceng_tm_vd-unv,
      qtd        TYPE ztt0maceng_tm_vd-qtd,
    END OF ty_s_detalhada,

    BEGIN OF ty_s_filial,
      bukrs  TYPE ztt0maceng_tm_vd-bukrs,
      branch TYPE ztt0maceng_tm_vd-branch,
      valor  TYPE ztt0maceng_tm_vd-valor,
    END OF ty_s_filial,

    BEGIN OF ty_s_material,
      matnr TYPE ztt0maceng_tm_vd-matnr,
      maktx TYPE ztt0maceng_tm_vd-maktx,
      valor TYPE ztt0maceng_tm_vd-valor,
    END OF ty_s_material,

    BEGIN OF ty_s_cliente,
      kunnr TYPE ztt0maceng_tm_vd-kunnr,
      valor TYPE ztt0maceng_tm_vd-valor,
    END OF ty_s_cliente.

  TYPES: ty_t_detalhada   TYPE HASHED TABLE OF ty_s_detalhada    WITH UNIQUE KEY nro item.
  TYPES: ty_t_filial      TYPE HASHED TABLE OF ty_s_filial       WITH UNIQUE KEY bukrs branch.
  TYPES: ty_t_material    TYPE HASHED TABLE OF ty_s_material     WITH UNIQUE KEY matnr maktx.
  TYPES: ty_t_cliente     TYPE HASHED TABLE OF ty_s_cliente      WITH UNIQUE KEY kunnr.

START-OF-SELECTION.

*--------------------------------------------------------------------*
*Criando Tabelas e Work-area
*--------------------------------------------------------------------*

  DATA: tl_detalhada TYPE ty_t_detalhada.
  DATA: wl_detalhada TYPE ty_s_detalhada.

  DATA: tl_filial    TYPE ty_t_filial.
  DATA: wl_filial    TYPE ty_s_filial.

  DATA: tl_material  TYPE ty_t_material.
  DATA: wl_material  TYPE ty_s_material.

  DATA: tl_cliente   TYPE ty_t_cliente.
  DATA: wl_cliente   TYPE ty_s_cliente.

*Alimentando tabela detalhada*
  SELECT nro item matnr maktx data_venda bukrs branch kunnr valor unv qtd
    FROM ztt0maceng_tm_vd INTO TABLE tl_detalhada
    WHERE bukrs       IN s_bukrs
    AND   branch      IN s_branch
    AND   nro         IN s_nro
    AND   data_venda  IN s_dt_vd
    AND   kunnr       IN s_kunnr.

*Loop de sumarização das outras tabelas*
  LOOP AT tl_detalhada INTO wl_detalhada.
    CASE 'X'.
      WHEN p_flal.
        CLEAR wl_filial.
        wl_filial-branch  = wl_detalhada-branch.
        wl_filial-bukrs   = wl_detalhada-bukrs.
        wl_filial-valor   = wl_detalhada-valor.
        COLLECT wl_filial INTO tl_filial.
      WHEN p_mat.
        CLEAR wl_material.
        wl_material-maktx = wl_detalhada-maktx.
        wl_material-matnr = wl_detalhada-matnr.
        wl_material-valor = wl_detalhada-valor.
        COLLECT wl_material INTO tl_material.
      WHEN p_clt.
        CLEAR wl_cliente.
        wl_cliente-kunnr = wl_detalhada-kunnr.
        wl_cliente-valor = wl_detalhada-valor.
        COLLECT wl_cliente INTO tl_cliente.
    ENDCASE.
  ENDLOOP.

*Loop para print das listas*
  CASE 'X'.
    WHEN p_detal.
      LOOP AT tl_detalhada INTO wl_detalhada .
        WRITE: / sy-vline,
             2(10) wl_detalhada-nro,
             sy-vline,
             14(3) wl_detalhada-item,
             sy-vline,
             20(10) wl_detalhada-matnr,
             sy-vline,
             32(10) wl_detalhada-maktx,
             sy-vline,
             44(10) wl_detalhada-data_venda,
             sy-vline,
             56(10) wl_detalhada-bukrs,
             sy-vline,
             70(10) wl_detalhada-branch,
             sy-vline,
             82(10) wl_detalhada-kunnr,
             sy-vline,
             94(10) wl_detalhada-valor,
             sy-vline,
             106(3) wl_detalhada-unv,
             sy-vline,
             111(10) wl_detalhada-qtd,
             sy-vline,
             sy-uline.
      ENDLOOP.
    WHEN p_flal.
      LOOP AT tl_filial INTO wl_filial.
        WRITE: / sy-vline,
               2(10) wl_filial-bukrs,
               sy-vline,
               14(10) wl_filial-branch,
               sy-vline,
               27(10) wl_filial-valor,
               sy-vline,
               sy-uline.
      ENDLOOP.
    WHEN p_mat.
      LOOP AT tl_material INTO wl_material.
        WRITE: / sy-vline,
               2(10) wl_material-matnr,
               sy-vline,
               14(10) wl_material-maktx,
               sy-vline,
               27(10) wl_material-valor,
               sy-vline,
               sy-uline.
      ENDLOOP.
    WHEN p_clt.
      LOOP AT tl_cliente INTO wl_cliente.
        WRITE: / sy-vline,
               2(10) wl_cliente-kunnr,
               sy-vline,
               14(10) wl_cliente-valor,
               sy-vline,
               sy-uline.
      ENDLOOP.

  ENDCASE.

*  BREAK-POINT.