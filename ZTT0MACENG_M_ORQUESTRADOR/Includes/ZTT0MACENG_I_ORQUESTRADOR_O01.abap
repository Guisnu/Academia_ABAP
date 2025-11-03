*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_I_ORQUESTRADOR_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CASE vg_ok_code.
    WHEN 'BACK' OR 'END' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'SAVE'.

    WHEN 'RUN'.
  ENDCASE.

ENDMODULE.