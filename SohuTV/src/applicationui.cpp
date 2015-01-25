/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationui.hpp"

#include <bb/cascades/resources/localehandler.h>
#include <bb/cascades/resources/qmldocument.h>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/Application>
#include <bb/cascades/LocaleHandler>
#include <bb/cascades/QmlDocument>
#include "bb/device/DisplayInfo.hpp"
#include "AppSettings.hpp"
#include <bb/system/SystemToast>
using namespace bb::cascades;

ApplicationUI::ApplicationUI() :
        QObject()
{
    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);
    bool res = QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this,
            SLOT(onSystemLanguageChanged()));
    Q_ASSERT(res);
    Q_UNUSED(res);

    // initial load
    onSystemLanguageChanged();

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    bb::device::DisplayInfo display;
    int width = display.pixelSize().width();
    int height = display.pixelSize().height();

    QDeclarativePropertyMap* displayProperties = new QDeclarativePropertyMap;
    displayProperties->insert("width", QVariant(width));
    displayProperties->insert("height", QVariant(height));
    qml->setContextProperty("DisplayInfo", displayProperties);
    qml->setContextProperty("_app", this);
    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    Application::instance()->setScene(root);
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("SohuTV_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}

void ApplicationUI::setValue(QString field, QString input)
{
    AppSettings::saveValueFor(field, input);
}

QString ApplicationUI::getValue(QString input, QString def)
{
    QString result = AppSettings::getValueFor(input, def);
    return result;
}


QString ApplicationUI::cacheSize()
{
    QDir dir;
    QString dataDir(QDir::homePath());
    QString dirName = dataDir + "/cache/";
    dir.cd(dirName);
    qDebug() << QString::number(dir_size(dirName));
    return QString::number(dir_size(dirName));
}

quint64 ApplicationUI::dir_size(const QString & str)
{
    quint64 sizex = 0;
    QFileInfo str_info(str);
    if (str_info.isDir()) {
        QDir dir(str);
        QFileInfoList list = dir.entryInfoList(
                QDir::Files | QDir::Dirs | QDir::Hidden | QDir::NoSymLinks | QDir::NoDotAndDotDot);
        for (int i = 0; i < list.size(); ++i) {
            QFileInfo fileInfo = list.at(i);
            if (fileInfo.isDir()) {
                sizex += dir_size(fileInfo.absoluteFilePath());
            } else
                sizex += fileInfo.size();

        }
    }
    return sizex;
}
void ApplicationUI::clearCache()
{
    QDir dir;
    QString dataDir(QDir::homePath());
    QString dirName = dataDir + "/cache/";
    dir.cd(dirName);

    QStringList list = dir.entryList();

    foreach (const QString &str, list){
    QFile theFile(dirName+str);
    qDebug()<<QFileInfo(dirName+str).size();
    theFile.remove();
    QFileInfo(theFile).size();
    qDebug()<<dirName+str;
}
    bb::system::SystemToast *toast = new bb::system::SystemToast(this);
    toast->setBody(tr("Cache cleared"));
    toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
    toast->show();
}
