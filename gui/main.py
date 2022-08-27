#
# Main program 
# This way to join Flask and PyQt5 was found on 
# https://maxinterview.com/code/how-to-run-flask-with-pyqt5-F1F2886B120537C/
#
import sys
try:
    from PyQt5.QtGui import QGuiApplication
    from PyQt5.QtQml import QQmlApplicationEngine
    from PyQt5.QtCore import QTimer
except ImportError:
    from PySide2.QtGui import QGuiApplication
    from PySide2.QtQml import QQmlApplicationEngine
    from PySide2.QtCore import QTimer
from time import strftime, localtime
from flask import Flask, render_template
from threading import Thread
from queue import Queue
from security import Security


class MainWindow(QGuiApplication):

    main_timer = None
    
    def __init__(self, *args, **kwargs):
        super(MainWindow, self).__init__(*args, **kwargs)

        self.engine = QQmlApplicationEngine()
        self.engine.quit.connect(self.quit)
        self.engine.load('main.qml')

        self.main_timer = QTimer()
        self.main_timer.timeout.connect(self.read_sensors)
        self.main_timer.start(100)

        self.security = Security()

        self.engine.rootContext().setContextProperty('security', self.security)

    def update_time(self):
        # Pass the current time to QML.
        curr_time = strftime("%H:%M:%S", localtime())
        self.engine.rootObjects()[0].setProperty('currTime', curr_time)

    def read_sensors(self):
        """
        this code must be replaced
        if not self.in_queue.empty():
            data = self.in_queue.get_nowait()
            if type(data) is str:
                self.ui.label.setText(data)
        """

        pass


if __name__ == "__main__":
    app = MainWindow(sys.argv)
    q = Queue()
    app_ = Flask(__name__)
    setattr(app_, "out_queue", q)
    setattr(app, "in_queue", q)

#   setting our root
    @app_.route('/')
    def index():
        return render_template('index.html')

    @app_.route('/message/<msg>')
    def message(msg):
        app_.out_queue.put(msg)
        return 'Ok'

    # Flask parameters
    kwargs = {'host': '0.0.0.0', 'port': 5000, 'threaded': True, 'use_reloader': False, 'debug': False}
    # Run Flask in another thread
    flaskThread = Thread(target=app_.run, daemon=True, kwargs=kwargs).start()

    if 'PyQt5' in sys.modules:
        sys.exit(app.exec())
    else:
        sys.exit(app.exec_())
