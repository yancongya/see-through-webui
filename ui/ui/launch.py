import sys
import os
import os.path as osp
import argparse

sys.path.append(osp.dirname(osp.dirname(osp.abspath(__file__))))

os.environ['QT_API'] = 'pyqt6'

parser = argparse.ArgumentParser()
parser.add_argument("--proj", default='', type=str, help='Open project directory on startup')
args, _ = parser.parse_known_args()


MAIN_WINDOW = None
APP = None

def restart():
    global MAIN_WINDOW
    print('restarting...\n')
    if MAIN_WINDOW:
        MAIN_WINDOW.close()
    os.execv(sys.executable, ['python'] + sys.argv)


def main():

    from qtpy.QtWidgets import QApplication
    from qtpy.QtGui import QGuiApplication
    from qtpy.QtCore import QTranslator, QLocale, QLibraryInfo

    from ui import shared
    from ui.logger import setup_logging, logger as LOGGER
    from ui import ui_config as program_config

    # os.chdir(shared.PROGRAM_PATH)
    setup_logging(shared.LOGGING_PATH)

    program_config.load_config()
    config = program_config.pcfg

    app_args = sys.argv
    app = QApplication(app_args)
    app.setApplicationName('Live2D Parsing')
    
    # 加载翻译文件
    translator = QTranslator()
    lang = shared.DEFAULT_DISPLAY_LANG
    lang_code = shared.DISPLAY_LANGUAGE_MAP.get(lang, 'English')
    if lang_code != 'English':
        qm_path = osp.join(shared.TRANSLATE_DIR, f'{lang_code}.qm')
        if osp.exists(qm_path):
            if translator.load(qm_path):
                app.installTranslator(translator)
                LOGGER.info(f'已加载翻译文件：{qm_path}')
            else:
                LOGGER.warning(f'无法加载翻译文件：{qm_path}')
        else:
            LOGGER.warning(f'翻译文件不存在：{qm_path}')

    ps = QGuiApplication.primaryScreen()
    shared.LDPI = ps.logicalDotsPerInch()
    shared.SCREEN_W = ps.geometry().width()
    shared.SCREEN_H = ps.geometry().height()

    from ui.mainwindow import MainWindow
    mainwindow = MainWindow(app, config)
    global MAIN_WINDOW
    MAIN_WINDOW = mainwindow
    mainwindow.restart_signal.connect(restart)

    mainwindow.show()

    if args.proj is not None and osp.exists(args.proj):
        mainwindow.openProj(args.proj)

    sys.exit(app.exec())


if __name__ == '__main__':
    main()
