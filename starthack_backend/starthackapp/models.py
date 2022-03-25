from starthackapp import app, db
import enum


class Swipe(enum.Enum):
	LIKE = 'LIKE'
	DISLIKE = 'DISLIKE'
	SUPER_LIKE = 'SUPER_LIKE'


class InstagramShort(db.Model):
	__tablename__ = "instagram_short"
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	movie_id = db.Column(db.Integer)
	short_url = db.Column(db.String(1000))

	def __init__(self, movie_id, short_url):
		self.movie_id = movie_id
		self.short_url = short_url


class Movie(db.Model):
	__tablename__ = "movies"
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	movie_id = db.Column(db.Integer)

	def __init__(self, movie_id):
		self.movie_id = movie_id


class MovieSwipe(db.Model):
	__tablename__ = "movie_swipe"
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	user_id = db.Column(db.Integer)
	movie_id = db.Column(db.Integer)
	swipe = db.Column(db.Enum(Swipe))

	def __init__(self, user_id, movie_id, swipe):
		self.user_id = user_id
		self.movie_id = movie_id
		self.swipe = swipe

class User(db.Model):
	__tablename__ = "user"
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	name = db.Column(db.String(50))
	fav_movie_1 = db.Column(db.Integer)
	fav_movie_2 = db.Column(db.Integer)
	fav_movie_3 = db.Column(db.Integer)
	nb_matches = db.Column(db.Integer)

	def __init__(self, name, fav_movie_1, fav_movie_2, fav_movie_3):
		self.name = name
		self.fav_movie_1 = fav_movie_1
		self.fav_movie_2 = fav_movie_2
		self.fav_movie_3 = fav_movie_3
		self.nb_matches = 0
