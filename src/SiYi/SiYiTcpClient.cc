#include "SiYiTcpClient.h"

#include <QDateTime>
#include <QDebug>
#include <QTcpSocket>
#include <QTimer>
#include <QTimerEvent>
#include <QtEndian>

#include "SiYiCrcApi.h"

SiYiTcpClient::SiYiTcpClient(const QString& ip, quint16 port, QObject* parent) : QThread(parent), ip_(ip), port_(port) {
    sequence_ = static_cast<quint16>(QDateTime::currentMSecsSinceEpoch());
    // Auto reconnect
    connect(this, &QThread::finished, this, [this]() { start(); });
}

SiYiTcpClient::~SiYiTcpClient() {
    if (isRunning()) {
        exit();
        wait();
    }
}

void SiYiTcpClient::sendMessage(const QByteArray& msg) {
    if (isRunning()) {
        txMessageVectorMutex_.lock();
        txMessageVector_.append(msg);
        txMessageVectorMutex_.unlock();
    }
}

quint16 SiYiTcpClient::sequence() {
    quint16 seq = sequence_;
    sequence_ += 1;
    return seq;
}

void SiYiTcpClient::run() {
    QTcpSocket* tcpClient = new QTcpSocket();
    QTimer* txTimer = new QTimer();
    QTimer* rxTimer = new QTimer();
    QTimer* heartbeatTimer = new QTimer();
    const QString info = QString("[%1:%2]:").arg(ip_, QString::number(port_));

    connect(tcpClient, &QTcpSocket::connected, this, [this, info, heartbeatTimer, txTimer]() {
        qInfo().nospace() << info << " Connect to server successfully!";
        heartbeatTimer->start();
        txTimer->start();
        isConnected_ = true;
        emit connected();
        emit isConnectedChanged();
    });

    connect(tcpClient, &QTcpSocket::disconnected, this, [this, info, heartbeatTimer]() {
        qInfo().nospace() << info << " Disconnect from server!";
        isConnected_ = false;
        txMessageVectorMutex_.lock();
        txMessageVector_.clear();
        txMessageVectorMutex_.unlock();
        emit isConnectedChanged();
        heartbeatTimer->stop();
        exit();
    });

    connect(tcpClient, &QAbstractSocket::errorOccurred, this, [this, info, heartbeatTimer, tcpClient]() {
        qInfo().nospace() << info << " " << tcpClient->errorString();
        heartbeatTimer->stop();
        exit();
    });

    // Timer for sending messages
    txTimer->setInterval(10);
    txTimer->setSingleShot(true);
    connect(txTimer, &QTimer::timeout, this, [this, info, tcpClient, txTimer]() {
        txMessageVectorMutex_.lock();
        QByteArray msg = txMessageVector_.isEmpty() ? QByteArray() : txMessageVector_.takeFirst();
        txMessageVectorMutex_.unlock();

        if (!msg.isEmpty()) {
            if (tcpClient->state() == QTcpSocket::ConnectedState) {
                if (tcpClient->write(msg) != -1) {
                    qInfo().nospace() << info << " Tx:" << msg.toHex(' ');
                } else {
                    qInfo().nospace() << info << " " << tcpClient->errorString();
                }
            } else {
                qInfo().nospace() << info << " Not connected state, the state is:" << tcpClient->state();
                exit();
            }
        }
        txTimer->start();
    });

    // Timer for processing received data
    rxTimer->setInterval(1);
    rxTimer->setSingleShot(true);
    connect(rxTimer, &QTimer::timeout, this, [this, info, tcpClient, rxTimer]() {
        rxBytesMutex_.lock();
        QByteArray bytes = tcpClient->readAll();
        rxBytes_.append(bytes);
        analyzeMessage();
        rxBytesMutex_.unlock();
        rxTimer->start();
    });

    // Heartbeat timer
    heartbeatTimer->setInterval(1500);
    heartbeatTimer->setSingleShot(true);
    connect(heartbeatTimer, &QTimer::timeout, this, [this, info, heartbeatTimer]() {
        timeoutCountMutex.lock();
        int count = timeoutCount;
        timeoutCountMutex.unlock();

        if (count > 3) {
            timeoutCountMutex.lock();
            timeoutCount = 0;
            timeoutCountMutex.unlock();
            qWarning().nospace() << info << " Heartbeat timeout, the client will be restart soon!";
            exit();
        }

        timeoutCountMutex.lock();
        timeoutCount += 1;
        timeoutCountMutex.unlock();

        QByteArray msg = heartbeatMessage();
        sendMessage(msg);
        heartbeatTimer->start();
    });

    tcpClient->connectToHost(ip_, port_);
    rxTimer->start();
    exec();

    txTimer->deleteLater();
    rxTimer->deleteLater();
    heartbeatTimer->deleteLater();
    tcpClient->deleteLater();
}

quint32 SiYiTcpClient::checkSum32(const QByteArray& bytes) { return SiYiCrcApi::calculateCrc32(bytes); }

void SiYiTcpClient::resetIp(const QString& ip) {
    if (ip_ != ip) {
        ip_ = ip;
        exit();
        wait();
        emit ipChanged();
    }
}
