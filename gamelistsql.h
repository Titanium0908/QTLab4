#ifndef GAMELIST__H
#define GAMELIST__H

#include <QtSql>

class gameListSQL: public QSqlQueryModel
{
    Q_OBJECT

    Q_PROPERTY(QSqlQueryModel* gameModel READ getModel CONSTANT)
    Q_PROPERTY(bool IsConnectionOpen READ isConnectionOpen CONSTANT)

public:
    explicit gameListSQL(QObject *parent);
    void refresh();
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void add(const QString& nameGam,
                         const QString& platformGam,
                         const QString& creatorGam,
                        const QString& genreGam);
    Q_INVOKABLE void del(const int index);
    Q_INVOKABLE void edit(const QString& nameGam,
                          const QString& platformGam,
                          const QString& creatorGam,
                         const QString& genreGam,
                          const int index);
    Q_INVOKABLE QString count(const QString& selectedPlatform);

signals:

public slots:

private:
    const static char* SQL_SELECT;
    QSqlDatabase db;
    QSqlQueryModel *getModel();
    bool _isConnectionOpen;
    bool isConnectionOpen();
};

#endif // RIVERLIST__H
