*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_OPEN_ABAP_SQL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_open_abap_sql.

TABLES: zasa0lss_tm_cad.

*--------------------------------------------------------------------*
*Estrutura globais                                                   *
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_s_cadastro,
    registro   TYPE zasa0lss_tm_cad-registro,
    nome       TYPE zasa0lss_tm_cad-nome,
    nascimento TYPE zasa0lss_tm_cad-nascimento,
  END OF ty_s_cadastro.

TYPES: ty_t_cadastro TYPE STANDARD TABLE OF ty_s_cadastro WITH NON-UNIQUE KEY registro.

DATA: tg_cadastro TYPE ty_t_cadastro,
      tg_fieldcat TYPE slis_t_fieldcat_alv.

DATA: wg_fieldcat TYPE slis_fieldcat_alv,
      wg_cadastro TYPE zasa0lss_tm_cad.
*--------------------------------------------------------------------*

*--------------------------------------------------------------------*
* TELA                                                               *
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

    SELECT-OPTIONS: s_reg    FOR zasa0lss_tm_cad-registro   NO-EXTENSION NO INTERVALS OBLIGATORY,
                    s_nome   FOR zasa0lss_tm_cad-nome       NO-EXTENSION NO INTERVALS,
                    s_nas    FOR zasa0lss_tm_cad-nascimento NO-EXTENSION NO INTERVALS.

    SELECTION-SCREEN SKIP.

    PARAMETERS: p_vs RADIOBUTTON GROUP grp1,
                p_cr RADIOBUTTON GROUP grp1,
                p_dl RADIOBUTTON GROUP grp1.

  SELECTION-SCREEN END OF BLOCK b01.
*--------------------------------------------------------------------*

START-OF-SELECTION.

  CASE 'X'.
    WHEN p_vs.

      SELECT registro nome nascimento
        FROM zasa0lss_tm_cad
        INTO TABLE tg_cadastro
          WHERE registro    IN s_reg
            AND nome        IN s_nome
            AND nascimento  IN s_nas.

      wg_fieldcat-fieldname = 'REGISTRO'.
      wg_fieldcat-seltext_s = 'REG.'.
      wg_fieldcat-seltext_m = 'REGISTRO'.
      wg_fieldcat-seltext_l = 'REGISTRO'.
      wg_fieldcat-key       = 'X'.
      APPEND wg_fieldcat TO tg_fieldcat.
      CLEAR: wg_fieldcat.

      wg_fieldcat-fieldname = 'NOME'.
      wg_fieldcat-seltext_s = 'NM.'.
      wg_fieldcat-seltext_m = 'NOME'.
      wg_fieldcat-seltext_l = 'NOME'.
      APPEND wg_fieldcat TO tg_fieldcat.
      CLEAR: wg_fieldcat.

      wg_fieldcat-fieldname = 'NASCIMENTO'.
      wg_fieldcat-seltext_s = 'NASC.'.
      wg_fieldcat-seltext_m = 'NASCIMENTO'.
      wg_fieldcat-seltext_l = 'NASCIMENTO'.
      APPEND wg_fieldcat TO tg_fieldcat.
      CLEAR: wg_fieldcat.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          it_fieldcat = tg_fieldcat
        TABLES
          t_outtab    = tg_cadastro
        EXCEPTIONS
          OTHERS      = 1.

      WHEN p_cr.
        wg_cadastro-registro = s_reg-low.
        wg_cadastro-nome = s_nome-low.
        wg_cadastro-nascimento = s_nas-low.

        INSERT zasa0lss_tm_cad FROM wg_cadastro.

        IF sy-subrc = 0.
*          MESSAGE |Deu certo : { wg_cadastro-nome }| TYPE 'S' DISPLAY LIKE 'S'.
          COMMIT WORK.
        ELSE.
*          MESSAGE |Deu ruim : { wg_cadastro-nome }| TYPE 'S' DISPLAY LIKE 'E'.
          ROLLBACK WORK.
        ENDIF.

        CLEAR wg_cadastro.

        WHEN p_dl.
          wg_cadastro-registro    = s_reg-low.
          wg_cadastro-nome        = s_nome-low.
          wg_cadastro-nascimento  = s_nas-low.

        DELETE zasa0lss_tm_cad FROM wg_cadastro.

        IF sy-subrc = 0.
*          MESSAGE |Deu certo : { wg_cadastro-nome }| TYPE 'S' DISPLAY LIKE 'S'.
          COMMIT WORK.
        ELSE.
*          MESSAGE |Deu ruim : { wg_cadastro-nome }| TYPE 'S' DISPLAY LIKE 'E'.
          ROLLBACK WORK.
        ENDIF.

        CLEAR wg_cadastro.

  ENDCASE.