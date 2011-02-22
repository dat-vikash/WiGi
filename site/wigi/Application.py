import tornado.web
import os
from wigi.Handlers.MainHandler import MainHandler, TestHandler
from wigi.Handlers.LoginHandler import LoginHandler
from tornado.options import options, define

define("port", default=8888, help="run on the given port", type=int)
define("facebook_api_key", help="your Facebook application API key",
       default="b3d747769a2c38359eebeed4e26ddec9")
define("facebook_secret", help="your Facebook application secret",
       default="261c90043b697e4fc948d9701064c59a")

class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", MainHandler),
            (r"/login", LoginHandler),
            (r"/test", TestHandler),
        ]
        settings = dict(
                        cookie_secret="11oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo=",
                        login_url="/login",
                        template_path=os.path.join(os.path.dirname(__file__), "templates"),
                        static_path=os.path.join(os.path.dirname(__file__), "static"),
                        facebook_api_key=options.facebook_api_key,
                        facebook_secret=options.facebook_secret,
                        debug=True,
                        xsrf_cookies=True,                                
        )
        tornado.web.Application.__init__(self, handlers, **settings)

