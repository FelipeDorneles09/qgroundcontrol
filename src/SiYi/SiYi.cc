#include "SiYi.h"

#include <QtQml/qqml.h>

#include <QCoreApplication>

static QObject* _siyiSingletonFactory(QQmlEngine*, QJSEngine*) { return SiYi::instance(); }

static void _siyiRegisterQmlTypes() {
    static const char* kRefOnly = "Reference only";

    qmlRegisterSingletonType<SiYi>("SiYi.Object", 1, 0, "SiYi", _siyiSingletonFactory);
    qmlRegisterUncreatableType<SiYiCamera>("SiYi.Object", 1, 0, "SiYiCamera", kRefOnly);
    qmlRegisterUncreatableType<SiYiTransmitter>("SiYi.Object", 1, 0, "SiYiTransmitter", kRefOnly);
}
Q_COREAPP_STARTUP_FUNCTION(_siyiRegisterQmlTypes)

SiYi* SiYi::instance_ = Q_NULLPTR;
SiYi::SiYi(QObject* parent) : QObject{parent} {
    camera_ = new SiYiCamera(this);
    transmitter_ = new SiYiTransmitter(this);
    connect(transmitter_, &SiYiCamera::connected, this, [=]() {
        this->isTransmitterConnected_ = true;
        camera_->start();
    });
    connect(transmitter_, &SiYiCamera::disconnected, this, [=]() {
        this->isTransmitterConnected_ = false;
        transmitter_->exit();
    });

    connect(camera_, &SiYiCamera::ipChanged, this, [=]() {
        if (camera_->isRunning()) {
            camera_->exit();
            camera_->wait();
        }

        camera_->start();
    });

#ifdef Q_OS_ANDROID
    isAndroid_ = true;
#else
    isAndroid_ = false;
#endif

    transmitter_->start();
#if 1  // 为1时，云台控制无需先连接
    camera_->start();
#endif
}

SiYi* SiYi::instance() {
    if (!instance_) {
        instance_ = new SiYi(qApp);
    }

    Q_ASSERT_X(instance_, __FUNCTION__, "Can not allocate memory for SiYi instance!");
    return instance_;
}

SiYiCamera* SiYi::cameraInstance() { return camera_; }

SiYiTransmitter* SiYi::transmitterInstance() { return transmitter_; }
