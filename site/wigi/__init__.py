print "Starting wigi server"
from wigi.models.models import DBManager, User,ItemComments, ItemTags, WigiItems, WigiTokens, Base
#create a DBManger instance
DbMan = DBManager()

