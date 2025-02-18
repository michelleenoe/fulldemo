from flask import Flask, session, render_template, request, redirect, url_for
from flask_session import Session


import x

from icecream import ic
ic.configureOutput(prefix=f'----- | ', includeContext=True)

app = Flask(__name__)
app.config['SESSION_TYPE'] = 'filesystem'
Session(app)

##############################

@app.after_request
def disable_cache(response):
    """
    This function automatically disables caching for all responses.
    It is applied after every request to the server.
    """
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    return response

##############################
## index 

@app.get("/")
def show_index():
    try:
        ##variables - python capital F
        is_session = False
        if session.get("user"): is_session = True
        active_index = "active"

        return render_template("index.html", title="Home", is_session=is_session, active_index=active_index)
    
    except Exception as ex:
        ic(ex)
        return "System under maintenance", 500
    finally:
        pass
        if "cursor" in locals():
            cursor.close()
        if "db" in locals():
            db.close()
    

##############################

@app.get("/contact-us")
def show_contact_us():
    active_contact_us = "active"
    return render_template("contact-us.html", title="Contact us", active_contact_us=active_contact_us)

##############################

@app.get("/about-us")
def show_about_us():
    active_about_us = "active"
    return render_template("about-us.html", title="About us", active_about_us=active_about_us)

##############################

@app.get("/signup")
def show_signup():
    active_signup = "active"
    return render_template("signup.html", title="Signup us", active_signup=active_signup)

##############################

@app.get("/login")
def show_login():
    active_login = "active"
    return render_template("login.html", title="Login", active_login=active_login)

##############################

app.post("/logout")
def show_logout():
    active_logout = "active"
    session.pop("user")
    return redirect(url_for("show_login"), active_logout=active_logout)

##############################

@app.get("/items")
def show_items():
    active_items = "active"
    return render_template("items.html", title="Items", active_items=active_items)

##############################

@app.get("/profile")
def show_profile():
    try:
        is_session  = False
        if session ["user"]: is_session = True
        return render_template("profile.html", title="Profile", user=session["user"], is_session=is_session)
    except Exception as ex:
        return redirect(url_for("show_login"))
    finally:
        pass

# ##############################

# backend

@app.post("/login")
def login():
    try:
        # whenever you enter a route --> always validate!!
        user_name = x.validate_user_name()
        db, cursor = x.db()
        ## you'll never be hacked === %s
        q = "SELECT * FROM users WHERE user_name = %s"
        cursor.execute(q, (user_name,))
        # fetch one = only get one 
        user = cursor.fetchone() #{"user_pk": 1, "user_name"}
        ic(user)
        #session variable (Session should be session to correctly set the session variable)
        session["user"] = user
        # what if the user is not there ?? 
        if not user: raise Exception("user not found")
        return redirect(url_for(("show_profile")))
    except Exception as ex:
        ic(ex)
        ## make sure the expection is text
        return str(ex), 400
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()  


##############################

@app.get("/api/v1/items")
def get_items():
    try:
        db, cursor = x.db()
        q = "SELECT * FROM users"
        cursor.execute(q)
        rows = cursor.fetchall()
        ic(rows)
        return rows
    except Exception as ex:
        return ex, 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()  


##############################
@app.delete("/api/v1/users/<user_id>")
def delete_user(user_id):
    try:
        db, cursor = x.db()
        q = "DELETE FROM users WHERE user_pk = %s"
        cursor.execute(q, (user_id,))
        if cursor.rowcount != 1:
            raise Exception("user not found")
        db.commit()
        return f"User {user_id} deleted"
    except Exception as ex:
        return ex, 400
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()  

##############################
