REPORT zttmaceng_r_fieldcat_tabint.

TYPES:
  BEGIN OF ty_s_alv,
    bukrs  TYPE t001-bukrs,
    branch TYPE j_1bbranch-branch,
    name1  TYPE j_1bbranch-name,
  END OF ty_s_alv.

TYPES: ty_t_alv TYPE STANDARD TABLE OF ty_s_alv.

DATA: tl_alv      TYPE ty_t_alv,
      tl_fieldcat TYPE slis_t_fieldcat_alv.

CALL FUNCTION 'ZTT0MACENG_MF_FIELDCAT_TABINT'
  EXPORTING
    i_t_alv      = tl_alv " Uma tabela interna com campos do ALV
  IMPORTING
    e_t_fieldcat = tl_fieldcat. "Catalogação dos campos a partir da tabela interna

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    it_fieldcat = tl_fieldcat
  TABLES
    t_outtab    = tl_alv.