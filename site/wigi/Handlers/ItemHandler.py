"""
This class sets up the restful operations on items. 
Note, that this is not a full rest implementation. 
Currently only POST and GET methods are implemented.
"""

import tornado.web
import logging
from wigi.Handlers.BaseHandler import BaseHandler
from tornado.options import options
import os
from wigi.models.models import WigiTokens, User, WigiItems,ItemTags


class ItemHandler(BaseHandler):
  
    def get(self,user_id):
	#get users items
        user = User.getUserById(user_id)
	items = WigiItems.getItemsForUser(user)
	itemMetas = []
        if items:
            for item in items:
                itemMetas.append({'item_image_url':"http://ec2-50-17-86-253.compute-1.amazonaws.com:8888/static/" +  item.image_location,
		    	          'item_comments':item.initial_comment})
	self.write(tornado.escape.json_encode(itemMetas))
	self.finish()
	

	# itemFilePaths = []
	#if items:
	#    itemFilePaths = [item.image_location for item in items]
        #self.render("items.html", items=itemFilePaths, user_id=user_id)
	




    def post(self,user_id):
        print "in itemhandler post for user: " + str(user_id)
        #print self.request.files
        
	import Image
	import cStringIO
	import datetime

        #validate the wigi access token
        user = User.getUserById(user_id)
        if user:
            print "user found!"
           # print self.get_argument('wigi_access_token')
            token = WigiTokens.getTokenForUser(user)
            if token:
                if self.get_argument('wigi_access_token') == token.wigi_token :
	            print "access token matches"
		    saveDir = "%s%s/items/" % (options.media_dir,str(user_id))
		    print "save directory : " + saveDir
                    if (not os.path.exists(saveDir)):
                        #directory doesn't exist
			#create, then save image
			os.makedirs(saveDir)
		    try:
		        im = cStringIO.StringIO(self.request.files["wigi_item_image"][0]['body'])	
 	   	        img = Image.open(im)
			print img.format, img. size, img.mode
		        imageFilePath= saveDir + str(datetime.datetime.now()).replace(" ","_") +"_" + str(user_id) + ".jpeg"
		   	img.save(imageFilePath)
			#save item, image tags and comments to db
                        newItem = WigiItems.addNewItemForUser(user, imageFilePath,'want_it', self.get_argument('wigi_item_comment'))	
                        ItemTags.addTagForItem(newItem,self.get_argument('wigi_item_tag'))
                    except IOError as e:
		        print "CANNOT CONVERT FILE: " + e.__str__()
                 
 	            self.finish("thanks")
            else:
                self.finish("Error retrieving Token")
	else:
	    #error retrieving user
            self.finish("Error adding item to wigi")
       
