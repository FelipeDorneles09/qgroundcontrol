#include "SiYi.h"

#include <QCoreApplication>
#include <QDebug>
#include <QtQml/QQmlEngine>

#include "SiYiCamera.h"
#include "SiYiTransmitter.h"

SiYi* SiYi::g_instance = nullptr;

static QObject* siYiQmlSingletonProvider(QQmlEngine* engine, QJSEngine* scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    return SiYi::instance();
}

static void registerSiYiQmlTypes() {
    qmlRegisterSingletonType<SiYi>("SiYi.Object", 1, 0, "SiYi", siYiQmlSingletonProvider);
    qmlRegisterUncreatableType<SiYiCamera>("SiYi.Object", 1, 0, "SiYiCamera", "Reference only");
    qmlRegisterUncreatableType<SiYiTransmitter>("SiYi.Object", 1, 0, "SiYiTransmitter", "Reference only");
}
Q_COREAPP_STARTUP_FUNCTION(registerSiYiQmlTypes)

SiYi::SiYi(QObject* parent) : QObject(parent) {
    camera_ = new SiYiCamera(this);
    transmitter_ = new SiYiTransmitter(this);

    qDebug() << "SiYi initialized";
}

SiYi::~SiYi() { g_instance = nullptr; }

SiYi* SiYi::instance() {
    if (!g_instance) {
        g_instance = new SiYi(qApp);
    }
    return g_instance;
}

bool SiYi::isAndroid() const {
#ifdef Q_OS_ANDROID
    return true;
#else
    return false;
#endif
}
