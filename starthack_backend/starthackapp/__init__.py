import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import tmdbsimple as tmdb


app = Flask(__name__)

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL').replace('postgres', 'postgresql')

db = SQLAlchemy(app)
migrate = Migrate(app, db)

import starthackapp.models
db.create_all()


tmdb.API_KEY = '87a6f0d8cbc219995ea5f138f0456c05'


import starthackapp.endpoints
