*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_connection definition.

  public section.



     CLASS-DATA conn_counter TYPE i READ-ONLY.

     METHODS constructor
       IMPORTING
         i_carrier_id TYPE /dmo/carrier_id
         i_connection_id TYPE /dmo/connection_id
       RAISING
        cx_abap_invalid_value.
     METHODS get_output
        RETURNING
            VALUE(r_output) TYPE STRING_TABLE.

  protected section.
  private section.
    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.

       TYPES: BEGIN OF st_details,
                    DepartureAirport TYPE /dmo/airport_from_id,
                    DestinationAirport TYPE /dmo/airport_to_id,
                    AirlineName TYPE /dmo/carrier_name,
              END OF st_details.
    DATA details TYPE st_details.
endclass.

class lcl_connection implementation.

  method constructor.

    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
         RAISE EXCEPTION TYPE cx_abap_invalid_value.
      ENDIF.

    SELECT SINGLE
      FROM /dmo/i_connection
    FIELDS DepartureAirport, DestinationAirport, \_Airline-Name as AirlineName
     WHERE AirlineID   = @i_carrier_id
       AND ConnectionID = @i_connection_id
      INTO CORRESPONDING FIELDS OF @details.

     IF SY-SUBRC <> 0.
        RAISE EXCEPTION TYPE cx_abap_invalid_value.
      ENDIF.


    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.

    conn_counter = conn_counter + 1.

  endmethod.

  method get_output.
    APPEND |--------------------------------|             TO r_output.
    APPEND |Carrier:     { carrier_id } { details-airlinename }| TO r_output.
    APPEND |Connection:  { connection_id   }|             TO r_output.
    APPEND |Departure:   { details-departureairport }|             TO r_output.
    APPEND |Destination: { details-destinationairport   }|             TO r_output.
    APPEND |--------------------------------|             TO r_output.
  endmethod.

endclass.
