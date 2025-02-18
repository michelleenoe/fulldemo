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
@app.get("/")
def show_index():
    try:
        is_session = False
        if session.get("user"): is_session = True

        active_index = "active"

        return render_template("index.html", is_session = is_session, active_index=active_index)
    



        # db, cursor = x.db()
        # q = """SELECT u.user_pk, u.user_name, GROUP_CONCAT(p.user_phone ORDER BY p.user_phone) AS phones FROM users u LEFT JOIN users_phones p ON u.user_pk = p.user_fk GROUP BY u.user_pk"""
        # cursor.execute(q)
        # rows = cursor.fetchall()
        # ic(rows)
        # for row in rows:
        #     if row["phones"]:
        #         row["user_phones"] = row["phones"].split(",")
        #     else:
        #         row["user_phones"] = []
        # ic(rows)
        # return render_template("index.html", title="Home", rows=rows)
    except Exception as ex:
        ic(ex)
        return "System under maintenance", 500
    finally:
        if "cursor" in locals(): cursor.close()
        if "db" in locals(): db.close()
    

##############################
@app.get("/logout")
def logout():
    session.pop("user")
    return redirect(url_for("show_login"))

@app.get("/items")
def show_items():
    active_items = "active"
    return render_template("items.html", title="Items", active_items=active_items)



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
@app.get("/profile")
def profile():
    try:
        is_session = False
        if session["user"]: is_session = True  
        active_profile = "active"      
        return render_template("profile.html", title="Profile", user=session["user"], is_session=is_session, active_profile=active_profile)
        # user_name = session["user"]["user_name"]
        # user_last_name = session["user"]["user_last_name"]
        # return render_template("profile.html", title="Profile", user_name=user_name, user_last_name=user_last_name)
    except Exception as ex:
        ic(ex)
        return redirect(url_for("show_login"))
    finally:
        pass




##############################
@app.get("/signup")
def show_signup():
    active_signup ="active"
    return render_template("signup.html", title="Signup us", active_signup=active_signup)

##############################
@app.get("/login")
def show_login():
    active_login = "active"
    return render_template("login.html", title="Login us", active_login=active_login)

##############################
@app.post("/login")
def login():
    try:
        # MUST VALIDATE
        user_name = x.validate_user_name()
        db, cursor = x.db()
        q = "SELECT * FROM users WHERE user_name = %s"
        cursor.execute(q, (user_name,))
        user = cursor.fetchone()
        ic(user)
        session["user"] = user
        if not user: raise Exception("User not found")

        return redirect(url_for("profile"))
    except Exception as ex:
        ic(ex)
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



