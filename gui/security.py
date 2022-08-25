from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot, QVariant


class Security(QObject):

    codeChanged = pyqtSignal()

    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        self._code = ""

    @pyqtProperty(str, notify=codeChanged)
    def code(self):
        return self._code

    @code.setter
    def code(self, value):
        if self._code == value:
            return
        self._code = value
        self.codeChanged.emit()

    @pyqtProperty(bool)
    def verify_code(self):
        # TODO temporary code (test) - to be replaced in future
        if self._code == "123":
            return True
        else:
            return False
