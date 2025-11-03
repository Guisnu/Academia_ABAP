*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_I_ORQUESTRADOR_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'STATUS_9000'.
  SET TITLEBAR 'TITLE_9000'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_CONTAINER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_container OUTPUT.

  CHECK o_cont_9000 IS NOT BOUND.

  CREATE OBJECT o_cont_9000
    EXPORTING
      container_name              = 'CONT_9000'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT o_splitt_9000
    EXPORTING
      parent            = o_cont_9000
      columns           = 2
      rows              = 1
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  o_cont_9000_tree = o_splitt_9000->get_container( row =  1 column =  1 ).
  o_splitt_9000->set_column_width( id = 1 width = 15 ).
  o_cont_9000_alv = o_splitt_9000->get_container( row =  1 column =  2 ).

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_TREE_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_tree_9000 OUTPUT.

  DATA tg_events TYPE cntl_simple_events.
  DATA wg_events TYPE cntl_simple_event.

  CREATE OBJECT o_tree_9000
    EXPORTING
      node_selection_mode = cl_gui_column_tree=>node_sel_mode_multiple
*     hide_selection      =                  " Visibility of Selection
*    EXCEPTIONS
*     illegal_node_selection_mode = 1                " "
*     others              = 2
    .
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  o_tree_9000->create_tree_control( parent = o_cont_9000_tree ).

  PERFORM zf_add_node USING 'ROOT' ''     'X' 'Rule Control'.
  PERFORM zf_add_node USING 'MD'   'ROOT' 'X' 'Master Data'.
  PERFORM zf_add_node USING 'AM'   'MD'   '' 'Application Management'.

  wg_events-eventid = cl_simple_tree_model=>eventid_node_double_click.
  wg_events-appl_event = 'X'.
  APPEND wg_events TO tg_events.
  o_tree_9000->set_registered_events( tg_events ).
*  APPEND VALUE cntl_simple_event( eventid = cl_simple_tree_model=>eventid_node_double_click appl_event = 'X' ) TO tg_events.

  CREATE OBJECT o_handler_tree_9000.

  SET HANDLER o_handler_tree_9000->node_double_click FOR o_tree_9000.

ENDMODULE.