*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_VD_F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form zf_carrega_tabelas
*&---------------------------------------------------------------------*
FORM zf_carrega_tabelas .
  SELECT partner partner_guid
    FROM but000
    INTO TABLE tg_but000
      WHERE partner IN s_parc.

*--------------------------------------------------------------------*
*PROCURANDO SE TEM UM FORNECEDOR COM OS DADOS                        *
*--------------------------------------------------------------------*
  IF tg_but000 IS NOT INITIAL.
    SELECT partner_guid vendor
          FROM cvi_vend_link
          INTO TABLE tg_vend_link
          FOR ALL ENTRIES IN tg_but000
            WHERE partner_guid EQ tg_but000-partner_guid
            AND vendor IN s_fornc.

    IF sy-subrc = 0.
      SELECT lifnr name1 land1 ort01 pstlz regio sortl stras mcod1 mcod3 adrnr
        FROM lfa1
        INTO TABLE tg_lfa1
        FOR ALL ENTRIES IN tg_vend_link
          WHERE ( lifnr EQ tg_vend_link-vendor
          AND   lifnr IN s_fornc ).

      IF p_fornc = 'X' AND sy-subrc = 0.
        SELECT addrnumber smtp_addr
          FROM adr6
          INTO TABLE tg_adr6
          FOR ALL ENTRIES IN tg_lfa1
            WHERE addrnumber EQ tg_lfa1-adrnr.
      ENDIF.

    ENDIF.
  ENDIF.

*--------------------------------------------------------------------*
*PROCURANDO CLIENTE                                                  *
*--------------------------------------------------------------------*
  IF tg_but000 IS NOT INITIAL.
    SELECT partner_guid customer
      FROM cvi_cust_link
      INTO TABLE tg_cust_link
      FOR ALL ENTRIES IN tg_but000
        WHERE partner_guid EQ tg_but000-partner_guid
        AND customer IN s_clt.

    IF sy-subrc = 0.
      SELECT kunnr name1 land1 ort01 pstlz regio sortl stras mcod1 mcod3 adrnr
        FROM kna1
        INTO TABLE tg_kna1
        FOR ALL ENTRIES IN tg_cust_link
        WHERE ( kunnr  EQ tg_cust_link-customer
        AND   kunnr IN s_clt ).

      IF p_clt = 'X' AND sy-subrc = 0.
        SELECT addrnumber smtp_addr
          FROM adr6
          INTO TABLE tg_adr6
          FOR ALL ENTRIES IN tg_kna1
            WHERE addrnumber EQ tg_kna1-adrnr.
      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_fldcat
*&---------------------------------------------------------------------*
FORM zf_fldcat USING p_v_struct TYPE dd02l-tabname.
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = p_v_struct
    CHANGING
      ct_fieldcat      = tg_fldcat.

  CASE 'X'.
    WHEN p_parc.

      READ TABLE tg_fldcat ASSIGNING FIELD-SYMBOL(<field>) WITH KEY fieldname = 'PARTNER'.
      IF <field> IS ASSIGNED.
        <field>-key  = 'X'.
        <field>-hotspot = 'X'.
        UNASSIGN <field>.
      ENDIF.

      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'STATUS'.
      IF <field> IS ASSIGNED.
        <field>-key  = 'X'.
        <field>-icon = 'X'.
      ENDIF.

      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'KUNNR'.
      IF <field> IS ASSIGNED.
        <field>-key  = 'X'.
        <field>-hotspot  = 'X'.
        UNASSIGN <field>.
      ENDIF.

      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'LIFNR'.
      IF <field> IS ASSIGNED.
        <field>-hotspot  = 'X'.
        UNASSIGN <field>.
      ENDIF.

    WHEN p_fornc.
      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'LIFNR'.
      IF <field> IS ASSIGNED.
        <field>-key = 'X'.
        <field>-hotspot  = 'X'.
        UNASSIGN <field>.
      ENDIF.

      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'PARTNER'.
      IF <field> IS ASSIGNED.
        <field>-key  = 'X'.
        <field>-hotspot = 'X'.
        UNASSIGN <field>.
      ENDIF.

    WHEN p_clt.
      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'KUNNR'.
      IF <field> IS ASSIGNED.
        <field>-key = 'X'.
        <field>-hotspot  = 'X'.
        UNASSIGN <field>.
      ENDIF.

      READ TABLE tg_fldcat ASSIGNING <field> WITH KEY fieldname = 'PARTNER'.
      IF <field> IS ASSIGNED.
        <field>-key  = 'X'.
        <field>-hotspot = 'X'.
        UNASSIGN <field>.
      ENDIF.
  ENDCASE.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_alv
*&---------------------------------------------------------------------*
FORM zf_alv USING p_v_titulo TYPE ty_titulo.
  DATA: wl_layout TYPE slis_layout_alv.
  wl_layout-zebra = 'X'.
  wl_layout-window_titlebar = p_v_titulo.
  wl_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat              = tg_fldcat
      is_layout                = wl_layout
      i_callback_user_command  = 'USER_COMMAND'
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF_STATUS'
    TABLES
      t_outtab                = <alv>.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_case_alv
*&---------------------------------------------------------------------*
FORM zf_case_alv .
  CASE 'X'.
    WHEN p_parc.
      LOOP AT tg_but000 ASSIGNING FIELD-SYMBOL(<but000>).
        CLEAR wg_parceiro_alv.

        wg_parceiro_alv-partner = <but000>-partner.

        "Adicionando costumer em parceiro
        READ TABLE tg_cust_link ASSIGNING FIELD-SYMBOL(<cust>) WITH TABLE KEY partner_guid = <but000>-partner_guid.
        IF <cust> IS ASSIGNED.
          IF <cust>-customer NOT IN s_clt.
            CONTINUE.
          ENDIF.

          wg_parceiro_alv-kunnr = <cust>-customer.

          "Procurando o nameK(kunnr) com base na tabela cust
          READ TABLE tg_kna1 ASSIGNING FIELD-SYMBOL(<kna1>) WITH TABLE KEY kunnr = <cust>-customer.

          IF <kna1> IS ASSIGNED.
            wg_parceiro_alv-nameK = <kna1>-name1.
          ENDIF.

        ENDIF.

        "Adicionando vendor em parceiro
        READ TABLE tg_vend_link ASSIGNING FIELD-SYMBOL(<vend>) WITH TABLE KEY partner_guid = <but000>-partner_guid.
        IF <vend> IS ASSIGNED.
          IF <vend>-vendor NOT IN s_fornc.
            CONTINUE.
          ENDIF.

          wg_parceiro_alv-lifnr = <vend>-vendor.

          "Procurando o nameL(lifnr) com base na tabela vend
          READ TABLE tg_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH TABLE KEY lifnr = <vend>-vendor.
          IF <lfa1> IS ASSIGNED.
            wg_parceiro_alv-nameL = <lfa1>-name1.
          ENDIF.

        ENDIF.

        "Validação de preenchimento do campo Status
        IF wg_parceiro_alv-kunnr IS INITIAL AND wg_parceiro_alv-lifnr IS INITIAL.
          wg_parceiro_alv-status = icon_initial.
        ELSEIF wg_parceiro_alv-kunnr IS NOT INITIAL AND wg_parceiro_alv-lifnr IS NOT INITIAL.
          wg_parceiro_alv-status = icon_complete.
        ELSE.
          wg_parceiro_alv-status = icon_activity.
        ENDIF.

*        IF ( s_clt[] IS NOT INITIAL AND wg_parceiro_alv-kunnr IS INITIAL )
*        OR ( s_fornc[] IS NOT INITIAL AND wg_parceiro_alv-lifnr IS INITIAL ).
*          CONTINUE.
*        ENDIF.

        APPEND wg_parceiro_alv TO tg_parceiro_alv.

        "Limpando todos o FIELD-SYMBOL
        UNASSIGN <cust>.
        UNASSIGN <vend>.
        UNASSIGN <lfa1>.
        UNASSIGN <kna1>.
      ENDLOOP.

      DELETE tg_parceiro_alv WHERE kunnr NOT IN s_clt.
      DELETE tg_parceiro_alv WHERE lifnr NOT IN s_fornc.

      "Assino o FIELD-SYMBOL alv com a tabela que será visualizada
      ASSIGN tg_parceiro_alv TO <alv>.

      "Verifica se alv foi assinada e cria ALV com configurações baseadas no preenchimento da tela.
      IF <alv> IS ASSIGNED.
        "Criando Field-cat baseado na Estrutura da SE11
        PERFORM zf_fldcat USING 'ZTT0MACENG_S_PARCEIROS_ALV'.
        "Cria o ALV com Field-Symbol <alv>
        PERFORM zf_alv USING 'Parceiro de negócio'.
      ENDIF.

*--------------------------------------------------------------------*

    WHEN p_fornc.
      LOOP AT tg_but000 ASSIGNING <but000>.

        "Adicionando dados de lifnr em fornec
        READ TABLE tg_vend_link ASSIGNING <vend> WITH KEY partner_guid = <but000>-partner_guid.
        IF <vend> IS ASSIGNED.
          wg_fornecedor_alv-lifnr = <vend>-vendor.
          wg_fornecedor_alv-partner = <but000>-partner.

          "Procurando dados de lifnr com base na tabela vend
          READ TABLE tg_lfa1 ASSIGNING <lfa1> WITH TABLE KEY lifnr = <vend>-vendor.
          IF <lfa1> IS ASSIGNED.
            wg_fornecedor_alv-namel = <lfa1>-name1.
            wg_fornecedor_alv-landl = <lfa1>-land1.
            wg_fornecedor_alv-ort01 = <lfa1>-ort01.
            wg_fornecedor_alv-pstlz = <lfa1>-pstlz.
            wg_fornecedor_alv-regio = <lfa1>-regio.
            wg_fornecedor_alv-sortl = <lfa1>-sortl.
            wg_fornecedor_alv-stras = <lfa1>-stras.
            wg_fornecedor_alv-mcod1 = <lfa1>-mcod1.
            wg_fornecedor_alv-mcod3 = <lfa1>-mcod3.

            READ TABLE tg_adr6 ASSIGNING FIELD-SYMBOL(<adr6>) WITH TABLE KEY addrnumber = <lfa1>-adrnr.
            IF <adr6> IS ASSIGNED.
              wg_fornecedor_alv-smtp_addr = <adr6>-smtp_addr.
            ENDIF.

          ENDIF.
          APPEND wg_fornecedor_alv TO tg_fornecedores_alv.
        ENDIF.

        CLEAR  wg_fornecedor_alv.

        UNASSIGN <vend>.
        UNASSIGN <lfa1>.
        UNASSIGN <adr6>.
      ENDLOOP.

      ASSIGN tg_fornecedores_alv TO <alv>.

      IF <alv> IS ASSIGNED.
        "Criando Field-cat baseado na Estrutura da SE11
        PERFORM zf_fldcat USING 'ZTT0MACENG_S_FORNECEDOR_ALV'.
        "Cria o ALV com Field-Symbol <alv>
        PERFORM zf_alv USING 'Fornecedor'.
      ENDIF.

*--------------------------------------------------------------------*

    WHEN p_clt.
      LOOP AT tg_but000 ASSIGNING <but000>.

        "Adicionando dados de lifnr em cliente
        READ TABLE tg_cust_link ASSIGNING <cust> WITH TABLE KEY partner_guid = <but000>-partner_guid.
        IF <cust> IS ASSIGNED.
          wg_cliente_alv-kunnr = <cust>-customer.
          wg_cliente_alv-partner = <but000>-partner.

          "Procurando dados de lifnr com base na tabela vend
          READ TABLE tg_kna1 ASSIGNING <kna1> WITH TABLE KEY kunnr = <cust>-customer.
          IF <kna1> IS ASSIGNED.
            wg_cliente_alv-namel = <kna1>-name1.
            wg_cliente_alv-land1 = <kna1>-land1.
            wg_cliente_alv-ort01 = <kna1>-ort01.
            wg_cliente_alv-pstlz = <kna1>-pstlz.
            wg_cliente_alv-regio = <kna1>-regio.
            wg_cliente_alv-sortl = <kna1>-sortl.
            wg_cliente_alv-stras = <kna1>-stras.
            wg_cliente_alv-mcod1 = <kna1>-mcod1.
            wg_cliente_alv-mcod3 = <kna1>-mcod3.

            READ TABLE tg_adr6 ASSIGNING <adr6> WITH TABLE KEY addrnumber = <kna1>-adrnr.
            IF <adr6> IS ASSIGNED.
              wg_cliente_alv-smtp_addr = <adr6>-smtp_addr.
            ENDIF.
          ENDIF.

          APPEND wg_cliente_alv TO tg_cliente_alv.
        ENDIF.

        CLEAR  wg_cliente_alv.

        UNASSIGN <cust>.
        UNASSIGN <kna1>.
        UNASSIGN <adr6>.
      ENDLOOP.

      ASSIGN tg_cliente_alv TO <alv>.

      IF <alv> IS ASSIGNED.

        READ TABLE tg_cliente_alv ASSIGNING FIELD-SYMBOL(<linha>) WITH KEY kunnr = '0000000023'.
        IF sy-subrc = 0 .
          DELETE <alv> INDEX sy-tabix.
        ENDIF.

        "Criando Field-cat baseado na Estrutura da SE11
        PERFORM zf_fldcat USING 'ZTT0MACENG_S_CLIENTE_ALV'.
        "Cria o ALV com Field-Symbol <alv>
        PERFORM zf_alv USING 'Cliente'.
      ENDIF.

  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& USER COMMAND
*&---------------------------------------------------------------------*
FORM user_command USING ucomm LIKE sy-ucomm selfield TYPE kkblo_selfield.

  DATA vl_answer TYPE c.

  IF ucomm EQ 'CREATE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question = 'Deseja criar um BP'
        text_button_1 = 'Sim'
        text_button_2 = 'Não'
      IMPORTING
        answer = vl_answer.
    ENDIF.

  CASE selfield-fieldname.

    WHEN 'PARTNER'.
      SET PARAMETER ID 'BPA'  FIELD selfield-value.
      CALL TRANSACTION 'BP' AND  SKIP FIRST SCREEN.
    WHEN 'LIFNR'.
      SET PARAMETER ID 'LIF'  FIELD selfield-value.
      CALL TRANSACTION 'XK03' AND  SKIP FIRST SCREEN.
    WHEN 'KUNNR'.
      SET PARAMETER ID 'KUN'  FIELD selfield-value.
      CALL TRANSACTION 'XD03' AND  SKIP FIRST SCREEN.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& SET PF STATUS
*&---------------------------------------------------------------------*
FORM set_pf_status USING extab TYPE slis_t_extab.
  SET PF-STATUS 'STATUS_RELATORIO'.
ENDFORM.