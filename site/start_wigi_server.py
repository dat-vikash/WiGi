""" This script starts up with wigi application server on specified port. Below are the identified application with url configurations.
"""

import tornado.httpserver
import tornado.ioloop
import tornado.web
from wigi.Handlers.LoginHandler import LoginHandler

#APPLICATION VARIABLES
#List of urls with corresponding wsgi handlers
URLS = [(r"/", LoginHandler),]
#Specified port to start server on
LISTEN_PORT = 8888 

#Create wigi application with configured urls
APPLICATION = tornado.web.Application(URLS)


if __name__ == "__main__":
    wigi_http_server = tornado.httpserver.HTTPServer(APPLICATION)
    wigi_http_server.listen(LISTEN_PORT)
    tornado.ioloop.IOLoop.instance().start()

