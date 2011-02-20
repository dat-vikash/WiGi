"""
This class sets up the landing page for wigi.
"""

import tornado.web
import tornado.auth


class MainHandler(tornado.web.RequestHandler,
                          tornado.auth.FacebookGraphMixin):
            @tornado.web.authenticated
            @tornado.web.asynchronous
            def get(self):
		print "in here!!!"
                self.facebook_request(
                    "/me/feed",
                    post_args={"message": "I am posting from my Tornado application!"},
                    access_token=self.current_user["access_token"],
                    callback=self.async_callback(self._on_post))

            def _on_post(self, new_entry):
                if not new_entry:
                    # Call failed; perhaps missing permission?
                    self.authorize_redirect()
                    return
                self.finish("Posted a message!")

