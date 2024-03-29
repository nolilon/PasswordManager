QT += quick qml

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        encryptedfilestorage.cpp \
        filestorage.cpp \
        istorage.cpp \
        main.cpp \
        passwordmodel.cpp \
        qmlclipboard.cpp

RESOURCES += qml.qrc

ICON = icon.icns
RC_ICONS = icon.ico

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    encryptedfilestorage.h \
    filestorage.h \
    istorage.h \
    password.h \
    passwordmodel.h \
    qmlclipboard.h

OTHER_FILES += \
    main.qml \
    StoragePasswordInput.qml \
    PasswordCard.qml \
    PasswordWidget.qml \
    RectButton.qml \
    SettingsWidget.qml

win32 {
    LIBS += -L$$PWD/'../../Program Files/OpenSSL-Win64/lib/' -llibcrypto
    INCLUDEPATH += $$PWD/'../../Program Files/OpenSSL-Win64/include'
    DEPENDPATH += $$PWD/'../../Program Files/OpenSSL-Win64/include'
}

macx {
    LIBS += -L$$PWD/../../opt/anaconda3/lib/ -lcrypto
    INCLUDEPATH += $$PWD/../../opt/anaconda3/include
}
