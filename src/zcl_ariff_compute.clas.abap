CLASS zcl_ariff_compute DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ariff_compute IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA number1 TYPE i.
    DATA number2 TYPE i.
    DATA result TYPE p VALUE 8 DECIMALS 2.
    DATA op TYPE c LENGTH 1.
    DATA: output TYPE string.

    number1 = 2.
    number2 = -5.
    op = '+'.

    CASE op.
      WHEN '+'.
        result = number1 + number2.
      WHEN '-'.
        result = number1 - number2.
      WHEN '*'.
        result = number1 * number2.
      WHEN '/'.
        TRY.
         result = number1 / number2.

            CATCH cx_sy_zerodivide.
                output = |Error: Unsupported operator '{ op }' - use +, -, *, or /|.
        ENDTRY.
      WHEN OTHERS.
        output = |'{ op }' is not a valid operator!|.
        RETURN.
    ENDCASE.

    IF output IS INITIAL.
            output = |{ number1 } { op } { number2 } = { result }|.
    ENDIF.

    out->write( output ).

  ENDMETHOD.
ENDCLASS.
