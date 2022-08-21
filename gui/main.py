from PyQt5.QtWidgets import QLabel, QVBoxLayout, QMainWindow, QApplication, QWidget
from PyQt5.QtCore import QTimer, Qt
from flask import Flask, render_template

from threading import Thread
from queue import Queue
import sys
from ui.form import Ui_Main

# You can copy and paste this code for test and run it

class MainWindow(QMainWindow):

    main_timer = None
    
    def __init__(self, *args, **kwargs):
        super(MainWindow, self).__init__(*args, **kwargs)
        self.ui = Ui_Main()
        self.ui.setupUi(self)

        # self.setAttribute(Qt.WA_TranslucentBackground)
        # self.setAttribute(Qt.WA_X11NetWmWindowTypeDesktop)
        # self.setWindowFlags(Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
        self.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.setGeometry(0,-6,1920,1080)
        self.main_timer = QTimer()
        self.main_timer.timeout.connect(self.read_sensors)
        self.main_timer.start(1000)        
        self.ui.bt_close.clicked.connect(self.exit_program)

    def read_sensors(self):
        if not self.in_queue.empty():
            data = self.in_queue.get_nowait()
            if type(data) is str:
                self.ui.label.setText(data)

    def exit_program(self):
        self.close()


#   Creating instance of QApplication
if __name__ == "__main__":
    app = QApplication(sys.argv)
    q = Queue()
    window = MainWindow()
    window.show()
    app_ = Flask(__name__)
    setattr(app_, "out_queue", q)
    setattr(window, "in_queue", q)

#   setting our root
    @app_.route('/')
    def index():
        return render_template('index.html')

    @app_.route('/message/<msg>')
    def message(msg):
        app_.out_queue.put(msg)
        return 'Ok'

#   Preparing parameters for flask to be given in the thread
#   so that it doesn't collide with main thread
    kwargs = {'host': '0.0.0.0', 'port': 5000, 'threaded': True, 'use_reloader': False, 'debug': False}

#   running flask thread
    flaskThread = Thread(target=app_.run, daemon=True, kwargs=kwargs).start()

    app.exec_()
