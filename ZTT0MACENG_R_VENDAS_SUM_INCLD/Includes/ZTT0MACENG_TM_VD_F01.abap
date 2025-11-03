*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_VD_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_fldcat USING p_v_struct TYPE dd02l-tabname p_v_fieldname TYPE slis_fieldname.
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = p_v_struct
    CHANGING
      ct_fieldcat      = tg_fldcat.

  CASE 'X'.
    WHEN p_detal.
      READ TABLE tg_fldcat ASSIGNING FIELD-SYMBOL(<field>) WITH KEY fieldname = p_v_fieldname.
      IF <field> IS ASSIGNED.
        <field>-do_sum = 'X'.
      ENDIF.
      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'QTD'.
      IF <field> IS ASSIGNED.
        <field>-do_sum = 'X'.
      ENDIF.

    WHEN p_flal.
      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = p_v_fieldname.
      IF <field> IS ASSIGNED.
        <field>-do_sum = 'X'.
      ENDIF.
    WHEN p_mat.
      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = p_v_fieldname.
      IF <field> IS ASSIGNED.
        <field>-do_sum = 'X'.
      ENDIF.
    WHEN p_clt.
      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = p_v_fieldname.
      IF <field> IS ASSIGNED.
        <field>-do_sum = 'X'.
      ENDIF.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_alv.
  DATA: wl_layout TYPE slis_layout_alv.

  wl_layout-zebra = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = tg_fldcat
      is_layout     = wl_layout
      i_grid_title  = 'Relatório de Vendas'
    TABLES
      t_outtab    = <alv>.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form carrega_dados
*&---------------------------------------------------------------------*
FORM carrega_dados .
  CASE 'X'.
    WHEN p_clt.
      SELECT kunnr SUM( valor ) AS valor
        FROM ztt0maceng_tm_vd INTO TABLE tg_cliente
        WHERE kunnr IN s_kunnr
          GROUP BY kunnr.

      ASSIGN tg_cliente TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_CLIENTE' 'VALOR'.

    WHEN p_detal.
      SELECT nro item matnr maktx data_venda bukrs branch kunnr valor unv qtd
        FROM ztt0maceng_tm_vd INTO TABLE tg_detalhada
        WHERE bukrs       IN s_bukrs
        AND   branch      IN s_branch
        AND   nro         IN s_nro
        AND   data_venda  IN s_dt_vd
        AND   kunnr       IN s_kunnr.

      ASSIGN tg_detalhada TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_DETALHADA' 'VALOR'.

    WHEN p_flal.
      SELECT bukrs branch SUM( valor ) AS valor
        FROM ztt0maceng_tm_vd INTO TABLE tg_filial
        WHERE bukrs       IN s_bukrs
        AND   branch      IN s_branch
        GROUP BY bukrs branch.

      ASSIGN tg_filial TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_FILIAL_SUM' 'VALOR'.

    WHEN p_mat.
      SELECT matnr maktx SUM( valor ) AS valor
        FROM ztt0maceng_tm_vd INTO TABLE tg_material
        WHERE matnr IN s_matnr
        AND   maktx IN s_maktx
        GROUP BY matnr maktx.

      ASSIGN tg_material TO <alv>.

      PERFORM zf_fldcat USING 'ZTT0MACENG_S_MATERIAL' 'VALOR'.

  ENDCASE.
ENDFORM.