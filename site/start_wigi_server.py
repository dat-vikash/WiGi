""" This script starts up with wigi application server on specified port. Below are the identified application with url configurations.
"""

import tornado.httpserver
import tornado.ioloop
import tornado.web
from wigi.Application import Application

from tornado.options import define, options

define("port", default=8888, help="run on the given port", type=int)
define("facebook_api_key", help="your Facebook application API key",
       default="b3d747769a2c38359eebeed4e26ddec9")
define("facebook_secret", help="your Facebook application secret",
       default="261c90043b697e4fc948d9701064c59a")

if __name__ == "__main__":
    wigi_http_server = tornado.httpserver.HTTPServer(Application())
    wigi_http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
