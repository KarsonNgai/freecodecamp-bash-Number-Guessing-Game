#!/bin/bash
 
PSQL="psql --username=freecodecamp --dbname=number_guss -t --no-align -c"
 
LOGIN() {
  echo "Enter your username:"
  read username_input
  #check the name
  username=$($PSQL "SELECT username FROM usernames WHERE username='$username_input'")
  if [[ -z $username ]]
  then
    #echo welcome newbie
    echo "Welcome, $username_input! It looks like this is your first time here."
    #入data 
    username_insert=$($PSQL "INSERT INTO usernames(username) VALUES ('$username_input')")
  else
    #echo detail
    game_played=$($PSQL "SELECT COUNT(*) FROM games LEFT JOIN usernames USING (username_id) WHERE username='$username' ")
    game_best=$($PSQL "SELECT MIN(game_record) FROM games LEFT JOIN usernames USING (username_id) WHERE username='$username' ")
    echo "Welcome back, $username! You have played $game_played games, and your best game took $game_best guesses."
  fi
  #去game
  counting=0
  RANDOM_NUMBER
  number_guss "Guess the secret number between 1 and 1000:"
}
 
RANDOM_NUMBER() {
  echo "in random_number"
  #random_value
  secret_number=0
  max_number=1000
  min_number=1
  while (( $secret_number > $max_number || $secret_number < $min_number ))
  do
    secret_number=$RANDOM
  done
}
 
number_guss(){
  if [[ $1 ]]
  then
    echo $1 
  fi
  (( counting ++ ))
  read guessing
  if [[ ! $guessing =~ ^[0-9]+$ ]]
  then
    number_guss "That is not an integer, guess again:"
  fi
 
  if [[ $secret_number -ne $guessing ]]
  then
    if [[ $secret_number < $guessing ]]
    then
      number_guss "It's higher than that, guess again:"
    else 
      number_guss "It's lower than that, guess again:"
    fi
  else
    #get username_id
    get_username_id=$($PSQL "SELECT username_id FROM usernames WHERE username='$username_input'")
    #insert data
    INSERT_DATA=$($PSQL "INSERT INTO games (username_id, game_record) VALUES ($get_username_id, $counting) ")
    echo "You guessed it in $counting tries. The secret number was $secret_number. Nice job!"
  fi
}
 
LOGIN
 

