import tornado.web
import tornado.auth
import logging
from wigi.Handlers.BaseHandler import BaseHandler
from wigi.conf.config import getConfiguration

#get configuration data
site_config = getConfiguration()


class LoginHandler(BaseHandler, tornado.auth.FacebookGraphMixin):
    @tornado.web.asynchronous
    def get(self):
        logging.error("loginhandler get: %s" % (self.get_argument("code",False)))
       	if self.get_argument("code",False):
               logging.error("got code ")
               self.get_authenticated_user(
                                           redirect_uri=site_config.get('wigi','facebook_redirect_uri'),
                                           client_id=self.settings["facebook_api_key"],
                                           client_secret=self.settings["facebook_secret"],
                                           code=self.get_argument("code"),
                                           callback=self.async_callback(self._on_login),
                                           )
               return
        self.authorize_redirect(redirect_uri=site_config.get('wigi','facebook_redirect_uri'),
                                client_id=self.settings["facebook_api_key"],
                                extra_params={"scope": site_config.get('wigi','facebook_permissions_scope'),
                                              "display":"popup"})	    	

    def _on_login(self, user):
        logging.info("USER INFO:")
        logging.error(user)
        self.set_secure_cookie("user", tornado.escape.json_encode(user))
        #self.write("<html><head></head> <body onunload='window.opener.location.reload();'> <script type='text/javascript'> self.close(); </script></body></html>")
        self.redirect("/") 
        #self.finish()


    def post(self):
        #get login agruments. Arguments include facebook accessToken, expiration date, and user fb_id
        from wigi.models.models import User
        assert(self.get_argument("wigi_accessToken"))
        assert(self.get_argument("wigi_expr_token"))
        assert(self.get_argument("wigi_fb_id"))

        #check if user exists
        if(User.doesUserExist(int(self.get_argument("wigi_fb_id")))):
            self.write("user exists")
        else:
           self.write("user doesn't exist")

        #if user exists, check accesstoken
        #if accesstoken matches, create 


