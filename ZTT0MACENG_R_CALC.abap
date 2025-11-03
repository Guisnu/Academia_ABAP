REPORT ztt0maceng_r_calc MESSAGE-ID ztt0maceng_cm_report.

SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE TEXT-b11.

  SELECTION-SCREEN SKIP 1.

  SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
*  PARAMETERS: p_valor1 TYPE p DECIMALS 2,
*              p_valor2 TYPE p DECIMALS 2.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 2(20) TEXT-c05 FOR FIELD p_valor1.
      PARAMETERS: p_valor1 TYPE p DECIMALS 2.
      SELECTION-SCREEN COMMENT 45(20) TEXT-c06 FOR FIELD p_valor2.
      PARAMETERS: p_valor2 TYPE p DECIMALS 2.
    SELECTION-SCREEN END OF LINE.
*           p_calc TYPE c LENGTH 1 OBLIGATORY.
  SELECTION-SCREEN END OF BLOCK b01.

  SELECTION-SCREEN SKIP 1.

  SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.

  SELECTION-SCREEN BEGIN OF LINE.
*   PARAMETERS: p_soma RADIOBUTTON GROUP grp1,
*                p_sub  RADIOBUTTON GROUP grp1,
*                p_div  RADIOBUTTON GROUP grp1,
*                p_mul  RADIOBUTTON GROUP grp1.
    PARAMETERS: p_soma RADIOBUTTON GROUP grp1.
    SELECTION-SCREEN COMMENT 4(20) TEXT-c01 FOR FIELD p_soma.
    PARAMETERS: p_sub RADIOBUTTON GROUP grp1.
    SELECTION-SCREEN COMMENT 27(20) TEXT-c02 FOR FIELD p_sub.
    PARAMETERS: p_div RADIOBUTTON GROUP grp1.
    SELECTION-SCREEN COMMENT 50(20) TEXT-c03 FOR FIELD p_div.
    PARAMETERS: p_mul RADIOBUTTON GROUP grp1.
    SELECTION-SCREEN COMMENT 75(20) TEXT-c04 FOR FIELD p_mul.

  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN END OF BLOCK B11.

START-OF-SELECTION.

  DATA: vl_resultado TYPE p DECIMALS 2.

*--------------------------------------------------------------------*
*Case para uso dos Parameters com campo de escrita                   *
*--------------------------------------------------------------------*
*  CASE p_calc.
*    WHEN '+'.
*      vl_resultado = p_valor1 + p_valor2.
*      WRITE vl_resultado.
*    WHEN '-'.
*      vl_resultado = p_valor1 - p_valor2.
*      WRITE vl_resultado.
*    WHEN '/'.
*      IF p_valor2 = 0.
*        MESSAGE s002 WITH p_calc DISPLAY LIKE 'E'.
**      Usado para não Permitir dividir por denominador menor que o numerador mas não é o ideal na ocasião
**      ELSEIF p_valor1 < p_valor2.
**        MESSAGE s003 WITH p_calc DISPLAY LIKE 'E'.
*      ELSE.
*        vl_resultado = p_valor1 / p_valor2.
*        WRITE vl_resultado.
*      ENDIF.
*    WHEN '*'.
*      vl_resultado = p_valor1 * p_valor2.
*      WRITE vl_resultado.
*    WHEN OTHERS.
*      MESSAGE s001 WITH p_calc DISPLAY LIKE 'E'.
*  ENDCASE.

*--------------------------------------------------------------------*
*Case para Radio Buttons                                             *
*--------------------------------------------------------------------*
  CASE 'X'.
    WHEN p_soma.
      vl_resultado = p_valor1 + p_valor2.
      WRITE vl_resultado.
    WHEN p_sub.
      vl_resultado = p_valor1 - p_valor2.
      WRITE vl_resultado.
    WHEN p_div.
      IF p_valor2 = 0.
        MESSAGE s002 DISPLAY LIKE 'E'.
*      Usado para não Permitir dividir por denominador menor que o numerador mas não é o ideal na ocasião
*      ELSEIF p_valor1 < p_valor2.
*        MESSAGE s003 WITH p_calc DISPLAY LIKE 'E'.
      ELSE.
        vl_resultado = p_valor1 / p_valor2.
        WRITE vl_resultado.
      ENDIF.
    WHEN p_mul.
      vl_resultado = p_valor1 * p_valor2.
      WRITE vl_resultado.
  ENDCASE.