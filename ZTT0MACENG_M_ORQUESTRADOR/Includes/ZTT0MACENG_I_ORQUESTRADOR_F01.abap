*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_I_ORQUESTRADOR_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form zf_add_node
*&---------------------------------------------------------------------*
FORM zf_add_node  USING   p_v_node_key
                          p_v_relative_node_key
                          p_v_isfolder
                          p_v_text.

  o_tree_9000->add_node(
   EXPORTING
     node_key                =  p_v_node_key "Cod node atual
     relative_node_key       =  p_v_relative_node_key "Cod do node pai
*     relationship            =
     isfolder                = p_v_isfolder
     text                    = p_v_text
*     hidden                  =
*     disabled                =
*     style                   =
*     no_branch               =
*     expander                =
*     image                   =
*     expanded_image          =
*     drag_drop_id            =
*     user_object             =
*   EXCEPTIONS
*     node_key_exists         = 1
*     illegal_relationship    = 2
*     relative_node_not_found = 3
*     node_key_empty          = 4
*     others                  = 5
 ).

ENDFORM.