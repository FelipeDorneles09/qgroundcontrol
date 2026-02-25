#include "SiYiCamera.h"

#include <QDebug>
#include <QTimerEvent>
#include <QtEndian>

SiYiCamera::SiYiCamera(QObject* parent) : SiYiTcpClient("192.168.144.25", 37256, parent) {
    connect(this, &SiYiTcpClient::connected, this, [this]() {
        getCamerVersion();
        getResolution();
        getRecordingState();
    });
}

SiYiCamera::~SiYiCamera() {}

bool SiYiCamera::turn(int yaw, int pitch) {
    uint8_t cmdId = 0x9a;
    QByteArray body;
    body.append(static_cast<char>(yaw));
    body.append(static_cast<char>(pitch));

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
    return true;
}

bool SiYiCamera::resetPostion() {
    uint8_t cmdId = 0x9b;
    QByteArray body;
    body.append(char(0x01));

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
    return true;
}

bool SiYiCamera::autoFocus(int x, int y, int w, int h) {
    uint8_t cmdId = 0x97;
    QByteArray body;
    body.append(char(0x01));

    quint16 cookedX = static_cast<quint16>(x * resolutionWidth_ / w);
    quint16 cookedY = static_cast<quint16>(y * resolutionHeight_ / h);
    qInfo() << cookedX << cookedY << x << y << w << h << resolutionWidth_ << resolutionHeight_;
    body.append(reinterpret_cast<const char*>(&cookedX), 2);
    body.append(reinterpret_cast<const char*>(&cookedY), 2);

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
    return true;
}

bool SiYiCamera::zoom(int option) {
    if (option != 1 && option != 0 && option != -1) {
        option = 0;
    }

    uint8_t cmdId = 0x98;
    QByteArray body;
    body.append(char(option));

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
    return true;
}

bool SiYiCamera::focus(int option) {
    if (option != 1 && option != 0 && option != -1) {
        option = 0;
    }

    uint8_t cmdId = 0x99;
    QByteArray body;
    body.append(char(option));

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
    return true;
}

bool SiYiCamera::sendCommand(int cmd) {
    uint8_t cmdId = 0x9f;
    QByteArray body;
    body.append(char(cmd));

    QByteArray msg = packMessage(0x00, cmdId, body);
    sendMessage(msg);
    return true;
}

bool SiYiCamera::sendRecodingCommand(int cmd) {
    uint8_t cmdId = 0x81;
    QByteArray body;
    body.append(char(cmd));

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
    return true;
}

bool SiYiCamera::getRecordingState() {
    uint8_t cmdId = 0x80;
    QByteArray body;

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
    return true;
}

void SiYiCamera::getResolution() {
    uint8_t cmdId = 0x83;
    QByteArray body;
    body.append(char(0x00));

    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
}

void SiYiCamera::analyzeIp(const QString& videoUrl) {
    qDebug() << "Analyzing IP from:" << videoUrl;
    QString url = videoUrl;
    url.remove(QString("rtsp://"));
    QStringList strList = url.split('/');
    if (!strList.isEmpty()) {
        QString ip = strList.first();
        if (ip.split(':').length() == 2) {
            ip = ip.split(':').first();
            if (ip.split('.').length() == 4) {
                resetIp(ip);
            }
        }
    }
}

void SiYiCamera::emitOperationResultChanged(int result) { emit operationResultChanged(result); }

QByteArray SiYiCamera::heartbeatMessage() { return packMessage(0x01, 0x80, QByteArray()); }

void SiYiCamera::analyzeMessage() {
    while (rxBytes_.length() >= 4) {
        if ((rxBytes_.at(0) == char(0x55)) && (rxBytes_.at(1) == char(0x66)) && (rxBytes_.at(2) == char(0xaa)) &&
            (rxBytes_.at(3) == char(0xbb))) {
            int headerLength = 4 + 1 + 4 + 2 + 1 + 4;
            if (rxBytes_.length() >= headerLength) {
                ProtocolMessageHeaderContext header;
                int offset = 0;

                quint32 stx = qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(rxBytes_.constData()));
                header.stx = stx;
                offset += 4;

                header.control = static_cast<quint8>(rxBytes_.at(offset));
                offset += 1;

                header.dataLength =
                    qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(rxBytes_.constData() + offset));
                offset += 4;

                header.sequence =
                    qFromLittleEndian<quint16>(reinterpret_cast<const uchar*>(rxBytes_.constData() + offset));
                offset += 2;

                header.cmdId = static_cast<quint8>(rxBytes_.at(offset));
                offset += 1;

                header.crc = qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(rxBytes_.constData() + offset));

                ProtocolMessageContext msg;
                msg.header = header;
                int msgLen = headerLength + header.dataLength + 4;

                if (rxBytes_.length() >= msgLen) {
                    msg.data = QByteArray(rxBytes_.constData() + headerLength, header.dataLength);
                    msg.crc = qFromLittleEndian<quint32>(
                        reinterpret_cast<const uchar*>(rxBytes_.constData() + headerLength + header.dataLength));
                } else {
                    break;
                }

                if (msg.header.cmdId == 0x80) {
                    messageHandle0x80(rxBytes_.mid(0, msgLen));
                } else if (msg.header.cmdId == 0x81) {
                    messageHandle0x81(rxBytes_.mid(0, msgLen));
                } else if (msg.header.cmdId == 0x83) {
                    messageHandle0x83(rxBytes_.mid(0, msgLen));
                } else if (msg.header.cmdId == 0x94) {
                    messageHandle0x94(rxBytes_.mid(0, msgLen));
                } else if (msg.header.cmdId == 0x98) {
                    messageHandle0x98(rxBytes_.mid(0, msgLen));
                } else if (msg.header.cmdId == 0x9e) {
                    messageHandle0x9e(rxBytes_.mid(0, msgLen));
                } else if (msg.header.cmdId == 0x90) {
                    // Nothing to do yet
                }

                if (msg.header.cmdId != 0x90) {
                    qInfo() << "[" << ip_ << ":" << port_ << "] Rx:" << rxBytes_.mid(0, msgLen).toHex(' ');
                }

                rxBytes_.remove(0, msgLen);
            } else {
                break;
            }
        } else {
            rxBytes_.remove(0, 1);
        }
    }
}

QByteArray SiYiCamera::packMessage(quint8 control, quint8 cmd, const QByteArray& payload) {
    ProtocolMessageContext ctx;
    ctx.header.stx = PROTOCOL_STX;
    ctx.header.control = control;
    ctx.header.dataLength = payload.length();
    ctx.header.sequence = sequence();
    ctx.header.cmdId = cmd;
    ctx.header.crc = headerCheckSum32(&ctx.header);
    ctx.data = payload;
    ctx.crc = packetCheckSum32(&ctx);

    QByteArray msg;
    quint32 leStx = qToLittleEndian<quint32>(ctx.header.stx);

    msg.append(reinterpret_cast<const char*>(&leStx), 4);
    msg.append(static_cast<char>(ctx.header.control));
    msg.append(reinterpret_cast<const char*>(&ctx.header.dataLength), 4);
    msg.append(reinterpret_cast<const char*>(&ctx.header.sequence), 2);
    msg.append(static_cast<char>(ctx.header.cmdId));
    msg.append(reinterpret_cast<const char*>(&ctx.header.crc), 4);
    msg.append(ctx.data);
    msg.append(reinterpret_cast<const char*>(&ctx.crc), 4);

    return msg;
}

quint32 SiYiCamera::headerCheckSum32(ProtocolMessageHeaderContext* ctx) {
    if (ctx) {
        QByteArray bytes;
        quint32 leStx = qToLittleEndian<quint32>(ctx->stx);
        bytes.append(reinterpret_cast<const char*>(&leStx), 4);
        bytes.append(static_cast<char>(ctx->control));
        bytes.append(reinterpret_cast<const char*>(&ctx->dataLength), 4);
        bytes.append(reinterpret_cast<const char*>(&ctx->sequence), 2);
        bytes.append(static_cast<char>(ctx->cmdId));

        return checkSum32(bytes);
    }
    return 0;
}

quint32 SiYiCamera::packetCheckSum32(ProtocolMessageContext* ctx) {
    if (ctx) {
        QByteArray bytes;
        quint32 leStx = qToLittleEndian<quint32>(ctx->header.stx);
        bytes.append(reinterpret_cast<const char*>(&leStx), 4);
        bytes.append(static_cast<char>(ctx->header.control));
        bytes.append(reinterpret_cast<const char*>(&ctx->header.dataLength), 4);
        bytes.append(reinterpret_cast<const char*>(&ctx->header.sequence), 2);
        bytes.append(static_cast<char>(ctx->header.cmdId));
        bytes.append(reinterpret_cast<const char*>(&ctx->header.crc), 4);
        bytes.append(ctx->data);

        return checkSum32(bytes);
    }
    return 0;
}

bool SiYiCamera::unpackMessage(ProtocolMessageContext* ctx, const QByteArray& msg) {
    if (ctx && msg.length() >= 16) {
        int offset = 0;
        ctx->header.stx = qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(msg.constData()));
        offset += 4;
        ctx->header.control = static_cast<quint8>(msg.at(offset));
        offset += 1;
        ctx->header.dataLength = qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(msg.constData() + offset));
        offset += 4;
        ctx->header.sequence = qFromLittleEndian<quint16>(reinterpret_cast<const uchar*>(msg.constData() + offset));
        offset += 2;
        ctx->header.cmdId = static_cast<quint8>(msg.at(offset));
        offset += 1;
        ctx->header.crc = qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(msg.constData() + offset));
        offset += 4;

        int dataLength = msg.length() - offset - 4;
        if (dataLength >= 0) {
            ctx->data = QByteArray(msg.constData() + offset, dataLength);
            ctx->crc =
                qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(msg.constData() + offset + dataLength));
            return true;
        }
    }
    return false;
}

void SiYiCamera::getCamerVersion() {
    uint8_t cmdId = 0x94;
    QByteArray body;
    QByteArray msg = packMessage(0x01, cmdId, body);
    sendMessage(msg);
}

void SiYiCamera::messageHandle0x80(const QByteArray& msg) { qDebug() << "Message 0x80 (Heartbeat response)"; }

void SiYiCamera::messageHandle0x81(const QByteArray& msg) {
    qDebug() << "Message 0x81 (Recording state)";
    if (msg.length() >= 20) {
        int offset = 16;  // Skip header
        qint8 state = msg.at(offset);
        if (isRecording_ != (state != 0)) {
            isRecording_ = (state != 0);
            emit isRecordingChanged();
        }
    }
}

void SiYiCamera::messageHandle0x83(const QByteArray& msg) {
    qDebug() << "Message 0x83 (Resolution)";
    if (msg.length() >= 22) {
        int offset = 16;  // Skip header
        resolutionWidth_ = qFromLittleEndian<qint16>(reinterpret_cast<const uchar*>(msg.constData() + offset));
        offset += 2;
        resolutionHeight_ = qFromLittleEndian<qint16>(reinterpret_cast<const uchar*>(msg.constData() + offset));
        qDebug() << "Resolution:" << resolutionWidth_ << "x" << resolutionHeight_;
    }
}

void SiYiCamera::messageHandle0x94(const QByteArray& msg) {
    qDebug() << "Message 0x94 (Camera version)";
    if (msg.length() >= 21) {
        int offset = 16;  // Skip header
        qint8 camType = msg.at(offset);
        camera_type_ = camType;
        qDebug() << "Camera type:" << static_cast<int>(camType);
    }
}

void SiYiCamera::messageHandle0x98(const QByteArray& msg) { qDebug() << "Message 0x98 (Zoom response)"; }

void SiYiCamera::messageHandle0x9e(const QByteArray& msg) { qDebug() << "Message 0x9e (Camera capabilities)"; }
