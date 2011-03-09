
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

