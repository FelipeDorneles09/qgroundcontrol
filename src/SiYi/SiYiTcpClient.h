#ifndef SIYITCPCLIENT_H
#define SIYITCPCLIENT_H

#include <QMutex>
#include <QTcpSocket>
#include <QThread>
#include <QVector>

#define PROTOCOL_STX 0x5566AABB

class SiYiTcpClient : public QThread {
    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY isConnectedChanged)

   public:
    explicit SiYiTcpClient(const QString& ip, quint16 port, QObject* parent = nullptr);
    ~SiYiTcpClient();

    void sendMessage(const QByteArray& msg);
    bool isConnected() const { return isConnected_; }

   protected:
    virtual void analyzeMessage() = 0;
    virtual QByteArray heartbeatMessage() = 0;

   protected:
    QVector<QByteArray> txMessageVector_;
    QMutex txMessageVectorMutex_;
    QByteArray rxBytes_;
    QMutex rxBytesMutex_;
    int timeoutCount = 0;
    QMutex timeoutCountMutex;
    QString ip_;
    quint16 port_;

   protected:
    quint16 sequence();
    void run() override;
    quint32 checkSum32(const QByteArray& bytes);
    void resetIp(const QString& ip);

   private:
    quint16 sequence_;
    bool isConnected_ = false;

   signals:
    void connected();
    void disconnected();
    void ipChanged();
    void isConnectedChanged();
};

#endif  // SIYITCPCLIENT_H
