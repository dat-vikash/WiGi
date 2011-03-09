
class DBManager(object):
    """ Manages Database connection. """
    

    __instance = None
    def __new__(cls, *args, **kwargs):
        if not cls.__instance:
	    cls.__instance = super(DBManager, cls).__new__(cls, *args, **kwargs)
	return cls.__instance
    
    def __init__(self):
        """ sets up db engine and connection pool."""
    	from wigi.conf.config import getConfiguration 
    	from sqlalchemy import create_engine
	from sqlalchemy.pool import QueuePool
    	from sqlalchemy.orm import sessionmaker
        print "in dbmanager init"
	#get configuration data
	self.site_config = getConfiguration()
        self.__connectionString = 'sqlite:///:memory:';
        self.engine = create_engine(self.__connectionString, echo=self.site_config.get('database','echo'), poolclass=QueuePool)
	
	#setup session
     	self.Session = sessionmaker(bind=self.engine)
        	
    
    def getSession(self):
        """ returns the global session object. """
	return self.Session()

    def getId(self):
        return id(self)


"""
 Declarative style table and class mapping configuration. 
"""

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects import mysql #mysql specific
from sqlalchemy import Column, String, Integer

#define base object
Base = declarative_base()

class User(Base):
    """ 
    """
    __tablename__ = 'users'

    #define table
    id = Column(Integer, primary_key=True)
    facebook_id = Column(mysql.BIGINT(unsigned=True))
    access_token = Column(String)

    #methods
    def __init__(self, facebook_id, accessToken=None):
        self.facebook_id = facebook_id
        self.accessToken = accessToken

    #table level methods
    @classmethod
    def doesUserExist(self, fb_id):
        """Checks to see if users exists based on facebook_id"""
	try:
	    dbconn = DBManager()
            session = dbconn.getSession()
            user = session.query(User).filter_by(facebook_id=fb_id).first()
            session.close()
            return True if user else False
       	except Exception as e:
            print e
            return False

 
