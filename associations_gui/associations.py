import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
import psycopg2 as pg
import secrets


class Handler:

    def __init__(self, builder):
        self.builder = builder
        self.device_tree = self.builder.get_object("device_tree")
        self.relay_tree = self.builder.get_object("relay_tree")
        self.loadData()

    def onShow(self, *args):
        pass

    def onDestroy(self, *args):
        Gtk.main_quit()

    def onButtonPressed(self, button):
        print("Hello World!")

    def onExit(self, *args):
        Gtk.main_quit()

    def loadData(self):

        self.conn = pg.connect(host=secrets.HOST, user=secrets.USER, database=secrets.DATABASE, password=secrets.PASSWORD, port=secrets.PORT)

        # load device treeview

        device_store = Gtk.TreeStore(str, str)
        room_dict = {}

        cursor = self.conn.cursor()
        cursor.execute('SELECT code, description FROM area.house_room ORDER BY code')
        for code, description in cursor.fetchall():
            room_iter = device_store.append(None, [code, description])
            room_dict[code] = room_iter

        cursor.execute("SELECT code_house_room, code, description FROM area.switch ORDER BY code_house_room, code")
        for code_room, code, description in cursor.fetchall():
            if code_room in room_dict:
                device_store.append(room_dict[code_room], [code, description]) 

        self.device_tree.set_model(device_store)

        for i, column_title in enumerate(["Código", "Descrição"]):
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(column_title, renderer, text=i)
            self.device_tree.append_column(column)

        # load relay treeview

        relay_store = Gtk.TreeStore(str, str)
        room_jb_dict = {}
        junction_dict = {}
        relay_block_dict = {}
        
        cursor = self.conn.cursor()
        cursor.execute('SELECT code, description FROM area.house_room ORDER BY code')
        for code, description in cursor.fetchall():
            room_jb_iter = relay_store.append(None, [code, description])
            room_jb_dict[code] = room_jb_iter

        cursor.execute("SELECT code_house_room, code, description FROM relay_blocks.junction_box ORDER BY code_house_room, code")
        for code_room, code, description in cursor.fetchall():
            if code_room in room_jb_dict:
                junction_iter = relay_store.append(room_jb_dict[code_room], [code, description]) 
                junction_dict[code] = junction_iter
 
        cursor.execute("SELECT code_junction_box, code, description FROM relay_blocks.relay_block ORDER BY code_junction_box, code")
        for code_junction_box, code, description in cursor.fetchall():
            if code_junction_box in junction_dict:
                relay_block_iter = relay_store.append(junction_dict[code_junction_box], [code, description]) 
                relay_block_dict[code] = relay_block_iter

        cursor.execute("SELECT code_relay_block, code, description FROM relay_blocks.relay ORDER BY code_relay_block, code")
        for code_relay_block, code, description in cursor.fetchall():
            if code_relay_block in relay_block_dict:
                relay_store.append(relay_block_dict[code_relay_block], [code, description]) 

        self.relay_tree.set_model(relay_store)

        for i, column_title in enumerate(["Código", "Descrição"]):
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(column_title, renderer, text=i)
            self.relay_tree.append_column(column)


        self.conn.commit()
        cursor.close()


builder = Gtk.Builder()
builder.add_from_file("application_window.glade")
builder.connect_signals(Handler(builder))

window = builder.get_object("main_window")
window.show_all()

Gtk.main()
