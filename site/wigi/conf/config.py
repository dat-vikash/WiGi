import os
from ConfigParser import SafeConfigParser

def getConfiguration():
    config = SafeConfigParser()
    config.read(os.path.join(os.path.dirname(os.getcwd()),"site/wigi/conf/site_dev.conf" ))
    return config
