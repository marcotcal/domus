import sys
try:
    from PyQt5.QtCore import QObject, pyqtSignal as Signal, pyqtProperty as Property
except ImportError:
    from PySide2.QtCore import QObject, Signal, Property


class Security(QObject):

    codeChanged = Signal()

    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        self._code = ""

    @Property(str, notify=codeChanged)
    def code(self):
        return self._code

    @code.setter
    def code(self, value):
        if self._code == value:
            return
        self._code = value
        self.codeChanged.emit()

    @Property(bool)
    def verify_code(self):
        # TODO temporary code (test) - to be replaced in future
        if self._code == "123":
            return True
        else:
            return False
