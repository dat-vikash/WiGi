import logging

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
     	self.Session = sessionmaker(bind=self.engine, expire_on_commit=False)
        	
    
    def getSession(self):
        """ returns the global session object. """
	if self.engine:
	    print "engine exists...returning session"
	    return self.Session()


    def getId(self):
        return id(self)


"""
 Declarative style table and class mapping configuration. 
"""

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects import mysql #mysql specific
from sqlalchemy import Column, String, Integer, ForeignKey

#define base object
Base = declarative_base()

class WigiTokens(Base):
    """ declarative class representing the wigi secure tokens table. This table allows for mobile devices to securely connect and update
	user accounts/profiles/etc. 
    """
    __tablename__ = 'wigi_tokens'

    #define table
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer,ForeignKey('users.id'))
    wigi_token = Column(String(length=64))

    #methods
    def __init__(self, user):
        import hashlib
        self.user_id = user.id
        self.wigi_token = hashlib.sha256(user.access_token).hexdigest()

    @classmethod
    def getTokenForUser(self, user):
        """ Retrieves the current token for a user. If no token is found, return None. """
	from wigi import DbMan
 	try:
 	    session = DbMan.getSession()
            print "04"
	    user = session.merge(user)
            print "05"
	    token = session.query(WigiTokens).filter_by(user_id=user.id).first()
            print "06"
            session.close()
	    return token if token else None
	except Exception as e:
	    logging.error("Error in WigiTokens.getTokenForUser: " + e.__str__())
	    return None
     
    @classmethod
    def clearTokensForUser(self, user):
        """ clears exisiting tokens for user. """
	from wigi import DbMan
	try:
  	    session = DbMan.getSesssion()
            user = session.merge(user)
	    exisitngTokens = session.query(WigiTokens).filter_by(user_id=user.id)
	    for token in existingTokens:
	        session.delete(token)
            session.commit()
            session.close()
            return True
        except Exception as e:
	    logging.error("Error in WigiTokens.clearTokensForUser: " + e)
            return False
	    

    @classmethod
    def createNewToken(self, user):
        """ Creates new token for a user. Contraint is that user can only have a single wigi token. If token already exists for user,
	    delete previous tokens before creation of new token.
        """
        from wigi import DbMan
        try:
            session = DbMan.getSession()
            print "01"
            #check if user already has a token
            user = session.merge(user)
            print "02"
            token = WigiTokens.getTokenForUser(user)
            print "03"
	    if token:
	        #token exists for user, delete token
		if WigiTokens.clearTokensForUser(user):
		    print "tokens successfully cleared."
                else:
		    print "tokens not cleared. "
	    #create new token for user
	    token = WigiTokens(user)
            print "1"
            assert(token.user_id)
            assert(token.wigi_token)
            session.add(token)
            session.commit()
            session.close()
            print "token created"
            return token
        except Exception as e:
            print "error creating token: " 
            print e
            return None
      
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
        self.access_token = accessToken

    #table level methods
    @classmethod
    def doesUserExist(self, fb_id):
        """Checks to see if users exists based on facebook_id"""
        from wigi import DbMan
	try:
            session = DbMan.getSession()
            user = session.query(User).filter_by(facebook_id=fb_id).first()
            session.close()
            return True if user else False
       	except Exception as e:
            print e
            return False

    @classmethod
    def getUserForFbId(self, fb_id):
	""" returns the user corresponding to the supplied facebook id. """
        from wigi import DbMan
        try:
            session = DbMan.getSession()
            user = session.query(User).filter_by(facebook_id=fb_id).first()
	    session.close()
            return user if user else None
	except Exception as e:
	    print e
            return None 
   
    @classmethod
    def createNewUser(self, fb_id, access_token):
        """ creates a new user. """
        from wigi import DbMan
        try:
            session = DbMan.getSession()
            user = User(fb_id, access_token)
            assert(user.facebook_id)
            assert(user.access_token)
            session.add(user)
            session.commit()
            session.close()
            return user
        except Exception as e:
            print e
            return None
