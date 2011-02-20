""" This class defines the base handler which methods determine if the current user has 
successfully SSO'd with facebook.
"""

import tornado.web

class BaseHandler(tornado.web.RequestHandler):
    
    def get_current_user(self):
        user_json = self.get_secure_cookie("user")
        if not user_json : return None
        return tornado.escape.json_decode(user_json)