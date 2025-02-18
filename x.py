from flask import request
import mysql.connector
import re

from icecream import ic
ic.configureOutput(prefix=f'***** | ', includeContext=True)


##############################
def db():
    db = mysql.connector.connect(
        host = "mysql",      # Replace with your MySQL server's address or docker service name "mysql"
        user = "root",  # Replace with your MySQL username
        password = "password",  # Replace with your MySQL password
        database = "company"   # Replace with your MySQL database name
    )
    cursor = db.cursor(dictionary=True)
    return db, cursor


##############################
## rules about the username field
USER_NAME_MIN = 2 #min 
USER_NAME_MAX = 20 # max / in the database varchar 20 (most likely)
# regular expression for the username field
# i want the username to be min 2 characters and max 20 characters 
USER_NAME_REGEX = f"^.{{{USER_NAME_MIN},{USER_NAME_MAX}}}$"
#function 
def validate_user_name():
    #the name - min 2 characters and max 20 characters
    error = f"name {USER_NAME_MIN} to {USER_NAME_MAX} characters"
    # the username comes from the request to the form and it is stripped
    user_name = request.form.get("user_name", "").strip()
    # if the username does not match the rules that we defines - we're going to raise an exception
    if not re.match(USER_NAME_REGEX, user_name): raise Exception(error)
    # return the username
    return user_name
