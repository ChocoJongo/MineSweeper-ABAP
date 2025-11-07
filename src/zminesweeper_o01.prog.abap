*&---------------------------------------------------------------------*
*& Include          ZMINESWEEPER_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_ALV_PLAY_GROUND OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE SET_ALV_PLAY_GROUND OUTPUT.

  IF GO_CONTAINER_PLAY IS INITIAL.

    CREATE OBJECT GO_CONTAINER_PLAY
      EXPORTING
        CONTAINER_NAME = 'CON_PLAY'.
    CREATE OBJECT GO_GRID_PLAY
      EXPORTING
        I_PARENT = GO_CONTAINER_PLAY.

    PERFORM SET_PLAY_GROUND_FCAT.

    CREATE OBJECT G_EVENT_RECEIVER01.

    SET HANDLER
*   Button Click
      G_EVENT_RECEIVER01->HANDLE_BUTTON_CLICK01
      FOR GO_GRID_PLAY.

    CLEAR: GS_LAYO.
    GS_LAYO-SEL_MODE = 'A'.

    CALL METHOD GO_GRID_PLAY->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT       = GS_LAYO
      CHANGING
        IT_OUTTAB       = GT_DISPLAY
        IT_FIELDCATALOG = GT_FCAT_FIELD
*       IT_SORT         =
*       IT_FILTER       =
      .
    IF SY-SUBRC <> 0.
*     Implement suitable error handling here
    ENDIF.

  ELSE.

    CALL METHOD GO_GRID_PLAY->REFRESH_TABLE_DISPLAY.

  ENDIF.

ENDMODULE.
