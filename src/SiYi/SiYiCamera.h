#ifndef SIYICAMERA_H
#define SIYICAMERA_H

#include <QHostAddress>
#include <QObject>

#include "SiYiTcpClient.h"

class SiYiCamera : public SiYiTcpClient {
    Q_OBJECT
    Q_PROPERTY(bool isRecording READ isRecording NOTIFY isRecordingChanged)
    Q_PROPERTY(int zoomMultiple READ zoomMultiple NOTIFY zoomMultipleChanged)
    Q_PROPERTY(bool enableZoom READ enableZoom NOTIFY enableZoomChanged)
    Q_PROPERTY(bool enableFocus READ enableFocus NOTIFY enableFocusChanged)
    Q_PROPERTY(bool enablePhoto READ enablePhoto NOTIFY enablePhotoChanged)
    Q_PROPERTY(bool enableVideo READ enableVideo NOTIFY enableVideoChanged)
    Q_PROPERTY(bool enableControl READ enableControl NOTIFY enableControlChanged)
    Q_PROPERTY(bool is4k READ is4k NOTIFY is4kChanged)

   public:
    struct ProtocolMessageHeaderContext {
        quint32 stx;
        quint8 control;
        quint32 dataLength;
        quint16 sequence;
        quint8 cmdId;
        quint32 crc;
    };

    struct ProtocolMessageContext {
        ProtocolMessageHeaderContext header;
        QByteArray data;
        quint32 crc;
    };

    enum CameraCommand { CameraCommandTakePhoto = 0 };
    Q_ENUM(CameraCommand)

    enum CameraVideoCommand { CloseRecording = 0, OpenRecording = 1 };
    Q_ENUM(CameraVideoCommand)

    enum CameraType {
        CameraTypeR1 = 0x6c,
        CameraTypeZR10 = 0x6e,
        CameraTypeR1M = 0x71,
        CameraTypeA8 = 0x72,
        CameraTypeA2 = 0x74,
        CameraTypeZR30 = 0x77,
        CameraTypeZT30 = 0x7B
    };
    Q_ENUM(CameraType)

   public:
    explicit SiYiCamera(QObject* parent = nullptr);
    ~SiYiCamera();

    Q_INVOKABLE bool turn(int yaw, int pitch);
    Q_INVOKABLE bool resetPostion();
    Q_INVOKABLE bool autoFocus(int x, int y, int w, int h);
    Q_INVOKABLE bool zoom(int option);
    Q_INVOKABLE bool focus(int option);
    Q_INVOKABLE bool sendCommand(int cmd);
    Q_INVOKABLE bool sendRecodingCommand(int cmd);
    Q_INVOKABLE void analyzeIp(const QString& videoUrl);
    Q_INVOKABLE void emitOperationResultChanged(int result);

    bool isRecording() const { return isRecording_; }
    int zoomMultiple() const { return zoomMultiple_; }
    bool enableZoom() const { return enableZoom_; }
    bool enableFocus() const { return enableFocus_; }
    bool enablePhoto() const { return enablePhoto_; }
    bool enableVideo() const { return enableVideo_; }
    bool enableControl() const { return enableControl_; }
    bool is4k() const { return is4k_; }

    bool getRecordingState();
    void getResolution();

   protected:
    QByteArray heartbeatMessage() override;
    void analyzeMessage() override;

   private:
    QByteArray packMessage(quint8 control, quint8 cmd, const QByteArray& payload);
    quint32 headerCheckSum32(ProtocolMessageHeaderContext* ctx);
    quint32 packetCheckSum32(ProtocolMessageContext* ctx);
    bool unpackMessage(ProtocolMessageContext* ctx, const QByteArray& msg);
    void getCamerVersion();

    void messageHandle0x80(const QByteArray& msg);
    void messageHandle0x81(const QByteArray& msg);
    void messageHandle0x83(const QByteArray& msg);
    void messageHandle0x94(const QByteArray& msg);
    void messageHandle0x98(const QByteArray& msg);
    void messageHandle0x9e(const QByteArray& msg);

   private:
    qint8 recording_state_ = 0;
    qint8 camera_type_ = -1;
    qint16 resolutionWidth_ = 0;
    qint16 resolutionHeight_ = 0;

    bool isRecording_ = false;
    int zoomMultiple_ = 1;
    bool enableZoom_ = false;
    bool enableFocus_ = false;
    bool enablePhoto_ = false;
    bool enableVideo_ = false;
    bool enableControl_ = false;
    bool is4k_ = false;

   signals:
    void isRecordingChanged();
    void zoomMultipleChanged();
    void enableZoomChanged();
    void enableFocusChanged();
    void enablePhotoChanged();
    void enableVideoChanged();
    void enableControlChanged();
    void is4kChanged();
    void operationResultChanged(int result);
};

#endif  // SIYICAMERA_H
