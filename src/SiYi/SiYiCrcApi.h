#ifndef SIYICRCAPI_H
#define SIYICRCAPI_H

#include <QObject>
#include <QtCore/QByteArray>

class SiYiCrcApi : public QObject {
    Q_OBJECT
   public:
    explicit SiYiCrcApi(QObject* parent = nullptr);
    static quint32 calculateCrc32(const QByteArray& bytes);
};

#endif  // SIYICRCAPI_H
