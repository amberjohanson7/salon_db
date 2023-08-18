#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~ Salon ~~~\n"

SERVICES_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi 

  echo -e "\nWelcome to the salon, please choose an option from the list of services:\n"
  # get available services
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services")
  # display available services
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT ;;
    2) APPOINTMENT ;;
    3) APPOINTMENT ;;
    *) SERVICES_MENU "Please choose a valid option." ;;
  esac
}

APPOINTMENT() {
  echo -e "\nWhat is your phone number?\n"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  # if not existing customer, make record
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number. What is your name?"
    read CUSTOMER_NAME

    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like that $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    # get appointment info
    SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #SERVICE_TIME=$($PSQL "SELECT time FROM services WHERE time = '$SERVICE_TIME_REQ'")

    # insert appointment record
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")

    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    # make appointment for existing customer
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like that $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    # get appointment info
    SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #SERVICE_TIME=$($PSQL "SELECT time FROM services WHERE time = '$SERVICE_TIME_REQ'")

    # insert appointment record
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")

    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

SERVICES_MENU
