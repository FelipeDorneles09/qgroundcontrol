#include "SiYiTransmitter.h"

#include <QDebug>
#include <QtEndian>

SiYiTransmitter::SiYiTransmitter(QObject* parent) : SiYiTcpClient("192.168.144.25", 37255, parent) {}

SiYiTransmitter::~SiYiTransmitter() {}

QByteArray SiYiTransmitter::heartbeatMessage() {
    // Simple heartbeat message for transmitter (0x80 cmdId)
    QByteArray body;
    // Can be empty or contain minimal data
    return body;
}

void SiYiTransmitter::onHeartbeatMessageReceived(const QByteArray& msg) {
    qDebug() << "Transmitter heartbeat:" << msg.toHex(' ');

    if (msg.length() >= 36) {
        int offset = 16;  // Skip header (STX + control + dataLen + sequence + cmdId + crc)

        // Parse transmitter status
        signalQuality_ = static_cast<int>(msg.at(offset));
        inactiveTime_ = qFromLittleEndian<qint32>(reinterpret_cast<const uchar*>(msg.constData() + offset + 1));
        upStreamEnergy_ = qFromLittleEndian<qint32>(reinterpret_cast<const uchar*>(msg.constData() + offset + 5));
        downStreamEnergy_ = qFromLittleEndian<qint32>(reinterpret_cast<const uchar*>(msg.constData() + offset + 9));

        rxBanWidth_ = static_cast<int>(msg.at(offset + 13));
        txBanWidth_ = static_cast<int>(msg.at(offset + 14));
        rssi_ = static_cast<int>(msg.at(offset + 15));
        freq_ = qFromLittleEndian<qint16>(reinterpret_cast<const uchar*>(msg.constData() + offset + 16));
        channel_ = static_cast<int>(msg.at(offset + 18));

        emit signalQualityChanged();
        emit inactiveTimeChanged();
        emit upStreamEnergyChanged();
        emit downStreamEnergyChanged();
        emit rxBanWidthChanged();
        emit txBanWidthChanged();
        emit rssiChanged();
        emit freqChanged();
        emit channelChanged();
    }
}

void SiYiTransmitter::analyzeMessage() {
    while (rxBytes_.length() >= 4) {
        if ((rxBytes_.at(0) == char(0x55)) && (rxBytes_.at(1) == char(0x66)) && (rxBytes_.at(2) == char(0xaa)) &&
            (rxBytes_.at(3) == char(0xbb))) {
            int headerLength = 4 + 1 + 4 + 2 + 1 + 4;
            if (rxBytes_.length() >= headerLength) {
                quint32 stx = qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(rxBytes_.constData()));
                quint8 control = static_cast<quint8>(rxBytes_.at(4));
                quint32 dataLength =
                    qFromLittleEndian<quint32>(reinterpret_cast<const uchar*>(rxBytes_.constData() + 5));

                int msgLen = headerLength + dataLength + 4;

                if (rxBytes_.length() >= msgLen) {
                    QByteArray msg(rxBytes_.constData(), msgLen);
                    quint8 cmdId = static_cast<quint8>(rxBytes_.at(11));

                    if (cmdId == 0x90) {
                        onHeartbeatMessageReceived(msg);
                    }

                    qInfo() << "Transmitter Rx:" << msg.toHex(' ');
                    rxBytes_.remove(0, msgLen);
                } else {
                    break;
                }
            } else {
                break;
            }
        } else {
            rxBytes_.remove(0, 1);
        }
    }
}
