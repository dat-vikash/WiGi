import tornado.web
from wigi.Handlers.MainHandler import MainHandler
from wigi.Handlers.LoginHandler import LoginHandler
from tornado.options import options


class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", MainHandler),
            (r"/login", LoginHandler),
        ]
        settings = dict(
            cookie_secret="11oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=",
            login_url="/login",
 	    facebook_api_key=options.facebook_api_key,
            facebook_secret=options.facebook_secret,
	    debug=True,
        )
        tornado.web.Application.__init__(self, handlers, **settings)

