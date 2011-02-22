import tornado.web
import tornado.auth
import logging
from wigi.Handlers.BaseHandler import BaseHandler

class LoginHandler(BaseHandler, tornado.auth.FacebookGraphMixin):
    @tornado.web.asynchronous
    def get(self):
        logging.error("loginhandler get: %s" % (self.get_argument("code",False)))
       	if self.get_argument("code",False):
               logging.error("got code ")
               self.get_authenticated_user(
                                           redirect_uri='http://localhost:8888/login',
                                           client_id=self.settings["facebook_api_key"],
                                           client_secret=self.settings["facebook_secret"],
                                           code=self.get_argument("code"),
                                           callback=self.async_callback(self._on_login),
                                           )
               return
        self.authorize_redirect(redirect_uri='http://localhost:8888/login',
                                client_id=self.settings["facebook_api_key"],
                                extra_params={"scope": "read_stream,offline_access",
                                              "display":"popup"})	    	

    def _on_login(self, user):
        logging.info("USER INFO:")
        logging.info(user)
        self.set_secure_cookie("user", tornado.escape.json_encode(user))
        self.write("<html><head></head> <body onunload='window.opener.location.reload();'> <script type='text/javascript'> self.close(); </script></body></html>")
        self.finish()
