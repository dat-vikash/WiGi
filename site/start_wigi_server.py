""" This script starts up with wigi application server on specified port. Below are the identified application with url configurations.
"""

import tornado.httpserver
import tornado.ioloop
import tornado.web
from wigi.Application import Application

from tornado.options import define, options

if __name__ == "__main__":
    wigi_http_server = tornado.httpserver.HTTPServer(Application())
    wigi_http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
