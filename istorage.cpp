#include "istorage.h"

#include <QDir>
#include <QSettings>

QString IStorage::_storageDir = "";

IStorage::IStorage()
{
    QSettings settings(QDir::currentPath()+"/settings.ini", QSettings::IniFormat);
    _storageDir = settings.value("storageDir", QDir::homePath() + "/.pwmng/").toString();
    QDir storageDir(_storageDir);
    if ( !storageDir.exists() ) storageDir.mkpath("./");
}

void IStorage::setDir(const QString &dir)
{
    const auto oldDirPath = _storageDir;
    _storageDir = dir;
    if (!_storageDir.endsWith(".pwmng")) _storageDir += "/.pwmng/";

    QSettings settings(QDir::currentPath()+"/settings.ini", QSettings::IniFormat);
    settings.setValue("storageDir", _storageDir);

    QDir newDir(_storageDir);
    QDir oldDir(oldDirPath);
    if ( !newDir.exists() ) newDir.mkpath("./");

    const auto files = oldDir.entryList(QDir::Files);
    for (auto &file : files)
    {
        QFile(oldDirPath+file).rename(_storageDir+file);
    }
    oldDir.rmdir("./");
    emit storageDirChanged();
}

QString IStorage::storageDir() const
{
    return _storageDir;
}
