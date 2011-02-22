"""
This class sets up the landing page for wigi.
"""

import tornado.web
import tornado.auth
import logging
from wigi.Handlers.BaseHandler import BaseHandler

class MainHandler(BaseHandler,tornado.auth.FacebookGraphMixin):
    
    def get(self):
        if not self.current_user:
            self.render("index.html", login_status='false')
        else:
            self.render("index.html", login_status='true')


class TestHandler(BaseHandler, tornado.auth.FacebookGraphMixin):
    @tornado.web.authenticated
    @tornado.web.asynchronous
    def get(self):
                self.facebook_request(
                    "/me/picture",
                    access_token=self.current_user["access_token"],
                    callback=self.async_callback(self._on_post))

    def _on_post(self, picture):
        if not picture:
            # Call failed; perhaps missing permission?
            self.authorize_redirect(redirect_uri='http://localhost:8888/login',
                                client_id=self.settings["facebook_api_key"],
                                extra_params={"scope": "read_stream,offline_access",
                                              "display":"popup"})
            return
        self.finish("Posted a message!")