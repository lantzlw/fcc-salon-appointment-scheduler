#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo How may I help you?
  
  LIST_SERVICES=$($PSQL "SELECT * FROM services WHERE name != 'name';")
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) INFO_MENU ;;
    2) INFO_MENU ;;
    3) INFO_MENU ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

INFO_MENU() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # check if customer is in system
  PHONE_NUMBER_IN_SYSTEM=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';");
  # if customer doesn't exist
  if [[ -z $PHONE_NUMBER_IN_SYSTEM ]]
  then
    # get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  fi
  # get service time
  echo -e "\nWhat time would you like to schedule?"
  read SERVICE_TIME

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  # get customer name
  GET_CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE customer_id = '$CUSTOMER_ID';")
  CUSTOMER_NAME=$(echo $GET_CUSTOMER_NAME | sed 's/ //g')


  # get service name
  GET_SERVICE=$($PSQL "SELECT name from services WHERE service_id = $SERVICE_ID_SELECTED;")
  SERVICE=$(echo $GET_SERVICE | sed 's/ //g')

  # add info into appointment table
  INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")  

  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
} 

MAIN_MENU
