# Добавил гемы для метрик (IO-bound нагрузочное тестирование)

## Добавил метод sync_sleep с имитацией IO-bound нагрузки в новый контроллер metrics#sync_sleep
Каждый запрос "засыпает" на n секунд.

## Прописал путь в маршрутах:
- get '/sync_sleep/:seconds', to: 'metrics#sync_sleep'

## Добавил гемы для метрик
- gem 'prometheus_exporter'

## Провёл нагрузочное тестирование: 
- Сначала запустил сервер с помощью команды rails server
- Потом саму команду для нагрузки сервера запросами
- siege -c 20 -r 50 http://localhost:3000/sync_sleep/1

## Результаты на /metrics после осады:
# Количество успешных запросов:
http_server_requests_total{code="200",method="get",path="/sync_sleep/:seconds"} 1000

# Длительность обработки:
http_server_request_duration_seconds_sum{method="get",path="/sync_sleep/:seconds"} 1023.4
http_server_request_duration_seconds_count{method="get",path="/sync_sleep/:seconds"} 1000

# Память:
rss_memory_mb 140.8046875 (было rss_memory_mb 77.9375)

## Выводы:
- Метрики корректно собираются
- /metrics остаётся доступным даже под нагрузкой
- Видна нагрузка: по длительности обработки и росту памяти.
