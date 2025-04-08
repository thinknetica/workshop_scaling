# IO-bound нагрузочное тестирование

## Метод: `sync_sleep(seconds)`
Каждый запрос "засыпает" на 1 секунду.

## Конфигурация:
- 100 пользователей
- 50 повторов
- Итого 5000 запросов

## Команда тестирования: 
- Сначала запустил rack-приложение с помощью команды puma -t 1:1 -p 3000
- siege -c 100 -r 50 http://0.0.0.0:3000/sync_sleep/1

## Результаты тестирования (до конца не дождался):
Transactions:                    3083 hits
Availability:                    100.00 %
Elapsed time:                    3091.14 secs
Data transferred:                0.15 MB
Response time:                   98.65 secs
Transaction rate:                1.00 trans/sec
Throughput:                      0.00 MB/sec
Concurrency:                     98.39
Successful transactions:         3083
Failed transactions:             0
Longest transaction:             100.32
Shortest transaction:            1.00

## Выводы:
- Время отклика выросло до ~99 секунд (все запросы в очереди)

## Решение по масштабированию:
- Приложение становится "узким горлышком" при высокой IO-нагрузке
- Масштабирование потребует или увеличения числа потоков, или перехода на async-архитектуру
- Решил попробовать увеличить число потоков до 5, запустив Puma в многопоточном режиме (puma -t 1:5 -p 3000)

## Результаты тестирования после запуска сервера в многопоточном режиме:
Transactions:                   5000 hits
Availability:                   100.00 %
Elapsed time:                   1003.73 secs
Data transferred:               0.24 MB
Response time:                  19.88 secs
Transaction rate:               4.98 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                    99.01
Successful transactions:        5000
Failed transactions:            0
Longest transaction:            21.04
Shortest transaction:           1.00

## Выводы:
- Пропускная способность выросла в 5 раз
- Время отклика снизилось до ~20 секунд

