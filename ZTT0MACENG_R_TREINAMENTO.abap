REPORT ztt0maceng_r_treinamento NO STANDARD PAGE HEADING LINE-SIZE 197 MESSAGE-ID ZTT0MACENG_CM_REPORT.

TABLES: ztt0maceng_tm_tr.

TOP-OF-PAGE.
  WRITE: / sy-vline,
             2(15) 'Usuário' COLOR COL_HEADING,
             sy-vline,
             19(10) 'Pacote' COLOR COL_HEADING,
             sy-vline,
             32(60)  'Descrição',
             sy-vline,
             94(10) 'Dt.Admissão',
             sy-vline,
             106(2) 'Trl',
             sy-vline,
             110(20) 'Nome Colaborador',
             sy-vline,
             134(10) 'Change Request',
             sy-vline,
             146(50) 'Descrição',
             sy-vline,
             sy-uline.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_user      FOR ztt0maceng_tm_tr-bname NO INTERVALS,
                  s_pacote    FOR ztt0maceng_tm_tr-devclass NO INTERVALS,
                  s_admdt     FOR ztt0maceng_tm_tr-data_admissao,
                  s_rqst      FOR ztt0maceng_tm_tr-tr_trkorr,
                  s_trn       FOR ztt0maceng_tm_tr-treinamento NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b01.

TYPES:
  BEGIN OF ty_s_treinamento,
    bname            TYPE ztt0maceng_tm_tr-bname, "User Name in User Master Record
    devclass         TYPE ztt0maceng_tm_tr-devclass, "Package
    ctext            TYPE ztt0maceng_tm_tr-ctext, "Short Description of Repository Objects
    data_admissao    TYPE ztt0maceng_tm_tr-data_admissao, "Data de Admissão do Colaborador
    treinamento      TYPE ztt0maceng_tm_tr-treinamento, "Sigla do Treinamento
    nome_colaborador TYPE ztt0maceng_tm_tr-nome_colaborador, "Nome do Colaborador
    tr_trkorr        TYPE ztt0maceng_tm_tr-tr_trkorr, "Input field for request number for individual display
    as4text          TYPE ztt0maceng_tm_tr-as4text, "Short Description of Repository Objects
  END   OF ty_s_treinamento.

TYPES: ty_t_treinamento TYPE SORTED TABLE OF ty_s_treinamento WITH UNIQUE KEY bname devclass.

START-OF-SELECTION.

  DATA: tl_treinamento TYPE ty_t_treinamento.
  DATA: wl_treinamento TYPE ty_s_treinamento.

  SELECT bname devclass ctext data_admissao treinamento nome_colaborador tr_trkorr as4text
    FROM ztt0maceng_tm_tr INTO TABLE tl_treinamento
    WHERE bname         IN s_user
    AND   devclass      IN s_pacote
    AND   data_admissao IN s_admdt
    AND   tr_trkorr     IN s_rqst
    AND   treinamento   IN s_trn.

IF sy-subrc <> 0.
  MESSAGE s005 DISPLAY LIKE 'E'.
ENDIF.

LOOP AT tl_treinamento INTO wl_treinamento.
  WRITE: / sy-vline,
             2(15) wl_treinamento-nome_colaborador COLOR COL_KEY,
             sy-vline,
             19(10) wl_treinamento-devclass COLOR COL_KEY,
             sy-vline,
             32(60) wl_treinamento-ctext,
             sy-vline,
             94(10) wl_treinamento-data_admissao,
             sy-vline,
             106(2) wl_treinamento-treinamento,
             sy-vline,
             110(20) wl_treinamento-nome_colaborador,
             sy-vline,
             134(10) wl_treinamento-tr_trkorr,
             sy-vline,
             146(50) wl_treinamento-as4text,
             sy-vline,
             sy-uline.
ENDLOOP.