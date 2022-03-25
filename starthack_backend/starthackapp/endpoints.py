from starthackapp import (
    app,
    db,
    models,
    tmdb,
)
from flask import jsonify, request
from instagrapi import Client
import pickle
import random


@app.route('/')
def index():
    return jsonify('Welcome to my app bro (main branch)')

def bonjour():
    with app.app_context():
        with open("starthackapp/ig_client_object_file.txt", "rb") as f:
            bytes_read = f.read()
            ig_client = pickle.loads(bytes_read)
        print(type(ig_client))

        movies = models.Movie.query.all()
        movie_ids = [movie.movie_id for movie in movies]
        print(movie_ids)

        for i, movie_id in enumerate(movie_ids):
            print(f'\n\n\n\n\n>>>>>>>>>>>>>>>>> movie {i+1}/{len(movie_ids)} | movie_id: {movie_id}')
            movie = tmdb.Movies(movie_id)
            movie.info()
            ig_hashtag = ''.join(filter(str.isalpha, movie.title)).lower()+'edit'
            print(f'ig_hashtag: {ig_hashtag}')

            medias = ig_client.hashtag_medias_top(ig_hashtag, amount=3)
            print(medias)

            for media in medias:
                video_url = media.dict()['video_url']
                if not video_url:
                    print('No video URL found...')
                    continue
                new_ig_short = models.InstagramShort(movie.id, str(video_url))
                db.session.add(new_ig_short)
                db.session.commit()
                print('Just added a new short!')

        return jsonify('function bonjour()')

def find_US_trailer(videos):
    videos = videos['results']
    for video in videos:
        if video['iso_639_1'] == 'en':
            return video['key']
    else:
        return videos[0]['key']

def get_top3_cast(full_cast):
    top3_cast = []
    for i, actor in enumerate(full_cast):
        if i > 2: break
        top3_cast.append(actor['name'])
    return top3_cast

def get_movies_from_ids(movies_ids):
    config = tmdb.Configuration()
    base_url = config.info()['images']['secure_base_url']

    movies = [tmdb.Movies(movie_id) for movie_id in movies_ids]
    ig_shorts_list = []

    for movie in movies:
        movie.info()
        movie.credits()
        movie.images()
        ig_shorts = models.InstagramShort.query.filter(models.InstagramShort.movie_id == movie.id).all()
        ig_shorts_list.append([ig_short.short_url for ig_short in ig_shorts])

    movies_dict = [
        {
            'movie_id': movie.id,
            'title': movie.title,
            'release_date': int(movie.release_date[:4]),
            'poster_url': base_url+'original'+movie.poster_path,
            'trailer_url': 'https://www.youtube.com/watch?v='+find_US_trailer(movie.videos()),
            'plot': movie.overview,
            'genres': [genre_obj['name'] for genre_obj in movie.genres],
            'rating': movie.vote_average,
            'nb_of_ratings': movie.vote_count,
            'top3_cast': get_top3_cast(movie.cast),
            'shorts_urls': ig_shorts,
        } for movie, ig_shorts in zip(movies, ig_shorts_list)
    ]

    return movies_dict


@app.route('/get_next_movies', methods=["GET"])
def get_next_movies():
    user_id = request.args.get('user_id', 1)
    movies_already_swiped = models.MovieSwipe.query.filter(models.MovieSwipe.user_id==user_id).all()
    nb_of_swipes = len(movies_already_swiped)
    current_user = models.User.query.get(user_id)
    print(f'nb_of_swipes: {nb_of_swipes}')
    print(f'nb_user_matches: {current_user.nb_matches}')
    if nb_of_swipes / 8 > current_user.nb_matches + 1:
        # send match
        matched_user_id = 2
        matched_user = models.User.query.get(matched_user_id)
        movies_ids = [matched_user.fav_movie_1, matched_user.fav_movie_2, matched_user.fav_movie_3]
        match_dict = {'match': True}
        current_user.nb_matches += 1
        db.session.commit()
    else:
        movies = models.Movie.query.all()
        movies_ids = {movie.movie_id for movie in movies}
        print(movies_ids)
        movies_ids_already_swiped = {movie.movie_id for movie in movies_already_swiped}
        print(movies_ids_already_swiped)
        movies_ids_not_swiped_yet = movies_ids - movies_ids_already_swiped
        print(movies_ids_not_swiped_yet)
        movies_ids = random.sample(movies_ids_not_swiped_yet, min(5, len(movies_ids_not_swiped_yet)))
        print(movies_ids)
        match_dict = {'match': False}

    movies_dict = get_movies_from_ids(movies_ids)
    results_dict = {'results': movies_dict}
    results_dict.update(match_dict)

    return jsonify(results_dict)


@app.route('/get_favorites', methods=["GET"])
def get_favorites():
    user_id = request.args.get('user_id', 1)
    fav_movies_db = models.MovieSwipe.query.filter(
        models.MovieSwipe.user_id == user_id,
        models.MovieSwipe.swipe == models.Swipe.SUPER_LIKE
    ).order_by(
        models.MovieSwipe.id.desc()
    ).all()
    fav_movies_ids = [movie.movie_id for movie in fav_movies_db]
    movies_dict = get_movies_from_ids(fav_movies_ids)

    return jsonify({'results': movies_dict})


@app.route('/remove_favorite', methods=["POST"])
def remove_favorite():
    form_data = request.form
    movie_id = form_data.get('movie_id')
    user_id = form_data.get('user_id', 1)

    fav_movie = models.MovieSwipe.query.filter(
        models.MovieSwipe.movie_id == movie_id,
        models.MovieSwipe.user_id == user_id,
    ).first()

    fav_movie.swipe = models.Swipe.LIKE

    db.session.commit()
    return jsonify('Movie removed from favorites successfully!')


@app.route('/get_movie_shorts', methods=["GET"])
def get_movie_shorts():
    shorts = models.InstagramShort.query.all()
    shorts = [
        {
            'id': short.id,
            'movie_id': short.movie_id,
            'short_url': short.short_url,
        } for short in shorts
    ]
    return jsonify(shorts)


@app.route('/swipe', methods=["POST"])
def swipe():
    form_data = request.form
    movie_id = form_data.get('movie_id')
    swipe = form_data.get('swipe')
    user_id = form_data.get('user_id', 1)

    if swipe == 'right':
        movie_swipe = models.MovieSwipe(user_id, movie_id, models.Swipe.LIKE)
    elif swipe == 'left':
        movie_swipe = models.MovieSwipe(user_id, movie_id, models.Swipe.DISLIKE)
    elif swipe == 'up':
        movie_swipe = models.MovieSwipe(user_id, movie_id, models.Swipe.SUPER_LIKE)
    else:
        return jsonify('Swiped unsuccessful!')

    db.session.add(movie_swipe)
    db.session.commit()
    return jsonify('Swiped successfully!')


@app.route('/get_movie_swipes', methods=["GET"])
def get_movie_swipes():
    swipes = models.MovieSwipe.query.all()
    swipes = [
        {
            'id': swipe_obj.id,
            'user_id': swipe_obj.user_id,
            'movie_id': swipe_obj.movie_id,
            'swipe': str(swipe_obj.swipe),
        } for swipe_obj in swipes
    ]
    return jsonify(swipes)


@app.route('/reset_movie_swipes', methods=["GET"])
def reset_movie_swipes():
    movie_swipes = models.MovieSwipe.query.all()
    for movie_swipe in movie_swipes:
        db.session.delete(movie_swipe)
    user_1 = models.User.query.filter(models.User.id==1).first()
    user_1.nb_matches = 0
    db.session.commit()
    return jsonify("Deleted all swipes!")


@app.route('/get_movies', methods=["GET"])
def get_movies():
    movies = models.Movie.query.all()
    movies = [
        {
            'id': movie.id,
            'movie_id': movie.movie_id,
        } for movie in movies
    ]
    return jsonify(movies)


@app.route('/add_all_movies', methods=["GET"])
def add_all_movies():
    movies_ids = [
        77338,
        356305,
        615904,
        550988,
        587807,
        646380,
        57214,
        771,
        772,
        455974,
        8095,
        696806,
        823625,
        760926,
        928381,
        512195,
        476669,
        768744,
        928999,
        753232,
        585083,
        476669,
        774825,
        676705,
        580489,
        624860,
        425909,
        635302,
        459151,
        13632,
        205321,
        523849,
        438970,
        390989,
        2899,
        9642,
        9564,
        818647,
        511809,
        744275,
        79014,
        24021,
        597,
        216015,
        138832,
        646385,
        460458,
        632727,
        423108,
        138843,
        72190,
        72331,
        396535,
        439079,
        126889,
        190859,
        2105,
        1359,
        4982,
        158015,
        316727,
    ]
    
    for movie_id in movies_ids:
        new_movie = models.Movie(movie_id)
        db.session.add(new_movie)
        db.session.commit()

    return jsonify('Added all movies successfully!')


@app.route('/get_users', methods=["GET"])
def get_users():
    users = models.User.query.all()
    users = [
        {
            'id': user.id,
            'name': user.name,
            'fav_movie_1': user.fav_movie_1,
            'fav_movie_2': user.fav_movie_2,
            'fav_movie_3': user.fav_movie_3,
            'nb_matches': user.nb_matches,
        } for user in users
    ]
    return jsonify(users)


@app.route('/add_user', methods=["POST"])
def add_user():
    form_data = request.form
    name = form_data.get('name')
    fav_movie_1 = form_data.get('fav_movie_1')
    fav_movie_2 = form_data.get('fav_movie_2')
    fav_movie_3 = form_data.get('fav_movie_3')

    new_user = models.User(name, fav_movie_1, fav_movie_2, fav_movie_3)

    db.session.add(new_user)
    db.session.commit()
    return jsonify('New user added successfully!')
