#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $YEAR != "year" ]]
  then

    LEFT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    RIGHT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # IF TEAM NAME NOT FOUND, INSERT FIRST COLUMN
    if [[ -z $LEFT_TEAM_ID ]]
    then
      INSERT_LEFT_NAME=$($PSQL"INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_LEFT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted $WINNER into list of teams
      fi
    fi
    # IF TEAM NAME NOT FOUND, INSERT SECOND COLUMN
    if [[ -z $RIGHT_TEAM_ID ]]
    then
      INSERT_RIGHT_NAME=$($PSQL"INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_RIGHT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted $OPPONENT into list of teams
      fi
    fi

   # get new team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #INSERT EACH ROW
    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi

done
