"""
This class sets up the restful operations on items. 
Note, that this is not a full rest implementation. 
Currently only POST and GET methods are implemented.
"""

import tornado.web
import logging
from wigi.Handlers.BaseHandler import BaseHandler
from wigi.conf.config import getConfiguration

#get configuration data
site_config = getConfiguration()

class ItemHandler(BaseHandler):
    def post(self,user_id):
        print "in itemhandler post for user: " + str(user_id)
        from wigi.models.models import WigiTokens
	self.write("success")
        #validate the wigi access token
        #user = User.getUserForFbId(self.get_argument('wigi_facebook_id'))
        #if self.get_agrument('wigi_access_token') == WigiTokens.getTokenForUser(user) :
	#    print "access token matches"
            
