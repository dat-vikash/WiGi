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


    @tornado.web.asynchronous
    def post(self):
        #get login agruments. Arguments include facebook accessToken, expiration date, and user fb_id
        from wigi.models.models import User, WigiTokens
        assert(self.get_argument("wigi_accessToken"))
        assert(self.get_argument("wigi_expr_token"))
        assert(self.get_argument("wigi_fb_id"))

        #check if user exists
        if(User.doesUserExist(int(self.get_argument("wigi_fb_id")))):
            #if user exists, check accesstoken
	    user = User.getUserForFbId(int(self.get_argument("wigi_fb_id")))
	    if user.access_token == self.get_argument("wigi_accessToken"):
	        print "user's accesstoken matches"
        	#if accesstoken matches, create secure wigi token and write to reponse
                userToken = WigiTokens.createNewToken(user)
	        self.write(userToken.wigi_token)
            else:
                self.write("access tokens do not match")
        else:
           print "user doesn't exist"
	   #if user doesn't exist, determine if accesstoken is valid and create user, then create wigi token and write to response
           self.accessToken = self.get_argument("wigi_accessToken")
	   self.facebook_request("/me",
                                access_token=self.get_argument("wigi_accessToken"),
                                callback=self.async_callback(self.__is_access_token_valid))
	   
    def __is_access_token_valid(self,response):
        if not response:
            print "here"
	    #invalid access token
	    self.finish('invalid access token')
            return
        else:
            #create user and wigi token, write token to response
            #verify user is who they say they are
            if(response.get('id') == self.get_argument('wigi_fb_id')):
	        print "creating new user id: %s token: %s" %(response.get('id'), self.get_argument('wigi_accessToken'))
            #newUser = User.createNewUser(int(response['id']), self.accessToken)
