*&---------------------------------------------------------------------*
*& Include          ZMINESWEEPER_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
      CLEAR: GT_DISPLAY, GT_FIELD.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
      CLEAR: GT_DISPLAY, GT_FIELD.
    WHEN 'RADO'.

      CASE 'X'.
        WHEN RB_MARK.
          RB_MARK = 'X'.
          CLEAR: RB_SAP.
        WHEN RB_SAP.
          RB_MARK = 'X'.
          CLEAR: RB_MARK.
        WHEN OTHERS.
      ENDCASE.
    WHEN 'BACKDOOR'.
      PERFORM SUCCESS_GAME.
    WHEN 'SWITCH'.
      CASE 'X'.
        WHEN RB_MARK.
          RB_SAP = 'X'.
          CLEAR: RB_MARK.
        WHEN RB_SAP.
          RB_MARK = 'X'.
          CLEAR: RB_SAP.
        WHEN OTHERS.
      ENDCASE.
    WHEN 'CHECK'.
      PERFORM CHECK_COMPLATE.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
