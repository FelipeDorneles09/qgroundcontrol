#pragma once

#include <QObject>

#include "SiYiCamera.h"
#include "SiYiTransmitter.h"

class SiYi : public QObject {
    Q_OBJECT

    Q_PROPERTY(SiYiCamera* camera READ camera CONSTANT)
    Q_PROPERTY(SiYiTransmitter* transmitter READ transmitter CONSTANT)
    Q_PROPERTY(bool isAndroid READ isAndroid CONSTANT)

   public:
    explicit SiYi(QObject* parent = nullptr);
    ~SiYi();

    static SiYi* instance();

    SiYiCamera* camera() const { return camera_; }
    SiYiTransmitter* transmitter() const { return transmitter_; }
    bool isAndroid() const;

   private:
    static SiYi* g_instance;
    SiYiCamera* camera_ = nullptr;
    SiYiTransmitter* transmitter_ = nullptr;
};
