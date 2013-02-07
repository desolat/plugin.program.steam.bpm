# -*- coding: UTF-8 -*-
'''
@since: 2013-02-01
@author: nuabranda@web.de
'''

import sys
import subprocess
from subprocess import CalledProcessError

REMOTE_DBG = False

# append pydev remote debugger
if REMOTE_DBG:
    # Make pydev debugger works for auto reload.
    # Note pydevd module need to be copied in XBMC\system\python\Lib\pysrc
    try:
        import pysrc.pydevd as pydevd
    # stdoutToServer and stderrToServer redirect stdout and stderr to eclipse console
        pydevd.settrace('localhost', stdoutToServer=True, stderrToServer=True)
    except ImportError as e:
        print str(e)
        sys.stderr.write("Error: " +
            "You must add org.python.pydev.debug.pysrc to your PYTHONPATH.")
        sys.exit(1)


import os.path

from xbmc import log, LOGERROR
from xbmcgui import Dialog
from xbmcaddon import Addon


#__plugin__ = "Steam BPM"
__scriptID__  = "plugin.program.steam.bpm"
#__author__ = "desolat"
#__url__ = "http://some"
#__credits__ = ""
#__version__ = "0.0.1"

STEAM_BINARY_NAME = "steam.exe"


def launchSteamBpm(addon):
    # @todo: try http://code.google.com/p/pywinauto/ with http://code.google.com/p/swapy/
    ahkExe = os.path.join(os.path.dirname(__file__), 'resources', 'launch_steam_bpm.exe')
    steamExe = getSteamExe(addon)
    cmd = [ahkExe, "%s" % steamExe, addon.getSetting('username'), addon.getSetting('password')]
    subprocess.check_call(cmd)

def getSteamExe(addon):
    steamFolder = addon.getSetting('steam_install_folder')
    steamBinPath = os.path.join(steamFolder, STEAM_BINARY_NAME)
    if not os.path.isfile(steamBinPath):
        raise NotFoundError(addon.getLocalizedString(71004))
    return steamBinPath

    
class NotFoundError(BaseException):
    
    def __init__(self, msg):
        self.msg = msg

if __name__ == "__main__":
    addon = Addon(__scriptID__)
    try:
        launchSteamBpm(addon)
    except CalledProcessError as e:
        log('AHK return code: %d' % e.returncode)
        msg = addon.getLocalizedString(72000 + e.returncode)
        log(msg, LOGERROR)
        dialog = Dialog() 
        dialog.ok(addon.getLocalizedString(71005), msg)
    except BaseException as e:
        log(str(e), LOGERROR)
        dialog = Dialog() 
        dialog.ok(addon.getLocalizedString(71005), str(e))