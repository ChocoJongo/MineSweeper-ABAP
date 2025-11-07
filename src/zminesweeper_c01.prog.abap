*&---------------------------------------------------------------------*
*& Include          ZMINESWEEPER_C01
*&---------------------------------------------------------------------*
CLASS LCL_EVENT_RECEIVER01 DEFINITION.
  PUBLIC SECTION.

*   셀버튼클릭
    METHODS HANDLE_BUTTON_CLICK01
      FOR EVENT BUTTON_CLICK OF CL_GUI_ALV_GRID
      IMPORTING
        ES_COL_ID
        ES_ROW_NO.


ENDCLASS. "(LCL_EVENT_RECEIVER DEFINITION) "
*----------------------------------------------------------------------*
* LOCAL CLASSES: IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS LCL_EVENT_RECEIVER01 IMPLEMENTATION.

* 셀버튼클릭
  METHOD HANDLE_BUTTON_CLICK01.
    CASE 'X'.
      WHEN RB_SAP.

        READ TABLE GT_FIELD ASSIGNING FIELD-SYMBOL(<FS_ROW1>) INDEX ES_ROW_NO-ROW_ID.
        IF SY-SUBRC = 0.
          ASSIGN COMPONENT ES_COL_ID-FIELDNAME OF STRUCTURE <FS_ROW1> TO FIELD-SYMBOL(<FS_TEMP1>).
        ENDIF.

        READ TABLE GT_DISPLAY ASSIGNING FIELD-SYMBOL(<FS_ROW2>) INDEX ES_ROW_NO-ROW_ID.
        IF SY-SUBRC = 0.
          ASSIGN COMPONENT ES_COL_ID-FIELDNAME OF STRUCTURE <FS_ROW2> TO FIELD-SYMBOL(<FS_TEMP2>).
        ENDIF.

        IF <FS_TEMP1> = GC_MINE.

          PERFORM GAME_OVER.

        ELSE.

          IF <FS_TEMP1> = '0'.
            PERFORM PROPAGATION_ZERO USING ES_ROW_NO-ROW_ID
                                           ES_COL_ID-FIELDNAME.
            <FS_TEMP2> = <FS_TEMP1>.

          ELSEIF <FS_TEMP2> = GC_FLAG.

            <FS_TEMP2> = <FS_TEMP1>.
            GV_COUNT_MINE -= 1.

          ELSE.
            <FS_TEMP2> = <FS_TEMP1>.
          ENDIF.

        ENDIF.

        UNASSIGN: <FS_TEMP1>, <FS_TEMP2>, <FS_ROW1>, <FS_ROW2>.

      WHEN RB_MARK.

        READ TABLE GT_DISPLAY ASSIGNING FIELD-SYMBOL(<FS_ROW3>) INDEX ES_ROW_NO-ROW_ID.
        IF SY-SUBRC = 0.
          ASSIGN COMPONENT ES_COL_ID-FIELDNAME OF STRUCTURE <FS_ROW3> TO FIELD-SYMBOL(<FS_TEMP3>).
        ENDIF.

        IF <FS_TEMP3> = GC_FLAG.
          CLEAR: <FS_TEMP3>.
          GV_COUNT_MINE -= 1.
        ELSEIF <FS_TEMP3> = '1' OR <FS_TEMP3> = '2' OR  <FS_TEMP3> = '3'
             OR <FS_TEMP3> = '4' OR <FS_TEMP3> = '5' OR <FS_TEMP3> = '6'
             OR <FS_TEMP3> = '7' OR <FS_TEMP3> = '8' OR <FS_TEMP3> = '0'.
          MESSAGE S000 WITH '이미 확인 곳에는 깃발을 세울 수 없습니다.'.
        ELSE.
          <FS_TEMP3> = GC_FLAG.
          GV_COUNT_MINE += 1.
        ENDIF.

        UNASSIGN: <FS_ROW3>, <FS_TEMP3>.

        IF GV_COUNT_MINE = GV_TOTAL_MINE.

          PERFORM CHECK_COMPLATE.

        ENDIF.

      WHEN OTHERS.
    ENDCASE.

    CALL METHOD GO_GRID_PLAY->REFRESH_TABLE_DISPLAY.

  ENDMETHOD.                    "HANDLE_BUTTON_CLICK01"


ENDCLASS.                    "LCL_EVENT_RECEIVER IMPLEMENTATION"

DATA:
  G_EVENT_RECEIVER01 TYPE REF TO LCL_EVENT_RECEIVER01.
