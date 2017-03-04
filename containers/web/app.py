# app.py

from flask import Flask
from flask import request, render_template
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import select
from sqlalchemy.orm import Session
from config import BaseConfig
import datetime


app = Flask(__name__)
app.config.from_object(BaseConfig)
db = SQLAlchemy(app)
cdate = str(datetime.datetime.now().date())

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        from_time = cdate + ' ' + str(request.form['from_time'])
        to_time = cdate + ' ' + str(request.form['to_time'])
#        #post = Post(text)
#        #db.session.add(post)
#        #db.session.commit()
        ftab = BaseConfig.Base.classes.flockertab
        session = Session(BaseConfig.engine)
        s = select([ftab]).where(ftab.intime.between(from_time,to_time))
        posts = session.execute(s)
        return render_template('index.html', posts=posts)
    else:
        return render_template('index.html')


if __name__ == '__main__':
    app.run()
