print "in __init__"
from wigi.models.models import DBManager, User
#create a DBManger instance
DbMan = DBManager()

#for dev purposes
#create in memory db
User.metadata.create_all(DbMan.engine)
