import tornado.web

class LoginHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello Wigi")


